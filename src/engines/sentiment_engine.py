from .openai_engine import fetch_openai_response
import json
import re

def analyze_and_summarize(text: str) -> dict:
    """
    Utiliza un modelo económico de OpenAI para realizar el primer análisis:
    sentimiento, emoción, resumen y extracción de temas clave.
    """
    prompt = f"""
    Analiza el siguiente texto y devuelve un objeto JSON con las siguientes claves:
    - "sentiment": Un valor numérico de -1.0 (muy negativo) a 1.0 (muy positivo).
    - "emotion": Una sola palabra que describa la emoción dominante (ej. "optimismo", "preocupación", "neutral").
    - "confidence_score": Un valor de 0.0 a 1.0 indicando tu confianza en el análisis.
    - "summary": Un resumen conciso del texto en menos de 30 palabras.
    - "key_topics": Una lista de 3 a 5 temas, marcas o conceptos clave mencionados en el texto.

    Texto a analizar:
    ---
    {text[:4000]}
    ---

    Responde únicamente con el JSON.
    """
    try:
        # Usamos un modelo rápido y económico para este primer análisis
        raw_response, _ = fetch_openai_response(prompt, model="gpt-4o-mini")

        # Extraer JSON de forma robusta (maneja fences y texto alrededor)
        def extract_json(text: str) -> str:
            fence = re.search(r"```json\s*(.*?)\s*```", text, flags=re.S | re.I)
            if fence:
                return fence.group(1).strip()
            fenced_any = re.search(r"```\s*(\{[^}]*\})\s*```", text, flags=re.S)
            if fenced_any:
                return fenced_any.group(1).strip()
            braces = re.search(r"\{.*\}", text, flags=re.S)
            return braces.group(0).strip() if braces else text

        cleaned = extract_json(raw_response)
        analysis = json.loads(cleaned)
        return analysis

    except Exception as e:
        print(f"Error en el análisis de sentimiento y resumen: {e}")
        return {
            "sentiment": 0.0,
            "emotion": "unknown",
            "confidence_score": 0.0,
            "summary": "No se pudo generar el resumen.",
            "key_topics": []
        }