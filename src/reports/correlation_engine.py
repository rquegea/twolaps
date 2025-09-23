import itertools
from collections import defaultdict, Counter
from typing import Dict, List, Tuple, Any


def _index_mentions_by_topic(mentions_by_category: Dict[str, List[dict]]) -> Tuple[Dict[str, Dict[str, List[dict]]], Counter]:
    """
    Construye índices topic -> categoría -> lista de menciones y un conteo global de tópicos.
    """
    topic_to_category_mentions: Dict[str, Dict[str, List[dict]]] = defaultdict(lambda: defaultdict(list))
    global_topic_counter: Counter = Counter()
    for category_name, mentions in mentions_by_category.items():
        for mention in mentions:
            key_topics = mention.get("key_topics") or []
            if isinstance(key_topics, dict):
                key_topics = list(key_topics.keys())
            for topic in key_topics:
                topic_str = str(topic).strip()
                if not topic_str:
                    continue
                topic_to_category_mentions[topic_str][category_name].append(mention)
                global_topic_counter.update([topic_str])
    return topic_to_category_mentions, global_topic_counter


def _average_sentiment(mentions: List[dict]) -> float:
    if not mentions:
        return 0.0
    s = 0.0
    c = 0
    for m in mentions:
        s += float(m.get("sentiment", 0.0) or 0.0)
        c += 1
    return (s / c) if c > 0 else 0.0


def _keyword_match(text: str, keywords: List[str]) -> bool:
    lowered = text.lower()
    return any(k in lowered for k in keywords)


def compute_cross_category_correlations(aggregated_data: dict) -> dict:
    """
    Deriva correlaciones e hipótesis entre categorías basándose en:
    - co-ocurrencia de tópicos entre categorías
    - diferencias de sentimiento por tópico entre categorías
    - vínculos KPI: cambios de SOV vs. cambios de sentimiento
    Devuelve un dict con hallazgos que luego interpretará la IA de alto nivel.
    """
    mentions_by_category: Dict[str, List[dict]] = aggregated_data.get("mentions_by_category", {})
    trends: Dict[str, Any] = aggregated_data.get("trends", {})

    topic_index, global_topic_counter = _index_mentions_by_topic(mentions_by_category)

    correlations: List[dict] = []

    for topic, cat_map in topic_index.items():
        if len(cat_map) < 2:
            continue
        category_list = list(cat_map.keys())
        for cat_a, cat_b in itertools.combinations(category_list, 2):
            mentions_a = cat_map[cat_a]
            mentions_b = cat_map[cat_b]
            avg_a = _average_sentiment(mentions_a)
            avg_b = _average_sentiment(mentions_b)
            diff = avg_a - avg_b

            strength = "bajo"
            if abs(diff) >= 0.6:
                strength = "alto"
            elif abs(diff) >= 0.3:
                strength = "medio"

            if strength != "bajo":
                correlations.append({
                    "type": "topic_sentiment_gap",
                    "topic": topic,
                    "categories": [cat_a, cat_b],
                    "evidence": {
                        "avg_sentiment": {cat_a: round(avg_a, 3), cat_b: round(avg_b, 3)},
                        "diff": round(diff, 3),
                        "mentions": {cat_a: len(mentions_a), cat_b: len(mentions_b)},
                    },
                    "strength": strength,
                    "hypothesis": f"El tópico '{topic}' muestra una diferencia de sentimiento notable entre '{cat_a}' y '{cat_b}'.",
                })

    prices_kw = ["precio", "precios", "coste", "costos", "costos", "matrícula", "cuota"]
    brand_kw = ["marca", "reputación", "prestigio", "notoriedad"]
    jobs_kw = ["empleo", "salidas", "trabajo", "contratación", "ofertas", "prácticas"]
    vfx_kw = ["vfx", "efectos visuales", "postproducción"]

    kpi_links: List[dict] = []

    sov_delta_by_cat: Dict[str, float] = trends.get("sov_delta_by_category", {})
    sent_delta_by_cat: Dict[str, float] = trends.get("sentiment_delta_by_category", {})

    for category_name in mentions_by_category.keys():
        sov_delta = float(sov_delta_by_cat.get(category_name, 0.0))
        sent_delta = float(sent_delta_by_cat.get(category_name, 0.0))
        if abs(sov_delta) >= 5.0 and abs(sent_delta) >= 0.2:
            kpi_links.append({
                "type": "kpi_link_sov_sentiment",
                "category": category_name,
                "evidence": {"sov_delta_pp": round(sov_delta, 2), "sentiment_delta": round(sent_delta, 3)},
                "hypothesis": "Cambios relevantes y simultáneos en SOV y sentimiento sugieren causalidad o un factor común.",
                "strength": "alto" if abs(sov_delta) >= 10.0 or abs(sent_delta) >= 0.4 else "medio",
            })

    semantic_links: List[dict] = []
    for cat_name, mentions in mentions_by_category.items():
        text_join = " ".join([m.get("summary", "") or "" for m in mentions]).lower()
        has_prices = _keyword_match(text_join, prices_kw)
        has_brand = _keyword_match(text_join, brand_kw)
        has_jobs = _keyword_match(text_join, jobs_kw)
        has_vfx = _keyword_match(text_join, vfx_kw)
        if has_prices and has_brand:
            semantic_links.append({
                "type": "semantic_prices_brand",
                "category": cat_name,
                "hypothesis": "Las conversaciones sobre precios podrían estar afectando la reputación de marca.",
                "strength": "medio",
            })
        if has_jobs and has_vfx:
            semantic_links.append({
                "type": "semantic_jobs_vfx",
                "category": cat_name,
                "hypothesis": "Hay señales de interés laboral en VFX vinculadas a esta categoría.",
                "strength": "medio",
            })

    topic_links: List[dict] = []
    emerging_topics = trends.get("emerging_topics", [])
    for item in emerging_topics[:10]:
        topic = item.get("topic")
        cats = list(topic_index.get(topic, {}).keys())
        if len(cats) >= 1:
            topic_links.append({
                "type": "emerging_topic_spread",
                "topic": topic,
                "categories": cats,
                "evidence": item,
                "hypothesis": f"El tópico emergente '{topic}' está ganando tracción en {len(cats)} categoría(s).",
                "strength": "alto" if item.get("delta", 0) >= 10 else "medio",
            })

    return {
        "correlations": correlations,
        "kpi_links": kpi_links,
        "semantic_links": semantic_links,
        "topic_links": topic_links,
        "global_topic_counts": dict(global_topic_counter.most_common(30)),
    }


