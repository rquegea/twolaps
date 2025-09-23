import os
import re
from datetime import datetime, timedelta
import psycopg2
import psycopg2.extras
from collections import defaultdict, Counter

def get_db_connection():
    """Establece la conexión con la base de datos.

    Preferimos `DATABASE_URL` si está definido (p. ej. en Docker Compose),
    y caemos a las variables `POSTGRES_*` para entornos locales.
    """
    database_url = os.getenv("DATABASE_URL")
    if database_url:
        return psycopg2.connect(database_url)
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "postgres"),
        port=os.getenv("DB_PORT", 5432),
        dbname=os.getenv("POSTGRES_DB"),
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD")
    )

def _compile_brand_patterns(brands: list) -> list:
    """Crea patrones regex robustos (case-insensitive, con límites de palabra) para detectar marcas."""
    patterns = []
    for brand in brands:
        if not brand:
            continue
        # Escapar caracteres especiales y permitir espacios variables
        escaped = re.escape(brand.strip())
        # Usar límites de palabra cuando sea razonable; caer a coincidencia flexible
        pattern = re.compile(rf"(?i)(?<!\w){escaped}(?!\w)")
        patterns.append((brand, pattern))
    return patterns


def detectar_marcas(texto: str, marcas: list) -> list:
    """Devuelve la lista de marcas detectadas en el texto (coincidencias únicas por mención)."""
    if not texto:
        return []
    found = set()
    for original, pattern in _compile_brand_patterns(marcas):
        if pattern.search(texto or ""):
            found.add(original)
    return list(found)


def _parse_date(date_str: str) -> datetime:
    return datetime.strptime(date_str, "%Y-%m-%d")


def _format_date(date_obj: datetime) -> str:
    return date_obj.strftime("%Y-%m-%d")


def _compute_previous_period(start_date: str, end_date: str) -> tuple[str, str]:
    """
    Calcula el periodo anterior de igual duración inmediatamente anterior al periodo actual.
    Ambos parámetros y valores devueltos en formato YYYY-MM-DD.
    """
    start_dt = _parse_date(start_date)
    end_dt = _parse_date(end_date)
    # Duración inclusiva en días (suponemos que la query usa < end+1day)
    duration_days = (end_dt - start_dt).days + 1
    prev_end = start_dt - timedelta(days=1)
    prev_start = prev_end - timedelta(days=duration_days - 1)
    return _format_date(prev_start), _format_date(prev_end)


def aggregate_data_for_report(client_id: int, market_id: int, start_date: str, end_date: str) -> dict:
    """
    Recopila, agrega y calcula KPIs desde la base de datos para el informe.
    Incluye: SOV total, menciones de competidores y SOV por categoría (cliente/total).
    """
    print(f"Agregando datos y calculando KPIs para el cliente {client_id}...")
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    
    # Estructura para almacenar todos los datos
    aggregated_data = {
        "client_id": client_id,
        "market_id": market_id,
        "start_date": start_date,
        "end_date": end_date,
        "mentions_by_category": defaultdict(list),
        "all_summaries": [],
        "kpis": {
            "total_mentions": 0,
            "average_sentiment": 0.0,
            "sentiment_by_category": defaultdict(lambda: {
                'sum': 0,
                'count': 0,
                'average': 0.0,
                # Distribución por categoría (conteos)
                'distribution': {'positive': 0, 'neutral': 0, 'negative': 0},
                # Temas más frecuentes por categoría
                'key_topics': Counter(),
            }),
            # Métricas de visibilidad (legado)
            "mentions_by_category_count": defaultdict(int),
            "share_of_voice_by_category": {},
            "visibility_index": 0.0,
            # NUEVOS KPIs basados en marcas
            "share_of_voice": 0.0,
            "competitor_mentions": defaultdict(int),
            # Desglose granular por categoría: menciones cliente/competidores/total con marcas
            "sov_by_category": defaultdict(lambda: {"client": 0, "total": 0, "competitors": defaultdict(int)}),
        }
    }

    try:
        # Obtener datos de mercado y cliente (competidores y nombre de cliente como marca base)
        cur.execute("SELECT name FROM clients WHERE id = %s;", (client_id,))
        client_row = cur.fetchone()
        client_name = client_row[0] if client_row else ""

        cur.execute("SELECT competitors FROM markets WHERE id = %s AND client_id = %s;", (market_id, client_id))
        market_row = cur.fetchone()
        market_competitors = []
        if market_row and market_row[0] is not None:
            # Puede venir como lista JSON o dict dependiente; normalizar a lista de strings
            comp = market_row[0]
            if isinstance(comp, list):
                market_competitors = [str(c) for c in comp]
            else:
                try:
                    # psycopg2 ya parsea JSONB a tipos python; fallback defensivo
                    market_competitors = [str(c) for c in list(comp)]
                except Exception:
                    market_competitors = []

        # Exponer metadatos para etapas posteriores (prompts, PDF)
        aggregated_data["client_name"] = client_name
        aggregated_data["market_competitors"] = market_competitors

        # Helper para ejecutar la query de menciones por periodo
        def fetch_mentions_for_period(start: str, end: str):
            cur.execute(
                """
                SELECT
                    pc.name as category_name,
                    m.summary,
                    m.sentiment,
                    m.key_topics
                FROM mentions m
                JOIN queries q ON m.query_id = q.id
                JOIN prompt_categories pc ON q.category_id = pc.id
                WHERE m.client_id = %s
                  AND q.market_id = %s
                  AND m.created_at >= %s::date
                  AND m.created_at < (%s::date + INTERVAL '1 day');
                """,
                (client_id, market_id, start, end),
            )
            return cur.fetchall()

        # Query de menciones con categoría (incluye key_topics) periodo actual
        rows = fetch_mentions_for_period(start_date, end_date)

        aggregated_data["kpis"]["total_mentions"] = len(rows)
        if not rows:
            # Aun así calcular periodo anterior para exponer metadatos
            prev_start, prev_end = _compute_previous_period(start_date, end_date)
            aggregated_data["previous_period"] = {"start_date": prev_start, "end_date": prev_end}
            return aggregated_data

        total_sentiment = 0.0
        # Acumuladores globales para temas/entidades
        global_topics_counter = Counter()
        topic_counts_by_category: dict[str, Counter] = defaultdict(Counter)
        for row in rows:
            category = row['category_name']
            # Normalizar a float para evitar mezclar Decimal con float más adelante
            sentiment = float(row['sentiment']) if row['sentiment'] is not None else 0.0
            
            row_dict = dict(row)
            row_dict['sentiment'] = sentiment
            aggregated_data["mentions_by_category"][category].append(row_dict)
            if row['summary']:
                aggregated_data["all_summaries"].append(row['summary'])
            
            # Cálculos para KPIs
            total_sentiment += sentiment
            kpi_cat = aggregated_data["kpis"]["sentiment_by_category"][category]
            kpi_cat['sum'] += sentiment
            kpi_cat['count'] += 1
            # 1) Distribución de sentimiento
            if sentiment > 0.2:
                kpi_cat['distribution']['positive'] += 1
            elif sentiment < -0.2:
                kpi_cat['distribution']['negative'] += 1
            else:
                kpi_cat['distribution']['neutral'] += 1
            # 2) Temas clave agregados
            key_topics = row.get('key_topics') if isinstance(row, dict) else row['key_topics']
            if key_topics:
                try:
                    # psycopg2 convierte JSONB a list/dict automáticamente; normalizar a lista de strings
                    if isinstance(key_topics, list):
                        normalized = [str(t) for t in key_topics]
                        kpi_cat['key_topics'].update(normalized)
                        global_topics_counter.update(normalized)
                        topic_counts_by_category[category].update(normalized)
                    elif isinstance(key_topics, dict):
                        # Si viniera como {topic: count}, sumar counts
                        norm_dict = {str(k): int(v) for k, v in key_topics.items()}
                        kpi_cat['key_topics'].update(norm_dict)
                        global_topics_counter.update(norm_dict)
                        topic_counts_by_category[category].update(norm_dict)
                    else:
                        # cadena con separado por comas (fallback)
                        parts = [s.strip() for s in str(key_topics).split(',') if s.strip()]
                        if parts:
                            kpi_cat['key_topics'].update(parts)
                            global_topics_counter.update(parts)
                            topic_counts_by_category[category].update(parts)
                except Exception:
                    pass
            aggregated_data["kpis"]["mentions_by_category_count"][category] += 1

            # --- Detección de marcas para SOV ---
            detected_brands = detectar_marcas(row['summary'], [client_name] + market_competitors)
            if detected_brands:
                for brand in detected_brands:
                    if brand == client_name:
                        aggregated_data["kpis"]["sov_by_category"][category]["client"] += 1
                    else:
                        aggregated_data["kpis"]["competitor_mentions"][brand] += 1
                        # Desglose de competidores por categoría
                        aggregated_data["kpis"]["sov_by_category"][category]["competitors"][brand] += 1
                    aggregated_data["kpis"]["sov_by_category"][category]["total"] += 1

        # Finalizar cálculos
        total_mentions = float(len(rows))
        aggregated_data["kpis"]["average_sentiment"] = float(total_sentiment) / total_mentions
        aggregated_data["kpis"]["visibility_index"] = total_mentions
        
        # Calcular la media de sentimiento por categoría
        for category, values in aggregated_data["kpis"]["sentiment_by_category"].items():
            values['average'] = float(values['sum']) / float(values['count']) if values['count'] > 0 else 0.0
            # Convertir Counter a top-5 dict para serialización JSON
            if isinstance(values.get('key_topics'), Counter):
                values['key_topics'] = dict(values['key_topics'].most_common(5))

        # Métrica legada: % de visibilidad por categoría (del total de menciones)
        sov_legacy = {}
        for category, count in aggregated_data["kpis"]["mentions_by_category_count"].items():
            sov_legacy[category] = (float(count) / total_mentions) * 100.0 if total_mentions > 0 else 0.0
        aggregated_data["kpis"]["share_of_voice_by_category"] = sov_legacy

        # Calcular SOV total basado en marcas detectadas
        total_client_mentions = sum(cat_counts["client"] for cat_counts in aggregated_data["kpis"]["sov_by_category"].values())
        total_competitor_mentions = sum(aggregated_data["kpis"]["competitor_mentions"].values())
        total_mentions_with_brands = float(total_client_mentions + total_competitor_mentions)
        if total_mentions_with_brands > 0:
            aggregated_data["kpis"]["share_of_voice"] = (float(total_client_mentions) / total_mentions_with_brands) * 100.0
        else:
            aggregated_data["kpis"]["share_of_voice"] = 0.0

        # Temas/entidades globales
        aggregated_data["global_key_topics"] = dict(global_topics_counter.most_common(15))
        aggregated_data["topic_counts_by_category"] = {
            cat: dict(cnt.most_common(20)) for cat, cnt in topic_counts_by_category.items()
        }

        # -------------- Tendencias (comparación periodo anterior) --------------
        prev_start, prev_end = _compute_previous_period(start_date, end_date)
        aggregated_data["previous_period"] = {"start_date": prev_start, "end_date": prev_end}
        prev_rows = fetch_mentions_for_period(prev_start, prev_end)

        prev_total_sentiment = 0.0
        prev_sentiment_by_category = defaultdict(lambda: {"sum": 0.0, "count": 0})
        prev_global_topics_counter = Counter()
        prev_topic_counts_by_category: dict[str, Counter] = defaultdict(Counter)
        prev_sov_by_category = defaultdict(lambda: {"client": 0, "total": 0, "competitors": defaultdict(int)})
        prev_competitor_mentions = defaultdict(int)
        for row in prev_rows:
            category = row['category_name']
            sentiment = float(row['sentiment']) if row['sentiment'] is not None else 0.0
            prev_total_sentiment += sentiment
            prev_sentiment_by_category[category]["sum"] += sentiment
            prev_sentiment_by_category[category]["count"] += 1
            key_topics = row.get('key_topics') if isinstance(row, dict) else row['key_topics']
            if key_topics:
                try:
                    if isinstance(key_topics, list):
                        normalized = [str(t) for t in key_topics]
                        prev_global_topics_counter.update(normalized)
                        prev_topic_counts_by_category[category].update(normalized)
                    elif isinstance(key_topics, dict):
                        norm_dict = {str(k): int(v) for k, v in key_topics.items()}
                        prev_global_topics_counter.update(norm_dict)
                        prev_topic_counts_by_category[category].update(norm_dict)
                    else:
                        parts = [s.strip() for s in str(key_topics).split(',') if s.strip()]
                        if parts:
                            prev_global_topics_counter.update(parts)
                            prev_topic_counts_by_category[category].update(parts)
                except Exception:
                    pass
            # Marcas para SOV previo
            detected_prev = detectar_marcas(row['summary'], [client_name] + market_competitors)
            if detected_prev:
                for brand in detected_prev:
                    if brand == client_name:
                        prev_sov_by_category[category]["client"] += 1
                    else:
                        prev_competitor_mentions[brand] += 1
                        prev_sov_by_category[category]["competitors"][brand] += 1
                    prev_sov_by_category[category]["total"] += 1

        # KPIs previos simples
        prev_total_mentions = float(len(prev_rows))
        prev_avg_sentiment = (prev_total_sentiment / prev_total_mentions) if prev_total_mentions > 0 else 0.0
        prev_avg_by_cat = {
            cat: (vals["sum"] / vals["count"]) if vals["count"] > 0 else 0.0
            for cat, vals in prev_sentiment_by_category.items()
        }

        # Deltas de sentimiento
        trends = {
            "sentiment_delta_total": aggregated_data["kpis"]["average_sentiment"] - prev_avg_sentiment,
            "sentiment_delta_by_category": {},
            "sov_delta_by_category": {},
            "competitor_mentions_delta": {},
            "emerging_topics": [],  # tópicos con crecimiento fuerte
        }

        for category, current_vals in aggregated_data["kpis"]["sentiment_by_category"].items():
            prev_avg = float(prev_avg_by_cat.get(category, 0.0))
            trends["sentiment_delta_by_category"][category] = current_vals.get("average", 0.0) - prev_avg

        # Deltas de SOV por categoría (cliente/total %)
        def compute_pct(entry: dict) -> float:
            total_local = float(entry.get("total", 0))
            client_local = float(entry.get("client", 0))
            return (client_local / total_local * 100.0) if total_local > 0 else 0.0

        for category, entry in aggregated_data["kpis"].get("sov_by_category", {}).items():
            current_pct = compute_pct(entry)
            prev_pct = compute_pct(prev_sov_by_category.get(category, {}))
            trends["sov_delta_by_category"][category] = current_pct - prev_pct

        # Deltas de menciones por competidor
        for brand, count in aggregated_data["kpis"].get("competitor_mentions", {}).items():
            prev_count = int(prev_competitor_mentions.get(brand, 0))
            trends["competitor_mentions_delta"][brand] = int(count) - prev_count

        # Tópicos emergentes: crecimiento absoluto >= 5 o ratio >= 200%
        current_topics = global_topics_counter
        prev_topics = prev_global_topics_counter
        emerging = []
        for topic, cur_count in current_topics.items():
            prev_count = int(prev_topics.get(topic, 0))
            if cur_count >= 3 and (prev_count == 0 or cur_count - prev_count >= 5 or (prev_count > 0 and (cur_count / prev_count) >= 2.0)):
                emerging.append({
                    "topic": topic,
                    "current": int(cur_count),
                    "previous": int(prev_count),
                    "delta": int(cur_count - prev_count),
                    "growth_ratio": (float(cur_count) / float(prev_count)) if prev_count > 0 else None,
                })
        # Ordenar por delta desc
        emerging.sort(key=lambda x: (x["delta"], x["current"]), reverse=True)
        trends["emerging_topics"] = emerging[:10]

        aggregated_data["trends"] = trends

        print(f"Datos agregados: {len(rows)} menciones, sentimiento promedio: {aggregated_data['kpis']['average_sentiment']:.2f}")

    finally:
        cur.close()
        conn.close()
        
    return aggregated_data