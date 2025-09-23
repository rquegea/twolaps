import os
import psycopg2
from datetime import datetime
import psycopg2.extras

def get_db_connection():
    """Establece la conexión con la base de datos."""
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
    Recopila y agrega datos de la base de datos para un cliente y período específicos.
    """
    print(f"Agregando datos para el cliente {client_id} desde {start_date} hasta {end_date}...")
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    
    aggregated_data = {
        "client_id": client_id,
        "market_id": market_id,
        "start_date": start_date,
        "end_date": end_date,
        "mentions_by_category": {},
        "all_summaries": []
    }

    try:
        cur.execute("""
            SELECT
                pc.name as category_name,
                m.response,
                m.summary,
                m.sentiment,
                m.key_topics,
                m.engine
            FROM mentions m
            JOIN queries q ON m.query_id = q.id
            JOIN prompt_categories pc ON q.category_id = pc.id
            WHERE m.client_id = %s
              AND q.market_id = %s
              AND m.created_at >= %s::date
              AND m.created_at < (%s::date + INTERVAL '1 day');
        """, (client_id, market_id, start_date, end_date))
        
        rows = cur.fetchall()
        
        for row in rows:
            category = row['category_name']
            if category not in aggregated_data["mentions_by_category"]:
                aggregated_data["mentions_by_category"][category] = []
            
            aggregated_data["mentions_by_category"][category].append(dict(row))
            if row['summary']:
                aggregated_data["all_summaries"].append(row['summary'])

        print(f"Datos agregados: {len(rows)} menciones encontradas.")

    finally:
        cur.close()
        conn.close()
        
    return aggregated_data