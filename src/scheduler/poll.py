import os
import time
import psycopg2
from psycopg2.extras import Json
from dotenv import load_dotenv
from datetime import datetime

# Cargar las funciones de los motores de IA
from src.engines.openai_engine import fetch_openai_response
from src.engines.perplexity_engine import fetch_perplexity_response
from src.engines.sentiment_engine import analyze_and_summarize

# Cargar variables de entorno
load_dotenv()

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

def run_poll():
    """
    El ciclo principal del planificador.
    1. Obtiene todos los clientes.
    2. Para cada cliente, obtiene sus queries activas.
    3. Ejecuta cada query en todos los motores de IA.
    4. Realiza el primer análisis económico.
    5. Guarda los resultados enriquecidos en la base de datos.
    """
    print(f"[{datetime.now()}] Iniciando ciclo de polling...")
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        # 1. Obtener todos los clientes
        cur.execute("SELECT id, name FROM clients;")
        clients = cur.fetchall()
        print(f"Encontrados {len(clients)} cliente(s).")

        for client_id, client_name in clients:
            print(f"\n--- Procesando cliente: {client_name} (ID: {client_id}) ---")
            
            # 2. Obtener queries para el cliente actual (con límite opcional)
            cur.execute("SELECT q.id, q.query FROM queries q JOIN markets m ON q.market_id = m.id WHERE m.client_id = %s AND q.enabled = TRUE;", (client_id,))
            queries = cur.fetchall()
            try:
                query_limit = int(os.getenv("QUERY_LIMIT", "0"))
            except ValueError:
                query_limit = 0
            if query_limit > 0:
                queries = queries[:query_limit]
            print(f"Encontradas {len(queries)} queries activas para este cliente.")
            
            for query_id, query_text in queries:
                print(f"  -> Ejecutando query: '{query_text[:50]}...' (ID: {query_id})")
                
                # 3. Definir los motores a ejecutar
                only_engine = os.getenv("ONLY_ENGINE", "").lower()
                engines = {}
                if only_engine == "perplexity":
                    engines["Perplexity (sonar)"] = fetch_perplexity_response
                elif only_engine == "openai":
                    engines["OpenAI (gpt-4o-mini)"] = fetch_openai_response
                else:
                    engines["OpenAI (gpt-4o-mini)"] = fetch_openai_response
                    engines["Perplexity (sonar)"] = fetch_perplexity_response
                
                for engine_name, fetch_function in engines.items():
                    start_time = time.time()
                    response_text, metadata = fetch_function(query_text)
                    latency_ms = int((time.time() - start_time) * 1000)

                    if not response_text or metadata.get("error"):
                        print(f"    - Error en {engine_name}: {metadata.get('error')}")
                        continue
                    
                    # 4. Realizar análisis económico
                    analysis_data = analyze_and_summarize(response_text)
                    
                    # 5. Guardar en la base de datos
                    insert_data = {
                        'client_id': client_id,
                        'query_id': query_id,
                        'engine': engine_name,
                        'response': response_text,
                        'sentiment': analysis_data.get('sentiment'),
                        'emotion': analysis_data.get('emotion'),
                        'confidence_score': analysis_data.get('confidence_score'),
                        'key_topics': Json(analysis_data.get('key_topics', [])),
                        'summary': analysis_data.get('summary'),
                        'model_name': metadata.get('model_name'),
                        'input_tokens': metadata.get('input_tokens'),
                        'output_tokens': metadata.get('output_tokens'),
                        'price_usd': metadata.get('price_usd'),
                        'latency_ms': latency_ms,
                        'created_at': datetime.now()
                    }

                    cur.execute("""
                        INSERT INTO mentions (client_id, query_id, engine, response, sentiment, emotion, confidence_score, key_topics, summary, model_name, input_tokens, output_tokens, price_usd, latency_ms, created_at)
                        VALUES (%(client_id)s, %(query_id)s, %(engine)s, %(response)s, %(sentiment)s, %(emotion)s, %(confidence_score)s, %(key_topics)s, %(summary)s, %(model_name)s, %(input_tokens)s, %(output_tokens)s, %(price_usd)s, %(latency_ms)s, %(created_at)s);
                    """, insert_data)
                    conn.commit()
                    print(f"    - Resultado de {engine_name} guardado en la base de datos.")
                    time.sleep(1) # Pequeña pausa para no saturar las APIs

    except Exception as e:
        print(f"Error fatal durante el polling: {e}")
    finally:
        cur.close()
        conn.close()
        print(f"[{datetime.now()}] Ciclo de polling finalizado.")

if __name__ == '__main__':
    # Esto permite ejecutar el script directamente para una sola pasada de prueba
    run_poll()