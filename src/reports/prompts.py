import json

def get_detailed_category_prompt(category_name: str, category_data: list, all_summaries: list, kpis: dict) -> str:
    """
    Crea un prompt dinámico para que la IA analice los datos por categoría, integrando KPIs.
    """
    data_json = json.dumps(category_data, indent=2, ensure_ascii=False, default=str)
    summaries_text = "\n- ".join(list(set(all_summaries)))

    # Precalcular SOV % de la categoría para evitar expresiones complejas en el f-string
    _sov_cat = kpis.get('sov_by_category', {}).get(category_name, {"client": 0, "total": 0})
    _client = float(_sov_cat.get('client', 0))
    _total = float(_sov_cat.get('total', 0))
    _sov_pct = (_client / _total * 100.0) if _total > 0 else 0.0

    prompt = f"""
    **ROL:** Eres un Analista de Inteligencia de Mercado Senior.
    **TAREA:** Redacta un resumen ejecutivo para la sección de un informe. Interpreta los datos, no te limites a listarlos. **Integra las métricas clave (KPIs) de forma natural en tu análisis** para dar un contexto cuantitativo.
    
    **SECCIÓN A ANALIZAR:** "{category_name}"

    **KPIs GENERALES DEL PERIODO:**
    - Menciones totales analizadas: {kpis.get('total_mentions', 'N/A')}
    - Sentimiento general promedio: {kpis.get('average_sentiment', 0.0):.2f} (en una escala de -1 a 1)
    - SOV de esta sección (cliente / total en %): {_sov_pct:.2f}%

    **DATOS DETALLADOS DE ESTA SECCIÓN:**
    ```json
    {data_json}
    ```

    **RESUMEN GLOBAL DE TODOS LOS TEMAS DETECTADOS (para contexto):**
    - {summaries_text}

    **INSTRUCCIÓN:**
    Basándote en TODOS los datos proporcionados, escribe un párrafo de análisis de entre 120 y 180 palabras para la sección "{category_name}". Cubre: contexto de mercado, competencia (incluye SOV si aplica) y sentimiento. Compara el sentimiento de esta sección con el promedio general cuando aporte valor. Termina con 1 recomendación práctica.
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


def get_executive_summary_prompt(aggregated_data: dict) -> str:
    """Crea un prompt de Resumen Ejecutivo basado en KPIs enriquecidos (incluye SOV y competencia)."""
    kpis = aggregated_data.get('kpis', {})
    client_name = aggregated_data.get('client_name', 'Nuestra marca')
    competitors = aggregated_data.get('market_competitors', [])
    total_mentions = kpis.get('total_mentions', 0)
    avg_sent = kpis.get('average_sentiment', 0.0)
    sov_total = kpis.get('share_of_voice', 0.0)
    competitor_mentions = kpis.get('competitor_mentions', {})
    sov_by_cat = kpis.get('sov_by_category', {})

    comp_json = json.dumps(competitor_mentions, ensure_ascii=False, indent=2)
    sov_cat_json = json.dumps(sov_by_cat, ensure_ascii=False, indent=2)

    return f"""
    **ROL:** Eres un Chief Insights Officer.
    **TAREA:** Redacta un RESUMEN EJECUTIVO (2-3 párrafos) claro y accionable.

    **DATOS CLAVE:**
    - Marca analizada: {client_name}
    - Competidores monitoreados: {', '.join(competitors) if competitors else 'N/D'}
    - Menciones totales (periodo): {total_mentions}
    - Sentimiento promedio (escala -1 a 1): {avg_sent:.2f}
    - Share of Voice total (cliente vs. competidores): {sov_total:.2f}%

    **Desglose de SOV por categoría (cliente/total):**
    ```json
    {sov_cat_json}
    ```

    **Menciones de competidores (conteo):**
    ```json
    {comp_json}
    ```

    **INSTRUCCIÓN:**
    - Sintetiza qué pasó en el periodo, qué temas destacaron y cómo quedó la competencia (usa SOV para evidenciarlo).
    - Indica implicaciones estratégicas para el negocio (no tácticas de bajo nivel).
    - Sé concreto, evita jerga, y prioriza claridad.
    """


def get_competitive_analysis_prompt(aggregated_data: dict) -> str:
    """Genera un prompt para la sección de Análisis Competitivo (SOV total y por tema)."""
    kpis = aggregated_data.get('kpis', {})
    client_name = aggregated_data.get('client_name', 'Nuestra marca')
    competitors = aggregated_data.get('market_competitors', [])
    sov_total = kpis.get('share_of_voice', 0.0)
    competitor_mentions = kpis.get('competitor_mentions', {})
    sov_by_cat = kpis.get('sov_by_category', {})
    comp_json = json.dumps(competitor_mentions, ensure_ascii=False, indent=2)
    sov_cat_json = json.dumps(sov_by_cat, ensure_ascii=False, indent=2)

    return f"""
    **ROL:** Eres un Analista de Competencia.
    **TAREA:** Redacta la sección "Análisis Competitivo" del informe.

    **Contexto:** Cliente = {client_name}. Competidores = {', '.join(competitors) if competitors else 'N/D'}.
    - SOV total del cliente: {sov_total:.2f}%
    - SOV por categoría (cliente/total):
    ```json
    {sov_cat_json}
    ```
    - Menciones por competidor:
    ```json
    {comp_json}
    ```

    **INSTRUCCIÓN:**
    - Identifica quién lidera la conversación total y por tema; resalta brechas (>10pp).
    - Señala categorías donde el cliente está subrepresentado y oportunidades para ganar share.
    - Concluye con 3 bullets de movimientos competitivos recomendados.
    """


def get_deep_dive_analysis_prompt(category_name: str, category_data: list, kpis: dict, client_name: str) -> str:
    """Prompt para Deep Dive por categoría: mercado, competencia y sentimiento, con SOV específico."""
    data_json = json.dumps(category_data, indent=2, ensure_ascii=False, default=str)
    sov_cat = kpis.get('sov_by_category', {}).get(category_name, {"client": 0, "total": 0})
    client = float(sov_cat.get('client', 0))
    total = float(sov_cat.get('total', 0))
    sov_pct = (client / total * 100.0) if total > 0 else 0.0
    avg_sent = kpis.get('average_sentiment', 0.0)
    cat_sent = kpis.get('sentiment_by_category', {}).get(category_name, {})
    cat_avg = float(cat_sent.get('average', 0.0))

    return f"""
    **ROL:** Eres un Analista Senior.
    **TAREA:** Deep dive de la categoría "{category_name}".

    **SOV de la categoría (cliente/total):** {sov_pct:.2f}% ({int(client)} menciones cliente / {int(total)} con marca)
    **Sentimiento promedio (global vs. categoría):** global={avg_sent:.2f}, categoría={cat_avg:.2f}

    **Evidencias (muestras de menciones):**
    ```json
    {data_json}
    ```

    **INSTRUCCIÓN:**
    - Explica el contexto de mercado, posicionamiento competitivo (usa SOV) y tono del sentimiento.
    - Resalta patrones y drivers.
    - Cierra con 2 recomendaciones accionables.
    (Extensión: 120-180 palabras)
    """