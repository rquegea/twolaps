import os
import psycopg2
import psycopg2.extras
from collections import defaultdict

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

def aggregate_data_for_report(client_id: int, market_id: int, start_date: str, end_date: str) -> dict:
    """
    Recopila, agrega y calcula KPIs desde la base de datos para el informe.
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
            "sentiment_by_category": defaultdict(lambda: {'sum': 0, 'count': 0})
        }
    }

    try:
        cur.execute("""
            SELECT
                pc.name as category_name,
                m.summary,
                m.sentiment
            FROM mentions m
            JOIN queries q ON m.query_id = q.id
            JOIN prompt_categories pc ON q.category_id = pc.id
            WHERE m.client_id = %s
              AND q.market_id = %s
              AND m.created_at >= %s::date
              AND m.created_at < (%s::date + INTERVAL '1 day');
        """, (client_id, market_id, start_date, end_date))
        
        rows = cur.fetchall()
        
        aggregated_data["kpis"]["total_mentions"] = len(rows)
        if not rows:
            return aggregated_data

        total_sentiment = 0.0
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

        # Finalizar cálculos
        aggregated_data["kpis"]["average_sentiment"] = float(total_sentiment) / float(len(rows))
        
        # Calcular la media de sentimiento por categoría
        for category, values in aggregated_data["kpis"]["sentiment_by_category"].items():
            values['average'] = float(values['sum']) / float(values['count']) if values['count'] > 0 else 0.0

        print(f"Datos agregados: {len(rows)} menciones, sentimiento promedio: {aggregated_data['kpis']['average_sentiment']:.2f}")

    finally:
        cur.close()
        conn.close()
        
    return aggregated_data