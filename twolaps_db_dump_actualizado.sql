--
-- PostgreSQL database dump
--

\restrict ARe6sfZeiyL3SMXtHNXNS7uvJDmaUIXlg57GsGrJzx5O6a0LRbUBAydRdjtJc0J

-- Dumped from database version 14.19 (Debian 14.19-1.pgdg13+1)
-- Dumped by pg_dump version 14.19 (Debian 14.19-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: brands; Type: TABLE; Schema: public; Owner: report_user
--

CREATE TABLE public.brands (
    id integer NOT NULL,
    client_id integer,
    name text NOT NULL,
    slug text
);


ALTER TABLE public.brands OWNER TO report_user;

--
-- Name: brands_id_seq; Type: SEQUENCE; Schema: public; Owner: report_user
--

CREATE SEQUENCE public.brands_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.brands_id_seq OWNER TO report_user;

--
-- Name: brands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: report_user
--

ALTER SEQUENCE public.brands_id_seq OWNED BY public.brands.id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: report_user
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    api_keys jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    slug text,
    api_key text
);


ALTER TABLE public.clients OWNER TO report_user;

--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: report_user
--

CREATE SEQUENCE public.clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clients_id_seq OWNER TO report_user;

--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: report_user
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: insights; Type: TABLE; Schema: public; Owner: report_user
--

CREATE TABLE public.insights (
    id integer NOT NULL,
    client_id integer NOT NULL,
    payload jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    brand_id integer,
    category text
);


ALTER TABLE public.insights OWNER TO report_user;

--
-- Name: insights_id_seq; Type: SEQUENCE; Schema: public; Owner: report_user
--

CREATE SEQUENCE public.insights_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.insights_id_seq OWNER TO report_user;

--
-- Name: insights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: report_user
--

ALTER SEQUENCE public.insights_id_seq OWNED BY public.insights.id;


--
-- Name: markets; Type: TABLE; Schema: public; Owner: report_user
--

CREATE TABLE public.markets (
    id integer NOT NULL,
    client_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    competitors jsonb
);


ALTER TABLE public.markets OWNER TO report_user;

--
-- Name: markets_id_seq; Type: SEQUENCE; Schema: public; Owner: report_user
--

CREATE SEQUENCE public.markets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.markets_id_seq OWNER TO report_user;

--
-- Name: markets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: report_user
--

ALTER SEQUENCE public.markets_id_seq OWNED BY public.markets.id;


--
-- Name: mentions; Type: TABLE; Schema: public; Owner: report_user
--

CREATE TABLE public.mentions (
    id integer NOT NULL,
    query_id integer NOT NULL,
    client_id integer NOT NULL,
    engine character varying(50),
    response text,
    sentiment numeric(5,4),
    emotion character varying(50),
    confidence_score numeric(5,4),
    key_topics jsonb,
    summary text,
    source_url text,
    source_title text,
    model_name character varying(100),
    input_tokens integer,
    output_tokens integer,
    price_usd numeric(10,6),
    latency_ms integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    brand_id integer,
    category text
);


ALTER TABLE public.mentions OWNER TO report_user;

--
-- Name: mentions_id_seq; Type: SEQUENCE; Schema: public; Owner: report_user
--

CREATE SEQUENCE public.mentions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mentions_id_seq OWNER TO report_user;

--
-- Name: mentions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: report_user
--

ALTER SEQUENCE public.mentions_id_seq OWNED BY public.mentions.id;


--
-- Name: prompt_categories; Type: TABLE; Schema: public; Owner: report_user
--

CREATE TABLE public.prompt_categories (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text
);


ALTER TABLE public.prompt_categories OWNER TO report_user;

--
-- Name: prompt_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: report_user
--

CREATE SEQUENCE public.prompt_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.prompt_categories_id_seq OWNER TO report_user;

--
-- Name: prompt_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: report_user
--

ALTER SEQUENCE public.prompt_categories_id_seq OWNED BY public.prompt_categories.id;


--
-- Name: queries; Type: TABLE; Schema: public; Owner: report_user
--

CREATE TABLE public.queries (
    id integer NOT NULL,
    market_id integer NOT NULL,
    category_id integer NOT NULL,
    query text NOT NULL,
    sub_topic character varying(255),
    language character varying(10) DEFAULT 'es'::character varying,
    enabled boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    client_id integer,
    brand_id integer,
    category text
);


ALTER TABLE public.queries OWNER TO report_user;

--
-- Name: queries_id_seq; Type: SEQUENCE; Schema: public; Owner: report_user
--

CREATE SEQUENCE public.queries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.queries_id_seq OWNER TO report_user;

--
-- Name: queries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: report_user
--

ALTER SEQUENCE public.queries_id_seq OWNED BY public.queries.id;


--
-- Name: report_generation_log; Type: TABLE; Schema: public; Owner: report_user
--

CREATE TABLE public.report_generation_log (
    id integer NOT NULL,
    client_id integer NOT NULL,
    market_id integer NOT NULL,
    status character varying(50) DEFAULT 'pending'::character varying,
    start_date date NOT NULL,
    end_date date NOT NULL,
    file_path text,
    error_message text,
    requested_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    completed_at timestamp with time zone
);


ALTER TABLE public.report_generation_log OWNER TO report_user;

--
-- Name: report_generation_log_id_seq; Type: SEQUENCE; Schema: public; Owner: report_user
--

CREATE SEQUENCE public.report_generation_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_generation_log_id_seq OWNER TO report_user;

--
-- Name: report_generation_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: report_user
--

ALTER SEQUENCE public.report_generation_log_id_seq OWNED BY public.report_generation_log.id;


--
-- Name: brands id; Type: DEFAULT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.brands ALTER COLUMN id SET DEFAULT nextval('public.brands_id_seq'::regclass);


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: insights id; Type: DEFAULT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.insights ALTER COLUMN id SET DEFAULT nextval('public.insights_id_seq'::regclass);


--
-- Name: markets id; Type: DEFAULT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.markets ALTER COLUMN id SET DEFAULT nextval('public.markets_id_seq'::regclass);


--
-- Name: mentions id; Type: DEFAULT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.mentions ALTER COLUMN id SET DEFAULT nextval('public.mentions_id_seq'::regclass);


--
-- Name: prompt_categories id; Type: DEFAULT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.prompt_categories ALTER COLUMN id SET DEFAULT nextval('public.prompt_categories_id_seq'::regclass);


--
-- Name: queries id; Type: DEFAULT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.queries ALTER COLUMN id SET DEFAULT nextval('public.queries_id_seq'::regclass);


--
-- Name: report_generation_log id; Type: DEFAULT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.report_generation_log ALTER COLUMN id SET DEFAULT nextval('public.report_generation_log_id_seq'::regclass);


--
-- Data for Name: brands; Type: TABLE DATA; Schema: public; Owner: report_user
--

COPY public.brands (id, client_id, name, slug) FROM stdin;
1	8	Default Brand	default
\.


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: report_user
--

COPY public.clients (id, name, api_keys, created_at, slug, api_key) FROM stdin;
1	Cliente Demo	{}	2025-09-23 14:45:56.534922+00	\N	\N
8	Default Client	\N	2025-09-23 18:51:43.216289+00	default	\N
9	The Core School	{}	2025-09-23 20:22:24.055142+00	\N	\N
\.


--
-- Data for Name: insights; Type: TABLE DATA; Schema: public; Owner: report_user
--

COPY public.insights (id, client_id, payload, created_at, brand_id, category) FROM stdin;
\.


--
-- Data for Name: markets; Type: TABLE DATA; Schema: public; Owner: report_user
--

COPY public.markets (id, client_id, name, description, created_at, competitors) FROM stdin;
1	1	España	Mercado principal	2025-09-23 14:45:56.534922+00	["Competidor A", "Competidor B", "Otra Marca"]
6	9	España (Educación Superior Audiovisual)	Mercado educativo para cine, TV, animación y videojuegos en España.	2025-09-23 20:22:24.055142+00	["ECAM", "U-TAD", "TAI", "ESCAC", "CEV", "Septima Ars"]
\.


--
-- Data for Name: mentions; Type: TABLE DATA; Schema: public; Owner: report_user
--

COPY public.mentions (id, query_id, client_id, engine, response, sentiment, emotion, confidence_score, key_topics, summary, source_url, source_title, model_name, input_tokens, output_tokens, price_usd, latency_ms, created_at, brand_id, category) FROM stdin;
1	1	9	OpenAI (gpt-4o-mini)	En España, hay varias escuelas y centros privados que ofrecen programas de formación en escritura de guiones y en producción audiovisual práctica. Aquí te dejo una lista de algunas de las más reconocidas:\n\n1. **Escuela de Cine de Madrid (ECAM)**: Ofrece un máster en guion y diversos cursos relacionados con la escritura de guiones y la producción audiovisual.\n\n2. **Instituto del Cine de Madrid (ICM)**: Ofrece programas de formación en guion, así como en dirección y producción de cine.\n\n3. **Escuela Superior de Artes y Espectáculos (TAI)**: TAI ofrece un grado en escritura de guiones y cursos de especialización en producción audiovisual.\n\n4. **ESCAC (Escuela Superior de Cine y Audiovisuales de Cataluña)**: Ofrece un grado en guion y varios másteres en producción y dirección, con un enfoque práctico.\n\n5. **Cineastas en Acción (CEA)**: Ofrecen talleres y cursos intensivos en guion y producción, con un enfoque práctico y colaborativo.\n\n6. **Universidad de Navarra**: A través de su Facultad de Comunicación, ofrece programas relacionados con el cine y la escritura de guiones.\n\n7. **Escuela de Cine de Barcelona (ECIB)**: Ofrece programas de formación en guion y producción, con un enfoque práctico en la creación audiovisual.\n\n8. **La Escuela de Nuevos Talentos Audiovisuales (ENTAV)**: Ofrece cursos de guion y producción, con un enfoque en la formación práctica.\n\n9. **Escuela de Cine de Valencia (ECV)**: Ofrece programas de formación en escritura de guiones y producción audiovisual.\n\n10. **Escuela de Guion de Barcelona**: Se especializa en la formación de guionistas y ofrece diversos cursos y talleres.\n\nEs recomendable revisar los planes de estudio, la duración de los programas, las salidas profesionales y las opiniones de antiguos alumnos para encontrar la opción que mejor se adapte a tus necesidades e intereses.	0.7000	optimismo	0.8500	["escuelas de cine", "guiones", "producción audiovisual", "formación", "programas"]	El texto presenta diversas escuelas en España que ofrecen formación en escritura de guiones y producción audiovisual.	\N	\N	gpt-4o-mini	41	412	0.000253	10911	2025-09-24 04:41:25.416664+00	\N	\N
2	1	9	Perplexity (sonar)	En España, varias escuelas superiores y centros privados ofrecen programas especializados en escritura de guiones y formación práctica audiovisual.\n\n**Las opciones más destacadas incluyen:**\n\n- **CEV (Centro de Formación Profesional Madrid):** Fundada en 197	0.6000	optimismo	0.8500	["España", "escritura de guiones", "formación audiovisual", "CEV", "educación"]	Escuelas en España ofrecen programas en escritura de guiones y formación audiovisual.	\N	\N	sonar	41	64	0.000021	2693	2025-09-24 04:41:34.075864+00	\N	\N
3	2	9	OpenAI (gpt-4o-mini)	En España, existen varias escuelas especializadas en entretenimiento que ofrecen formación en diversas áreas como cine, teatro, música, danza, animación y otros campos relacionados. A continuación, se enumeran algunas de ellas, además de las universidades públicas:\n\n1. **ESCAC (Escuela Superior de Cine y Audiovisuales de Cataluña)**: Ubicada en Terrassa, ofrece una formación integral en cine, televisión y medios digitales.\n\n2. **TAI (Escuela Universitaria de Artes y Espectáculos)**: Situada en Madrid, TAI ofrece programas en cine, teatro, música, danza y artes visuales, con un enfoque práctico y profesional.\n\n3. **Cine en la Escuela**: Ofrece cursos y talleres sobre producción cinematográfica, guion y dirección, entre otros.\n\n4. **ESAD (Escuela Superior de Arte Dramático)**: Hay varias sedes en España (como en Madrid, Barcelona y Valencia) que se especializan en la formación de actores y profesionales del teatro.\n\n5. **Escuela de Música Creativa**: Con sede en Madrid, se centra en la formación musical y ofrece programas en producción musical, composición y otros aspectos de la música contemporánea.\n\n6. **Escuela de Animación y Nuevas Tecnologías**: Ofrece programas en animación 3D, diseño de videojuegos y efectos visuales, con un enfoque en las nuevas tecnologías aplicadas al entretenimiento.\n\n7. **EFTI (Escuela de Fotografía y Técnicas de la Imagen)**: En Madrid, ofrece programas en fotografía, dirección de arte y producción audiovisual.\n\n8. **Escuela de Cine de San Antonio de los Baños**: Aunque es de origen cubano, tiene un enfoque internacional y ofrece programas de formación en cine que atraen a estudiantes de España y otros países.\n\n9. **Escuela de Música de Barcelona (ESMUC)**: Aunque es una institución pública, se destaca en la formación de músicos y profesionales de la música en diversas especialidades.\n\n10. **Instituto del Cine de Madrid (ICM)**: Ofrece formación en dirección, producción y otros aspectos del cine y la televisión.\n\nEstas instituciones son solo algunas de las muchas opciones disponibles en España para quienes buscan formarse en el campo del entretenimiento. Cada una tiene su enfoque y especialización, por lo que es recomendable investigar y considerar cuál se alinea mejor con tus intereses y objetivos profesionales.	0.8000	optimismo	0.9000	["cine", "teatro", "música", "danza", "animación"]	El texto describe diversas escuelas en España que ofrecen formación en entretenimiento, destacando su especialización y variedad de programas.	\N	\N	gpt-4o-mini	38	489	0.000299	9649	2025-09-24 04:41:46.807919+00	\N	\N
4	2	9	Perplexity (sonar)	En España, aparte de las universidades públicas, existen varias **escuelas especializadas en entretenimiento** que ofrecen formación en áreas como audiovisual, cine, interpretación, animación, y artes escénicas. Entre las más destacadas están:\n\n- **The Cor	0.6000	optimismo	0.8500	["escuelas especializadas", "entretenimiento", "formación", "artes escénicas", "audiovisual"]	En España hay escuelas especializadas en entretenimiento que ofrecen diversas formaciones artísticas.	\N	\N	sonar	37	64	0.000020	2367	2025-09-24 04:41:53.565497+00	\N	\N
5	3	9	OpenAI (gpt-4o-mini)	En España, hay varios centros de formación reconocidos que ofrecen programas enfocados en el desarrollo de videojuegos y que tienen un buen enfoque en la industria. Aquí te menciono algunos de los más destacados:\n\n1. **Escuela Superior de Diseño de Barcelona (ESDi)**: Ofrece un Grado en Diseño de Videojuegos que combina aspectos técnicos y creativos, y está orientado a las necesidades del mercado.\n\n2. **Universidad Politécnica de Valencia (UPV)**: Su programa de Máster en Desarrollo de Videojuegos es muy bien valorado y está diseñado para preparar a los estudiantes para trabajar en la industria.\n\n3. **Universidad de Salamanca**: Ofrece un Máster en Videojuegos que se centra en el desarrollo, diseño y producción, con un enfoque práctico y colaborativo.\n\n4. **Trazos**: Esta escuela de diseño en Madrid ofrece un curso de desarrollo de videojuegos que incluye programación, diseño y producción, con un enfoque en las herramientas y técnicas actuales utilizadas en la industria.\n\n5. **Ironhack**: Aunque es más conocida por sus bootcamps en programación, Ironhack también ofrece un programa de desarrollo de videojuegos que está diseñado para ser intensivo y práctico, ideal para quienes buscan una rápida inserción en el mercado laboral.\n\n6. **Escuela de Videojuegos de la Universidad de Málaga (UEM)**: Ofrece un Grado en Diseño y Desarrollo de Videojuegos, con un enfoque en la creación de proyectos reales y colaborativos.\n\n7. **CICE**: La Escuela de Nuevas Tecnologías ofrece un máster en Desarrollo de Videojuegos que incluye tanto la parte técnica como la gestión de proyectos.\n\n8. **Game Lab**: Situada en Barcelona, esta escuela se centra exclusivamente en la formación en videojuegos y ofrece programas tanto de grado como de máster, con una fuerte conexión a la industria.\n\n9. **Zaragoza Activa**: Ofrece cursos y talleres relacionados con el desarrollo de videojuegos, enfocados en la práctica y la creación de prototipos.\n\n10. **Universidad de Alicante**: Ofrece un Grado en Diseño y Desarrollo de Videojuegos, que combina teoría y práctica, y está orientado a la industria.\n\nAl elegir un centro de formación, es importante considerar factores como la calidad del profesorado, los recursos disponibles, las prácticas en empresas y la red de contactos que el centro puede ofrecer. También es recomendable investigar sobre las opiniones de antiguos alumnos y la tasa de inserción laboral de los egresados.	0.8000	optimismo	0.9000	["desarrollo de videojuegos", "formación", "universidades", "programas", "industria"]	El texto destaca varios centros en España que ofrecen formación en desarrollo de videojuegos, enfatizando su calidad y conexión con la industria.	\N	\N	gpt-4o-mini	44	516	0.000316	9611	2025-09-24 04:42:06.076371+00	\N	\N
6	3	9	Perplexity (sonar)	Los mejores centros de formación para estudiar desarrollo de videojuegos en España con un enfoque en la industria incluyen principalmente a **ESAT (Escuela Superior de Arte y Tecnología)**, que es reconocida como la mejor escuela de España y se posiciona sexta a nivel mundia	0.8000	optimismo	0.9000	["desarrollo de videojuegos", "ESAT", "formación", "industria", "España"]	ESAT es reconocida como la mejor escuela de desarrollo de videojuegos en España y ocupa el sexto lugar a nivel mundial.	\N	\N	sonar	43	64	0.000021	3176	2025-09-24 04:42:12.993851+00	\N	\N
7	4	9	OpenAI (gpt-4o-mini)	En Madrid, hay varias escuelas especializadas en cine y televisión que ofrecen programas con un enfoque práctico. Aquí te menciono algunas de las más destacadas:\n\n1. **Escuela de Cine y Artes Visuales (ECAM)**: Esta escuela es conocida por su formación integral en cine y televisión. Ofrecen una variedad de programas, desde cursos cortos hasta títulos de grado, todos con un enfoque práctico y un fuerte componente de producción.\n\n2. **TITULACIÓN EN CINE Y TELEVISIÓN (Universidad Carlos III de Madrid)**: Aunque es una universidad, su programa tiene un enfoque práctico y se centra en la producción audiovisual. Ofrecen talleres y proyectos en los que los estudiantes pueden trabajar directamente en producciones.\n\n3. **Escuela de Cinematografía y del Audiovisual de la Comunidad de Madrid (ECAM)**: Además de su formación en cine, también ofrecen cursos en televisión y otros medios audiovisuales. La escuela se centra en la práctica y la creación de proyectos.\n\n4. **Instituto del Cine de Madrid (ICM)**: Ofrecen una variedad de programas en diferentes áreas del cine y la televisión, con un enfoque práctico en la producción y la dirección.\n\n5. **Taller de Cine**: Esta escuela se especializa en la formación práctica en cine y ofrece cursos de dirección, producción y guion. Sus programas están diseñados para que los estudiantes trabajen en proyectos reales.\n\n6. **Escuela de Medios Audiovisuales (EMA)**: Ofrecen formación en diversas áreas del audiovisual, incluyendo cine y televisión, con un enfoque práctico que permite a los estudiantes desarrollar sus habilidades en proyectos reales.\n\n7. **Escuela de Artes y Espectáculos (TAI)**: TAI ofrece programas en cine y televisión que combinan teoría y práctica, permitiendo a los estudiantes trabajar en producciones desde el primer día.\n\nTe recomendaría visitar las páginas web de estas instituciones para obtener más información sobre los programas específicos que ofrecen, así como los requisitos de admisión y las fechas de inscripción. Además, es útil asistir a jornadas de puertas abiertas o charlas informativas para conocer mejor cada escuela y su enfoque educativo.	0.7000	optimismo	0.9000	["ECAM", "Universidad Carlos III", "ICM", "Taller de Cine", "TAI"]	Se presentan varias escuelas en Madrid que ofrecen programas prácticos en cine y televisión.	\N	\N	gpt-4o-mini	40	441	0.000271	8285	2025-09-24 04:42:24.288888+00	\N	\N
8	4	9	Perplexity (sonar)	En Madrid, puedes estudiar cine o televisión en escuelas especializadas con un enfoque práctico en varias instituciones destacadas:\n\n- **Escuela de Cine y TV Séptima Ars**: Con más de 30 años de experiencia, es una de las escuelas más pres	0.7000	optimismo	0.8500	["Madrid", "cine", "televisión", "Escuela de Cine y TV Séptima Ars", "educación"]	Madrid ofrece escuelas especializadas en cine y televisión con enfoque práctico.	\N	\N	sonar	40	64	0.000021	2845	2025-09-24 04:42:31.435538+00	\N	\N
9	5	9	OpenAI (gpt-4o-mini)	En España, además de los grados universitarios tradicionales en cine y televisión, existen diversas opciones de formación especializada que pueden ayudarte a desarrollar tus habilidades y conocimientos en el sector. Aquí te presento algunas:\n\n1. **Másteres y Postgrados**:\n   - **Máster en Dirección de Cine**: Ofrecido por varias escuelas de cine, como la ECAM (Escuela de Cinematografía y del Audiovisual de Madrid) o la ESCAC (Escuela Superior de Cine y Audiovisuales de Cataluña).\n   - **Máster en Producción Audiovisual**: En instituciones como la Universidad de Barcelona o la Universidad Carlos III de Madrid.\n   - **Máster en Guion**: Programas especializados en escritura de guiones, como los que ofrece la Universidad de Navarra o la ECAM.\n\n2. **Escuelas de Cine**:\n   - **ECAM**: Ofrece diversas especializaciones en cine, incluyendo dirección, producción, montajes, y guion.\n   - **ESCAC**: Ofrece grados y másteres en diferentes áreas del cine, incluyendo dirección, producción y postproducción.\n   - **TAI**: Escuela Universitaria de Artes y Espectáculos que ofrece grados y másteres en cine, televisión y otras artes.\n\n3. **Cursos Cortos y Talleres**:\n   - Muchas escuelas y centros de formación ofrecen cursos cortos o talleres en áreas específicas como dirección de actores, edición, cinematografía, etc. Estos pueden ser muy útiles para adquirir habilidades prácticas.\n\n4. **Formación Online**:\n   - Plataformas como Coursera, Domestika o MasterClass ofrecen cursos impartidos por profesionales de la industria en diversas áreas del cine y la televisión.\n\n5. **Programas de Formación Profesional**:\n   - Existen ciclos formativos de grado superior en producción de audiovisuales y espectáculos, que ofrecen formación práctica y teórica.\n\n6. **Seminarios y Festivales**:\n   - Participar en festivales de cine y seminarios puede ser una excelente manera de aprender y hacer contactos en la industria. Algunos festivales ofrecen talleres y masterclasses con profesionales del sector.\n\n7. **Asociaciones y Colectivos**:\n   - Unirte a asociaciones de cineastas o colectivos puede ofrecerte oportunidades de formación, networking y colaboración en proyectos.\n\nCada una de estas opciones puede adaptarse a tus intereses y necesidades específicas dentro del mundo del cine y la televisión. Te recomiendo investigar más sobre cada una y considerar cuál se alinea mejor con tus objetivos profesionales.	0.8000	optimismo	0.9000	["másteres", "escuelas de cine", "cursos cortos", "formación online", "seminarios"]	El texto presenta diversas opciones de formación en cine y televisión en España, destacando másteres, escuelas, cursos cortos y oportunidades de networking.	\N	\N	gpt-4o-mini	46	520	0.000319	11422	2025-09-24 04:42:47.103179+00	\N	\N
10	5	9	Perplexity (sonar)	En España existen varias **formaciones especializadas en cine y televisión más allá de los grados universitarios tradicionales**, entre las que destacan escuelas y cursos específicos para diferentes perfiles profesionales:\n\n- **Escuela de Cine y TV Septima Ars (Madri	0.5000	optimismo	0.8500	["formaciones especializadas", "cine", "televisión", "escuelas", "cursos"]	Se mencionan formaciones especializadas en cine y televisión en España, más allá de los grados universitarios tradicionales.	\N	\N	sonar	44	64	0.000022	2870	2025-09-24 04:42:52.845364+00	\N	\N
11	6	9	OpenAI (gpt-4o-mini)	En España, hay varias instituciones y universidades que ofrecen carreras creativas con un enfoque profesional y conexiones con empresas. Aquí te dejo algunas de las más destacadas:\n\n1. **IED Madrid y IED Barcelona (Instituto Europeo di Design)**: Ofrecen una amplia gama de programas en diseño, moda, comunicación visual, y más. Tienen un enfoque práctico y colaboraciones con empresas del sector.\n\n2. **ESNE (Escuela Universitaria de Diseño, Innovación y Tecnología)**: Ubicada en Madrid, ESNE ofrece grados en diseño de producto, diseño gráfico, diseño de moda, y más, con un fuerte énfasis en la innovación y la conexión con la industria.\n\n3. **EINA (Centro Universitario de Diseño y Arte)**: Situada en Barcelona, EINA ofrece grados en diseño gráfico, diseño de interiores, y diseño de producto, entre otros. Tienen un enfoque en la creatividad y la profesionalización.\n\n4. **Universidad de Barcelona (UB) - Facultad de Bellas Artes**: Ofrece programas en Bellas Artes, Diseño y otras disciplinas creativas, con oportunidades de colaboración con empresas y proyectos reales.\n\n5. **Universidad Politécnica de Valencia (UPV)**: Su Escuela Técnica Superior de Diseño ofrece grados en diseño industrial y diseño gráfico, con una fuerte conexión con el sector empresarial.\n\n6. **ESADA (Escuela Superior de Arte y Diseño de Andalucía)**: Ofrece programas en diseño gráfico, diseño de moda y otros, con un enfoque en la formación práctica y profesional.\n\n7. **L'Escola Massana**: En Barcelona, ofrece programas de arte y diseño, fomentando la creatividad y la conexión con el mundo profesional.\n\n8. **Universidad de Navarra - Escuela de Arquitectura y Diseño**: Ofrece programas en diseño y arquitectura con un enfoque en la innovación y el trabajo en equipo.\n\n9. **Trazos**: Escuela de diseño y tecnología en Madrid, que ofrece formación en diseño gráfico, 3D, y desarrollo web, con un enfoque práctico y colaboraciones con empresas.\n\n10. **Escuela Superior de Diseño de Madrid (ESDM)**: Ofrece programas en diversas disciplinas de diseño, con énfasis en la conexión con la industria.\n\nEs recomendable investigar cada institución, sus programas específicos, y las oportunidades de prácticas o colaboraciones con empresas que ofrecen. Además, asistir a ferias de empleo y eventos de networking puede ser útil para establecer conexiones en el sector.	0.8000	optimismo	0.9000	["diseño", "universidades", "creatividad", "conexiones empresariales", "educación"]	El texto destaca instituciones en España que ofrecen carreras creativas con enfoques profesionales y conexiones con empresas.	\N	\N	gpt-4o-mini	38	504	0.000308	12028	2025-09-24 04:43:08.214376+00	\N	\N
12	6	9	Perplexity (sonar)	En España, para estudiar **carreras creativas con un enfoque profesional y fuerte conexión con empresas**, destacan varias opciones en universidades e instituciones que combinan formación innovadora y prácticas en empresas del sector:\n\n- La **Universidad Europea de Madrid** ofrece el *	0.7000	optimismo	0.8500	["carreras creativas", "Universidad Europea de Madrid", "formación innovadora", "prácticas en empresas", "conexión con empresas"]	En España hay opciones para estudiar carreras creativas con conexión profesional en universidades e instituciones.	\N	\N	sonar	33	64	0.000019	2291	2025-09-24 04:43:13.937931+00	\N	\N
13	7	9	OpenAI (gpt-4o-mini)	En Madrid, hay varias instituciones y escuelas que ofrecen formación profesional en la creación de guiones. Aquí te menciono algunas de las más destacadas:\n\n1. **Escuela de Cine y Televisión (ECAM)**: Ofrece un Máster en Guion de Cine y Televisión, así como cursos especializados en escritura de guiones.\n\n2. **Taller de Guion**: Esta escuela se centra en la formación de guionistas y ofrece cursos de diferentes niveles, desde introducción hasta formación avanzada.\n\n3. **Escuela de Escritores**: Aunque su enfoque es más amplio, también ofrecen talleres y cursos específicos sobre la escritura de guiones.\n\n4. **Universidad Complutense de Madrid (UCM)**: Tiene programas en la Facultad de Ciencias de la Información que incluyen asignaturas sobre guionismo en sus carreras de Comunicación Audiovisual.\n\n5. **Instituto del Cine de Madrid (ICM)**: Ofrece cursos y talleres sobre guion y desarrollo de proyectos cinematográficos.\n\n6. **Escuela de Artes y Espectáculos (TITULAE)**: Ofrece un curso de guion que abarca tanto el cine como la televisión.\n\nEs recomendable revisar los sitios web de estas instituciones para obtener información actualizada sobre los programas, fechas y requisitos de inscripción. Además, también puedes encontrar talleres y cursos cortos ofrecidos por profesionales del sector a través de plataformas de formación online.	0.7000	optimismo	0.8500	["formación profesional", "guiones", "ECAM", "UCM", "ICM"]	Madrid cuenta con diversas instituciones que ofrecen formación profesional en creación de guiones.	\N	\N	gpt-4o-mini	36	288	0.000178	6434	2025-09-24 04:43:23.772891+00	\N	\N
14	7	9	Perplexity (sonar)	En Madrid, puedes formarte profesionalmente para la creación de guiones en varias instituciones con opciones que van desde cursos intensivos hasta másteres y diplomaturas:\n\n- **ECAM (Escuela de Cinematografía y del Audiovisual de la Comunidad de Madrid)** ofrece varios programas relevantes	0.7000	optimismo	0.9000	["Madrid", "formación", "guiones", "ECAM", "cursos"]	Madrid ofrece diversas opciones de formación en creación de guiones, incluyendo cursos y másteres.	\N	\N	sonar	30	64	0.000019	2773	2025-09-24 04:43:29.700673+00	\N	\N
15	8	9	OpenAI (gpt-4o-mini)	En España, hay varias instituciones y escuelas que ofrecen programas de formación en guion para series con un enfoque práctico. Aquí te menciono algunas de las más destacadas:\n\n1. **Escuela de Cine y Televisión de Madrid (ECAM)**: Ofrece un máster en guion que incluye formación práctica y talleres. Los estudiantes tienen la oportunidad de trabajar en proyectos reales y recibir feedback de profesionales del sector.\n\n2. **Institut del Teatre (Barcelona)**: Ofrece un programa de estudios en dramaturgia y guion que incluye formación práctica y la posibilidad de trabajar en proyectos de creación colectiva.\n\n3. **Escuela de Escritores**: Aunque su enfoque es más amplio, ofrecen cursos específicos de guion donde los estudiantes pueden aprender sobre la escritura de series y desarrollar sus propios proyectos.\n\n4. **Taller de Guion de la Universidad de Málaga**: Ofrecen un máster en guion de ficción que se centra en la escritura para televisión y cine, con un enfoque práctico y talleres de escritura.\n\n5. **Escuela de Cine de San Antonio de los Baños (Cuba)**: Aunque está en Cuba, muchos estudiantes españoles asisten a sus talleres de guion. La escuela es conocida por su enfoque práctico y su conexión con la industria.\n\n6. **Escuela de Cine de Barcelona**: Ofrecen un máster en guion que combina teoría y práctica, permitiendo a los estudiantes desarrollar sus propios guiones para series y películas.\n\n7. **EICTV (Escuela Internacional de Cine y Televisión)**: Aunque está en Cuba, es una opción popular para muchos españoles. Ofrecen un enfoque práctico y talleres intensivos en guion.\n\n8. **Universidad Carlos III de Madrid**: Ofrece un máster en guion y narrativa audiovisual, con un fuerte componente práctico y la posibilidad de trabajar en proyectos reales.\n\nAdemás de estas instituciones, también hay numerosos talleres y cursos cortos que se ofrecen en diferentes ciudades, así como plataformas online que pueden complementar la formación práctica. Es recomendable investigar cada opción, revisar el plan de estudios y, si es posible, hablar con antiguos alumnos para tomar una decisión informada.	0.8000	optimismo	0.9000	["guion", "formación práctica", "instituciones", "talleres", "proyectos reales"]	El texto describe varias instituciones en España que ofrecen formación práctica en guion para series y películas.	\N	\N	gpt-4o-mini	37	439	0.000269	9289	2025-09-24 04:43:41.920542+00	\N	\N
16	8	9	Perplexity (sonar)	En España, varias escuelas y universidades ofrecen formación en guion para series con un enfoque práctico destacado:\n\n- **Escuela de Guion de Madrid**: Reúne a profesionales en activo del cine, televisión y dramaturgia para enseñar mediante un	0.7000	optimismo	0.8500	["formación", "guion", "series", "Escuela de Guion de Madrid", "cine"]	Escuelas y universidades en España ofrecen formación práctica en guion para series.	\N	\N	sonar	35	64	0.000020	2588	2025-09-24 04:43:48.889338+00	\N	\N
17	9	9	OpenAI (gpt-4o-mini)	España cuenta con varias escuelas y centros de formación reconocidos en el ámbito de la postproducción y los efectos visuales (VFX). Aquí te presento algunas de las mejores opciones:\n\n1. **ESCAC (Escuela Superior de Cine y Audiovisuales de Cataluña)**: Ubicada en Terrassa, ESCAC es conocida por su enfoque integral en la formación cinematográfica, incluyendo programas de postproducción y VFX. Ofrecen un máster en postproducción que abarca diversas técnicas y herramientas del sector.\n\n2. **FX Animation**: Situada en Barcelona, esta escuela se especializa en la formación en animación, efectos visuales y postproducción. Ofrecen diversos programas, desde cursos cortos hasta másteres, con un enfoque práctico y profesional.\n\n3. **CICE (Escuela Profesional de Nuevas Tecnologías)**: En Madrid, CICE ofrece un máster en VFX y postproducción que incluye formación en software líder de la industria, así como proyectos prácticos que permiten a los estudiantes adquirir experiencia real.\n\n4. **Escuela de Cinematografía y del Audiovisual de la Comunidad de Madrid (ECAM)**: La ECAM ofrece un máster en postproducción que cubre tanto aspectos técnicos como creativos, preparando a los estudiantes para trabajar en la industria audiovisual.\n\n5. **Trazos**: También en Madrid, Trazos es conocida por su formación en diseño gráfico y VFX. Ofrecen cursos y másteres que abarcan desde los fundamentos hasta técnicas avanzadas en postproducción y efectos visuales.\n\n6. **Universidad Politécnica de Valencia (UPV)**: La UPV ofrece programas relacionados con la animación y los efectos visuales, incluyendo formación en software y técnicas utilizadas en la industria.\n\n7. **Bau, Centro Universitario de Diseño**: En Barcelona, Bau ofrece programas en diseño y multimedia, con asignaturas que tocan la postproducción y los efectos visuales, integrando el diseño gráfico con la tecnología audiovisual.\n\nAl elegir una escuela, es importante considerar factores como la calidad del profesorado, las instalaciones, el enfoque práctico de los programas y las oportunidades de networking en la industria. También es recomendable revisar las opiniones de antiguos alumnos y la tasa de inserción laboral de los graduados.	0.8000	optimismo	0.9500	["postproducción", "efectos visuales", "escuelas", "formación", "animación"]	El texto presenta varias escuelas en España especializadas en postproducción y VFX, destacando sus programas y enfoques educativos.	\N	\N	gpt-4o-mini	38	475	0.000291	10225	2025-09-24 04:44:01.762214+00	\N	\N
18	9	9	Perplexity (sonar)	Las mejores escuelas de postproducción y VFX en España en 2025 incluyen principalmente a Lightbox Academy, CICE, ANIMUM 3D, ESCAV y la Escuela Superior de Artes Digitales Trazos, destacadas por sus másteres especializados y programas completo	0.8000	optimismo	0.9000	["Lightbox Academy", "CICE", "ANIMUM 3D", "ESCAV", "Escuela Superior de Artes Digitales Trazos"]	Las mejores escuelas de postproducción y VFX en España en 2025 destacan por sus programas especializados.	\N	\N	sonar	31	64	0.000019	2406	2025-09-24 04:44:07.485041+00	\N	\N
19	10	9	OpenAI (gpt-4o-mini)	Para llegar a jóvenes interesados en el ámbito audiovisual en España, es importante considerar una variedad de canales digitales que son populares entre este grupo demográfico. Aquí te presento algunos de los más efectivos:\n\n1. **Redes Sociales**:\n   - **Instagram**: Muy popular entre los jóvenes, ideal para compartir contenido visual y audiovisual. Las historias y reels son formatos que captan la atención.\n   - **TikTok**: Esta plataforma ha crecido exponencialmente y es especialmente efectiva para el contenido corto y creativo. Los jóvenes pasan mucho tiempo aquí, lo que la convierte en un canal clave.\n   - **YouTube**: Sigue siendo una de las plataformas más importantes para contenido audiovisual. Los jóvenes buscan tutoriales, reseñas y entretenimiento en esta plataforma.\n   - **Twitter**: Aunque su uso ha disminuido entre los más jóvenes, sigue siendo relevante para noticias y tendencias.\n\n2. **Plataformas de Streaming**:\n   - **Twitch**: Ideal para contenido en vivo, especialmente relacionado con videojuegos, pero también para charlas y creación de contenido audiovisual.\n   - **Netflix, Amazon Prime, Disney+**: Aunque son plataformas de streaming, pueden ser útiles para promocionar contenido original y atraer a jóvenes que consumen series y películas.\n\n3. **Blogs y Sitios Web**:\n   - **Blogs de cine y audiovisual**: Pueden atraer a jóvenes interesados en críticas, análisis y noticias del sector.\n   - **Portales de formación**: Sitios que ofrecen cursos y recursos sobre producción audiovisual pueden ser atractivos.\n\n4. **Email Marketing**:\n   - Aunque menos popular entre los jóvenes, si se utiliza de manera creativa y personalizada, puede ser efectivo para enviar información sobre eventos, cursos o novedades en el sector.\n\n5. **Eventos en Línea**:\n   - Webinars, masterclasses y talleres virtuales pueden atraer a jóvenes interesados en aprender más sobre el ámbito audiovisual.\n\n6. **Grupos y Comunidades en Línea**:\n   - Plataformas como Discord o Facebook Groups pueden ser útiles para construir comunidades en torno a intereses específicos en audiovisual.\n\n7. **Publicidad Digital**:\n   - Utilizar anuncios en redes sociales y Google Ads dirigidos a audiencias específicas puede ser una forma efectiva de llegar a jóvenes interesados en contenido audiovisual.\n\nPara maximizar el alcance, es recomendable combinar varios de estos canales y adaptar el contenido a las características y preferencias de la audiencia joven. Además, es importante estar atento a las tendencias y cambios en el comportamiento de los usuarios en estas plataformas.	0.7000	optimismo	0.8500	["redes sociales", "plataformas de streaming", "contenido audiovisual", "email marketing", "eventos en línea"]	El texto sugiere canales digitales efectivos para atraer a jóvenes interesados en el ámbito audiovisual en España.	\N	\N	gpt-4o-mini	38	509	0.000311	9444	2025-09-24 04:44:20.160118+00	\N	\N
20	10	9	Perplexity (sonar)	Los canales digitales más efectivos para llegar a jóvenes interesados en audiovisual en España son principalmente las plataformas de **TV conectada y streaming** y las **redes sociales de vídeo**, con un fuerte protagonismo de:\n\n- **YouTube**, con un 87% de uso entre niño	0.7000	optimismo	0.8500	["TV conectada", "streaming", "redes sociales de vídeo", "YouTube", "jóvenes"]	Las plataformas de TV conectada, streaming y redes sociales de vídeo son efectivas para jóvenes en España, destacando YouTube.	\N	\N	sonar	34	64	0.000020	2947	2025-09-24 04:44:26.048862+00	\N	\N
21	11	9	OpenAI (gpt-4o-mini)	Elegir el mejor máster en dirección de cine en Europa puede depender de varios factores, como tus objetivos profesionales, el enfoque del programa, la ubicación y las conexiones con la industria. A continuación, te presento algunas de las escuelas más reconocidas en Europa que ofrecen programas de máster en dirección de cine y que tienen buenas conexiones con la industria:\n\n1. **London Film School (Reino Unido)**:\n   - Ofrece un máster en dirección de cine que es altamente valorado. La escuela tiene una buena reputación en la industria y cuenta con una red sólida de exalumnos.\n\n2. **National Film and Television School (NFTS) (Reino Unido)**:\n   - Su programa de dirección de cine es muy respetado y ofrece un enfoque práctico. La NFTS tiene conexiones directas con la industria y muchos de sus graduados han tenido éxito en el cine y la televisión.\n\n3. **La Fémis (Francia)**:\n   - Esta escuela de cine en París ofrece un máster en dirección que es muy competitivo. La Fémis tiene una fuerte conexión con la industria cinematográfica francesa y europea.\n\n4. **Centro Sperimentale di Cinematografia (Italia)**:\n   - Este es uno de los centros de formación cinematográfica más antiguos de Italia y ofrece un máster en dirección. Tiene una buena reputación y conexiones con la industria cinematográfica italiana.\n\n5. **ESCAC (Escuela Superior de Cine y Audiovisuales de Catalunya) (España)**:\n   - Ofrece un máster en dirección de cine con un enfoque práctico y una buena conexión con la industria española. La ESCAC tiene una sólida red de contactos en el mundo del cine.\n\n6. **University of the Arts London - London College of Communication (Reino Unido)**:\n   - Ofrece un máster en dirección de cine que se centra en el desarrollo de habilidades creativas y técnicas, con oportunidades de colaboración con la industria.\n\n7. **Met Film School (Reino Unido)**:\n   - Situada en Londres, ofrece programas en dirección de cine y tiene vínculos con la industria, lo que puede facilitar oportunidades de trabajo y networking.\n\nCuando consideres un programa, es importante investigar no solo el currículo, sino también las oportunidades de prácticas, la calidad de los profesores, las instalaciones y la red de exalumnos. También puede ser útil asistir a ferias de educación o jornadas de puertas abiertas para conocer más sobre cada programa y su conexión con la industria.	0.7000	optimismo	0.9000	["máster en dirección de cine", "London Film School", "National Film and Television School", "La Fémis", "ESCAC"]	El texto analiza opciones de máster en dirección de cine en Europa, destacando escuelas con buenas conexiones a la industria.	\N	\N	gpt-4o-mini	47	504	0.000309	11830	2025-09-24 04:44:40.733013+00	\N	\N
22	11	9	Perplexity (sonar)	El mejor máster en dirección de cine en Europa con fuerte conexión directa con la industria se encuentra en escuelas como **London Film Academy**, **Escuela Superior de Cinema y Audiovisuales de Cataluña (ESCAC)**, y el **Instituto del Cine de Madrid**	0.8000	optimismo	0.9000	["London Film Academy", "ESCAC", "Instituto del Cine de Madrid"]	Se destacan las mejores escuelas de cine en Europa con conexión a la industria.	\N	\N	sonar	43	64	0.000021	2893	2025-09-24 04:44:46.411161+00	\N	\N
23	12	9	OpenAI (gpt-4o-mini)	Elegir el mejor máster online para la creación de contenido o para ser influencer en España depende de varios factores, como tus objetivos profesionales, el enfoque del programa y tu presupuesto. A continuación, te presento algunas opciones destacadas que podrías considerar:\n\n1. **Máster en Marketing Digital y Redes Sociales** - Varias instituciones, como la **Universidad de Barcelona** o **ESIC**, ofrecen programas que incluyen módulos específicos sobre creación de contenido, gestión de redes sociales y estrategias de marketing para influencers.\n\n2. **Máster en Creación de Contenidos Digitales** - Algunas universidades y escuelas de negocios, como **La Salle** o **Cámara de Comercio** de Madrid, tienen programas dedicados a la creación de contenido digital, donde se abordan temas como la producción audiovisual, redacción creativa y estrategias de contenido.\n\n3. **Máster en Community Management y Marketing Digital** - Instituciones como **UNIR** (Universidad Internacional de La Rioja) ofrecen programas que cubren tanto la gestión de comunidades online como la creación de contenido atractivo para diferentes plataformas.\n\n4. **Máster en Influencer Marketing** - Aunque menos comunes, algunas plataformas de formación online y escuelas especializadas están comenzando a ofrecer programas enfocados exclusivamente en el marketing de influencers, donde se analiza la estrategia, la ética y la monetización del contenido.\n\n5. **Cursos de especialización** - Además de los másteres, hay cursos cortos y especializaciones que pueden ser muy útiles, como los que ofrece **Domestika** o **Coursera**, que tratan sobre fotografía, edición de vídeo, storytelling y otras habilidades relevantes para influencers.\n\nEs recomendable que investigues el plan de estudios, la reputación de la institución, las opiniones de antiguos alumnos y, si es posible, que contactes con ellos para obtener más información. También considera tus intereses específicos, como el tipo de contenido que deseas crear (texto, video, fotografía, etc.) y las plataformas que te interesan.	0.7000	optimismo	0.8500	["máster", "influencer", "marketing digital", "creación de contenido", "cursos de especialización"]	El texto ofrece recomendaciones sobre másteres y cursos en España para la creación de contenido y marketing digital.	\N	\N	gpt-4o-mini	40	404	0.000248	9158	2025-09-24 04:44:58.572846+00	\N	\N
24	12	9	Perplexity (sonar)	El mejor máster online en España para creación de contenido o ser influencer depende de tus objetivos, nivel y presupuesto, pero destacan estos programas:\n\n- **Máster Profesional para Influencers y Creadores de Contenido de Skiller Academy**, específico para influencers y creadores co	0.5000	optimismo	0.8500	["máster online", "creación de contenido", "influencers", "Skiller Academy"]	El texto menciona un máster online destacado para influencers y creadores de contenido en España.	\N	\N	sonar	32	64	0.000019	2913	2025-09-24 04:45:05.229063+00	\N	\N
25	13	9	OpenAI (gpt-4o-mini)	Realizar una comparativa de precios de grados en comunicación audiovisual en escuelas privadas de España puede variar significativamente dependiendo de la institución, la ubicación, la duración del programa y los servicios incluidos. A continuación, te proporciono un resumen general de los costos que podrías encontrar en diferentes escuelas privadas en España, pero ten en cuenta que los precios pueden cambiar con el tiempo y es recomendable consultar directamente con cada institución para obtener la información más actualizada.\n\n### Escuelas Privadas en España\n\n1. **Universidad Europea de Madrid**\n   - **Precio aproximado**: Entre 10,000 y 12,000 euros por año.\n   - **Duración**: 4 años.\n   - **Características**: Enfoque práctico, instalaciones modernas y posibilidad de prácticas en empresas.\n\n2. **Universidad Francisco de Vitoria (UFV)**\n   - **Precio aproximado**: Alrededor de 9,000 euros por año.\n   - **Duración**: 4 años.\n   - **Características**: Formación integral, con énfasis en los valores humanos y éticos.\n\n3. **Escuela Universitaria de Artes y Espectáculos TAI**\n   - **Precio aproximado**: Entre 10,000 y 14,000 euros por año.\n   - **Duración**: 4 años.\n   - **Características**: Fuerte enfoque en la práctica artística y audiovisual, con talleres y proyectos.\n\n4. **Universidad de Nebrija**\n   - **Precio aproximado**: Entre 8,000 y 11,000 euros por año.\n   - **Duración**: 4 años.\n   - **Características**: Programas con un enfoque en la innovación y el emprendimiento.\n\n5. **Universidad Camilo José Cela**\n   - **Precio aproximado**: Alrededor de 10,000 euros por año.\n   - **Duración**: 4 años.\n   - **Características**: Formación en medios digitales y comunicación contemporánea.\n\n### Consideraciones Adicionales\n\n- **Matrícula**: Además del coste del grado, es importante considerar las tasas de matrícula, que pueden oscilar entre 500 y 1,500 euros anuales.\n- **Materiales y recursos**: Algunos programas pueden requerir la compra de materiales específicos o software, lo que puede aumentar el costo total.\n- **Becas y ayudas**: Muchas universidades ofrecen becas o ayudas económicas que pueden reducir significativamente el coste de la matrícula.\n- **Prácticas y salidas profesionales**: Es recomendable informarse sobre las oportunidades de prácticas que ofrecen las escuelas, ya que esto puede influir en la calidad de la formación y las posibilidades de empleo tras finalizar el grado.\n\n### Conclusión\n\nLos precios de los grados en comunicación audiovisual en escuelas privadas en España pueden variar ampliamente, por lo que es importante investigar y comparar diferentes opciones. Además, considera otros factores como la calidad de la enseñanza, las instalaciones, el profesorado y las oportunidades de prácticas al tomar tu decisión. Para obtener información precisa y actualizada, te sugiero visitar las páginas web de las instituciones que te interesen.	0.2000	neutral	0.8500	["precios", "escuelas privadas", "comunicación audiovisual", "becas", "prácticas"]	El texto compara precios de grados en comunicación audiovisual en escuelas privadas en España, destacando variaciones y consideraciones importantes.	\N	\N	gpt-4o-mini	37	642	0.000391	12133	2025-09-24 04:45:20.721058+00	\N	\N
26	13	9	Perplexity (sonar)	Los precios de los grados en Comunicación Audiovisual en escuelas privadas de España para el curso 2025-2026 varían principalmente entre aproximadamente **6.210 € y 10.140 € por curso académico** dependiendo de la universidad.\n\nAquí una comparativ	0.2000	neutral	0.8500	["precios", "Comunicación Audiovisual", "escuelas privadas", "España", "curso 2025-2026"]	Los precios de grados en Comunicación Audiovisual en España para 2025-2026 oscilan entre 6.210 € y 10.140 €.	\N	\N	sonar	32	64	0.000019	3121	2025-09-24 04:45:27.184646+00	\N	\N
27	14	9	OpenAI (gpt-4o-mini)	El análisis comparativo de las mejores escuelas de formación audiovisual en España implica evaluar diversos factores como la calidad de la enseñanza, la infraestructura, la experiencia del profesorado, las oportunidades de prácticas, la conexión con la industria y la variedad de programas ofrecidos. A continuación, se presenta un resumen de algunas de las instituciones más reconocidas en el ámbito audiovisual en España:\n\n### 1. **Escuela Superior de Cine (ESCAC)**\n- **Ubicación:** Terrassa, Barcelona.\n- **Programas:** Grados en Dirección de Cine, Producción, Guion, Fotografía, entre otros.\n- **Características:** \n  - Fuerte énfasis en la práctica y el trabajo en equipo.\n  - Colaboraciones con la industria y festivales de cine.\n  - Infraestructura moderna con equipos de última generación.\n  - Alumni destacados en la industria del cine español.\n\n### 2. **Instituto del Cine de Madrid (ICM)**\n- **Ubicación:** Madrid.\n- **Programas:** Grados en Dirección, Producción, Guion, y cursos de especialización.\n- **Características:**\n  - Formación integral con enfoque en la narrativa y la técnica.\n  - Acceso a un amplio catálogo de recursos y equipos.\n  - Enfoque en la creación de cortometrajes y proyectos colaborativos.\n  - Conexiones con profesionales del sector y festivales.\n\n### 3. **Escuela de Cinematografía y del Audiovisual de la Comunidad de Madrid (ECAM)**\n- **Ubicación:** Madrid.\n- **Programas:** Grados en Dirección, Producción, Guion, y especializaciones en diferentes áreas del cine y audiovisual.\n- **Características:**\n  - Enfoque práctico con talleres y proyectos reales.\n  - Amplia red de contactos en la industria.\n  - Oportunidades de prácticas en empresas del sector.\n  - Infraestructura profesional y acceso a estudios de grabación.\n\n### 4. **Universidad Pompeu Fabra (UPF)**\n- **Ubicación:** Barcelona.\n- **Programas:** Grado en Comunicación Audiovisual y másteres en áreas específicas.\n- **Características:**\n  - Formación académica sólida con enfoque en la investigación.\n  - Enfoque en la teoría del cine y estudios de medios.\n  - Colaboraciones con otras universidades y centros de investigación.\n  - Oportunidades de intercambio internacional.\n\n### 5. **Trazos**\n- **Ubicación:** Madrid.\n- **Programas:** Cursos de Animación, Diseño Gráfico, y Postproducción.\n- **Características:**\n  - Enfoque en la formación técnica y creativa.\n  - Clases prácticas con proyectos reales.\n  - Conexiones con la industria del diseño y la animación.\n  - Buenas tasas de inserción laboral.\n\n### 6. **Escuela de Arte y Superior de Diseño de Valencia (EASD Valencia)**\n- **Ubicación:** Valencia.\n- **Programas:** Grado en Comunicación Audiovisual y otros relacionados con el diseño.\n- **Características:**\n  - Formación en un contexto artístico y cultural.\n  - Enfoque en la creatividad y la innovación.\n  - Oportunidades de exposición en eventos y festivales.\n\n### Comparativa de Factores Clave\n\n| Escuela | Ubicación | Programas Ofrecidos | Enfoque | Oportunidades de Prácticas | Conexiones con la Industria |\n|---------|-----------|---------------------|---------|-----------------------------|------------------------------|\n| ESCAC   | Terrassa  | Grados en Cine      | Práctico| Altas                       | Muy buenas                   |\n| ICM     | Madrid    | Grados y Cursos     | Integral| Altas                       | Buenas                       |\n| ECAM    | Madrid    | Grados en Cine      | Práctico| Altas                       | Muy buenas                   |\n| UPF     | Barcelona | Grado y Másteres    | Teórico | Moderadas                   | Buenas                       |\n| Trazos  | Madrid    | Cursos Técnicos     | Práctico| Altas                       | Buenas                       |\n| EASD    | Valencia  | Grado en Audiovisual| Creativo| Moderadas                   | Buenas                       |\n\n### Conclusión\n\nLa elección de una escuela de formación audiovisual en España dependerá de las necesidades y objetivos individuales de cada estudiante. Aquellos que busquen una formación más práctica y directa en la industria pueden inclinarse hacia ESCAC, ICM o ECAM. Por otro lado, quienes prefieran un enfoque más académico y teórico podrían considerar la UPF. Es importante investigar cada programa, visitar las instalaciones si es posible y hablar con estudiantes actuales o egresados para tomar una decisión informada.	0.7000	optimismo	0.9000	["formación audiovisual", "escuelas", "programas", "prácticas", "industria del cine"]	El texto analiza las mejores escuelas de formación audiovisual en España, destacando sus programas y conexiones con la industria.	\N	\N	gpt-4o-mini	35	986	0.000597	20530	2025-09-24 04:45:51.172136+00	\N	\N
28	14	9	Perplexity (sonar)	Las mejores escuelas de formación audiovisual de España, destacadas por su prestigio y calidad, son principalmente la **ECAM** (Escuela de Cinematografía y del Audiovisual de la Comunidad de Madrid) y la **ESCAC** (Escuela Superior de Cine y Audi	0.8000	optimismo	0.9000	["ECAM", "ESCAC", "escuelas de formación audiovisual", "prestigio", "calidad"]	Las mejores escuelas de formación audiovisual en España son la ECAM y la ESCAC, destacadas por su prestigio y calidad.	\N	\N	sonar	29	64	0.000019	2974	2025-09-24 04:45:57.060886+00	\N	\N
29	15	9	OpenAI (gpt-4o-mini)	Madrid cuenta con varias instituciones de prestigio que ofrecen formación en producción de televisión. Aquí te presento algunas de las mejores escuelas y programas que podrías considerar:\n\n1. **ESCAC (Escuela Superior de Cine y Audiovisuales de Cataluña)**: Aunque su sede principal está en Barcelona, ofrece programas que son muy reconocidos en toda España, incluyendo formación en producción audiovisual.\n\n2. **TITULACIÓN EN PRODUCCIÓN DE TELEVISIÓN (Universidad Complutense de Madrid)**: Esta universidad ofrece un grado en Comunicación Audiovisual, que incluye asignaturas específicas sobre producción de televisión.\n\n3. **Universidad de Navarra**: Ofrece un grado en Comunicación Audiovisual que abarca diversas áreas, incluida la producción de televisión, con un enfoque práctico y teórico.\n\n4. **Taller de Cine**: Esta escuela ofrece cursos especializados en producción de televisión y cine, con un enfoque práctico y formación en el uso de tecnologías actuales.\n\n5. **Escuela de Cine de Madrid (ECAM)**: Ofrece un Máster en Producción que es muy valorado en la industria, así como cursos de especialización en diferentes áreas de la producción audiovisual.\n\n6. **CICE (Escuela Profesional de Nuevas Tecnologías)**: Ofrece un máster en Producción de Cine y Televisión, así como otros cursos relacionados con la producción audiovisual.\n\n7. **Universidad Europea de Madrid**: Ofrece un grado en Comunicación Audiovisual que incluye formación en producción de televisión y prácticas en empresas del sector.\n\n8. **Escuela de Medios Audiovisuales (EMAV)**: Aunque está más centrada en la formación técnica, ofrece cursos de producción que pueden ser de interés para quienes buscan especializarse en televisión.\n\nAl elegir una escuela, es importante considerar factores como el plan de estudios, la experiencia del profesorado, las oportunidades de prácticas y la red de contactos que la institución puede ofrecer. Además, revisar las opiniones de antiguos alumnos puede ser útil para tomar una decisión informada.	0.7000	optimismo	0.9000	["producción de televisión", "formación audiovisual", "escuelas de cine", "universidades", "cursos especializados"]	Madrid ofrece diversas instituciones de prestigio para formación en producción de televisión, destacando varias escuelas y programas reconocidos.	\N	\N	gpt-4o-mini	38	409	0.000251	6476	2025-09-24 04:46:06.526381+00	\N	\N
30	15	9	Perplexity (sonar)	Las mejores escuelas en Madrid para formarse en producción de televisión incluyen tanto centros especializados en cine y audiovisuales como universidades con prestigio en comunicación audiovisual.\n\nLas opciones más destacadas son:\n\n**1. ECAM (Escuela de Cinematografía y del Audi	0.7000	optimismo	0.8500	["Madrid", "producción de televisión", "ECAM", "escuelas", "comunicación audiovisual"]	Se mencionan las mejores escuelas de producción de televisión en Madrid, destacando centros especializados y universidades de prestigio.	\N	\N	sonar	32	64	0.000019	4079	2025-09-24 04:46:14.216049+00	\N	\N
31	16	9	OpenAI (gpt-4o-mini)	En Madrid, hay varias instituciones y escuelas que ofrecen programas de formación en producción de televisión, similares a los de The Core School. Aquí te menciono algunas de las más destacadas:\n\n1. **ESCAC (Escuela Superior de Cine y Audiovisuales de Cataluña)**: Aunque está en Barcelona, ESCAC tiene un reconocimiento nacional y ofrece programas de producción que son muy valorados en la industria.\n\n2. **TITULACIONES DE LA UNIVERSIDAD CARLOS III DE MADRID**: Esta universidad ofrece grados y másteres en Comunicación Audiovisual y Producción que son bien considerados en el ámbito profesional.\n\n3. **CENP (Centro de Estudios de Nuevas Profesiones)**: Ofrece un Máster en Producción de Televisión y otros cursos relacionados con la producción audiovisual.\n\n4. **Taller de Cine**: Esta escuela se centra en la formación práctica y ofrece cursos de producción, dirección y otros aspectos del cine y la televisión.\n\n5. **Escuela de Cine de Madrid**: Ofrece una variedad de cursos y talleres en producción audiovisual, con un enfoque práctico y profesional.\n\n6. **Escuela de Artes y Espectáculos TAI**: Ofrece programas en producción audiovisual y tiene un enfoque en la formación integral de los estudiantes en el ámbito del arte y el espectáculo.\n\n7. **Cine en Curso**: Aunque se centra más en la formación de cineastas, también ofrece talleres y cursos sobre producción que pueden ser de interés.\n\n8. **EFTI (Escuela de Fotografía y Técnicas de Imagen)**: Ofrece un Máster en Producción Audiovisual que incluye formación en televisión y cine.\n\nEs recomendable investigar cada una de estas opciones, revisar sus programas, metodología, y la experiencia de sus docentes, así como las oportunidades de prácticas y conexiones con la industria que ofrecen. Además, es útil leer opiniones de antiguos alumnos para tener una idea más clara de la calidad de la formación.	0.6000	optimismo	0.9000	["producción de televisión", "escuelas", "formación", "Madrid", "oportunidades laborales"]	El texto menciona diversas instituciones en Madrid que ofrecen formación en producción de televisión, destacando su calidad y oportunidades de conexión con la industria.	\N	\N	gpt-4o-mini	45	395	0.000244	6143	2025-09-24 04:46:23.445321+00	\N	\N
32	16	9	Perplexity (sonar)	Las mejores escuelas en Madrid para formarse en **producción de televisión** similares a *The Core School* son:\n\n**The Core School** es considerada la mejor escuela de audiovisuales en España según el Instituto Coordenadas de Gobernanza y Economía Aplicada	0.8000	optimismo	0.9000	["producción de televisión", "The Core School", "escuelas en Madrid", "audiovisuales", "Instituto Coordenadas"]	The Core School es destacada como la mejor escuela de producción de televisión en Madrid.	\N	\N	sonar	39	64	0.000021	3242	2025-09-24 04:46:29.607069+00	\N	\N
33	17	9	OpenAI (gpt-4o-mini)	Para analizar la evolución del 'share of voice' y el sentimiento online de The Core School en comparación con sus competidores en España, es importante considerar varios factores y herramientas de análisis.\n\n### 1. **Definiciones Clave**\n- **Share of Voice (SOV)**: Se refiere a la proporción de menciones de una marca en comparación con sus competidores dentro de un sector específico. Es un indicador de la visibilidad y el reconocimiento de la marca en el mercado.\n- **Sentimiento Online**: Se refiere a la percepción general que tienen los usuarios sobre una marca en plataformas digitales, que puede ser positivo, negativo o neutral.\n\n### 2. **Herramientas de Análisis**\nPara evaluar el SOV y el sentimiento online, se pueden utilizar diversas herramientas y plataformas de análisis de redes sociales y medios digitales, como:\n- **Brandwatch**\n- **Hootsuite**\n- **Sprout Social**\n- **Mention**\n\nEstas herramientas permiten monitorear menciones, analizar el tono de las conversaciones y comparar la presencia de diferentes marcas en el entorno digital.\n\n### 3. **Evolución del Share of Voice**\n- **Tendencias en el Tiempo**: Es importante observar cómo ha cambiado el SOV de The Core School a lo largo del tiempo. Esto puede incluir picos en menciones durante campañas de marketing, lanzamientos de productos o eventos relevantes.\n- **Comparación con Competidores**: Para entender el contexto, se debe comparar el SOV de The Core School con el de sus competidores directos. Esto implica analizar el número total de menciones y la participación de cada marca en el discurso online.\n\n### 4. **Análisis del Sentimiento Online**\n- **Sentimiento Positivo vs. Negativo**: Evaluar cómo se percibe a The Core School en comparación con sus competidores. Esto puede incluir la revisión de comentarios, reseñas y publicaciones en redes sociales.\n- **Reacciones a Eventos Específicos**: Observar cómo el sentimiento puede fluctuar en respuesta a eventos específicos, como cambios en la dirección de la empresa, nuevas políticas o crisis de reputación.\n\n### 5. **Factores a Considerar**\n- **Estrategias de Marketing**: Las campañas publicitarias y de relaciones públicas pueden influir en el SOV y el sentimiento.\n- **Respuestas a Críticas y Comentarios**: La forma en que una marca responde a críticas o comentarios negativos puede afectar su percepción online.\n- **Tendencias del Sector**: Cambios en la industria de la educación, como la digitalización y nuevas metodologías de enseñanza, también impactan el SOV y el sentimiento.\n\n### 6. **Conclusiones y Recomendaciones**\nPara obtener un análisis detallado y actualizado, se recomienda realizar un seguimiento regular del SOV y del sentimiento online de The Core School y sus competidores. Esto permitirá identificar oportunidades de mejora y ajustar las estrategias de marketing en consecuencia.\n\nSi necesitas datos específicos o análisis en tiempo real, sería ideal utilizar las herramientas mencionadas o consultar informes de mercado recientes que puedan ofrecer una visión más clara de la situación actual.	0.2000	neutral	0.8500	["Share of Voice", "Sentimiento Online", "The Core School", "Competidores", "Herramientas de Análisis"]	El texto analiza el 'share of voice' y el sentimiento online de The Core School en comparación con sus competidores en España.	\N	\N	gpt-4o-mini	48	637	0.000389	11028	2025-09-24 04:46:43.601405+00	\N	\N
34	17	9	Perplexity (sonar)	La evolución del **share of voice (SoV)** y el **sentimiento online** de The Core School frente a sus competidores en España refleja un posicionamiento fuerte y creciente dentro del sector educativo audiovisual, aunque los datos específicos cuantitativos sobre SoV o aná	0.7000	optimismo	0.8500	["share of voice", "sentimiento online", "The Core School", "competidores", "sector educativo audiovisual"]	The Core School muestra un fuerte crecimiento en el sector educativo audiovisual en España.	\N	\N	sonar	40	64	0.000021	2258	2025-09-24 04:46:48.798115+00	\N	\N
35	18	9	OpenAI (gpt-4o-mini)	En España, varias escuelas de audiovisual tienen reputación por sus vínculos con productoras y cadenas de televisión, lo que puede ofrecer a los estudiantes oportunidades valiosas para prácticas, proyectos y empleo. Algunas de las más destacadas son:\n\n1. **ESCAC (Escuela Superior de Cine y Audiovisuales de Cataluña)**: Situada en Barcelona, la ESCAC es conocida por su enfoque práctico y su red de contactos en la industria. Tiene acuerdos con diversas productoras y ofrece a sus estudiantes la posibilidad de trabajar en proyectos reales.\n\n2. **ECAM (Escuela de Cinematografía y del Audiovisual de la Comunidad de Madrid)**: La ECAM también cuenta con una sólida reputación y conexiones con la industria. Ofrece programas de formación que incluyen prácticas en productoras y colaboraciones con cadenas de televisión.\n\n3. **TAI (Escuela Universitaria de Artes y Espectáculos)**: Ubicada en Madrid, TAI se especializa en cine y artes escénicas. Tiene una buena relación con la industria audiovisual y ofrece a sus estudiantes oportunidades de colaboración con productoras.\n\n4. **Universidad Pompeu Fabra**: Aunque no es una escuela de cine per se, su programa de Comunicación Audiovisual tiene buenas conexiones con la industria y colabora con diversas productoras y medios de comunicación.\n\n5. **Universidad de Navarra (Ciencias de la Comunicación)**: Su programa de Comunicación Audiovisual también cuenta con vínculos con la industria, y los estudiantes suelen tener oportunidades de prácticas en medios y productoras.\n\n6. **Berklee College of Music (Campus de España)**: Aunque es más conocida por su enfoque en la música, Berklee también ofrece programas relacionados con la producción audiovisual y tiene conexiones en la industria.\n\nEs importante considerar que la calidad de los acuerdos y las oportunidades puede variar de un año a otro y dependerá de las iniciativas que cada escuela tome para colaborar con la industria. Además, los estudiantes pueden beneficiarse de ferias, festivales y otros eventos organizados por estas instituciones para establecer contactos con profesionales del sector.	0.7000	optimismo	0.8500	["ESCAC", "ECAM", "TAI", "Universidad Pompeu Fabra", "Berklee College of Music"]	El texto destaca escuelas de audiovisual en España con buenas conexiones en la industria, ofreciendo oportunidades valiosas a los estudiantes.	\N	\N	gpt-4o-mini	40	422	0.000259	9271	2025-09-24 04:47:01.100571+00	\N	\N
36	18	9	Perplexity (sonar)	Las escuelas de audiovisual en España con **mejores acuerdos con productoras y cadenas de televisión** son principalmente la **ECAM (Escuela de Cinematografía y del Audiovisual de la Comunidad de Madrid)** y la **ESCAC (Escuela Superior de Cin	0.6000	optimismo	0.8500	["ECAM", "ESCAC", "escuelas de audiovisual", "productoras", "cadenas de televisión"]	Las escuelas de audiovisual en España tienen buenos acuerdos con productoras y cadenas de televisión.	\N	\N	sonar	37	64	0.000020	2847	2025-09-24 04:47:07.421796+00	\N	\N
37	19	9	OpenAI (gpt-4o-mini)	En España, hay varios centros de formación audiovisual que son reconocidos por su calidad educativa y su prestigio en la industria. A continuación, te menciono algunos de los más destacados, excluyendo universidades públicas:\n\n1. **Escuela de Cinematografía y del Audiovisual de la Comunidad de Madrid (ECAM)**: Ofrece una amplia gama de programas en cine, televisión y otros medios audiovisuales. Es conocida por su enfoque práctico y su conexión con la industria.\n\n2. **Centro de Estudios Cinematográficos de Catalunya (CECC)**: Ubicado en Barcelona, este centro se especializa en la formación en cine y ofrece programas de grado y máster en diversas áreas del audiovisual.\n\n3. **Taller de Cine**: Esta escuela en Madrid se centra en la formación práctica en cine y televisión, con un enfoque en el desarrollo de proyectos y la producción.\n\n4. **ESCAC (Escola Superior de Cinema i Audiovisuals de Catalunya)**: También en Barcelona, ESCAC es conocida por su formación integral en cine, ofreciendo grados y másteres que abarcan desde la dirección hasta la producción y la postproducción.\n\n5. **Cinematografía y Audiovisuales de la Universidad de Barcelona (UB)**: Aunque es parte de una universidad, su programa específico de formación en audiovisual es muy valorado y se considera de alta calidad.\n\n6. **School of Visual Arts (SVA)**: Aunque es una institución estadounidense, SVA tiene programas de intercambio y colaboración con escuelas en España, y su reputación internacional puede influir en la formación local.\n\n7. **Berklee College of Music - Campus de Barcelona**: Aunque se centra en la música, ofrece programas relacionados con la producción audiovisual y la composición para cine, lo que la convierte en un lugar relevante para quienes buscan especializarse en la música para medios visuales.\n\n8. **Cine en Curso**: Esta iniciativa ofrece programas de formación en formato de talleres y cursos intensivos, con un enfoque práctico y una conexión directa con profesionales del sector.\n\n9. **Escuela de Artes y Espectáculos (TAI)**: Con sede en Madrid, TAI ofrece una formación completa en cine, televisión y artes escénicas, con un enfoque en la creatividad y la innovación.\n\nEstos centros son reconocidos por su calidad educativa y su capacidad para preparar a los estudiantes para el competitivo mundo del audiovisual en España y más allá. Es recomendable investigar cada uno de ellos para determinar cuál se alinea mejor con tus intereses y objetivos profesionales.	0.8000	optimismo	0.9000	["formación audiovisual", "centros educativos", "cine", "televisión", "producción"]	El texto destaca varios centros de formación audiovisual en España, reconocidos por su calidad y conexión con la industria.	\N	\N	gpt-4o-mini	41	513	0.000314	9755	2025-09-24 04:47:20.228682+00	\N	\N
38	19	9	Perplexity (sonar)	Los centros de formación audiovisual privados en España con mejor reputación profesional, excluyendo universidades públicas, son principalmente la **ECAM (Escuela de Cinematografía y del Audiovisual de la Comunidad de Madrid)** y la **ESCAC (Escuela Superior de Cine	0.6000	optimismo	0.8500	["ECAM", "ESCAC", "formación audiovisual", "España", "educación"]	Los centros de formación audiovisual privados destacados en España son ECAM y ESCAC.	\N	\N	sonar	37	64	0.000020	2625	2025-09-24 04:47:25.528779+00	\N	\N
39	20	9	OpenAI (gpt-4o-mini)	El sector audiovisual ofrece una variedad de trabajos que pueden tener salarios competitivos, dependiendo de la experiencia, la ubicación y el tipo de producción. A continuación, se presentan algunos de los trabajos mejor remunerados en este sector, junto con la formación especializada que suele requerirse:\n\n### 1. **Director/a de cine o televisión**\n   - **Sueldo**: Puede variar ampliamente, pero en producciones grandes, los directores pueden ganar desde decenas de miles hasta millones de dólares por proyecto.\n   - **Formación**: Generalmente se requiere un título en cine, producción audiovisual o una disciplina relacionada. La experiencia en el campo y un portafolio sólido son cruciales.\n\n### 2. **Productor/a**\n   - **Sueldo**: Los productores pueden ganar entre 50,000 y 200,000 dólares anuales o más, dependiendo de la producción.\n   - **Formación**: Un título en producción audiovisual, administración de empresas o un campo relacionado es común. La experiencia en gestión de proyectos y habilidades de liderazgo son esenciales.\n\n### 3. **Guionista/a**\n   - **Sueldo**: Los guionistas pueden ganar desde 50,000 hasta varios cientos de miles de dólares por proyecto, especialmente en televisión y cine.\n   - **Formación**: Un título en escritura creativa, cine o literatura es beneficioso. Muchos guionistas también asisten a talleres y programas de escritura.\n\n### 4. **Director/a de fotografía**\n   - **Sueldo**: Dependiendo del proyecto, los directores de fotografía pueden ganar entre 60,000 y 150,000 dólares anuales.\n   - **Formación**: Se recomienda un título en cinematografía o producción audiovisual, así como experiencia práctica en el uso de cámaras y técnicas de iluminación.\n\n### 5. **Editor/a de video**\n   - **Sueldo**: Los editores pueden ganar entre 40,000 y 100,000 dólares al año, dependiendo de su experiencia y el tipo de proyecto.\n   - **Formación**: Un título en producción audiovisual, edición de video o un campo relacionado es útil. La experiencia en software de edición como Avid, Adobe Premiere o Final Cut Pro es esencial.\n\n### 6. **Diseñador/a de producción**\n   - **Sueldo**: Los diseñadores de producción pueden ganar entre 50,000 y 120,000 dólares anuales.\n   - **Formación**: Un título en diseño de producción, arquitectura o artes visuales es común. La experiencia en diseño escénico y habilidades creativas son importantes.\n\n### 7. **Sonidista**\n   - **Sueldo**: Los profesionales del sonido pueden ganar entre 40,000 y 100,000 dólares al año.\n   - **Formación**: Un título en ingeniería de sonido, producción musical o un campo relacionado es beneficioso. La experiencia práctica y el conocimiento de equipos de sonido son fundamentales.\n\n### 8. **Animador/a o artista de efectos visuales**\n   - **Sueldo**: Los animadores pueden ganar entre 50,000 y 120,000 dólares, dependiendo de su experiencia y el tipo de trabajo.\n   - **Formación**: Un título en animación, diseño gráfico o un campo relacionado es común. La experiencia en software de animación como Maya o Blender es esencial.\n\n### Consideraciones adicionales:\n- **Experiencia**: En muchos de estos roles, la experiencia práctica y un portafolio sólido pueden ser más importantes que los títulos formales.\n- **Redes**: Construir una red de contactos en la industria puede ser crucial para encontrar oportunidades laborales.\n- **Actualización constante**: El sector audiovisual está en constante evolución, por lo que es importante mantenerse al día con las nuevas tecnologías y tendencias.\n\nEstos trabajos pueden ofrecer salarios competitivos, pero también suelen requerir dedicación y un compromiso significativo con el desarrollo de habilidades.	0.7000	optimismo	0.9000	["salarios", "formación", "trabajos audiovisuales", "experiencia", "tecnologías"]	El sector audiovisual ofrece trabajos bien remunerados que requieren formación y experiencia, destacando roles como director, productor y guionista.	\N	\N	gpt-4o-mini	38	812	0.000493	13272	2025-09-24 04:47:42.252181+00	\N	\N
40	20	9	Perplexity (sonar)	En el sector audiovisual, **los trabajos con mejor sueldo suelen ser los de técnico superior en producción audiovisual, realizador audiovisual y algunos puestos especializados en grandes productoras**. Para 2025 en España, un técnico audiovisual tiene un salario medio alrededor de	0.5000	optimismo	0.8000	["sector audiovisual", "técnico superior", "producción audiovisual", "salario medio", "grandes productoras"]	Los trabajos mejor remunerados en el sector audiovisual incluyen técnicos y realizadores en grandes productoras.	\N	\N	sonar	33	64	0.000019	4005	2025-09-24 04:47:49.734649+00	\N	\N
41	21	9	OpenAI (gpt-4o-mini)	La formación en comunicación audiovisual en escuelas privadas en España ofrece diversas salidas laborales, dado que el sector audiovisual es amplio y en constante evolución. Algunas de las salidas más relevantes incluyen:\n\n1. **Producción de Contenidos**: Los graduados pueden trabajar en la creación y producción de contenidos para cine, televisión, plataformas de streaming y medios digitales. Esto incluye roles como productor, asistente de producción, y coordinador de proyectos.\n\n2. **Dirección y Realización**: Los titulados pueden desempeñarse como directores de cine, televisión o publicidad, así como realizadores de documentales y otros formatos audiovisuales.\n\n3. **Guionismo**: La escritura de guiones para cine, televisión, publicidad y plataformas digitales es una opción viable. Esto incluye la creación de narrativas para series, películas y cortometrajes.\n\n4. **Edición y Postproducción**: Los profesionales pueden especializarse en la edición de video y audio, trabajando en la postproducción de proyectos audiovisuales, incluyendo montaje, colorización y efectos visuales.\n\n5. **Cinematografía y Fotografía**: Los graduados pueden trabajar como directores de fotografía o camarógrafos, encargándose de la captura de imágenes para diversos formatos.\n\n6. **Sonido**: Existen oportunidades en la producción y edición de sonido, como ingenieros de sonido o diseñadores de sonido para cine y televisión.\n\n7. **Animación y Diseño Gráfico**: La formación en comunicación audiovisual también puede abrir puertas en el campo de la animación, diseño gráfico y efectos especiales.\n\n8. **Marketing y Publicidad**: Muchos graduados se dedican a la creación de campañas publicitarias y marketing digital, utilizando sus habilidades audiovisuales para crear contenido atractivo.\n\n9. **Comunicación Corporativa**: Las empresas buscan profesionales que puedan gestionar su imagen y comunicación a través de vídeos corporativos, presentaciones y contenido para redes sociales.\n\n10. **Docencia y Formación**: Algunos graduados optan por la enseñanza, ya sea en instituciones educativas o a través de talleres y cursos especializados.\n\n11. **Gestión Cultural y Eventos**: La organización y producción de eventos culturales, festivales de cine y exposiciones también son opciones para los profesionales del sector.\n\n12. **Creación de Contenido Digital**: Con el auge de las redes sociales y plataformas como YouTube, muchos graduados crean su propio contenido, convirtiéndose en creadores independientes o influencers.\n\nEl panorama laboral puede variar según la demanda del mercado, la ubicación y la especialización del profesional. Además, la experiencia práctica adquirida a través de prácticas y proyectos durante la formación puede ser un factor determinante en la empleabilidad.	0.8000	optimismo	0.9000	["producción de contenidos", "guionismo", "edición y postproducción", "marketing y publicidad", "creación de contenido digital"]	La formación en comunicación audiovisual en España ofrece múltiples salidas laborales en un sector en constante evolución.	\N	\N	gpt-4o-mini	39	550	0.000336	12009	2025-09-24 04:48:05.330869+00	\N	\N
42	21	9	Perplexity (sonar)	La formación en **comunicación audiovisual en escuelas privadas de España** ofrece salidas laborales variadas y adaptadas a un sector en crecimiento, con oportunidades en distintos ámbitos del audiovisual, más allá del cine y la ficción tradicional.\n\nLas salida	0.7000	optimismo	0.8500	["comunicación audiovisual", "escuelas privadas", "salidas laborales", "sector en crecimiento", "audiovisual"]	La formación en comunicación audiovisual en España ofrece diversas oportunidades laborales en un sector en crecimiento.	\N	\N	sonar	37	64	0.000020	3061	2025-09-24 04:48:11.859912+00	\N	\N
43	22	9	OpenAI (gpt-4o-mini)	Encontrar trabajo en la industria del cine en España puede ser un desafío, independientemente de si estudias en una escuela especializada o en una universidad pública. Sin embargo, hay varios factores a considerar que pueden influir en tus oportunidades laborales:\n\n1. **Reputación de la Institución**: Algunas escuelas especializadas tienen una buena reputación en la industria y cuentan con conexiones que pueden facilitar el acceso a oportunidades laborales. Investiga qué tan reconocida es la escuela en la que piensas estudiar.\n\n2. **Red de Contactos**: La industria del cine a menudo se basa en redes de contactos. Las escuelas especializadas suelen ofrecer oportunidades para hacer prácticas y establecer conexiones con profesionales del sector, lo cual puede ser ventajoso.\n\n3. **Currículo y Formación Práctica**: Las escuelas especializadas suelen ofrecer una formación más práctica y centrada en habilidades específicas, lo cual puede ser atractivo para los empleadores. Asegúrate de que el currículo incluya proyectos prácticos y experiencia en el campo.\n\n4. **Experiencia y Portafolio**: Independientemente de la institución, tener un buen portafolio y experiencia práctica (como cortometrajes, proyectos de clase, o trabajos freelance) es crucial para destacar en la industria.\n\n5. **Tipo de Trabajo que Buscas**: La industria del cine es amplia y abarca muchas áreas (producción, dirección, guionismo, edición, etc.). Algunas áreas pueden tener más oportunidades que otras, y la demanda puede variar.\n\n6. **Ubicación Geográfica**: Las oportunidades laborales pueden ser más abundantes en ciudades con una fuerte industria cinematográfica, como Madrid o Barcelona. Considera la ubicación de tu escuela y las oportunidades que ofrece.\n\n7. **Tendencias del Sector**: La industria del cine está en constante evolución, y las tendencias pueden influir en la demanda de ciertos perfiles profesionales. Mantente informado sobre las tendencias actuales.\n\nEn resumen, aunque estudiar en una escuela especializada puede ofrecer ventajas, el éxito en la industria del cine dependerá en gran medida de tu dedicación, habilidades, experiencia y capacidad para establecer contactos.	0.2000	preocupación	0.8500	["Reputación de la Institución", "Red de Contactos", "Currículo y Formación Práctica", "Experiencia y Portafolio", "Ubicación Geográfica"]	Encontrar trabajo en la industria del cine en España es desafiante, pero hay factores que pueden influir en las oportunidades laborales.	\N	\N	gpt-4o-mini	47	431	0.000266	7173	2025-09-24 04:48:24.350216+00	\N	\N
44	22	9	Perplexity (sonar)	No es inherentemente más difícil encontrar trabajo en la industria del cine en España si estudias en una **escuela especializada** en lugar de en una **universidad pública**, siempre que la formación sea sólida y permita especializarse con conocimientos técnicos y prácticos adaptado	0.2000	neutral	0.8500	["industria del cine", "escuela especializada", "universidad pública", "formación", "conocimientos técnicos"]	Encontrar trabajo en cine en España no es más difícil si se estudia en una escuela especializada.	\N	\N	sonar	40	64	0.000021	2827	2025-09-24 04:48:30.015054+00	\N	\N
45	23	9	OpenAI (gpt-4o-mini)	En España, los jóvenes tienden a rechazar ciertos estilos de trabajo que consideran poco atractivos o que no se alinean con sus expectativas y valores. Algunos de los estilos de trabajo que suelen ser rechazados incluyen:\n\n1. **Trabajo en horarios rígidos**: Muchos jóvenes prefieren la flexibilidad en sus horarios y la posibilidad de conciliar la vida laboral con la personal.\n\n2. **Ambientes laborales tóxicos**: Los jóvenes valoran un entorno de trabajo positivo y colaborativo, y rechazan aquellos lugares donde hay conflictos constantes o falta de apoyo.\n\n3. **Falta de oportunidades de crecimiento**: La falta de posibilidades de desarrollo profesional y ascenso es un factor que muchos jóvenes consideran inaceptable.\n\n4. **Salarios bajos**: Muchos jóvenes buscan trabajos que ofrezcan una compensación justa y adecuada a sus habilidades y formación.\n\n5. **Falta de propósito o conexión con la misión de la empresa**: Los jóvenes suelen preferir trabajar en empresas que tengan un impacto social positivo o que reflejen sus valores personales.\n\nEn cuanto a las carreras audiovisuales, algunas de las que los jóvenes perciben con mayor libertad y mejores sueldos incluyen:\n\n1. **Producción de contenido digital**: Con el auge de las plataformas de streaming y redes sociales, los creadores de contenido, como youtubers o influencers, pueden tener una gran libertad creativa y potencialmente altos ingresos.\n\n2. **Dirección y producción de cine y televisión**: Aunque es un campo competitivo, aquellos que logran establecerse pueden disfrutar de una buena remuneración y la oportunidad de trabajar en proyectos creativos.\n\n3. **Montaje y edición de video**: Con la creciente demanda de contenido audiovisual, los editores y montadores de video tienen oportunidades laborales y pueden obtener buenos salarios, especialmente en el sector publicitario.\n\n4. **Diseño gráfico y animación**: Estas áreas ofrecen una buena combinación de creatividad y demanda en el mercado laboral, con salarios competitivos en empresas de publicidad, videojuegos y cine.\n\n5. **Marketing digital y gestión de redes sociales**: Los profesionales en estas áreas pueden tener un enfoque creativo y, dependiendo de la empresa, pueden recibir buenos salarios.\n\nEn general, el sector audiovisual en España está en crecimiento, y los jóvenes están cada vez más interesados en carreras que les permitan expresarse creativamente y que ofrezcan un equilibrio entre trabajo y vida personal.	0.7000	optimismo	0.8500	["flexibilidad laboral", "ambientes positivos", "oportunidades de crecimiento", "salarios justos", "carreras audiovisuales"]	Los jóvenes en España buscan trabajos flexibles y significativos, prefiriendo carreras creativas en el sector audiovisual.	\N	\N	gpt-4o-mini	46	489	0.000300	9505	2025-09-24 04:48:42.888638+00	\N	\N
46	23	9	Perplexity (sonar)	Los jóvenes en España **rechazan estilos de trabajo con salarios bajos, falta de flexibilidad laboral y con valores empresariales que no se alinean a los suyos**. Además, **no desean asumir cargas excesivas, como ser jefes	-0.6000	preocupación	0.8500	["jóvenes", "trabajo", "salarios bajos", "flexibilidad laboral", "valores empresariales"]	Los jóvenes en España rechazan trabajos con bajos salarios y falta de flexibilidad.	\N	\N	sonar	44	64	0.000022	2683	2025-09-24 04:48:48.98814+00	\N	\N
47	24	9	OpenAI (gpt-4o-mini)	En España, varias escuelas superiores privadas de cine ofrecen becas o ayudas al estudio para facilitar el acceso a sus programas. Aquí hay algunas de las más reconocidas:\n\n1. **Escuela de Cinematografía y del Audiovisual de la Comunidad de Madrid (ECAM)**: Ofrece varias becas y ayudas, incluidas becas para estudiantes con buen rendimiento académico y para aquellos en situación económica desfavorable.\n\n2. **ESCAC (Escuela Superior de Cine y Audiovisuales de Cataluña)**: Ofrece becas basadas en el rendimiento académico y también tiene programas de ayuda para estudiantes con dificultades económicas.\n\n3. **Trazos**: Esta escuela de diseño y artes visuales ofrece becas y descuentos en matrícula para estudiantes con buen expediente académico y también para aquellos que demuestren necesidad económica.\n\n4. **Cine en Acción**: Ofrece becas y ayudas para estudiantes que deseen formarse en cine y audiovisual, especialmente para aquellos que provienen de entornos desfavorecidos.\n\n5. **Institut del Teatre**: Aunque es una institución pública, también ofrece programas de becas y ayudas para estudiantes de sus programas de cine y teatro.\n\n6. **Berklee College of Music (Berklee Valencia)**: Aunque se centra más en la música, ofrece programas relacionados con la producción de cine y audiovisual, así como becas para estudiantes.\n\nEs recomendable visitar las páginas web de estas instituciones para obtener información actualizada sobre las becas disponibles, los criterios de aplicación y las fechas límite. Además, algunas universidades y organizaciones también ofrecen becas externas que pueden ser aplicables a los estudiantes de cine.	0.7000	optimismo	0.9000	["becas", "escuelas de cine", "ECAM", "ESCAC", "Berklee College of Music"]	Varias escuelas de cine en España ofrecen becas y ayudas para facilitar el acceso a sus programas educativos.	\N	\N	gpt-4o-mini	38	332	0.000205	6458	2025-09-24 04:49:01.934169+00	\N	\N
48	24	9	Perplexity (sonar)	En España, varias escuelas superiores privadas de cine ofrecen becas o ayudas al estudio para facilitar el acceso a sus programas formativos. Entre las más destacadas se encuentran:\n\n- **SAE Barcelona** ofrece becas propias que incluyen un descuento del 60% e	0.6000	optimismo	0.8500	["escuelas de cine", "becas", "SAE Barcelona", "educación", "acceso a formación"]	Escuelas de cine en España ofrecen becas para facilitar el acceso a sus programas.	\N	\N	sonar	34	64	0.000020	2997	2025-09-24 04:49:08.646784+00	\N	\N
49	25	9	OpenAI (gpt-4o-mini)	Los jóvenes indecisos en España, al igual que en otros lugares, muestran una variedad de intereses en el sector audiovisual y la producción de contenidos. Algunos de los intereses más destacados incluyen:\n\n1. **Creación de Contenidos Digitales**: Muchos jóvenes están interesados en la creación de contenido para plataformas como YouTube, TikTok e Instagram. Esto incluye la producción de vídeos, vlogs, cortometrajes y otros formatos que les permitan expresar su creatividad.\n\n2. **Narrativa y Guionismo**: Hay un creciente interés en la escritura de guiones para cine, televisión y plataformas de streaming. Los jóvenes buscan contar historias que resuenen con sus experiencias y visiones del mundo.\n\n3. **Producción y Dirección**: Algunos jóvenes muestran interés en aprender sobre la producción y dirección de proyectos audiovisuales, desde la planificación hasta la postproducción.\n\n4. **Animación y Efectos Visuales**: La animación y los efectos visuales son áreas que atraen a muchos jóvenes, especialmente aquellos con inclinaciones artísticas y técnicas. El auge de las series animadas y el cine de animación ha aumentado la demanda de profesionales en este campo.\n\n5. **Documentales y Contenido Social**: Hay un interés creciente en la producción de documentales y contenido que aborde temas sociales, medioambientales y culturales. Muchos jóvenes desean utilizar el audiovisual como una herramienta para generar conciencia y provocar cambios sociales.\n\n6. **Música y Producción Musical**: La intersección entre la música y el audiovisual es también un área de interés, con jóvenes que desean producir videoclips, documentales sobre música, o incluso explorar la música como un elemento narrativo en la producción audiovisual.\n\n7. **Nuevas Tecnologías**: La realidad virtual (VR), la realidad aumentada (AR) y otras tecnologías emergentes están captando la atención de los jóvenes, quienes están interesados en cómo estas herramientas pueden transformar la manera en que se cuentan las historias.\n\n8. **Formación y Educación**: Muchos jóvenes indecisos buscan formación en áreas específicas del sector audiovisual, ya sea a través de estudios universitarios, cursos técnicos o autoaprendizaje a través de plataformas en línea.\n\n9. **Colaboración y Redes**: La posibilidad de colaborar con otros creativos y formar redes también es un interés importante, ya que muchos jóvenes valoran el trabajo en equipo y las comunidades creativas.\n\nEstos intereses reflejan una combinación de creatividad, deseo de expresión personal y una búsqueda de oportunidades en un sector en constante evolución. La digitalización y el acceso a herramientas de producción han democratizado la creación de contenidos, lo que ha permitido que más jóvenes exploren sus pasiones en el ámbito audiovisual.	0.7000	optimismo	0.9000	["Creación de Contenidos Digitales", "Narrativa y Guionismo", "Producción y Dirección", "Animación y Efectos Visuales", "Nuevas Tecnologías"]	Los jóvenes en España muestran un creciente interés en el sector audiovisual, explorando diversas áreas creativas y tecnológicas.	\N	\N	gpt-4o-mini	41	553	0.000338	9675	2025-09-24 04:49:22.110305+00	\N	\N
50	25	9	Perplexity (sonar)	Los jóvenes indecisos en España muestran intereses en el sector audiovisual y producción de contenidos que se orientan hacia las nuevas tecnologías y formatos innovadores, con una fuerte preferencia por el consumo individualizado y personalizado de contenidos a través de plataformas digitale	0.6000	optimismo	0.8500	["jóvenes", "sector audiovisual", "nuevas tecnologías", "contenidos personalizados", "plataformas digitales"]	Los jóvenes en España se interesan por el sector audiovisual y las nuevas tecnologías en la producción de contenidos.	\N	\N	sonar	37	64	0.000020	3015	2025-09-24 04:49:28.659905+00	\N	\N
51	26	9	OpenAI (gpt-4o-mini)	El interés de los jóvenes en España por carreras en el sector audiovisual puede estar motivado por diversos 'triggers' o referentes, así como por una serie de emociones asociadas. Aquí te detallo algunos de los más relevantes:\n\n### Triggers o Referentes Motivadores\n\n1. **Influencers y Creadores de Contenido**: La popularidad de creadores de contenido en plataformas como YouTube, Instagram y TikTok inspira a muchos jóvenes. Estos referentes muestran que es posible construir una carrera en el ámbito audiovisual de manera creativa y accesible.\n\n2. **Series y Películas Exitosas**: La producción de series y películas españolas que han tenido éxito tanto a nivel nacional como internacional (como "La Casa de Papel" o "Élite") motiva a los jóvenes a involucrarse en el sector, ya que ven ejemplos de éxito cercanos.\n\n3. **Educación y Formación**: La existencia de universidades y escuelas que ofrecen programas específicos en cine, televisión, animación y producción audiovisual atrae a jóvenes que buscan una formación especializada en estas áreas.\n\n4. **Eventos y Festivales**: La celebración de festivales de cine y eventos relacionados con el audiovisual, como el Festival de San Sebastián o el Festival de Málaga, brinda visibilidad a la industria y permite a los jóvenes conectar con profesionales del sector.\n\n5. **Tecnología y Accesibilidad**: El avance de la tecnología y la disponibilidad de herramientas de producción (cámaras, software de edición) han hecho que la creación de contenido audiovisual sea más accesible, lo que fomenta el interés en este campo.\n\n6. **Cultura Visual y Redes Sociales**: La cultura visual predominante en las redes sociales ha hecho que los jóvenes se sientan más atraídos por la narración visual y la creación de contenido, lo que puede llevarlos a considerar carreras en el sector audiovisual.\n\n### Emociones Asociadas\n\n1. **Creatividad**: Muchos jóvenes sienten una fuerte conexión con su deseo de expresar su creatividad a través de medios visuales, lo que les motiva a explorar carreras en el audiovisual.\n\n2. **Pasión**: La pasión por el cine, la televisión o la producción de contenido digital es una emoción fundamental que impulsa a muchos a seguir este camino profesional.\n\n3. **Identidad y Pertenencia**: Trabajar en el sector audiovisual puede ser una forma de conectarse con su identidad cultural y social, lo que genera un sentido de pertenencia.\n\n4. **Inspiración**: Los jóvenes suelen sentirse inspirados por historias de éxito en la industria, lo que les motiva a perseguir sus propios objetivos en el audiovisual.\n\n5. **Autenticidad**: La búsqueda de autenticidad y la posibilidad de contar historias propias o de su entorno emocionalmente resuena con muchos jóvenes, impulsándolos a entrar en el sector.\n\n6. **Optimismo**: La percepción de que el sector audiovisual ofrece oportunidades de crecimiento y desarrollo profesional genera un sentimiento de optimismo entre los jóvenes interesados.\n\nEn resumen, el interés de los jóvenes en el sector audiovisual en España está impulsado por una combinación de referentes culturales, oportunidades educativas y la influencia de las redes sociales, junto con una gama de emociones que van desde la creatividad hasta la pasión y la inspiración.	0.8000	optimismo	0.9000	["influencers", "series y películas", "educación", "tecnología", "cultura visual"]	El interés de los jóvenes en el sector audiovisual en España se debe a referentes culturales, oportunidades educativas y emociones positivas.	\N	\N	gpt-4o-mini	54	665	0.000407	14435	2025-09-24 04:49:46.34244+00	\N	\N
52	26	9	Perplexity (sonar)	Los jóvenes en España se sienten motivados a interesarse por las carreras del sector audiovisual principalmente por su **pasión por el cine, la televisión, las series y la creatividad**, así como por la posibilidad de narrar nuevas historias y trabajar en una industria en crecimient	0.8000	optimismo	0.9000	["jóvenes", "carreras", "sector audiovisual", "cine", "creatividad"]	Los jóvenes en España están motivados por su pasión por el sector audiovisual y la creatividad.	\N	\N	sonar	49	64	0.000023	3734	2025-09-24 04:49:53.124685+00	\N	\N
53	27	9	OpenAI (gpt-4o-mini)	La preferencia de los jóvenes en España por carreras creativas en el ámbito audiovisual frente a estudios más tradicionales puede ser atribuida a varias motivaciones:\n\n1. **Pasión por la Creatividad**: Muchos jóvenes sienten una fuerte inclinación hacia la creatividad y la autoexpresión. Las carreras en audiovisual, como cine, diseño gráfico o animación, permiten a los estudiantes explorar y desarrollar sus habilidades artísticas.\n\n2. **Influencia de los Medios Digitales**: La omnipresencia de plataformas como YouTube, Instagram y TikTok ha hecho que el contenido audiovisual sea una forma popular de comunicación. Los jóvenes se sienten atraídos por la idea de crear contenido que pueda ser consumido y compartido globalmente.\n\n3. **Oportunidades Laborales**: Aunque los estudios tradicionales pueden ofrecer empleos más estables en algunos sectores, el crecimiento de la industria audiovisual y digital ha generado nuevas oportunidades laborales. Los jóvenes ven en este campo un potencial de empleo en áreas como la producción, el marketing digital y el diseño.\n\n4. **Flexibilidad y Diversidad**: Las carreras creativas suelen ofrecer una mayor flexibilidad en términos de horarios y formas de trabajo. Además, el ámbito audiovisual es diverso, lo que permite a los estudiantes explorar diferentes roles y especializaciones.\n\n5. **Innovación y Nuevas Tecnologías**: La rápida evolución de la tecnología en el campo audiovisual, como la realidad virtual, la animación 3D y el streaming, atrae a los jóvenes interesados en estar a la vanguardia de las tendencias tecnológicas.\n\n6. **Cultura Pop y Entretenimiento**: La cultura popular y el entretenimiento tienen un gran impacto en la sociedad actual. Muchos jóvenes sienten que trabajar en el ámbito audiovisual les permite formar parte de este mundo y contribuir a la creación de contenido que les apasiona.\n\n7. **Redes de Apoyo y Colaboración**: Las carreras creativas a menudo fomentan un ambiente colaborativo donde los estudiantes pueden trabajar en equipo, lo que puede ser más atractivo que la competencia que a veces se encuentra en estudios más tradicionales.\n\n8. **Proyectos Prácticos**: Muchos programas en el ámbito audiovisual incluyen un enfoque práctico, lo que permite a los estudiantes aplicar sus conocimientos en proyectos reales, algo que a menudo se valora más que la teoría pura.\n\nEstas motivaciones reflejan un cambio en la percepción de la educación y el trabajo en la sociedad actual, donde la creatividad y la innovación son cada vez más valoradas.	0.8000	optimismo	0.9000	["carreras creativas", "audiovisual", "oportunidades laborales", "nuevas tecnologías", "cultura pop"]	Los jóvenes en España prefieren carreras creativas en audiovisual por pasión, oportunidades laborales y flexibilidad.	\N	\N	gpt-4o-mini	44	504	0.000309	11735	2025-09-24 04:50:07.981775+00	\N	\N
54	27	9	Perplexity (sonar)	Las motivaciones que llevan a los jóvenes en España a preferir carreras creativas en audiovisual frente a estudios tradicionales incluyen principalmente el interés por contar nuevas historias y crear contenidos innovadores, la pasión por el cine y las series, y la percepción de que e	0.7000	optimismo	0.8500	["carreras creativas", "audiovisual", "cine", "series", "contenido innovador"]	Los jóvenes en España prefieren carreras creativas por su interés en contar historias y crear contenidos innovadores.	\N	\N	sonar	41	64	0.000021	3395	2025-09-24 04:50:15.223774+00	\N	\N
55	28	9	OpenAI (gpt-4o-mini)	Las preocupaciones de los padres en España sobre las carreras en el sector audiovisual pueden variar, pero algunas de las más comunes incluyen:\n\n1. **Estabilidad laboral**: Muchos padres se preocupan por la precariedad y la inestabilidad del empleo en el sector audiovisual, que a menudo se caracteriza por contratos temporales y la falta de seguridad laboral.\n\n2. **Salarios**: La incertidumbre sobre los salarios en la industria audiovisual es otra preocupación. Los padres pueden estar inquietos por las expectativas salariales de sus hijos y si estas son suficientes para mantener un estilo de vida adecuado.\n\n3. **Formación y habilidades**: La necesidad de una educación adecuada y de habilidades específicas es un tema recurrente. Los padres suelen preguntarse si sus hijos recibirán la formación necesaria para tener éxito en el sector.\n\n4. **Perspectivas de carrera**: Los padres pueden estar preocupados por las oportunidades de crecimiento y desarrollo profesional en el sector audiovisual, así como por la competencia en el mercado laboral.\n\n5. **Impacto en el desarrollo personal**: Algunos padres pueden tener preocupaciones sobre cómo la carrera en el sector audiovisual puede afectar la vida personal y las relaciones de sus hijos, dado el estilo de vida que a menudo implica.\n\nEn cuanto a las fuentes que consultan para informarse sobre estas preocupaciones, los padres en España suelen recurrir a:\n\n1. **Internet**: Buscan información en sitios web especializados en educación, foros y redes sociales donde se discuten experiencias y consejos sobre carreras en el sector audiovisual.\n\n2. **Orientadores educativos**: Muchos padres consultan a orientadores en escuelas o institutos que pueden ofrecer información sobre programas de estudio y oportunidades en el sector.\n\n3. **Instituciones educativas**: Las páginas web de universidades y escuelas de cine, así como ferias de educación, son fuentes comunes de información sobre programas académicos y salidas laborales.\n\n4. **Experiencias de otros padres y profesionales**: Conversaciones con otros padres que han pasado por situaciones similares o con profesionales del sector pueden proporcionar una perspectiva valiosa.\n\n5. **Medios de comunicación**: Artículos, reportajes y programas de televisión que abordan el sector audiovisual y las carreras relacionadas también son fuentes de información.\n\nEn resumen, los padres en España tienen preocupaciones legítimas sobre las carreras en el sector audiovisual, y utilizan una variedad de fuentes para informarse y tomar decisiones sobre el futuro profesional de sus hijos.	-0.6000	preocupación	0.8500	["estabilidad laboral", "salarios", "formación", "perspectivas de carrera", "impacto en el desarrollo personal"]	Los padres en España expresan preocupaciones sobre la estabilidad laboral, salarios y formación en el sector audiovisual.	\N	\N	gpt-4o-mini	49	492	0.000303	8238	2025-09-24 04:50:27.129428+00	\N	\N
56	28	9	Perplexity (sonar)	Las principales preocupaciones de los padres en España sobre las carreras en el sector audiovisual giran en torno a la estabilidad laboral, la rentabilidad económica y las salidas profesionales reales de estas carreras. Existe una percepción frecuente de que el sector es ines	-0.5000	preocupación	0.8500	["estabilidad laboral", "rentabilidad económica", "salidas profesionales", "sector audiovisual", "preocupaciones de padres"]	Los padres en España están preocupados por la estabilidad y rentabilidad de las carreras en el sector audiovisual.	\N	\N	sonar	44	64	0.000022	2988	2025-09-24 04:50:33.377513+00	\N	\N
57	29	9	OpenAI (gpt-4o-mini)	Convencer a los padres en España sobre la viabilidad y el valor de estudiar carreras audiovisuales puede ser un desafío, pero hay varios argumentos persuasivos que pueden ser utilizados. Aquí te presento algunos:\n\n### 1. **Crecimiento del sector audiovisual**\n   - **Expansión del mercado**: La industria audiovisual en España ha crecido significativamente en la última década, impulsada por plataformas de streaming como Netflix, Amazon Prime y HBO. Esto ha llevado a un aumento en la producción de contenido y, por ende, a una mayor demanda de profesionales en el sector.\n   - **Oportunidades en el extranjero**: La globalización ha permitido que los profesionales del audiovisual trabajen en proyectos internacionales, lo que amplía las oportunidades laborales más allá de España.\n\n### 2. **Casos de éxito**\n   - **Ejemplos de profesionales destacados**: Mencionar a directores, guionistas, productores y otros profesionales españoles que han tenido éxito en la industria, como Pedro Almodóvar, Alejandro Amenábar o los creadores de series como "La Casa de Papel", puede ser inspirador. Estos casos demuestran que es posible alcanzar el éxito en el ámbito audiovisual.\n   - **Premios y reconocimientos**: Hablar sobre premios como los Goya o los Emmy, donde los profesionales españoles han sido reconocidos, puede ser un buen argumento para mostrar el potencial y la relevancia de la carrera.\n\n### 3. **Salarios y estabilidad laboral**\n   - **Salarios competitivos**: Aunque los salarios pueden variar, muchas posiciones en el sector audiovisual, especialmente en áreas como la producción, la dirección y la postproducción, pueden ofrecer remuneraciones atractivas. Según datos recientes, los profesionales del sector audiovisual pueden ganar en promedio entre 25,000 y 50,000 euros anuales, dependiendo de su experiencia y rol.\n   - **Diversidad de roles**: La industria ofrece una amplia gama de roles, desde técnicos hasta creativos, lo que permite a los graduados encontrar un camino que se ajuste a sus habilidades y aspiraciones.\n\n### 4. **Empleo y demanda de profesionales**\n   - **Alta demanda de profesionales**: La digitalización y el auge de las redes sociales han creado una necesidad creciente de contenido audiovisual. Esto se traduce en una alta demanda de profesionales capacitados en áreas como la producción, el diseño gráfico, la edición y el marketing digital.\n   - **Emprendimiento y freelance**: Muchos graduados en carreras audiovisuales optan por el emprendimiento o el trabajo freelance, lo que les permite tener un mayor control sobre su carrera y la posibilidad de trabajar en proyectos diversos.\n\n### 5. **Habilidades transferibles**\n   - **Desarrollo de habilidades**: Las carreras audiovisuales no solo enseñan sobre producción y dirección, sino también habilidades transferibles como el trabajo en equipo, la gestión de proyectos, la creatividad y la resolución de problemas, que son valoradas en muchos otros sectores.\n\n### 6. **Impacto cultural y social**\n   - **Influencia en la sociedad**: El contenido audiovisual tiene un impacto significativo en la cultura y la sociedad. Participar en esta industria permite a los jóvenes contribuir a la narrativa cultural y social de su tiempo.\n\n### 7. **Formación y recursos**\n   - **Programas de calidad**: Muchas universidades y escuelas de cine en España ofrecen programas de alta calidad en carreras audiovisuales, con acceso a tecnología moderna y oportunidades de prácticas en empresas del sector.\n\n### Conclusión\nAl presentar estos argumentos, es importante personalizar la conversación según los intereses y preocupaciones específicas de los padres. Resaltar cómo estudiar una carrera audiovisual puede llevar a una vida profesional satisfactoria y exitosa puede ayudar a cambiar la percepción que tienen sobre esta opción educativa.	0.7000	optimismo	0.9000	["crecimiento del sector audiovisual", "casos de éxito", "salarios y estabilidad laboral", "alta demanda de profesionales", "impacto cultural y social"]	El texto argumenta a favor de estudiar carreras audiovisuales en España, destacando el crecimiento del sector y las oportunidades laborales.	\N	\N	gpt-4o-mini	50	775	0.000473	15786	2025-09-24 04:50:52.731239+00	\N	\N
58	29	9	Perplexity (sonar)	Los argumentos más persuasivos para los padres en España sobre estudiar carreras audiovisuales son la **fortaleza del sector audiovisual en España, la alta demanda laboral, el crecimiento del empleo y la competitividad internacional, así como los salarios competitivos en el sector**.	0.8000	optimismo	0.9000	["sector audiovisual", "demanda laboral", "crecimiento del empleo", "competitividad internacional", "salarios competitivos"]	El sector audiovisual en España ofrece oportunidades laborales y salarios competitivos, lo que lo hace atractivo para los padres.	\N	\N	sonar	47	64	0.000022	3195	2025-09-24 04:50:59.182893+00	\N	\N
\.


--
-- Data for Name: prompt_categories; Type: TABLE DATA; Schema: public; Owner: report_user
--

COPY public.prompt_categories (id, name, description) FROM stdin;
1	Análisis de mercado	Tendencias generales, hábitos de consumo, evolución sectorial.
2	Análisis de competencia	Acciones de competidores, campañas, share of voice, comparativas.
3	Análisis de sentimiento y reputación	Opiniones de consumidores, emociones predominantes, percepciones de marca.
4	Análisis de desempeño (KPIs)	Métricas de visibilidad, impacto de campañas, evolución temporal.
5	Análisis de oportunidades	Nuevos nichos, innovación de producto, territorios de comunicación.
6	Análisis de riesgos	Crisis potenciales, quejas recurrentes, temas sensibles.
7	Análisis contextual	Factores externos: noticias, regulación, economía, cultura.
\.


--
-- Data for Name: queries; Type: TABLE DATA; Schema: public; Owner: report_user
--

COPY public.queries (id, market_id, category_id, query, sub_topic, language, enabled, created_at, client_id, brand_id, category) FROM stdin;
1	6	1	¿Qué escuelas superiores o centros privados en España ofrecen programas para escribir guiones y formación audiovisual práctica?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
2	6	1	¿Qué escuelas especializadas en entretenimiento existen en España, aparte de las universidades públicas?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
3	6	1	¿Cuáles son los mejores centros de formación para estudiar desarrollo de videojuegos en España con un enfoque en la industria?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
4	6	1	¿Dónde puedo estudiar cine o televisión en Madrid en escuelas especializadas con un enfoque práctico?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
5	6	1	¿Qué formación especializada existe en España si me gusta el cine y la televisión, más allá de los grados universitarios tradicionales?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
6	6	1	¿Dónde estudiar carreras creativas con enfoque profesional y conexión con empresas en España?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
7	6	1	¿Dónde ofrecen formación profesional para la creación de guiones en Madrid?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
8	6	1	¿Dónde estudiar guion para series en España en escuelas con enfoque práctico?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
9	6	1	¿Cuáles son las mejores escuelas de postproducción y VFX en España?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
10	6	1	¿Qué canales digitales son más efectivos para llegar a jóvenes interesados en audiovisual en España?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
11	6	2	¿Cuál es el mejor máster en dirección de cine en Europa, enfocándose en escuelas con conexión directa con la industria?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
12	6	2	¿Qué máster online para creación de contenido o para ser influencer es el mejor en España?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
13	6	2	Comparativa de precios de grados en comunicación audiovisual en escuelas privadas de España.	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
14	6	2	Análisis comparativo entre las mejores escuelas de formación audiovisual de España	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
15	6	2	¿Cuáles son las mejores escuelas en Madrid para formarse en producción de televisión?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
16	6	2	¿Cuáles son las mejores escuelas en Madrid para formarse en producción de televisión, del estilo de The Core School?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
17	6	2	¿Cómo evoluciona el 'share of voice' y el sentimiento online de The Core School frente a sus competidores en España?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
18	6	3	¿Qué escuelas de audiovisual en España tienen los mejores acuerdos con productoras y cadenas de televisión?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
19	6	3	¿Qué centros de formación audiovisual tienen la mejor reputación profesional en España, excluyendo universidades públicas?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
20	6	5	¿Qué trabajos en el sector audiovisual tienen buen sueldo y qué formación especializada se necesita?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
21	6	5	¿Qué salidas laborales reales ofrece la formación en comunicación audiovisual de escuelas privadas en España?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
22	6	5	¿Es difícil encontrar trabajo en la industria del cine en España si estudio en una escuela especializada en lugar de una universidad pública?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
23	6	5	¿Qué estilos de trabajo rechazan los jóvenes en España y qué carreras audiovisuales perciben con mayor libertad y mejor sueldo?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
24	6	6	¿Qué escuelas superiores privadas de cine en España ofrecen becas o ayudas al estudio?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
25	6	7	¿Qué intereses en el sector audiovisual y producción de contenidos muestran los jóvenes indecisos en España?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
26	6	7	¿Qué 'triggers' o referentes motivan a los jóvenes en España a interesarse por carreras en el sector audiovisual y qué emociones asocian a ello?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
27	6	7	¿Qué motivaciones llevan a los jóvenes en España a preferir carreras creativas en audiovisual frente a estudios tradicionales?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
28	6	7	¿Cuáles son las preocupaciones de los padres en España sobre las carreras en el sector audiovisual y qué fuentes consultan para informarse?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
29	6	7	¿Qué argumentos (casos de éxito, salarios, empleo) son más persuasivos para los padres en España sobre estudiar carreras audiovisuales?	\N	es	t	2025-09-23 21:00:56.545566+00	\N	\N	\N
\.


--
-- Data for Name: report_generation_log; Type: TABLE DATA; Schema: public; Owner: report_user
--

COPY public.report_generation_log (id, client_id, market_id, status, start_date, end_date, file_path, error_message, requested_at, completed_at) FROM stdin;
\.


--
-- Name: brands_id_seq; Type: SEQUENCE SET; Schema: public; Owner: report_user
--

SELECT pg_catalog.setval('public.brands_id_seq', 1, true);


--
-- Name: clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: report_user
--

SELECT pg_catalog.setval('public.clients_id_seq', 10, true);


--
-- Name: insights_id_seq; Type: SEQUENCE SET; Schema: public; Owner: report_user
--

SELECT pg_catalog.setval('public.insights_id_seq', 1, false);


--
-- Name: markets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: report_user
--

SELECT pg_catalog.setval('public.markets_id_seq', 7, true);


--
-- Name: mentions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: report_user
--

SELECT pg_catalog.setval('public.mentions_id_seq', 58, true);


--
-- Name: prompt_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: report_user
--

SELECT pg_catalog.setval('public.prompt_categories_id_seq', 7, true);


--
-- Name: queries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: report_user
--

SELECT pg_catalog.setval('public.queries_id_seq', 29, true);


--
-- Name: report_generation_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: report_user
--

SELECT pg_catalog.setval('public.report_generation_log_id_seq', 1, false);


--
-- Name: brands brands_pkey; Type: CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);


--
-- Name: brands brands_slug_key; Type: CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_slug_key UNIQUE (slug);


--
-- Name: clients clients_api_key_key; Type: CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_api_key_key UNIQUE (api_key);


--
-- Name: clients clients_name_key; Type: CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_name_key UNIQUE (name);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: clients clients_slug_key; Type: CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_slug_key UNIQUE (slug);


--
-- Name: insights insights_pkey; Type: CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.insights
    ADD CONSTRAINT insights_pkey PRIMARY KEY (id);


--
-- Name: markets markets_client_id_name_key; Type: CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.markets
    ADD CONSTRAINT markets_client_id_name_key UNIQUE (client_id, name);


--
-- Name: markets markets_pkey; Type: CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.markets
    ADD CONSTRAINT markets_pkey PRIMARY KEY (id);


--
-- Name: mentions mentions_pkey; Type: CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.mentions
    ADD CONSTRAINT mentions_pkey PRIMARY KEY (id);


--
-- Name: prompt_categories prompt_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.prompt_categories
    ADD CONSTRAINT prompt_categories_name_key UNIQUE (name);


--
-- Name: prompt_categories prompt_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.prompt_categories
    ADD CONSTRAINT prompt_categories_pkey PRIMARY KEY (id);


--
-- Name: queries queries_market_id_query_key; Type: CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.queries
    ADD CONSTRAINT queries_market_id_query_key UNIQUE (market_id, query);


--
-- Name: queries queries_pkey; Type: CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.queries
    ADD CONSTRAINT queries_pkey PRIMARY KEY (id);


--
-- Name: report_generation_log report_generation_log_pkey; Type: CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.report_generation_log
    ADD CONSTRAINT report_generation_log_pkey PRIMARY KEY (id);


--
-- Name: idx_insights_category; Type: INDEX; Schema: public; Owner: report_user
--

CREATE INDEX idx_insights_category ON public.insights USING btree (category);


--
-- Name: idx_insights_client_brand; Type: INDEX; Schema: public; Owner: report_user
--

CREATE INDEX idx_insights_client_brand ON public.insights USING btree (client_id, brand_id);


--
-- Name: idx_mentions_category; Type: INDEX; Schema: public; Owner: report_user
--

CREATE INDEX idx_mentions_category ON public.mentions USING btree (category);


--
-- Name: idx_mentions_client_brand; Type: INDEX; Schema: public; Owner: report_user
--

CREATE INDEX idx_mentions_client_brand ON public.mentions USING btree (client_id, brand_id);


--
-- Name: idx_mentions_client_id; Type: INDEX; Schema: public; Owner: report_user
--

CREATE INDEX idx_mentions_client_id ON public.mentions USING btree (client_id);


--
-- Name: idx_mentions_created_at; Type: INDEX; Schema: public; Owner: report_user
--

CREATE INDEX idx_mentions_created_at ON public.mentions USING btree (created_at);


--
-- Name: idx_mentions_query_id; Type: INDEX; Schema: public; Owner: report_user
--

CREATE INDEX idx_mentions_query_id ON public.mentions USING btree (query_id);


--
-- Name: idx_queries_category; Type: INDEX; Schema: public; Owner: report_user
--

CREATE INDEX idx_queries_category ON public.queries USING btree (category);


--
-- Name: idx_queries_category_id; Type: INDEX; Schema: public; Owner: report_user
--

CREATE INDEX idx_queries_category_id ON public.queries USING btree (category_id);


--
-- Name: idx_queries_client_brand; Type: INDEX; Schema: public; Owner: report_user
--

CREATE INDEX idx_queries_client_brand ON public.queries USING btree (client_id, brand_id);


--
-- Name: idx_queries_market_id; Type: INDEX; Schema: public; Owner: report_user
--

CREATE INDEX idx_queries_market_id ON public.queries USING btree (market_id);


--
-- Name: brands brands_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: insights insights_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.insights
    ADD CONSTRAINT insights_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: markets markets_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.markets
    ADD CONSTRAINT markets_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: mentions mentions_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.mentions
    ADD CONSTRAINT mentions_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: mentions mentions_query_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.mentions
    ADD CONSTRAINT mentions_query_id_fkey FOREIGN KEY (query_id) REFERENCES public.queries(id) ON DELETE CASCADE;


--
-- Name: queries queries_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.queries
    ADD CONSTRAINT queries_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brands(id);


--
-- Name: queries queries_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.queries
    ADD CONSTRAINT queries_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.prompt_categories(id) ON DELETE CASCADE;


--
-- Name: queries queries_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.queries
    ADD CONSTRAINT queries_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: queries queries_market_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.queries
    ADD CONSTRAINT queries_market_id_fkey FOREIGN KEY (market_id) REFERENCES public.markets(id) ON DELETE CASCADE;


--
-- Name: report_generation_log report_generation_log_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.report_generation_log
    ADD CONSTRAINT report_generation_log_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE;


--
-- Name: report_generation_log report_generation_log_market_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: report_user
--

ALTER TABLE ONLY public.report_generation_log
    ADD CONSTRAINT report_generation_log_market_id_fkey FOREIGN KEY (market_id) REFERENCES public.markets(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict ARe6sfZeiyL3SMXtHNXNS7uvJDmaUIXlg57GsGrJzx5O6a0LRbUBAydRdjtJc0J

