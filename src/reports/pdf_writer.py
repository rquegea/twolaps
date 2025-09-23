import io
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import Paragraph, Table, TableStyle
from reportlab.lib.units import inch
from reportlab.graphics.shapes import Drawing
from reportlab.graphics.charts.barcharts import VerticalBarChart
from reportlab.graphics.charts.axes import XCategoryAxis, YValueAxis
from reportlab.lib import colors

BR = '<br/>'

def draw_sentiment_chart(data: dict):
    """Crea un gráfico de barras de sentimiento por categoría."""
    drawing = Drawing(width=500, height=250)
    
    chart_data = []
    labels = []
    
    sentiment_by_category = data.get('sentiment_by_category', {})
    if not sentiment_by_category:
        return None

    # Ordenar categorías por sentimiento para un mejor visual
    sorted_categories = sorted(sentiment_by_category.items(), key=lambda item: item[1]['average'], reverse=True)

    for category, values in sorted_categories:
        chart_data.append(values['average'])
        labels.append(category.replace("Análisis de ", "").replace(" y ", " y\n")) # Acortar etiquetas

    bar_chart = VerticalBarChart()
    bar_chart.x = 50
    bar_chart.y = 50
    bar_chart.height = 180
    bar_chart.width = 400
    bar_chart.data = [tuple(chart_data)]
    
    # Colores de las barras (verde si positivo, rojo si negativo)
    for i, val in enumerate(chart_data):
        bar_chart.bars[i].fillColor = colors.green if val >= 0 else colors.red

    # Ejes
    bar_chart.categoryAxis = XCategoryAxis()
    bar_chart.categoryAxis.categoryNames = labels
    bar_chart.categoryAxis.labels.boxAnchor = 'n'
    bar_chart.categoryAxis.labels.angle = 30
    
    bar_chart.valueAxis = YValueAxis()
    bar_chart.valueAxis.valueMin = -1
    bar_chart.valueAxis.valueMax = 1
    bar_chart.valueAxis.valueStep = 0.5
    bar_chart.valueAxis.labels.fontName = 'Helvetica'

    drawing.add(bar_chart)
    return drawing


def draw_sov_chart(kpis: dict):
    """Crea un gráfico de barras con el Share of Voice por categoría (%)."""
    sov = kpis.get('share_of_voice_by_category', {})
    if not sov:
        return None

    drawing = Drawing(width=500, height=250)
    labels = []
    values = []
    # Ordenar por mayor SOV
    for category, value in sorted(sov.items(), key=lambda x: x[1], reverse=True):
        labels.append(category.replace("Análisis de ", "").replace(" y ", " y\n"))
        values.append(round(float(value), 2))

    bar_chart = VerticalBarChart()
    bar_chart.x = 50
    bar_chart.y = 50
    bar_chart.height = 180
    bar_chart.width = 400
    bar_chart.data = [tuple(values)]

    for i in range(len(values)):
        bar_chart.bars[i].fillColor = colors.HexColor('#4F81BD')

    bar_chart.categoryAxis = XCategoryAxis()
    bar_chart.categoryAxis.categoryNames = labels
    bar_chart.categoryAxis.labels.boxAnchor = 'n'
    bar_chart.categoryAxis.labels.angle = 30

    bar_chart.valueAxis = YValueAxis()
    bar_chart.valueAxis.valueMin = 0
    bar_chart.valueAxis.valueMax = 100
    bar_chart.valueAxis.valueStep = 20
    bar_chart.valueAxis.labels.fontName = 'Helvetica'

    drawing.add(bar_chart)
    return drawing


def draw_visibility_by_topic_chart(kpis: dict):
    """Gráfico de SOV del cliente por categoría (cliente/total en %)."""
    sov_by_cat = kpis.get('sov_by_category', {})
    if not sov_by_cat:
        return None

    labels = []
    values = []
    for category, counts in sov_by_cat.items():
        total = float(counts.get('total', 0))
        client = float(counts.get('client', 0))
        pct = (client / total * 100.0) if total > 0 else 0.0
        labels.append(category.replace("Análisis de ", "").replace(" y ", " y\n"))
        values.append(round(pct, 2))

    if not values:
        return None

    drawing = Drawing(width=500, height=250)
    bar_chart = VerticalBarChart()
    bar_chart.x = 50
    bar_chart.y = 50
    bar_chart.height = 180
    bar_chart.width = 400
    bar_chart.data = [tuple(values)]
    for i in range(len(values)):
        bar_chart.bars[i].fillColor = colors.HexColor('#2E8B57')

    bar_chart.categoryAxis = XCategoryAxis()
    bar_chart.categoryAxis.categoryNames = labels
    bar_chart.categoryAxis.labels.boxAnchor = 'n'
    bar_chart.categoryAxis.labels.angle = 30

    bar_chart.valueAxis = YValueAxis()
    bar_chart.valueAxis.valueMin = 0
    bar_chart.valueAxis.valueMax = 100
    bar_chart.valueAxis.valueStep = 20
    bar_chart.valueAxis.labels.fontName = 'Helvetica'

    drawing.add(bar_chart)
    return drawing

def create_pdf_report(report_content: dict, metadata: dict) -> io.BytesIO:
    """Crea un informe en PDF híbrido: parte estratégica + anexo detallado, con KPIs y gráficos."""
    buffer = io.BytesIO()
    p = canvas.Canvas(buffer, pagesize=letter)
    width, height = letter
    styles = getSampleStyleSheet()
    styles.add(ParagraphStyle(name='Justify', alignment=4, fontName='Helvetica', fontSize=10, leading=14))
    
    y_position = height - inch

    p.setFont("Helvetica-Bold", 18)
    p.drawString(inch, y_position, "Informe de Inteligencia de Mercado")
    y_position -= 30
    
    p.setFont("Helvetica", 11)
    p.drawString(inch, y_position, f"Periodo: {metadata.get('start_date')} a {metadata.get('end_date')}")
    y_position -= 40
    
    # --- NUEVA SECCIÓN: KPIs Y GRÁFICOS ---
    p.setFont("Helvetica-Bold", 14)
    p.drawString(inch, y_position, "Resumen Ejecutivo de KPIs")
    y_position -= 30
    
    kpis = metadata.get('kpis', {})
    p.setFont("Helvetica", 10)
    p.drawString(inch, y_position, f"Menciones totales analizadas: {kpis.get('total_mentions', 0)}")
    y_position -= 15
    p.drawString(inch, y_position, f"Sentimiento General Promedio: {kpis.get('average_sentiment', 0.0):.2f}")
    y_position -= 20
    
    # Tabla de Share of Voice vs. Competencia
    p.setFont("Helvetica-Bold", 14)
    p.drawString(inch, y_position, "Share of Voice vs. Competencia")
    y_position -= 20

    competitor_mentions = kpis.get('competitor_mentions', {})
    sov_by_cat = kpis.get('sov_by_category', {})
    total_client_mentions = sum(v.get('client', 0) for v in sov_by_cat.values())
    total_comp_mentions = sum(competitor_mentions.values())
    total_with_brands = total_client_mentions + total_comp_mentions
    client_sov_pct = (total_client_mentions / total_with_brands * 100.0) if total_with_brands > 0 else 0.0

    table_data = [["Marca", "Menciones", "% SOV"]]
    table_data.append([metadata.get('client_name', 'Cliente'), int(total_client_mentions), f"{client_sov_pct:.1f}%"])
    for brand, count in sorted(competitor_mentions.items(), key=lambda x: x[1], reverse=True):
        pct = (float(count) / float(total_with_brands) * 100.0) if total_with_brands > 0 else 0.0
        table_data.append([brand, int(count), f"{pct:.1f}%"])

    table = Table(table_data, colWidths=[200, 100, 100])
    table.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.lightgrey),
        ('TEXTCOLOR', (0,0), (-1,0), colors.black),
        ('FONTNAME', (0,0), (-1,0), 'Helvetica-Bold'),
        ('FONTSIZE', (0,0), (-1,0), 10),
        ('ALIGN', (1,1), (-1,-1), 'CENTER'),
        ('GRID', (0,0), (-1,-1), 0.25, colors.grey),
        ('FONTSIZE', (0,1), (-1,-1), 9),
    ]))
    _, th = table.wrapOn(p, width - 2 * inch, y_position)
    if y_position - th < inch:
        p.showPage()
        y_position = height - inch
    table.drawOn(p, inch, y_position - th)
    y_position -= (th + 20)

    # Dibujar gráficos: Sentimiento y Visibilidad por Tema (SOV por categoría)
    chart_sent = draw_sentiment_chart(kpis)
    if chart_sent:
        chart_sent.drawOn(p, inch, y_position - 250)
        y_position -= 280

    chart_visibility = draw_visibility_by_topic_chart(kpis)
    if chart_visibility:
        chart_visibility.drawOn(p, inch, y_position - 250)
        y_position -= 280

    # --- Parte Estratégica ---
    strategic_content = report_content.get("strategic", {})

    # Título de la parte estratégica
    p.setFont("Helvetica-Bold", 16)
    p.drawString(inch, y_position, "Informe Estratégico")
    y_position -= 30

    # Resumen Ejecutivo (nuevo)
    p.setFont("Helvetica-Bold", 14)
    p.drawString(inch, y_position, "Resumen Ejecutivo")
    y_position -= 20
    new_exec = strategic_content.get("Resumen Ejecutivo", "")
    if new_exec:
        paragraph = Paragraph(new_exec.replace('\n', BR), styles['Justify'])
        _, h = paragraph.wrapOn(p, width - 2 * inch, y_position)
        if y_position - h < inch:
            p.showPage()
            y_position = height - inch
        paragraph.drawOn(p, inch, y_position - h)
        y_position -= (h + 30)

    # Resumen Ejecutivo y Hallazgos Principales
    p.setFont("Helvetica-Bold", 14)
    p.drawString(inch, y_position, "Resumen Ejecutivo y Hallazgos Principales")
    y_position -= 20
    summary_text = strategic_content.get("Resumen Ejecutivo y Hallazgos", "")
    if summary_text:
        paragraph = Paragraph(summary_text.replace('\n', BR), styles['Justify'])
        _, h = paragraph.wrapOn(p, width - 2 * inch, y_position)
        if y_position - h < inch:
            p.showPage()
            y_position = height - inch
        paragraph.drawOn(p, inch, y_position - h)
        y_position -= (h + 30)

    # Plan de Acción Estratégico
    p.setFont("Helvetica-Bold", 14)
    p.drawString(inch, y_position, "Plan de Acción Estratégico")
    y_position -= 20
    plan_text = strategic_content.get("Plan de Acción Estratégico", "")
    # Análisis Competitivo (nuevo)
    p.setFont("Helvetica-Bold", 14)
    p.drawString(inch, y_position, "Análisis Competitivo")
    y_position -= 20
    comp_text = strategic_content.get("Análisis Competitivo", "")
    if comp_text:
        paragraph = Paragraph(comp_text.replace('\n', BR), styles['Justify'])
        _, h = paragraph.wrapOn(p, width - 2 * inch, y_position)
        if y_position - h < inch:
            p.showPage()
            y_position = height - inch
        paragraph.drawOn(p, inch, y_position - h)
        y_position -= (h + 30)

    if plan_text:
        paragraph = Paragraph(plan_text.replace('\n', BR), styles['Justify'])
        _, h = paragraph.wrapOn(p, width - 2 * inch, y_position)
        if y_position - h < inch:
            p.showPage()
            y_position = height - inch
        paragraph.drawOn(p, inch, y_position - h)
        y_position -= (h + 30)

    # --- Parte Detallada (Anexo) ---
    p.showPage()
    y_position = height - inch

    p.setFont("Helvetica-Bold", 16)
    p.drawString(inch, y_position, "Anexo: Análisis Detallado por Categoría")
    y_position -= 30

    detailed_content = report_content.get("detailed", {})

    for category_name, text in detailed_content.items():
        paragraph_temp = Paragraph(text.replace('\n', BR), styles['Justify'])
        _, h_temp = paragraph_temp.wrapOn(p, width - 2 * inch, y_position)
        
        if y_position - h_temp < inch:
            p.showPage()
            y_position = height - inch
        
        p.setFont("Helvetica-Bold", 14)
        p.drawString(inch, y_position, category_name)
        y_position -= 25
        
        paragraph = Paragraph(text.replace('\n', BR), styles['Justify'])
        _, h = paragraph.wrapOn(p, width - 2 * inch, y_position)
        paragraph.drawOn(p, inch, y_position - h)
        y_position -= (h + 40)

    p.save()
    buffer.seek(0)
    return buffer