-- Tabla para gestionar Clientes del servicio
CREATE TABLE IF NOT EXISTS clients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    api_keys JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para gestionar los Mercados (ej. España, México, LATAM)
CREATE TABLE IF NOT EXISTS markets (
    id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(client_id, name)
);

-- NUEVO: Tabla para las Categorías Estratégicas de Análisis
CREATE TABLE IF NOT EXISTS prompt_categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT
);

-- Tabla de Queries (Prompts), ahora vinculada a una categoría estratégica
CREATE TABLE IF NOT EXISTS queries (
    id SERIAL PRIMARY KEY,
    market_id INTEGER NOT NULL REFERENCES markets(id) ON DELETE CASCADE,
    category_id INTEGER NOT NULL REFERENCES prompt_categories(id) ON DELETE CASCADE,
    query TEXT NOT NULL,
    -- 'topic' ahora es un sub-tema opcional para mayor granularidad si se necesita
    sub_topic VARCHAR(255),
    language VARCHAR(10) DEFAULT 'es',
    enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(market_id, query)
);

-- Tabla de Menciones (Resultados de IA), sin cambios
CREATE TABLE IF NOT EXISTS mentions (
    id SERIAL PRIMARY KEY,
    query_id INTEGER NOT NULL REFERENCES queries(id) ON DELETE CASCADE,
    client_id INTEGER NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    engine VARCHAR(50),
    response TEXT,
    sentiment NUMERIC(5, 4),
    emotion VARCHAR(50),
    confidence_score NUMERIC(5, 4),
    key_topics JSONB,
    summary TEXT,
    source_url TEXT,
    source_title TEXT,
    model_name VARCHAR(100),
    input_tokens INTEGER,
    output_tokens INTEGER,
    price_usd NUMERIC(10, 6),
    latency_ms INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Insights (Análisis de la IA avanzada), sin cambios
CREATE TABLE IF NOT EXISTS insights (
    id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    payload JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para registrar la generación de informes, sin cambios
CREATE TABLE IF NOT EXISTS report_generation_log (
    id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    market_id INTEGER NOT NULL REFERENCES markets(id) ON DELETE CASCADE,
    status VARCHAR(50) DEFAULT 'pending',
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    file_path TEXT,
    error_message TEXT,
    requested_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP WITH TIME ZONE
);

-- Índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_queries_market_id ON queries(market_id);
CREATE INDEX IF NOT EXISTS idx_queries_category_id ON queries(category_id);
CREATE INDEX IF NOT EXISTS idx_mentions_query_id ON mentions(query_id);
CREATE INDEX IF NOT EXISTS idx_mentions_client_id ON mentions(client_id);
CREATE INDEX IF NOT EXISTS idx_mentions_created_at ON mentions(created_at);
