import json

def get_detailed_category_prompt(category_name: str, category_data: list, all_summaries: list, kpis: dict) -> str:
    """
    Crea un prompt dinámico para que la IA analice los datos por categoría, integrando KPIs.
    """
    data_json = json.dumps(category_data, indent=2, ensure_ascii=False, default=str)
    summaries_text = "\n- ".join(list(set(all_summaries)))

    prompt = f"""
    **ROL:** Eres un Analista de Inteligencia de Mercado Senior.
    **TAREA:** Redacta un resumen ejecutivo para la sección de un informe. Interpreta los datos, no te limites a listarlos. **Integra las métricas clave (KPIs) de forma natural en tu análisis** para dar un contexto cuantitativo.
    
    **SECCIÓN A ANALIZAR:** "{category_name}"

    **KPIs GENERALES DEL PERIODO:**
    - Menciones totales analizadas: {kpis.get('total_mentions', 'N/A')}
    - Sentimiento general promedio: {kpis.get('average_sentiment', 0.0):.2f} (en una escala de -1 a 1)

    **DATOS DETALLADOS DE ESTA SECCIÓN:**
    ```json
    {data_json}
    ```

    **RESUMEN GLOBAL DE TODOS LOS TEMAS DETECTADOS (para contexto):**
    - {summaries_text}

    **INSTRUCCIÓN:**
    Basándote en TODOS los datos proporcionados, escribe un párrafo de análisis de entre 100 y 150 palabras para la sección "{category_name}". Compara el sentimiento de esta sección con el promedio general si es relevante.
    """
    return prompt


def get_insight_extraction_prompt(aggregated_data: dict) -> str:
    """
    Genera un prompt para extraer un JSON de insights estratégicos a partir de los datos agregados.
    La salida DEBE SER únicamente un objeto JSON válido, sin texto adicional.
    """
    data_json = json.dumps(aggregated_data, ensure_ascii=False, default=str)
    return (
        "Eres un Analista de Inteligencia de Mercado Senior. "
        "Analiza todos los datos proporcionados y devuelve EXCLUSIVAMENTE un objeto JSON con la siguiente estructura exacta. "
        "NO incluyas texto explicativo, comentarios ni markdown, solo el JSON. "
        "Los datos a analizar son:\n\n"
        "```json\n" + data_json + "\n```\n\n"
        "Estructura esperada del JSON de salida (rellena con tu análisis):\n\n"
        "{\n"
        "  \"executive_summary\": \"Un resumen de alto nivel de 2-3 frases con los hallazgos más críticos.\",\n"
        "  \"key_findings\": [\n"
        "    \"Un hallazgo importante sobre el mercado.\",\n"
        "    \"Otro hallazgo relevante sobre la competencia.\",\n"
        "    \"Un tercer hallazgo sobre la percepción del cliente.\"\n"
        "  ],\n"
        "  \"opportunities\": [\n"
        "    {\n"
        "      \"opportunity\": \"Descripción de una oportunidad de negocio clara.\",\n"
        "      \"impact\": \"Alto/Medio/Bajo\"\n"
        "    }\n"
        "  ],\n"
        "  \"risks\": [\n"
        "    {\n"
        "      \"risk\": \"Descripción de un riesgo o amenaza potencial.\",\n"
        "      \"mitigation\": \"Sugerencia sobre cómo mitigar este riesgo.\"\n"
        "    }\n"
        "  ],\n"
        "  \"recommendations\": [\n"
        "    \"Una recomendación estratégica y accionable.\",\n"
        "    \"Otra recomendación clara y concisa.\"\n"
        "  ]\n"
        "}"
    )


def get_strategic_summary_prompt(insights_json: dict) -> str:
    """Genera el prompt para redactar "Resumen Ejecutivo y Hallazgos Principales" a partir de insights."""
    executive_summary = insights_json.get("executive_summary", "")
    key_findings = insights_json.get("key_findings", [])
    findings_text = "\n- ".join(key_findings) if key_findings else ""
    return f"""
    **ROL:** Eres un Analista de Inteligencia de Mercado Senior.
    **TAREA:** Redacta la sección "Resumen Ejecutivo y Hallazgos Principales" de un informe estratégico.

    **EXECUTIVE SUMMARY (base):**
    {executive_summary}

    **HALLAZGOS PRINCIPALES:**
    - {findings_text}

    **INSTRUCCIÓN:**
    Redacta entre 2 y 3 párrafos claros y concisos que sinteticen el estado del mercado, la competencia y la percepción del cliente, utilizando el executive summary y los hallazgos como base. Evita repetir literalmente las viñetas; integra y sintetiza.
    """


def get_strategic_plan_prompt(insights_json: dict) -> str:
    """Genera el prompt para redactar el "Plan de Acción Estratégico" enlazando oportunidades, riesgos y recomendaciones."""
    opportunities = insights_json.get("opportunities", [])
    risks = insights_json.get("risks", [])
    recommendations = insights_json.get("recommendations", [])
    opp_text = json.dumps(opportunities, ensure_ascii=False, indent=2)
    risks_text = json.dumps(risks, ensure_ascii=False, indent=2)
    recs_text = "\n- ".join(recommendations) if recommendations else ""
    return f"""
    **ROL:** Eres un Estratega de Negocio.
    **TAREA:** Redacta la sección "Plan de Acción Estratégico" conectando oportunidades, riesgos y recomendaciones de forma coherente y priorizada.

    **OPORTUNIDADES (base):**
    ```json
    {opp_text}
    ```

    **RIESGOS (base):**
    ```json
    {risks_text}
    ```

    **RECOMENDACIONES (base):**
    - {recs_text}

    **INSTRUCCIÓN:**
    Propón un plan de acción priorizado (corto/medio plazo), asignando recomendaciones a oportunidades específicas y contemplando mitigaciones para los riesgos. Escribe 2-3 párrafos con lenguaje claro y accionable.
    """