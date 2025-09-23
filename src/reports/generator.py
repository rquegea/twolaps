from src.engines.openai_engine import fetch_openai_response
from src.reports.prompts import get_analysis_prompt

def generate_report_content(aggregated_data: dict) -> dict:
    """
    Orquesta la generación del contenido textual para cada sección del informe.
    """
    report_content = {}
    mentions_by_category = aggregated_data.get("mentions_by_category", {})
    all_summaries = aggregated_data.get("all_summaries", [])
    kpis = aggregated_data.get("kpis", {}) # <-- AÑADIR ESTA LÍNEA
    
    print("Generando contenido del informe con IA avanzada...")
    
    for category_name, data in mentions_by_category.items():
        if not data: continue
        
        print(f"  - Analizando categoría: {category_name}")
        # Pasar los KPIs al prompt
        prompt = get_analysis_prompt(category_name, data, all_summaries, kpis) # <-- MODIFICAR ESTA LÍNEA
        
        analysis_text, _ = fetch_openai_response(prompt, model="gpt-4o")
        
        report_content[category_name] = analysis_text
    
    print("✅ Contenido del informe generado.")
    return report_content
