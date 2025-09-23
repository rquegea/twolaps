import os
from flask import Flask, jsonify, request
from dotenv import load_dotenv

# Cargar variables de entorno desde el archivo .env
load_dotenv()

# Inicializar la aplicación Flask
app = Flask(__name__)

# --- Endpoints de la API ---

@app.route('/health', methods=['GET'])
def health_check():
    """
    Endpoint básico para verificar que el servicio está funcionando.
    """
    return jsonify({"status": "healthy", "service": "ia-report-backend"}), 200

@app.route('/reports/generate', methods=['POST'])
def generate_report_endpoint():
    """
    Endpoint para iniciar la generación de un informe en PDF.
    En el futuro, recibirá el client_id, market_id y rango de fechas.
    """
    data = request.json
    client_id = data.get('client_id')
    market_id = data.get('market_id')
    start_date = data.get('start_date')
    end_date = data.get('end_date')

    if not all([client_id, market_id, start_date, end_date]):
        return jsonify({"error": "Faltan parámetros: client_id, market_id, start_date, end_date"}), 400

    # TODO: Aquí irá la lógica para:
    # 1. Crear una entrada en la tabla 'report_generation_log' con estado 'pending'.
    # 2. Iniciar el proceso de recopilación de datos de la base de datos.
    # 3. Llamar a la IA avanzada para generar los textos del informe.
    # 4. Construir el PDF con reportlab.
    # 5. Actualizar el log a 'success' o 'failed' y guardar la ruta del archivo.

    print(f"Solicitud recibida para generar informe para el cliente {client_id} en el mercado {market_id}.")
    
    # Por ahora, devolvemos una respuesta de confirmación.
    return jsonify({
        "message": "Solicitud de generación de informe recibida.",
        "client_id": client_id,
        "market_id": market_id,
        "date_range": f"{start_date} a {end_date}"
    }), 202 # 202 Accepted indica que la solicitud ha sido aceptada pero el proceso aún no ha terminado.

# --- Bloque principal para ejecutar la aplicación ---

if __name__ == '__main__':
    # El host '0.0.0.0' hace que sea accesible desde fuera del contenedor Docker
    app.run(host='0.0.0.0', port=5050, debug=True)

