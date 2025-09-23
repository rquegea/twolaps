-- Tabla para gestionar Clientes del servicio
CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    -- Almacena de forma segura las claves API para cada servicio (OpenAI, SerpAPI, etc.)
    api_keys JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para gestionar los Mercados (ej. España, México, LATAM)
CREATE TABLE markets (
    id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(client_id, name)
);

-- Tabla de Queries (Prompts), ahora asociada a un mercado específico de un cliente
CREATE TABLE queries (
    id SERIAL PRIMARY KEY,
    market_id INTEGER NOT NULL REFERENCES markets(id) ON DELETE CASCADE,
    query TEXT NOT NULL,
    topic VARCHAR(255),
    language VARCHAR(10) DEFAULT 'es',
    enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(market_id, query)
);

-- Tabla de Menciones (Resultados de IA), enriquecida con metadatos para informes detallados
CREATE TABLE mentions (
    id SERIAL PRIMARY KEY,
    query_id INTEGER NOT NULL REFERENCES queries(id) ON DELETE CASCADE,
    client_id INTEGER NOT NULL REFERENCES clients(id) ON DELETE CASCADE, -- Denormalizado para facilitar consultas
    engine VARCHAR(50),
    response TEXT,
    
    -- Campos de análisis enriquecido (de la IA económica)
    sentiment NUMERIC(5, 4),
    emotion VARCHAR(50),
    confidence_score NUMERIC(5, 4),
    key_topics JSONB,
    summary TEXT,

    -- Metadatos de la fuente (si aplica, ej. SerpAPI)
    source_url TEXT,
    source_title TEXT,

    -- Metadatos de la ejecución para control de costes y rendimiento
    model_name VARCHAR(100),
    input_tokens INTEGER,
    output_tokens INTEGER,
    price_usd NUMERIC(10, 6),
    latency_ms INTEGER,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Insights (Análisis de la IA avanzada)
CREATE TABLE insights (
    id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    -- Un insight puede estar asociado a una o varias menciones, por eso el payload es más general
    payload JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- NUEVO: Tabla para registrar la generación de informes
CREATE TABLE report_generation_log (
    id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    market_id INTEGER NOT NULL REFERENCES markets(id) ON DELETE CASCADE,
    status VARCHAR(50) DEFAULT 'pending', -- pending, success, failed
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    file_path TEXT, -- Ruta donde se guardó el PDF
    error_message TEXT,
    requested_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP WITH TIME ZONE
);

-- Índices para mejorar el rendimiento de las consultas
CREATE INDEX idx_queries_market_id ON queries(market_id);
CREATE INDEX idx_mentions_query_id ON mentions(query_id);
CREATE INDEX idx_mentions_client_id ON mentions(client_id);
CREATE INDEX idx_mentions_created_at ON mentions(created_at);
CREATE INDEX idx_insights_client_id ON insights(client_id);
CREATE INDEX idx_report_log_client_market ON report_generation_log(client_id, market_id);
