import os
import psycopg2
from psycopg2.extras import Json
from dotenv import load_dotenv

# Cargar variables de entorno
load_dotenv()

# --- DATOS DE PRUEBA ---

# 1. Clientes y Mercados
CLIENT_DATA = {"name": "Cliente Demo", "api_keys": {}}
MARKET_DATA = {
    "name": "España",
    "description": "Mercado principal",
    "competitors": ["Competidor A", "Competidor B", "Otra Marca"],
}

# 2. Categorías Estratégicas de Prompts
PROMPT_CATEGORIES = [
    ("Análisis de mercado", "Tendencias generales, hábitos de consumo, evolución sectorial."),
    ("Análisis de competencia", "Acciones de competidores, campañas, share of voice, comparativas."),
    ("Análisis de sentimiento y reputación", "Opiniones de consumidores, emociones predominantes, percepciones de marca."),
    ("Análisis de desempeño (KPIs)", "Métricas de visibilidad, impacto de campañas, evolución temporal."),
    ("Análisis de oportunidades", "Nuevos nichos, innovación de producto, territorios de comunicación."),
    ("Análisis de riesgos", "Crisis potenciales, quejas recurrentes, temas sensibles."),
    ("Análisis contextual", "Factores externos: noticias, regulación, economía, cultura."),
]

# 3. Set de Prompts de Prueba (Query, Categoría)
PROMPTS_TO_INSERT = [
    # Análisis de mercado
    ("¿Cuáles son las últimas tendencias en consumo de contenido digital en España?", "Análisis de mercado"),
    ("Evolución del sector ed-tech en LATAM durante los últimos 2 años.", "Análisis de mercado"),
    # Análisis de competencia
    ("Comparativa de precios de másteres de marketing digital entre las principales escuelas de negocio españolas.", "Análisis de competencia"),
    ("¿Qué campañas de publicidad ha lanzado recientemente nuestro principal competidor?", "Análisis de competencia"),
    # Análisis de sentimiento y reputación
    ("¿Cuál es la percepción general de los estudiantes sobre la formación online en España?", "Análisis de sentimiento y reputación"),
    ("Opiniones y quejas sobre los bootcamps de programación en Madrid.", "Análisis de sentimiento y reputación"),
    # Análisis de desempeño (KPIs)
    ("Evolución de la visibilidad online de nuestra marca en el último trimestre.", "Análisis de desempeño (KPIs)"),
    # Análisis de oportunidades
    ("¿Qué nuevos nichos de mercado existen para la formación en inteligencia artificial?", "Análisis de oportunidades"),
    # Análisis de riesgos
    ("¿Cuáles son las principales críticas a los modelos de suscripción en plataformas educativas?", "Análisis de riesgos"),
    # Análisis contextual
    ("¿Cómo afecta la nueva regulación europea de IA al sector educativo?", "Análisis contextual"),
]


def get_db_connection():
    """Establece la conexión con la base de datos."""
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "postgres"),
        port=os.getenv("DB_PORT", 5432),
        dbname=os.getenv("POSTGRES_DB"),
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD"),
    )


def seed_data():
    """Inserta los datos iniciales en la base de datos."""
    conn = get_db_connection()
    cur = conn.cursor()
    print("🌱 Empezando a poblar la base de datos con datos de prueba...")

    try:
        # 1. Insertar Cliente
        cur.execute("INSERT INTO clients (name, api_keys) VALUES (%s, %s) ON CONFLICT (name) DO NOTHING RETURNING id;",
                    (CLIENT_DATA["name"], Json(CLIENT_DATA["api_keys"])))
        client_id_row = cur.fetchone()
        if not client_id_row:
            cur.execute("SELECT id FROM clients WHERE name = %s;", (CLIENT_DATA["name"],))
            client_id = cur.fetchone()[0]
        else:
            client_id = client_id_row[0]
        print(f"   - Cliente '{CLIENT_DATA['name']}' asegurado con ID: {client_id}")

        # 2. Insertar Mercado (con lista de competidores)
        cur.execute(
            """
            INSERT INTO markets (client_id, name, description, competitors)
            VALUES (%s, %s, %s, %s)
            ON CONFLICT (client_id, name) DO UPDATE SET
                description = EXCLUDED.description,
                competitors = EXCLUDED.competitors
            RETURNING id;
            """,
            (
                client_id,
                MARKET_DATA["name"],
                MARKET_DATA["description"],
                Json(MARKET_DATA["competitors"]),
            ),
        )
        market_id = cur.fetchone()[0]
        print(f"   - Mercado '{MARKET_DATA['name']}' asegurado con ID: {market_id}")

        # 3. Insertar Categorías
        category_map = {}
        for name, desc in PROMPT_CATEGORIES:
            cur.execute("INSERT INTO prompt_categories (name, description) VALUES (%s, %s) ON CONFLICT (name) DO NOTHING RETURNING id;",
                        (name, desc))
            category_id_row = cur.fetchone()
            if not category_id_row:
                cur.execute("SELECT id FROM prompt_categories WHERE name = %s;", (name,))
                cat_id = cur.fetchone()[0]
            else:
                cat_id = category_id_row[0]
            category_map[name] = cat_id
        print(f"   - {len(category_map)} categorías estratégicas aseguradas.")

        # 4. Insertar Prompts
        inserted_count = 0
        for query_text, category_name in PROMPTS_TO_INSERT:
            category_id = category_map.get(category_name)
            if not category_id:
                print(f"   - ⚠️  Categoría '{category_name}' no encontrada. Saltando prompt.")
                continue
            
            cur.execute("INSERT INTO queries (market_id, category_id, query) VALUES (%s, %s, %s) ON CONFLICT (market_id, query) DO NOTHING;",
                        (market_id, category_id, query_text))
            if cur.rowcount > 0:
                inserted_count += 1
        
        print(f"   - {inserted_count} nuevos prompts insertados.")
        conn.commit()
        print("\n✅ ¡Base de datos poblada con éxito!")

    except Exception as e:
        conn.rollback()
        print(f"❌ Error al poblar la base de datos: {e}")
    finally:
        cur.close()
        conn.close()


if __name__ == "__main__":
    seed_data()
