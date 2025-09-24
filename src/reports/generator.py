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
    get_correlation_interpretation_prompt,
    get_trends_anomalies_prompt,
)
from src.reports.correlation_engine import compute_cross_category_correlations
from src.reports.correlation_engine import compute_time_series_correlations
from src.reports.plotter import (
    generate_sentiment_trend_plot,
    generate_mentions_trend_plot,
)
import tempfile
import os


PRIORITY_CATEGORIES = [
    "Análisis de competencia",
    "Análisis de marketing y estrategia",
    "Análisis de mercado",
]


def _ordered_categories(mentions_by_category: dict) -> list:
    present = [c for c, data in mentions_by_category.items() if data]
    # Prioritarios primero (en orden), luego el resto alfabético
    prioritized = [c for c in PRIORITY_CATEGORIES if c in present]
    remaining = sorted([c for c in present if c not in PRIORITY_CATEGORIES])
    return prioritized + remaining


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

    ordered_cats = _ordered_categories(mentions_by_category)
    aggregated_data["ordered_categories"] = ordered_cats

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
                cleaned = cleaned[len("```")]
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
    report_content = {"strategic": {}, "detailed": {}, "cross": {}}
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
    # Fase 2.5: Correlaciones Transversales + Series temporales
    # -------------------------
    try:
        correlation_data = compute_cross_category_correlations(aggregated_data)
        ts_corr = compute_time_series_correlations(aggregated_data)
        correlation_data["time_series_correlations"] = ts_corr
        corr_prompt = get_correlation_interpretation_prompt(aggregated_data, correlation_data)
        corr_text, _ = fetch_openai_response(corr_prompt, model="gpt-4o")
        report_content["cross"]["Correlaciones Transversales"] = corr_text
        report_content["cross"]["_raw_correlations"] = correlation_data
    except Exception as e:
        print(f"Error generando Correlaciones Transversales: {e}")
        report_content["cross"]["Correlaciones Transversales"] = ""

    # -------------------------
    # Fase 3: Contenido Detallado (Anexo)
    # -------------------------
    for category_name in ordered_cats:
        data = mentions_by_category.get(category_name) or []
        if not data:
            continue
        print(f"  - Analizando categoría para anexo: {category_name}")
        # Usar el nuevo prompt basado en KPIs enriquecidos
        prompt = get_deep_dive_analysis_prompt(category_name, kpis, aggregated_data.get("client_name", "Nuestra marca"))
        analysis_text, _ = fetch_openai_response(prompt, model="gpt-4o")
        report_content["detailed"][category_name] = analysis_text

    # -------------------------
    # Fase 4: Tendencias y Anomalías
    # -------------------------
    try:
        trends_prompt = get_trends_anomalies_prompt(aggregated_data)
        trends_text, _ = fetch_openai_response(trends_prompt, model="gpt-4o")
        report_content["strategic"]["Tendencias y Señales Emergentes"] = trends_text
    except Exception as e:
        print(f"Error generando Tendencias y Señales Emergentes: {e}")
        report_content["strategic"]["Tendencias y Señales Emergentes"] = ""

    print("✅ Contenido del informe híbrido generado.")

    # -------------------------
    # Fase 5: Gráficos de series temporales (global y por categoría)
    # -------------------------
    try:
        tmp_dir = tempfile.mkdtemp(prefix="ia_report_")
        ts_data = aggregated_data.get("time_series", {})
        # Global
        sentiment_img = generate_sentiment_trend_plot(ts_data, tmp_dir)
        mentions_img = generate_mentions_trend_plot(ts_data, tmp_dir)
        charts = {}
        if sentiment_img and os.path.exists(sentiment_img):
            charts["sentiment_trend"] = sentiment_img
        if mentions_img and os.path.exists(mentions_img):
            charts["mentions_trend"] = mentions_img
        # Por categoría (siguiendo prioridad)
        per_cat = ts_data.get("per_category", {}) if isinstance(ts_data, dict) else {}
        cat_charts = {}
        for cat_name in ordered_cats:
            series = per_cat.get(cat_name)
            if not series:
                continue
            safe_cat = "".join([c if c.isalnum() else "_" for c in str(cat_name)])
            cat_dir = os.path.join(tmp_dir, f"cat_{safe_cat}")
            os.makedirs(cat_dir, exist_ok=True)
            s_img = generate_sentiment_trend_plot(series, cat_dir)
            m_img = generate_mentions_trend_plot(series, cat_dir)
            entry = {}
            if s_img and os.path.exists(s_img):
                entry["sentiment_trend"] = s_img
            if m_img and os.path.exists(m_img):
                entry["mentions_trend"] = m_img
            if entry:
                cat_charts[cat_name] = entry
        if charts or cat_charts:
            aggregated_data["charts"] = charts
            if cat_charts:
                aggregated_data["charts"]["per_category"] = cat_charts
    except Exception as e:
        print(f"Error generando gráficos de serie temporal: {e}")

    return report_content
