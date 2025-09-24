import os
import psycopg2
from psycopg2.extras import Json
from dotenv import load_dotenv

# Cargar variables de entorno
load_dotenv()

# --- DATOS PARA THE CORE SCHOOL ---

# 1. Cliente y Mercado
CLIENT_DATA = {"name": "The Core School", "api_keys": {}}
MARKET_DATA = {
    "name": "España (Educación Superior Audiovisual)",
    "description": "Mercado educativo para cine, TV, animación y videojuegos en España.",
    "competitors": ["ECAM", "U-TAD", "TAI", "ESCAC", "CEV", "Septima Ars"],
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
    ("Análisis de marketing y estrategia", "Canales, contenidos y posicionamiento para captar a jóvenes indecisos."),
]

# 3. Set de Prompts Estratégicos para The Core School
PROMPTS_TO_INSERT = [
    # Categoría: Análisis de mercado
    ('¿Qué escuelas superiores o centros privados en España ofrecen programas para escribir guiones y formación audiovisual práctica?', 'Análisis de mercado'),
    ('¿Qué escuelas especializadas en entretenimiento existen en España, aparte de las universidades públicas?', 'Análisis de mercado'),
    ('¿Cuáles son los mejores centros de formación para estudiar desarrollo de videojuegos en España con un enfoque en la industria?', 'Análisis de mercado'),
    ('¿Dónde puedo estudiar cine o televisión en Madrid en escuelas especializadas con un enfoque práctico?', 'Análisis de mercado'),
    ('¿Qué formación especializada existe en España si me gusta el cine y la televisión, más allá de los grados universitarios tradicionales?', 'Análisis de mercado'),
    ('¿Dónde estudiar carreras creativas con enfoque profesional y conexión con empresas en España?', 'Análisis de mercado'),
    ('¿Dónde ofrecen formación profesional para la creación de guiones en Madrid?', 'Análisis de mercado'),
    ('¿Dónde estudiar guion para series en España en escuelas con enfoque práctico?', 'Análisis de mercado'),
    ('¿Cuáles son las mejores escuelas de postproducción y VFX en España?', 'Análisis de mercado'),

    # Categoría: Análisis de competencia
    ('¿Cuál es el mejor máster en dirección de cine en Europa, enfocándose en escuelas con conexión directa con la industria?', 'Análisis de competencia'),
    ('¿Qué máster online para creación de contenido o para ser influencer es el mejor en España?', 'Análisis de competencia'),
    ('Comparativa de precios de grados en comunicación audiovisual en escuelas privadas de España.', 'Análisis de competencia'),
    ('Análisis comparativo entre las mejores escuelas de formación audiovisual de España', 'Análisis de competencia'),
    ('¿Cuáles son las mejores escuelas en Madrid para formarse en producción de televisión?', 'Análisis de competencia'),
    ('¿Cuáles son las mejores escuelas en Madrid para formarse en producción de televisión, del estilo de The Core School?', 'Análisis de competencia'),
    ('¿Cómo evoluciona el \'share of voice\' y el sentimiento online de The Core School frente a sus competidores en España?', 'Análisis de competencia'),
    # Nuevos (Análisis de competencia)
    ("¿Qué otras alternativas de formación (FP, grados universitarios, bootcamps, academias online) aparecen con más frecuencia en el 'set de consideración' de los jóvenes indecisos en España cuando comparan opciones frente a The Core, Escuela Superior de Audiovisuales?", 'Análisis de competencia'),
    ("¿Qué pain points destacan los jóvenes indecisos y sus padres sobre la oferta actual en formación audiovisual en España (ej. programas largos, costes altos, poca conexión con la industria, falta de prácticas reales), y cómo se diferencian frente a la propuesta de The Core?", 'Análisis de competencia'),

    # Categoría: Análisis de sentimiento y reputación
    ('¿Qué escuelas de audiovisual en España tienen los mejores acuerdos con productoras y cadenas de televisión?', 'Análisis de sentimiento y reputación'),
    ('¿Qué centros de formación audiovisual tienen la mejor reputación profesional en España, excluyendo universidades públicas?', 'Análisis de sentimiento y reputación'),
    # Nuevo (Análisis de sentimiento y reputación)
    ('¿Cómo perciben los jóvenes indecisos en España la industria audiovisual —incluyendo áreas como realización, producción, iluminación, guion y desarrollo de formatos televisivos— en términos de prestigio, empleabilidad, estabilidad e innovación, y cómo se asocia la marca The Core, Escuela Superior de Audiovisuales a estas percepciones?', 'Análisis de sentimiento y reputación'),

    # Categoría: Análisis de oportunidades (basado en Empleo y Salidas)
    ('¿Qué trabajos en el sector audiovisual tienen buen sueldo y qué formación especializada se necesita?', 'Análisis de oportunidades'),
    ('¿Qué salidas laborales reales ofrece la formación en comunicación audiovisual de escuelas privadas en España?', 'Análisis de oportunidades'),
    ('¿Es difícil encontrar trabajo en la industria del cine en España si estudio en una escuela especializada en lugar de una universidad pública?', 'Análisis de oportunidades'),
    ('¿Qué estilos de trabajo rechazan los jóvenes en España y qué carreras audiovisuales perciben con mayor libertad y mejor sueldo?', 'Análisis de oportunidades'),

    # Categoría: Análisis de riesgos (basado en Costes y Becas)
    ('¿Qué escuelas superiores privadas de cine en España ofrecen becas o ayudas al estudio?', 'Análisis de riesgos'),

    # Categoría: Análisis contextual (Audiencia, Motivaciones, Preocupaciones)
    ('¿Qué intereses en el sector audiovisual y producción de contenidos muestran los jóvenes indecisos en España?', 'Análisis contextual'),
    ("¿Qué 'triggers' o referentes motivan a los jóvenes en España a interesarse por carreras en el sector audiovisual y qué emociones asocian a ello?", 'Análisis contextual'),
    ('¿Qué motivaciones llevan a los jóvenes en España a preferir carreras creativas en audiovisual frente a estudios tradicionales?', 'Análisis contextual'),
    ('¿Cuáles son las preocupaciones de los padres en España sobre las carreras en el sector audiovisual y qué fuentes consultan para informarse?', 'Análisis contextual'),
    ('¿Qué argumentos (casos de éxito, salarios, empleo) son más persuasivos para los padres en España sobre estudiar carreras audiovisuales?', 'Análisis contextual'),
    # Nuevos (Análisis contextual)
    ("¿Cuál es la estimación del número de jóvenes en España (16-25 años) que se declaran indecisos sobre su futuro académico/profesional y qué intereses emergentes en el ámbito audiovisual (producción, realización, iluminación, guion, postproducción, desarrollo de formatos televisivos como concursos o realities) destacan en sus conversaciones online?", 'Análisis contextual'),
    ("¿Qué 'triggers' (eventos, experiencias, contenidos o referentes) mencionan los jóvenes indecisos en España como detonantes para interesarse por carreras en el audiovisual —como realización, guion, producción o formatos televisivos— y qué emociones expresan en esos momentos (curiosidad, esperanza, inseguridad)?", 'Análisis contextual'),
    ("¿Cuáles son las motivaciones principales que impulsan a los jóvenes indecisos en España a considerar carreras fuera de las tradicionales (ej. creatividad, flexibilidad, propósito, ingresos vinculados a la industria audiovisual), y qué factores producen rechazo en los estudios convencionales (exigencia, hartazgo, falta de libertad)?", 'Análisis contextual'),
    ("¿Qué tipos de trabajos o estilos de vida rechazan explícitamente los jóvenes indecisos en España (ej. 'trabajo de oficina', '9 a 5', 'oposiciones'), qué carreras vinculadas al audiovisual (realización, guion, producción, iluminación, postproducción) se asocian con una mayor sensación de libertad, y entre ellas cuáles ofrecen mejores perspectivas de remuneración tras finalizar los estudios?", 'Análisis contextual'),
    ("¿Cuáles son las preocupaciones más repetidas por los padres en España cuando sus hijos consideran carreras en el ámbito audiovisual (empleabilidad, coste, prestigio, seguridad laboral), y qué fuentes consultan para informarse sobre instituciones como The Core, Escuela Superior de Audiovisuales?", 'Análisis contextual'),
    ("¿Qué tipo de argumentos, datos o testimonios resultan más persuasivos para convencer a los padres en España sobre la viabilidad de estudiar en el ámbito audiovisual (ej. tasas de empleo, casos de éxito, salarios, trayectorias internacionales), y cómo puede The Core posicionarse como referencia en esos mensajes?", 'Análisis contextual'),

    # (NUEVA) Categoría: Análisis de marketing y estrategia
    ('¿Qué canales digitales son más efectivos para llegar a jóvenes interesados en audiovisual en España?', 'Análisis de marketing y estrategia'),
    ('¿Cuáles son las búsquedas y tendencias digitales más frecuentes en España relacionadas con "carreras audiovisuales", "profesiones creativas", "empleos del futuro" o "formación en realización, guion y producción", y cómo pueden vincularse a la propuesta educativa de The Core, Escuela Superior de Audiovisuales?', 'Análisis de marketing y estrategia'),
    ('¿Qué canales y plataformas digitales (TikTok, YouTube, Twitch, Instagram, foros) son los más efectivos para llegar a jóvenes indecisos en España, y qué formatos de contenido vinculados al audiovisual (testimonios de alumnos, casos de éxito en realización, guion o producción, experiencias en concursos/realities) generan mayor engagement para instituciones como The Core?', 'Análisis de marketing y estrategia'),
    ('¿Cómo evoluciona el "share of voice" y el sentimiento online de The Core, Escuela Superior de Audiovisuales frente a sus principales competidores en España, y qué oportunidades de posicionamiento aparecen al vincular su marca con términos como "empleos del futuro", "formación audiovisual", "realización", "guion" o "producción de formatos televisivos"?', 'Análisis de marketing y estrategia'),
]


def get_db_connection():
    """Establece la conexión con la base de datos (prioriza DATABASE_URL) con fallback robusto."""
    database_url = os.getenv("DATABASE_URL")
    if database_url:
        try:
            return psycopg2.connect(database_url)
        except Exception:
            pass

    # Intento 1: usar variables de entorno DB_*
    try:
        return psycopg2.connect(
            host=os.getenv("DB_HOST", "localhost"),
            port=int(os.getenv("DB_PORT", 5433)),
            dbname=os.getenv("POSTGRES_DB", "ia_reports_db"),
            user=os.getenv("POSTGRES_USER", "report_user"),
            password=os.getenv("POSTGRES_PASSWORD", "strong_password"),
        )
    except Exception:
        # Intento 2: fallback fijo a localhost:5433 con credenciales por defecto de docker-compose
        return psycopg2.connect(
            host="localhost",
            port=5433,
            dbname="ia_reports_db",
            user="report_user",
            password="strong_password",
        )


def seed_data():
    """Limpia e inserta los datos iniciales en la base de datos."""
    conn = get_db_connection()
    cur = conn.cursor()
    print("🌱 Empezando a poblar la base de datos con datos para The Core School...")

    try:
        # --- PASO 1: VACIAR TABLAS ---
        print("   - Vaciando tablas existentes (queries, prompt_categories)...")
        # El CASCADE asegura que las tablas dependientes (mentions) también se limpien.
        # RESTART IDENTITY reinicia los contadores auto-incrementales.
        cur.execute("TRUNCATE TABLE prompt_categories, queries RESTART IDENTITY CASCADE;")
        print("   - Tablas vaciadas correctamente.")

        # Asegurar columna 'competitors' en markets (idempotente)
        cur.execute("ALTER TABLE markets ADD COLUMN IF NOT EXISTS competitors JSONB;")

        # --- PASO 2: INSERTAR DATOS ---
        
        # Insertar Cliente
        cur.execute("INSERT INTO clients (name, api_keys) VALUES (%s, %s) ON CONFLICT (name) DO NOTHING RETURNING id;",
                    (CLIENT_DATA["name"], Json(CLIENT_DATA["api_keys"])))
        client_id_row = cur.fetchone()
        if not client_id_row:
            cur.execute("SELECT id FROM clients WHERE name = %s;", (CLIENT_DATA["name"],))
            client_id = cur.fetchone()[0]
        else:
            client_id = client_id_row[0]
        print(f"   - Cliente '{CLIENT_DATA['name']}' asegurado con ID: {client_id}")

        # Insertar Mercado
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

        # Insertar Categorías
        category_map = {}
        for name, desc in PROMPT_CATEGORIES:
            cur.execute("INSERT INTO prompt_categories (name, description) VALUES (%s, %s) ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description RETURNING id;",
                        (name, desc))
            cat_id = cur.fetchone()[0]
            category_map[name] = cat_id
        print(f"   - {len(category_map)} categorías estratégicas aseguradas.")

        # Insertar Prompts
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