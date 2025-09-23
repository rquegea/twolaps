import os
import traceback
from flask import Flask, jsonify, request, send_file
from dotenv import load_dotenv
from src.reports.aggregator import aggregate_data_for_report
from src.reports.generator import generate_report_content
from src.reports.pdf_writer import create_pdf_report

load_dotenv()
app = Flask(__name__)

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy", "service": "ia-report-backend"}), 200

@app.route('/reports/generate', methods=['POST'])
def generate_report_endpoint():
    data = request.json
    client_id = data.get('client_id')
    market_id = data.get('market_id')
    start_date = data.get('start_date')
    end_date = data.get('end_date')

    if not all([client_id, market_id, start_date, end_date]):
        return jsonify({"error": "Faltan parámetros"}), 400

    try:
        # 1. Recolectar y agregar datos
        aggregated_data = aggregate_data_for_report(client_id, market_id, start_date, end_date)
        
        # 2. Generar el contenido del informe con la IA
        report_content = generate_report_content(aggregated_data)
        
        # 3. Crear el archivo PDF
        pdf_buffer = create_pdf_report(report_content, aggregated_data)
        
        # 4. Enviar el PDF como respuesta
        return send_file(
            pdf_buffer,
            as_attachment=True,
            download_name=f"informe_{client_id}_{start_date}_a_{end_date}.pdf",
            mimetype='application/pdf'
        )

    except Exception as e:
        # Log detallado del stacktrace para diagnosticar el 500
        traceback.print_exc()
        print(f"Error generando el informe: {e}")
        return jsonify({"error": "No se pudo generar el informe", "details": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5050, debug=True)