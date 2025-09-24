import os
from datetime import datetime, timedelta
from dotenv import load_dotenv
from src.reports.aggregator import aggregate_data_for_report
from src.reports.generator import generate_report_content
from src.reports.pdf_writer import create_pdf_report

# Cargar variables de entorno (para la conexión a la BD)
load_dotenv()

# --- PARÁMETROS DEL INFORME ---
# Puedes ajustar estos valores según lo que necesites analizar

CLIENT_ID = 9  # ID de The Core School
MARKET_ID = 6  # ID del mercado a analizar (verifícalo en tu tabla 'markets')

# Fechas (por defecto, los últimos 7 días)
END_DATE = datetime.now()
START_DATE = END_DATE - timedelta(days=7)

# Formatear fechas a string 'YYYY-MM-DD'
end_date_str = END_DATE.strftime('%Y-%m-%d')
start_date_str = START_DATE.strftime('%Y-%m-%d')

OUTPUT_FILENAME = "informe_manual.pdf"
# -----------------------------

def main():
    """
    Flujo completo para generar un informe en PDF manualmente.
    """
    print("--- Iniciando Generación Manual de Informe ---")
    print(f"Cliente: {CLIENT_ID} | Mercado: {MARKET_ID}")
    print(f"Periodo: {start_date_str} a {end_date_str}")
    print("-" * 45)

    print("1. 📊 Agregando datos y calculando KPIs...")
    aggregated_data = aggregate_data_for_report(CLIENT_ID, MARKET_ID, start_date_str, end_date_str)
    
    if not aggregated_data or aggregated_data["kpis"]["total_mentions"] == 0:
        print("\n❌ ADVERTENCIA: No se encontraron menciones para este periodo.")
        print("   Asegúrate de que el script 'poll.py' se ha ejecutado y ha recopilado datos.")
        # Opcional: Aún así, intentamos generar un informe "vacío" para ver la estructura
        # return 
    else:
        print(f"   ✅ Se analizarán {aggregated_data['kpis']['total_mentions']} menciones.")


    print("2. 🧠 Generando contenido del informe con la IA...")
    report_content = generate_report_content(aggregated_data)
    print("   ✅ Contenido del informe generado.")

    print(f"3. 📄 Creando el archivo PDF: {OUTPUT_FILENAME}...")
    pdf_buffer = create_pdf_report(report_content, aggregated_data)

    with open(OUTPUT_FILENAME, "wb") as f:
        f.write(pdf_buffer.getvalue())
        
    print(f"\n✅ ¡Informe '{OUTPUT_FILENAME}' generado con éxito!")
    print("-" * 45)


if __name__ == "__main__":
    main()