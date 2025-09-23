import json

__all__ = ["get_analysis_prompt"]

def get_analysis_prompt(category_name: str, category_data: list, all_summaries: list) -> str:
    """
    Crea un prompt dinámico para que la IA analice los datos de una categoría.
    """
    data_json = json.dumps(category_data, indent=2, ensure_ascii=False, default=str)
    summaries_text = "\n- ".join(all_summaries)

    prompt = f"""
    **ROL:** Eres un Analista de Inteligencia de Mercado Senior.
    **TAREA:** Redacta un resumen ejecutivo para la sección de un informe. Interpreta los datos, no te limites a listarlos. Encuentra patrones, tendencias y extrae conclusiones accionables.
    **SECCIÓN A ANALIZAR:** "{category_name}"

    **DATOS DETALLADOS DE ESTA SECCIÓN (en formato JSON):**
    ```json
    {data_json}
    ```

    **RESUMEN GLOBAL DE TODOS LOS TEMAS DETECTADOS EN EL PERIODO (para contexto):**
    - {summaries_text}

    **INSTRUCCIÓN:**
    Basándote en los datos detallados de la sección y el contexto global, escribe un párrafo de análisis de entre 100 y 150 palabras para la sección "{category_name}".
    """
    return prompt