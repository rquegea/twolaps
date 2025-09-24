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
    Instruye a la IA a analizar explícitamente series temporales (globales y por categoría),
    detectar anomalías, cruzar volumen vs. sentimiento, formular hipótesis y proponer acciones.
    """
    data_json = json.dumps(aggregated_data, ensure_ascii=False, default=str)
    return (
        "Eres un Analista de Datos y Estratega Senior. "
        "Analiza todos los datos proporcionados y devuelve EXCLUSIVAMENTE un objeto JSON con la estructura especificada. "
        "NO incluyas texto explicativo, comentarios ni markdown, solo el JSON. "
        "Los datos a analizar son:\n\n"
        "```json\n" + data_json + "\n```\n\n"
        "Objetivos de análisis (aplícalos al conjunto global y por categoría cuando existan datos):\n"
        "1) Serie temporal - tendencia: Describe si el sentimiento y el volumen son ascendentes, descendentes, estables o volátiles.\n"
        "2) Anomalías: Identifica picos/caídas significativas; indica fechas y magnitud (aprox.).\n"
        "3) Cruce Sentimiento vs Volumen: Explica si aumentos de conversación coinciden con caídas de sentimiento (o viceversa).\n"
        "4) Hipótesis: Aporta explicaciones plausibles de las anomalías (p.ej. campaña de competidor, noticia, lanzamiento).\n"
        "5) Conclusiones estratégicas: Resume oportunidades, riesgos y un plan de acción concreto.\n\n"
        "Estructura esperada del JSON de salida (rellena con tu análisis):\n\n"
        "{\n"
        "  \"executive_summary\": \"2-3 frases con lo más crítico y útil para negocio.\",\n"
        "  \"time_series_analysis\": {\n"
        "    \"global\": {\n"
        "      \"trend\": \"ascendente|descendente|estable|volátil\",\n"
        "      \"anomalies\": [ { \"date\": \"YYYY-MM-DD\", \"type\": \"spike|drop\", \"metric\": \"mentions|sentiment\", \"note\": \"breve explicación\" } ],\n"
        "      \"sentiment_vs_volume\": \"breve explicación del cruce\"\n"
        "    },\n"
        "    \"by_category\": [\n"
        "      { \"category\": \"Nombre\", \"trend\": \"...\", \"anomalies\": [ ... ], \"sentiment_vs_volume\": \"...\" }\n"
        "    ]\n"
        "  },\n"
        "  \"key_findings\": [\n"
        "    \"Un hallazgo importante sobre el mercado (basado en series y KPIs).\",\n"
        "    \"Otro hallazgo relevante sobre la competencia (SOV, picos, etc.).\",\n"
        "    \"Un tercer hallazgo sobre la percepción del cliente.\"\n"
        "  ],\n"
        "  \"opportunities\": [ { \"opportunity\": \"Descripción\", \"impact\": \"Alto|Medio|Bajo\" } ],\n"
        "  \"risks\": [ { \"risk\": \"Descripción\", \"mitigation\": \"Acción\" } ],\n"
        "  \"recommendations\": [ \"Acción 1\", \"Acción 2\", \"Acción 3\" ]\n"
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

    return (
        f"""
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
    )


def get_deep_dive_analysis_prompt(category_name: str, kpis: dict, client_name: str) -> str:
    """
    NUEVO PROMPT MEJORADO para el análisis detallado por categoría.
    Usa los KPIs enriquecidos para forzar un análisis de "minería de datos".
    """
    cat_kpis = kpis.get('sentiment_by_category', {}).get(category_name, {})

    sentiment_avg = cat_kpis.get('average', 0.0)
    distribution = cat_kpis.get('distribution', {})
    key_topics = cat_kpis.get('key_topics', {})

    dist_text = json.dumps(distribution, indent=2, ensure_ascii=False)
    topics_text = json.dumps(key_topics, indent=2, ensure_ascii=False)

    return f"""
    **ROL:** Eres un Analista de Inteligencia de Mercado experto en el sector de {client_name}.
    **TAREA:** Escribe el análisis para la sección "{category_name}" de un informe. Tu análisis debe ser una minería de datos, conectando los datos cuantitativos con conclusiones cualitativas y accionables.

    **DATOS CUANTITATIVOS DE ESTA SECCIÓN:**
    - Sentimiento Promedio de la Sección: {sentiment_avg:.2f} (comparado con el general de {kpis.get('average_sentiment', 0.0):.2f})
    - Distribución del Sentimiento:
    {dist_text}
    - Temas Clave (y su frecuencia):
    {topics_text}

    **INSTRUCCIONES:**
    1.  **Interpreta el Sentimiento:** ¿Es el sentimiento de esta categoría significativamente diferente del promedio general? ¿Qué nos dice la distribución (ej. es polarizado, mayormente neutral, etc.)?
    2.  **Conecta con los Temas:** ¿Cómo se relacionan los temas más frecuentes con el sentimiento observado? (ej. 'El sentimiento negativo está impulsado principalmente por conversaciones sobre 'precios'').
    3.  **Extrae un Insight Accionable:** Basado en esta conexión entre datos y temas, ¿cuál es la principal conclusión o recomendación para {client_name}?

    **FORMATO:** Redacta un párrafo de análisis denso, profesional y directo. No listes los datos, intégralos en tu narrativa.
    """


def get_correlation_interpretation_prompt(aggregated_data: dict, correlation_data: dict) -> str:
    """
    Solicita a la IA de alto nivel que interprete correlaciones transversales entre categorías y KPIs.
    """
    data_json = json.dumps(correlation_data, indent=2, ensure_ascii=False)
    client_name = aggregated_data.get('client_name', 'Nuestra marca')
    return f"""
    **ROL:** Eres un Analista Principal de Insights con enfoque causal.
    **TAREA:** Interpreta las correlaciones transversales entre categorías y KPIs y extrae 3-5 insights potentes y accionables para {client_name}.

    **DATOS DE CORRELACIÓN (base):**
    ```json
    {data_json}
    ```

    **INSTRUCCIONES:**
    - Prioriza relaciones con mayor "strength" y soporte cuantitativo.
    - Formula hipótesis plausibles y cómo validarlas (dato/experimento).
    - Concreta implicaciones y una recomendación por insight.
    - Responde en 2-3 párrafos, profesional y claro.
    """


def get_trends_anomalies_prompt(aggregated_data: dict) -> str:
    """
    Pide a la IA analizar tendencias y anomalías entre periodo actual y anterior.
    """
    trends = aggregated_data.get('trends', {})
    prev = aggregated_data.get('previous_period', {})
    trends_json = json.dumps(trends, indent=2, ensure_ascii=False)
    return f"""
    **ROL:** Eres un Analista de Tendencias.
    **TAREA:** Redacta la sección "Tendencias y Señales Emergentes" del informe, explicando cambios significativos entre periodos.

    **PERIODO ANTERIOR:** {prev.get('start_date', 'N/D')} a {prev.get('end_date', 'N/D')}
    **CAMBIOS (trends JSON):**
    ```json
    {trends_json}
    ```

    **INSTRUCCIONES:**
    - Explica las variaciones de sentimiento (total y por categoría) y SOV por categoría.
    - Destaca competidores que ganaron/perdieron share y por qué podría estar pasando.
    - Enumera 3-5 tópicos emergentes y valora si son moda o tendencia (con criterios).
    - Cierra con 3 recomendaciones tácticas inmediatas y 2 estratégicas.
    """