import json
from src.engines.openai_engine import fetch_openai_response
from src.reports.prompts import (
    get_detailed_category_prompt,
    get_insight_extraction_prompt,
    get_strategic_plan_prompt,
    get_strategic_summary_prompt,
    get_executive_summary_prompt,
    get_competitive_analysis_prompt,
    get_deep_dive_analysis_prompt,
)

def generate_report_content(aggregated_data: dict) -> dict:
    """
    Orquesta la generación del contenido textual para el informe híbrido:
    - Fase 1: Extracción de insights estratégicos (JSON)
    - Fase 2: Redacción de secciones estratégicas
    - Fase 3: Redacción del anexo detallado por categorías
    """
    mentions_by_category = aggregated_data.get("mentions_by_category", {})
    # all_summaries no se usa en la versión con deep dive basado en KPIs
    kpis = aggregated_data.get("kpis", {})

    print("Generando contenido del informe híbrido con IA avanzada...")

    # -------------------------
    # Fase 1: Extracción de Insights
    # -------------------------
    insights_data = {}
    try:
        insights_prompt = get_insight_extraction_prompt(aggregated_data)
        insights_text, _ = fetch_openai_response(insights_prompt, model="gpt-4o")
        # Asegurar que solo intentamos parsear el JSON
        insights_text_stripped = insights_text.strip()
        # Intento directo de parseo; si fallase por envolturas Markdown, intentar limpiar
        if insights_text_stripped.startswith("```) "):
            # Caso improbable; dejamos fallback más abajo
            pass
        try:
            insights_data = json.loads(insights_text_stripped)
        except Exception:
            # Limpieza básica de cercas Markdown y texto alrededor
            cleaned = insights_text_stripped
            if cleaned.startswith("```json"):
                cleaned = cleaned[len("```json"):]
            if cleaned.startswith("```"):
                cleaned = cleaned[len("```"):]
            if cleaned.endswith("```"):
                cleaned = cleaned[: -len("```")]
            insights_data = json.loads(cleaned.strip())
    except Exception as e:
        print(f"Error parseando JSON de insights: {e}")
        insights_data = {
            "executive_summary": "",
            "key_findings": [],
            "opportunities": [],
            "risks": [],
            "recommendations": [],
        }

    # -------------------------
    # Fase 2: Contenido Estratégico
    # -------------------------
    report_content = {"strategic": {}, "detailed": {}}
    # Resumen Ejecutivo (basado en KPIs enriquecidos)
    try:
        exec_prompt = get_executive_summary_prompt(aggregated_data)
        executive_summary, _ = fetch_openai_response(exec_prompt, model="gpt-4o")
        report_content["strategic"]["Resumen Ejecutivo"] = executive_summary
    except Exception as e:
        print(f"Error generando Resumen Ejecutivo (KPIs): {e}")
        report_content["strategic"]["Resumen Ejecutivo"] = ""

    # Resumen Ejecutivo y Hallazgos (opcional, basado en insights JSON)
    try:
        summary_prompt = get_strategic_summary_prompt(insights_data)
        strategic_summary, _ = fetch_openai_response(summary_prompt, model="gpt-4o")
        report_content["strategic"]["Resumen Ejecutivo y Hallazgos"] = strategic_summary
    except Exception as e:
        print(f"Error generando Resumen Ejecutivo (insights): {e}")
        report_content["strategic"]["Resumen Ejecutivo y Hallazgos"] = ""

    try:
        plan_prompt = get_strategic_plan_prompt(insights_data)
        strategic_plan, _ = fetch_openai_response(plan_prompt, model="gpt-4o")
        report_content["strategic"]["Plan de Acción Estratégico"] = strategic_plan
    except Exception as e:
        print(f"Error generando Plan de Acción: {e}")
        report_content["strategic"]["Plan de Acción Estratégico"] = ""

    # Análisis Competitivo
    try:
        comp_prompt = get_competitive_analysis_prompt(aggregated_data)
        comp_text, _ = fetch_openai_response(comp_prompt, model="gpt-4o")
        report_content["strategic"]["Análisis Competitivo"] = comp_text
    except Exception as e:
        print(f"Error generando Análisis Competitivo: {e}")
        report_content["strategic"]["Análisis Competitivo"] = ""

    # -------------------------
    # Fase 3: Contenido Detallado (Anexo)
    # -------------------------
    for category_name, data in mentions_by_category.items():
        if not data:
            continue
        print(f"  - Analizando categoría para anexo: {category_name}")
        prompt = get_deep_dive_analysis_prompt(category_name, data, kpis, aggregated_data.get("client_name", "Nuestra marca"))
        analysis_text, _ = fetch_openai_response(prompt, model="gpt-4o")
        report_content["detailed"][category_name] = analysis_text

    print("✅ Contenido del informe híbrido generado.")
    return report_content
