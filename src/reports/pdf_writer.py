import io
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import Paragraph
from reportlab.lib.units import inch

def create_pdf_report(report_content: dict, metadata: dict) -> io.BytesIO:
    """
    Crea un informe en PDF a partir del contenido generado.
    """
    buffer = io.BytesIO()
    p = canvas.Canvas(buffer, pagesize=letter)
    width, height = letter
    styles = getSampleStyleSheet()
    styles.add(ParagraphStyle(name='Justify', alignment=4)) # Justificado

    y_position = height - inch
    page_num = 1

    # Título
    p.setFont("Helvetica-Bold", 18)
    p.drawString(inch, y_position, "Informe de Inteligencia de Mercado")
    y_position -= 30
    
    p.setFont("Helvetica", 11)
    p.drawString(inch, y_position, f"Periodo: {metadata.get('start_date')} a {metadata.get('end_date')}")
    y_position -= 40
    
    # Contenido
    for category_name, text in report_content.items():
        if y_position < 2 * inch: # Salto de página si no hay espacio
            # footer y salto de página
            p.setFont("Helvetica", 9)
            p.drawRightString(8*inch, 0.5*inch, f"Página {page_num}")
            p.showPage()
            page_num += 1
            y_position = height - inch

        p.setFont("Helvetica-Bold", 14)
        p.drawString(inch, y_position, category_name)
        y_position -= 20
        
        paragraph = Paragraph(text.replace('\n', '<br/>'), styles['Justify'])
        w, h = paragraph.wrapOn(p, width - 2 * inch, height)
        if h > (y_position - inch):
            # no cabe en esta página, salta con footer
            p.setFont("Helvetica", 9)
            p.drawRightString(8*inch, 0.5*inch, f"Página {page_num}")
            p.showPage()
            page_num += 1
            y_position = height - inch
        paragraph.drawOn(p, inch, y_position - h)
        y_position -= (h + 30)

    # Footer final
    p.setFont("Helvetica", 9)
    p.drawRightString(8*inch, 0.5*inch, f"Página {page_num}")
    p.save()
    buffer.seek(0)
    return buffer