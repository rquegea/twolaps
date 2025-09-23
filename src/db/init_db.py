import os
import psycopg2
from dotenv import load_dotenv

# Carga las variables de entorno (p. ej., desde un archivo .env)
load_dotenv()

def get_db_connection():
    """Establece la conexión con la base de datos usando variables de entorno."""
    database_url = os.getenv("DATABASE_URL")
    if database_url:
        return psycopg2.connect(database_url)
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "postgres"), # 'postgres' es el nombre del servicio en docker-compose
        port=os.getenv("DB_PORT", 5432),
        dbname=os.getenv("POSTGRES_DB"),
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD")
    )

def initialize_database():
    """Lee el schema.sql y lo ejecuta para crear las tablas."""
    try:
        # La ruta al schema es relativa a la ubicación del script
        schema_path = os.path.join(os.path.dirname(__file__), "schema.sql")
        
        with open(schema_path, "r") as f:
            schema_sql = f.read()

        conn = get_db_connection()
        cur = conn.cursor()
        
        print("Aplicando esquema a la base de datos...")
        cur.execute(schema_sql)
        conn.commit()
        
        cur.close()
        conn.close()
        
        print("✅ ¡Base de datos inicializada correctamente!")

    except Exception as e:
        print(f"❌ Error al inicializar la base de datos: {e}")

if __name__ == "__main__":
    initialize_database()