import os
import matplotlib
matplotlib.use('Agg')  # Backend sin interfaz para servidores
import matplotlib.pyplot as plt
from typing import Dict, List, Optional


def _ensure_dir(path: str) -> None:
    os.makedirs(path, exist_ok=True)


def generate_sentiment_trend_plot(time_series: Dict, out_dir: str) -> Optional[str]:
    """
    Genera un gráfico de líneas con el sentimiento promedio diario.
    time_series: {
      'sentiment_per_day': [{ 'date': 'YYYY-MM-DD', 'average': float }]
    }
    """
    data = time_series or {}
    points: List[Dict] = data.get('sentiment_per_day', []) or []
    if not points:
        return None

    points_sorted = sorted(points, key=lambda x: x.get('date'))
    dates = [p['date'] for p in points_sorted]
    values = [float(p.get('average', 0.0)) for p in points_sorted]

    _ensure_dir(out_dir)
    fig, ax = plt.subplots(figsize=(8, 3))
    ax.plot(dates, values, marker='o', linewidth=2, color='#1f77b4')
    ax.set_title('Evolución del Sentimiento (diario)')
    ax.set_xlabel('Fecha')
    ax.set_ylabel('Sentimiento promedio')
    ax.grid(True, linestyle='--', alpha=0.3)
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()

    out_path = os.path.join(out_dir, 'sentiment_trend.png')
    fig.savefig(out_path, dpi=150)
    plt.close(fig)
    return out_path


def generate_mentions_trend_plot(time_series: Dict, out_dir: str) -> Optional[str]:
    """
    Genera un gráfico de barras con el volumen de menciones por día.
    time_series: {
      'mentions_per_day': [{ 'date': 'YYYY-MM-DD', 'count': int }]
    }
    """
    data = time_series or {}
    points: List[Dict] = data.get('mentions_per_day', []) or []
    if not points:
        return None

    points_sorted = sorted(points, key=lambda x: x.get('date'))
    dates = [p['date'] for p in points_sorted]
    counts = [int(p.get('count', 0)) for p in points_sorted]

    _ensure_dir(out_dir)
    fig, ax = plt.subplots(figsize=(8, 3))
    ax.bar(dates, counts, color='#2ca02c')
    ax.set_title('Evolución del Volumen de Menciones (diario)')
    ax.set_xlabel('Fecha')
    ax.set_ylabel('Menciones')
    ax.grid(True, axis='y', linestyle='--', alpha=0.3)
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()

    out_path = os.path.join(out_dir, 'mentions_trend.png')
    fig.savefig(out_path, dpi=150)
    plt.close(fig)
    return out_path
