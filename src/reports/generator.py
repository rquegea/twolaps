import os
from ..engines.openai_engine import fetch_openai_response
from .prompts import get_analysis_prompt
from .aggregator import aggregate_data_for_report

MODEL = os.getenv("REPORT_MODEL", "gpt-4o")
TEMPERATURE = float(os.getenv("REPORT_TEMPERATURE", "0.3"))

def generate_report_content(aggregated_data: dict) -> dict:
    """
    Orquesta la generación del contenido textual para cada sección del informe.
    """
    report_content = {}
    mentions_by_category = aggregated_data.get("mentions_by_category", {})
    all_summaries = aggregated_data.get("all_summaries", [])
    
    print("Generando contenido del informe con IA avanzada...")
    
    if not mentions_by_category:
        return {"Resumen ejecutivo": "No se registraron menciones en el periodo seleccionado."}

    for category_name, data in mentions_by_category.items():
        print(f"  - Analizando categoría: {category_name}")
        prompt = get_analysis_prompt(category_name, data, all_summaries)
        
        # Usamos el modelo configurable para el análisis final
        analysis_text, _ = fetch_openai_response(prompt, model=MODEL)
        
        report_content[category_name] = analysis_text
    
    print("✅ Contenido del informe generado.")
    return report_content