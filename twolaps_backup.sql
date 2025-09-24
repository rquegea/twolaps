--
-- PostgreSQL database dump
--

\restrict 2yJBgVY6o6uydrdWe1aeaKSds487Icg87PZohn0lYxU22ZwpBnAC5Ow3arjsNsT

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
1	1	9	OpenAI (gpt-4o-mini)	En España, hay varias escuelas y centros privados que ofrecen programas de formación en escritura de guiones y en producción audiovisual práctica. A continuación, te menciono algunas de las más destacadas:\n\n1. **Escuela de Cinematografía y del Audiovisual de Madrid (ECAM)**: Ofrece un Máster en Guion y diversos cursos relacionados con la escritura de guiones y la producción audiovisual.\n\n2. **Instituto del Cine de Madrid (ICM)**: Ofrece programas de formación en guion, dirección y producción, con un enfoque práctico.\n\n3. **Escuela de Artes y Espectáculos TAI**: Situada en Madrid, ofrece un Grado en Cinematografía y programas de postgrado en guion y producción audiovisual.\n\n4. **Escuela de Cine de Barcelona (ESCAC)**: Ofrece un Grado en Cinematografía y programas de máster en guion y producción, con un enfoque muy práctico.\n\n5. **Universidad de Navarra - Escuela de Comunicación**: Ofrece un Máster en Guion y Producción Audiovisual, con un enfoque en la narrativa y la creación de contenidos.\n\n6. **Cine en Curso**: Ofrece talleres de escritura de guiones y producción, con un enfoque en la práctica y el trabajo en equipo.\n\n7. **Escuela de Negocios y Dirección (ENyD)**: Ofrece un Máster en Producción y Dirección de Cine, que incluye formación en guion.\n\n8. **Taller de Guion**: Este es un espacio donde se imparten cursos de escritura de guiones en diferentes formatos, incluyendo cine y televisión.\n\n9. **Escuela de Cine y Televisión de San Antonio de Los Baños (EICTV)**: Aunque está en Cuba, es conocida en el ámbito hispano y ofrece programas de formación en guion y producción, atrayendo a estudiantes de España y otros países.\n\n10. **Escuela de Cine de Málaga (ECM)**: Ofrece formación en guion y producción, con un enfoque práctico y talleres.\n\nEs recomendable visitar las páginas web de estas instituciones para obtener información más detallada sobre los programas, requisitos de admisión y fechas de inscripción. Además, muchas de estas escuelas tienen un enfoque práctico que permite a los estudiantes trabajar en proyectos reales, lo cual es fundamental en el ámbito audiovisual.	0.7000	optimismo	0.9000	["formación audiovisual", "guion", "producción", "escuelas", "práctica"]	El texto presenta diversas escuelas en España que ofrecen formación en guion y producción audiovisual, destacando su enfoque práctico.	\N	\N	gpt-4o-mini	41	480	0.000294	13530	2025-09-24 16:25:53.599895+00	\N	\N
2	1	9	Perplexity (sonar)	En España, varias escuelas superiores y centros privados ofrecen programas específicos en **escritura de guiones** y formación práctica en **audiovisuales**:\n\n- **CEV (Centro de Formación Profesional Madrid)** es una escuela pionera fundada e	0.5000	optimismo	0.8000	["escritura de guiones", "audiovisuales", "CEV", "formación profesional", "escuelas superiores"]	Escuelas en España ofrecen programas de escritura de guiones y formación en audiovisuales.	\N	\N	sonar	41	64	0.000021	4017	2025-09-24 16:26:01.925367+00	\N	\N
3	2	9	OpenAI (gpt-4o-mini)	En España, hay varias escuelas especializadas en entretenimiento, además de las universidades públicas. Estas instituciones ofrecen programas en áreas como cine, teatro, música, danza, producción audiovisual y más. A continuación, te menciono algunas de las más reconocidas:\n\n1. **ESCAC (Escola Superior de Cinema i Audiovisuals de Catalunya)**: Ubicada en Barcelona, esta escuela se especializa en la formación en cine y audiovisual, ofreciendo grados y másteres en dirección, producción, guion, y más.\n\n2. **TIS (Taller de Interpretación de Sevilla)**: Esta escuela se centra en la formación de actores y actrices, ofreciendo cursos de interpretación y técnicas teatrales.\n\n3. **EICTV (Escuela Internacional de Cine y Televisión)**: Aunque se encuentra en Cuba, muchos estudiantes españoles asisten a esta prestigiosa escuela para formarse en cine y televisión.\n\n4. **ESCOLA DE TEATRE EÒLIA**: Situada en Barcelona, ofrece formación en interpretación, dirección y dramaturgia, con un enfoque en el teatro contemporáneo.\n\n5. **CITHE (Centro Internacional de Teatro y Educación)**: Ofrece programas de formación en artes escénicas, centrados en la intersección entre teatro y educación.\n\n6. **Musical Theatre Academy (MTA)**: Ubicada en Madrid, esta escuela se especializa en formación en teatro musical, combinando canto, danza y actuación.\n\n7. **ESAD (Escuela Superior de Arte Dramático)**: Con sedes en varias ciudades, como Madrid y Valencia, ofrece formación en interpretación y otras disciplinas relacionadas con las artes escénicas.\n\n8. **La Escuela de Cine de Madrid**: Ofrece formación en diferentes aspectos del cine, desde la dirección hasta la producción y la edición.\n\n9. **Cineastas en acción**: Esta escuela ofrece cursos de cine y televisión, así como talleres de producción y dirección.\n\n10. **Escuela de Música Creativa (EMC)**: En Madrid, se centra en la formación musical, abarcando desde la composición hasta la interpretación en diversos géneros.\n\nAdemás de estas, hay muchas otras escuelas y academias en diferentes ciudades de España que ofrecen programas especializados en diversas áreas del entretenimiento. Es recomendable investigar cada una de ellas para encontrar la que mejor se adapte a tus intereses y necesidades.	0.8000	optimismo	0.9000	["escuelas de cine", "teatro", "música", "producción audiovisual", "formación artística"]	El texto describe varias escuelas en España especializadas en entretenimiento, destacando sus programas y áreas de enfoque.	\N	\N	gpt-4o-mini	38	481	0.000294	19374	2025-09-24 16:26:25.619576+00	\N	\N
4	2	9	Perplexity (sonar)	En España, además de las universidades públicas, existen varias **escuelas especializadas privadas en entretenimiento**, algunas con foco en audiovisual, cine, y producción de contenido. Entre las más destacadas están:\n\n- **The Core Entertainment Science School** (Madrid): Es l	0.5000	optimismo	0.8000	["escuelas especializadas", "entretenimiento", "audiovisual", "cine", "producción de contenido"]	En España, hay escuelas privadas especializadas en entretenimiento, destacando The Core Entertainment Science School en Madrid.	\N	\N	sonar	37	64	0.000020	3415	2025-09-24 16:26:33.664659+00	\N	\N
5	3	9	OpenAI (gpt-4o-mini)	En España, hay varios centros de formación reconocidos que ofrecen programas de estudios en desarrollo de videojuegos con un enfoque en la industria. Aquí te presento algunos de los más destacados:\n\n1. **Universidad Politécnica de Valencia (UPV)**:\n   - Ofrece un Grado en Diseño y Desarrollo de Videojuegos, que combina teoría y práctica con un enfoque en la industria. Además, cuenta con laboratorios y proyectos colaborativos.\n\n2. **Universidad de Barcelona (UB)**:\n   - La UB ofrece un Máster en Diseño y Desarrollo de Videojuegos, que se centra en la creación de videojuegos desde un enfoque práctico y profesional.\n\n3. **ESNE (Escuela Universitaria de Diseño, Innovación y Tecnología)**:\n   - Ofrece un Grado en Diseño de Videojuegos y un Máster en Diseño y Desarrollo de Videojuegos. Su enfoque está en la formación integral, incluyendo diseño, programación y producción.\n\n4. **IED (Istituto Europeo di Design)**:\n   - En su sede de Madrid, el IED ofrece un Grado en Diseño de Videojuegos que prepara a los estudiantes para las demandas del mercado laboral a través de proyectos prácticos y colaboraciones con empresas.\n\n5. **GameLab (Escuela de Videojuegos)**:\n   - Ofrece programas de formación específicos en desarrollo de videojuegos, incluyendo cursos de programación, diseño y producción, con un enfoque práctico y orientado a la industria.\n\n6. **CICE (Escuela Profesional de Nuevas Tecnologías)**:\n   - Ofrece un Máster en Desarrollo de Videojuegos que incluye formación en programación, diseño y producción, con un enfoque en las herramientas y técnicas utilizadas en la industria.\n\n7. **Universidad de Deusto**:\n   - Ofrece un Grado en Ingeniería en Desarrollo de Videojuegos, que combina aspectos técnicos y creativos, preparando a los estudiantes para los retos del sector.\n\n8. **Escuela Superior de Diseño de Barcelona (ESDi)**:\n   - Ofrece un Grado en Diseño de Videojuegos, que incluye formación en diseño, programación y producción, con proyectos colaborativos y prácticas en la industria.\n\n9. **CENP (Centro de Nuevas Profesiones)**:\n   - Ofrece un programa especializado en desarrollo de videojuegos que incluye formación en diversas áreas como diseño, programación y narrativa.\n\nAl elegir un centro de formación, es importante considerar factores como el plan de estudios, la experiencia del profesorado, las oportunidades de prácticas y el acceso a la industria. También es recomendable visitar las instalaciones y hablar con estudiantes actuales para obtener una visión más clara del programa.	0.8000	optimismo	0.9000	["videojuegos", "formación", "universidades", "programas", "industria"]	El texto describe centros de formación en España que ofrecen programas en desarrollo de videojuegos con un enfoque práctico y profesional.	\N	\N	gpt-4o-mini	44	535	0.000328	12518	2025-09-24 16:26:50.19758+00	\N	\N
6	3	9	Perplexity (sonar)	Los mejores centros de formación para estudiar desarrollo de videojuegos en España con un enfoque en la industria son principalmente **CEV (Escuela Superior de Formación Audiovisual, Animación 3D y Nuevas Tecnologías)** en Madrid, **Voxel School**, y alguno	0.7000	optimismo	0.8500	["CEV", "Voxel School", "desarrollo de videojuegos", "formación", "España"]	Se mencionan los mejores centros de formación en España para estudiar desarrollo de videojuegos.	\N	\N	sonar	43	64	0.000021	3509	2025-09-24 16:26:59.477955+00	\N	\N
7	4	9	OpenAI (gpt-4o-mini)	En Madrid, hay varias escuelas especializadas en cine y televisión que ofrecen un enfoque práctico en sus programas. Aquí te menciono algunas de las más reconocidas:\n\n1. **Escuela de Cine de la Comunidad de Madrid (ECAM)**: Esta escuela es conocida por su enfoque práctico y su conexión con la industria. Ofrecen una variedad de programas, desde cortometrajes hasta producción y dirección.\n\n2. **TITULOS DE CINE**: Esta escuela ofrece una formación integral en cine y televisión, con un enfoque en la práctica. Tienen programas de dirección, producción, guion y más.\n\n3. **ESCAC (Escuela Superior de Cine y Audiovisuales de Cataluña)**: Aunque está en Barcelona, es reconocida a nivel nacional y ofrece programas de posgrado y máster que pueden ser de interés. Su enfoque práctico es muy valorado.\n\n4. **Cine en Acción**: Esta escuela ofrece cursos y talleres prácticos en diferentes áreas del cine y la televisión, desde la dirección hasta la producción y el guion.\n\n5. **Escuela de Artes y Espectáculos TAI**: Ofrece una formación en cine y televisión con un enfoque en la práctica y la creación de proyectos.\n\n6. **Escuela de Cine y Televisión de Madrid (ECT)**: Se centra en la formación práctica, con un enfoque en la creación de proyectos audiovisuales.\n\n7. **Cine y Televisión de la Universidad Complutense de Madrid (UCM)**: Aunque es una universidad, su programa en Comunicación Audiovisual incluye una fuerte componente práctica.\n\nEs recomendable visitar las páginas web de estas instituciones para obtener más información sobre los programas, requisitos de admisión y fechas de inscripción. Además, puedes considerar asistir a jornadas de puertas abiertas para conocer más sobre el ambiente y la metodología de enseñanza.	0.7000	optimismo	0.9000	["cine", "televisión", "formación práctica", "escuelas", "programas"]	El texto destaca varias escuelas de cine y televisión en Madrid, enfocándose en su formación práctica y conexión con la industria.	\N	\N	gpt-4o-mini	40	371	0.000229	9424	2025-09-24 16:27:13.302915+00	\N	\N
8	4	9	Perplexity (sonar)	En Madrid puedes estudiar cine o televisión en escuelas especializadas con un enfoque práctico en centros como la **Escuela de Cine y TV Séptima Ars**, que ofrece diplomaturas y cursos prácticos en dirección, cámara, montaje, guion y producció	0.7000	optimismo	0.8500	["Madrid", "cine", "televisión", "Escuela de Cine y TV Séptima Ars", "cursos prácticos"]	Madrid ofrece oportunidades de estudio en cine y televisión en la Escuela de Cine y TV Séptima Ars.	\N	\N	sonar	40	64	0.000021	2922	2025-09-24 16:27:20.201028+00	\N	\N
9	5	9	OpenAI (gpt-4o-mini)	En España, existen diversas opciones de formación especializada en el ámbito del cine y la televisión que van más allá de los grados universitarios tradicionales. Aquí te presento algunas de las más destacadas:\n\n1. **Escuelas de Cine**: Hay varias escuelas de cine en España que ofrecen programas de formación en diferentes áreas, como dirección, producción, guion, montaje, cinematografía, etc. Algunas de las más reconocidas son:\n   - **Escuela de Cinematografía y del Audiovisual de la Comunidad de Madrid (ECAM)**: Ofrece másteres y cursos en diferentes especialidades del cine.\n   - **Escuela Internacional de Cine y Televisión (EICTV)** en San Antonio de los Baños, Cuba, aunque no está en España, muchos españoles asisten a esta escuela.\n   - **Escuela de Artes y Espectáculos (TAI)**: Ofrece grados y másteres en cine, televisión y artes visuales.\n\n2. **Másteres y Postgrados**: Muchas universidades y escuelas ofrecen programas de máster y postgrado en áreas específicas del cine y la televisión, como:\n   - **Máster en Dirección de Cine y TV**.\n   - **Máster en Producción Cinematográfica**.\n   - **Máster en Guion**.\n\n3. **Cursos Cortos y Talleres**: Existen numerosos cursos cortos y talleres que se centran en aspectos específicos del cine y la televisión, como:\n   - Talleres de dirección, actuación, guion, producción, etc.\n   - Cursos online en plataformas como Coursera, Domestika o MasterClass, que ofrecen formación de profesionales del sector.\n\n4. **Formación Profesional**: Algunos ciclos formativos de grado superior están orientados a la producción y realización audiovisual, como:\n   - **Técnico Superior en Producción Audiovisual**.\n   - **Técnico Superior en Realización de Proyectos Audiovisuales**.\n\n5. **Asociaciones y Colectivos**: Algunas asociaciones y colectivos del sector ofrecen formación y talleres, como la **Academia de las Artes y las Ciencias Cinematográficas de España**, que organiza eventos, proyecciones y cursos.\n\n6. **Festivales y Eventos**: Participar en festivales de cine y televisión, como el Festival de Cine de San Sebastián o el Festival de Málaga, puede ofrecer oportunidades de formación a través de masterclasses y talleres impartidos por profesionales del sector.\n\n7. **Programas de Residencia**: Algunos programas de residencia permiten a los aspirantes a cineastas trabajar en proyectos específicos bajo la tutoría de profesionales experimentados.\n\nEstas opciones permiten a los interesados en el cine y la televisión adquirir habilidades prácticas y teóricas, así como establecer contactos en la industria.	0.8000	optimismo	0.9000	["formación especializada", "escuelas de cine", "másteres", "cursos cortos", "festivales"]	El texto describe diversas opciones de formación en cine y televisión en España, destacando escuelas, másteres y cursos especializados.	\N	\N	gpt-4o-mini	46	569	0.000348	17573	2025-09-24 16:27:41.922417+00	\N	\N
10	5	9	Perplexity (sonar)	En España existen varias **formaciones especializadas en cine y televisión más allá de los grados universitarios tradicionales**, que incluyen escuelas de cine, cursos técnicos y programas para actores y especialistas de cine:\n\n- **Escuela de Cine y TV Septim	0.5000	optimismo	0.8500	["cine", "televisión", "escuelas de cine", "cursos técnicos", "programas para actores"]	Existen formaciones especializadas en cine y televisión en España, más allá de los grados universitarios tradicionales.	\N	\N	sonar	44	64	0.000022	3446	2025-09-24 16:27:48.935197+00	\N	\N
11	6	9	OpenAI (gpt-4o-mini)	En España, hay varias instituciones y universidades que ofrecen carreras creativas con un enfoque profesional y conexión con empresas. Aquí te presento algunas de las más destacadas:\n\n1. **IED (Istituto Europeo di Design)**: Ofrece programas en diseño, moda, comunicación visual y gestión creativa. Tiene sedes en varias ciudades, incluyendo Madrid y Barcelona, y se enfoca en la conexión con la industria a través de proyectos y prácticas.\n\n2. **ESNE (Escuela Universitaria de Diseño, Innovación y Tecnología)**: Ubicada en Madrid, ESNE ofrece grados en diseño gráfico, diseño de interiores, diseño de moda y diseño de videojuegos, con un fuerte enfoque en la innovación y la colaboración con empresas.\n\n3. **EINA, Centre Universitari de Disseny i Art**: Situada en Barcelona, EINA ofrece grados y másteres en diseño gráfico, diseño de interiores y arte. La escuela promueve la conexión con el mundo profesional a través de prácticas y proyectos colaborativos.\n\n4. **Universidad Politécnica de Madrid (UPM)**: A través de su Escuela Técnica Superior de Diseño Industrial, la UPM ofrece programas en diseño industrial que incluyen un enfoque práctico y colaboraciones con empresas.\n\n5. **Universidad de Barcelona (UB)**: Ofrece grados en Bellas Artes y Diseño, con un enfoque en la creatividad y la conexión con el entorno profesional a través de prácticas y proyectos.\n\n6. **ESIC Business & Marketing School**: Aunque es más conocida por sus programas en marketing y negocios, también ofrece másteres en diseño y creatividad, con un enfoque en la conexión con el mundo empresarial.\n\n7. **FUNDACIÓN CEADE**: Esta fundación ofrece programas en diseño de moda y diseño gráfico, con un enfoque práctico y colaboraciones con marcas y empresas del sector.\n\n8. **La Salle Campus Barcelona**: Ofrece grados en diseño multimedia y diseño gráfico, con un fuerte enfoque en la tecnología y la conexión con la industria.\n\n9. **Universidad de Navarra**: A través de su Facultad de Comunicación, ofrece programas en diseño y comunicación visual, con oportunidades de prácticas en empresas.\n\n10. **Escuela Superior de Diseño de Madrid (ESDM)**: Ofrece una variedad de programas en diseño con un enfoque práctico y conexión con el sector profesional.\n\nEs recomendable investigar cada institución, sus programas específicos, y las oportunidades de prácticas y conexión con empresas para encontrar la opción que mejor se adapte a tus intereses y objetivos profesionales.	0.8000	optimismo	0.9000	["diseño", "educación", "universidades", "prácticas", "creatividad"]	El texto destaca diversas instituciones en España que ofrecen carreras creativas con un enfoque práctico y conexión con empresas.	\N	\N	gpt-4o-mini	38	508	0.000310	9493	2025-09-24 16:28:01.870263+00	\N	\N
12	6	9	Perplexity (sonar)	En España, para estudiar carreras creativas con un enfoque profesional y conexión directa con empresas, destacan varias opciones universitarias y centros especializados que combinan formación teórica, práctica e inserción laboral.\n\n**Universidad Francisco de Vitoria (UFV)*	0.7000	optimismo	0.8500	["carreras creativas", "formación teórica", "práctica", "inserción laboral", "Universidad Francisco de Vitoria"]	Se destacan opciones universitarias en España para carreras creativas con enfoque profesional y conexión con empresas.	\N	\N	sonar	33	64	0.000019	2763	2025-09-24 16:28:08.894432+00	\N	\N
13	7	9	OpenAI (gpt-4o-mini)	En Madrid, hay varias instituciones y escuelas que ofrecen formación profesional en creación de guiones. Aquí te menciono algunas de ellas:\n\n1. **Escuela de Cinematografía y del Audiovisual de la Comunidad de Madrid (ECAM)**: Ofrece un máster en guion que cubre aspectos teóricos y prácticos de la escritura de guiones para cine y televisión.\n\n2. **Taller de Guion**: Esta escuela se especializa en la formación de guionistas y ofrece cursos y talleres de diferentes niveles, desde iniciación hasta formación avanzada.\n\n3. **Escuela de Escritores**: Ofrecen cursos de escritura creativa, incluyendo talleres específicos de guion para cine y televisión.\n\n4. **Universidad Complutense de Madrid (UCM)**: Tiene programas relacionados con el cine y la televisión, donde se puede estudiar guion como parte de la carrera de Comunicación Audiovisual.\n\n5. **Escuela de Cine de Madrid (ECM)**: Ofrecen cursos de guion y producción cinematográfica, así como talleres y programas de formación.\n\n6. **Cine en curso**: Ofrecen talleres y cursos sobre guion de forma intensiva, dirigidos a quienes desean profundizar en la escritura de guiones.\n\nTe recomendaría investigar cada una de estas opciones, ya que pueden variar en duración, metodología y enfoque. Además, es útil revisar las opiniones de antiguos alumnos y el contenido específico de cada programa para encontrar el que mejor se adapte a tus necesidades.	0.7000	optimismo	0.9000	["formación profesional", "guiones", "Madrid", "cine", "televisión"]	El texto presenta varias instituciones en Madrid que ofrecen formación profesional en creación de guiones, con recomendaciones para investigar cada opción.	\N	\N	gpt-4o-mini	36	308	0.000190	8452	2025-09-24 16:28:21.603947+00	\N	\N
14	7	9	Perplexity (sonar)	En Madrid, existen varias opciones para formación profesional en creación de guiones, destacando las siguientes:\n\n- **Escuela de Guion de Madrid**: Ofrece cursos online y un Máster Propio en Guion de Cine, Series TV y Dramaturgia en colaboración con la Universidad Au	0.7000	optimismo	0.8500	["formación profesional", "guiones", "Escuela de Guion de Madrid", "Máster Propio", "Universidad Au"]	En Madrid hay opciones de formación profesional en guiones, destacando la Escuela de Guion de Madrid con cursos y un máster.	\N	\N	sonar	30	64	0.000019	3444	2025-09-24 16:28:29.068929+00	\N	\N
15	8	9	OpenAI (gpt-4o-mini)	En España, hay varias escuelas y programas que ofrecen formación en guion para series con un enfoque práctico. Aquí te dejo algunas opciones destacadas:\n\n1. **Escuela de Cinematografía y del Audiovisual de la Comunidad de Madrid (ECAM)**: Ofrece un máster en guion que incluye formación práctica y teórica, con un enfoque en la escritura de guiones para cine y televisión.\n\n2. **TITULACIÓN EN GUION DE LA ESCUELA DE CINE DE MALAGA (ECAM)**: Este programa se centra en la creación de guiones para diferentes formatos, incluyendo series, y proporciona un entorno práctico para el desarrollo de proyectos.\n\n3. **Escuela Superior de Artes y Espectáculos (TAI)**: Ofrece un grado en escritura de guion, así como másters y cursos especializados en guion para cine y televisión, con un fuerte componente práctico.\n\n4. **Escuela de Guion de Barcelona**: Se especializa en la formación de guionistas para cine y televisión, ofreciendo cursos intensivos y talleres que fomentan la escritura práctica.\n\n5. **Escuela de Cine de San Antonio de los Baños (EICTV)**: Aunque está en Cuba, muchos estudiantes españoles asisten a sus programas, que son muy valorados en el ámbito del guion y la producción audiovisual.\n\n6. **Máster en Guion de la Universidad de Salamanca**: Este programa tiene un enfoque práctico y se centra en la escritura de guiones para diferentes medios, incluyendo series de televisión.\n\n7. **Instituto del Cine de Madrid (ICM)**: Ofrece cursos y talleres de guion que incluyen ejercicios prácticos y análisis de obras existentes.\n\n8. **Escuela de Guion de Madrid**: Ofrece cursos de guion para televisión, donde se trabaja en proyectos reales y se fomenta la colaboración entre estudiantes.\n\nAdemás de estas instituciones, también es recomendable participar en talleres y seminarios organizados por asociaciones de guionistas, como la **Asociación de Guionistas de España (AGAE)**, que suelen ofrecer oportunidades de formación práctica y networking en el sector. \n\nTe sugiero investigar cada opción y considerar qué programa se adapta mejor a tus necesidades y objetivos profesionales.	0.7000	optimismo	0.9000	["formación en guion", "escuelas de cine", "programas prácticos", "Asociación de Guionistas de España", "proyectos audiovisuales"]	El texto presenta diversas escuelas en España que ofrecen formación práctica en guion para cine y televisión.	\N	\N	gpt-4o-mini	37	457	0.000280	16085	2025-09-24 16:28:49.224564+00	\N	\N
16	8	9	Perplexity (sonar)	En España, para estudiar guion para series en escuelas con **enfoque práctico**, destacan varias opciones:\n\n- **Escuela de Guion de Madrid** ofrece cursos presenciales y online con profesionales en activo del cine, televisión y dramaturgia, centrados e	0.6000	optimismo	0.8500	["España", "guion", "Escuela de Guion de Madrid", "cursos", "cine"]	Se presentan opciones para estudiar guion en España, destacando la Escuela de Guion de Madrid con un enfoque práctico.	\N	\N	sonar	35	64	0.000020	3427	2025-09-24 16:28:56.060558+00	\N	\N
17	9	9	OpenAI (gpt-4o-mini)	En España, hay varias escuelas y centros de formación que son reconocidos por su calidad en la enseñanza de postproducción y efectos visuales (VFX). Aquí te presento algunas de las más destacadas:\n\n1. **ESCAC (Escola Superior de Cinema i Audiovisuals de Catalunya)**: Ubicada en Barcelona, la ESCAC es conocida por su enfoque integral en la formación de cineastas y profesionales del audiovisual. Ofrecen programas de postproducción que incluyen VFX.\n\n2. **Cine en Acción**: Esta escuela en Madrid se especializa en formación para el cine y la televisión, ofreciendo cursos de postproducción y efectos visuales, así como de edición y montaje.\n\n3. **FX Animation**: Con sede en Barcelona, FX Animation es conocida por su formación en animación, efectos visuales y postproducción. Ofrecen programas especializados que cubren desde los fundamentos hasta técnicas avanzadas.\n\n4. **Trazos**: Esta escuela, también en Madrid, ofrece un máster en efectos visuales y postproducción que abarca diversas técnicas y herramientas utilizadas en la industria.\n\n5. **CICE (Escuela de Nuevas Tecnologías de la Comunicación)**: Situada en Madrid, CICE ofrece varios programas relacionados con la postproducción y los efectos visuales, incluyendo un máster en VFX.\n\n6. **Bau, Centro Universitario de Diseño de Barcelona**: Aunque su enfoque principal es el diseño, también ofrecen programas relacionados con la postproducción y la creación de contenido audiovisual.\n\n7. **Escuela de Cine de Urgel**: En Madrid, esta escuela ofrece formación en diferentes áreas del cine, incluyendo la postproducción y los efectos visuales.\n\n8. **Mediatraining**: Esta institución ofrece cursos y talleres en diversas áreas del audiovisual, incluyendo postproducción y VFX, con un enfoque práctico.\n\nAl elegir una escuela, es importante considerar factores como la calidad del profesorado, el equipamiento disponible, las oportunidades de prácticas y la red de contactos en la industria. También es recomendable revisar las opiniones de antiguos alumnos y el tipo de proyectos que se realizan durante el curso.	0.8000	optimismo	0.9000	["postproducción", "efectos visuales", "escuelas", "formación", "cine"]	El texto destaca varias escuelas en España reconocidas por su calidad en postproducción y efectos visuales.	\N	\N	gpt-4o-mini	38	443	0.000271	12065	2025-09-24 16:29:11.803142+00	\N	\N
18	9	9	Perplexity (sonar)	Algunas de las mejores escuelas y másteres de postproducción y efectos visuales (VFX) en España son:\n\n- **Lightbox Academy**: Su Máster en VFX – Visual Effects tiene una alta puntuación (8.9) y es muy reconocido en	0.8000	optimismo	0.9000	["escuelas", "másteres", "postproducción", "efectos visuales", "Lightbox Academy"]	Se mencionan escuelas destacadas de postproducción y VFX en España, destacando Lightbox Academy.	\N	\N	sonar	31	64	0.000019	2251	2025-09-24 16:29:17.801785+00	\N	\N
19	10	9	OpenAI (gpt-4o-mini)	Elegir el mejor máster en dirección de cine en Europa puede depender de varios factores, incluidos tus objetivos profesionales, el enfoque del programa y las conexiones con la industria. Aquí te presento algunas de las escuelas más reconocidas que ofrecen programas de máster en dirección de cine y que tienen buenas conexiones con la industria cinematográfica:\n\n1. **La Fémis (Francia)**:\n   - Ubicación: París\n   - Descripción: Esta escuela es conocida por su enfoque riguroso en la formación cinematográfica y su conexión con la industria francesa. Los estudiantes tienen la oportunidad de trabajar en proyectos reales y colaborar con profesionales del cine.\n\n2. **National Film and Television School (NFTS) (Reino Unido)**:\n   - Ubicación: Beaconsfield, Inglaterra\n   - Descripción: La NFTS es altamente respetada y ofrece un máster en dirección de cine que incluye formación práctica y teórica. La escuela tiene una excelente reputación y conexiones con la industria británica.\n\n3. **Centro Sperimentale di Cinematografia (Italia)**:\n   - Ubicación: Roma\n   - Descripción: Esta es una de las escuelas de cine más antiguas de Italia y ofrece programas en dirección cinematográfica. La escuela tiene vínculos con la industria cinematográfica italiana y europea.\n\n4. **London Film School (Reino Unido)**:\n   - Ubicación: Londres\n   - Descripción: La London Film School ofrece un máster en dirección que se centra en la práctica y la teoría del cine. Tiene una fuerte conexión con la industria y una red de exalumnos que trabaja en diversas áreas del cine.\n\n5. **Escuela de Cine de Lisboa (Portugal)**:\n   - Ubicación: Lisboa\n   - Descripción: Esta escuela ha ganado reconocimiento en los últimos años y ofrece programas que fomentan la creatividad y la conexión con la industria cinematográfica local e internacional.\n\n6. **Escuela de Cine de Dinamarca (Danish Film School)**:\n   - Ubicación: Copenhague\n   - Descripción: Ofrece un programa de máster en dirección que se centra en la práctica y la teoría del cine. Tiene una buena reputación y conexiones con la industria danesa y europea.\n\n7. **EICAR (Escuela Internacional de Cine y Artes Audiovisuales) (Francia)**:\n   - Ubicación: París\n   - Descripción: EICAR es conocida por su enfoque práctico en la educación cinematográfica y sus conexiones con la industria en Francia.\n\nAl elegir un programa, es importante investigar los planes de estudio, la experiencia de los profesores, las oportunidades de networking y las tasas de empleo de los graduados. También puede ser útil visitar las escuelas, si es posible, y hablar con estudiantes actuales o exalumnos para obtener una perspectiva más clara.	0.7000	optimismo	0.8500	["máster en dirección de cine", "La Fémis", "NFTS", "London Film School", "Centro Sperimentale di Cinematografia"]	El texto analiza diversas escuelas de cine en Europa, destacando su calidad y conexiones con la industria.	\N	\N	gpt-4o-mini	47	573	0.000351	15103	2025-09-24 16:29:36.803468+00	\N	\N
20	10	9	Perplexity (sonar)	El **mejor máster en dirección de cine en Europa con fuerte conexión directa a la industria** se encuentra principalmente en escuelas reconocidas por su formación práctica intensiva y su vínculo estrecho con profesionales del sector audiovisual, como la **ECAM**	0.8000	optimismo	0.9000	["máster", "dirección de cine", "ECAM", "industria audiovisual", "formación práctica"]	El mejor máster en dirección de cine en Europa destaca por su conexión con la industria y formación práctica.	\N	\N	sonar	43	64	0.000021	3401	2025-09-24 16:29:43.820554+00	\N	\N
60	30	9	Perplexity (sonar)	Las principales preocupaciones de los padres en España respecto a las carreras en el sector audiovisual suelen relacionarse con la incertidumbre sobre la estabilidad laboral y la accesibilidad a la profesión, además de dudas sobre el futuro del sector audiovisual como opción profesional. Estos te	-0.6000	preocupación	0.8500	["preocupaciones", "sector audiovisual", "estabilidad laboral", "accesibilidad", "futuro profesional"]	Los padres en España están preocupados por la estabilidad laboral y el futuro del sector audiovisual para sus hijos.	\N	\N	sonar	44	64	0.000022	2812	2025-09-24 16:37:49.091852+00	\N	\N
61	31	9	OpenAI (gpt-4o-mini)	Convencer a los padres en España sobre la importancia de estudiar carreras audiovisuales puede requerir una combinación de argumentos centrados en el éxito profesional, las oportunidades de empleo y los salarios potenciales. Aquí te presento algunos puntos que podrían ser persuasivos:\n\n### 1. **Crecimiento del Sector Audiovisual**\n   - **Expansión de la Industria**: El sector audiovisual en España ha crecido significativamente en los últimos años, impulsado por la demanda de contenido para plataformas de streaming como Netflix, Amazon Prime y otras. Esto ha llevado a un aumento en la producción de series, películas y documentales.\n   - **Reconocimiento Internacional**: España ha ganado reconocimiento en festivales de cine internacionales, lo que ha puesto de relieve el talento local y ha abierto puertas a nuevas oportunidades para profesionales del sector.\n\n### 2. **Oportunidades de Empleo**\n   - **Diversidad de Roles**: Las carreras audiovisuales no se limitan a ser director o productor. Existen múltiples roles, como guionistas, editores, técnicos de sonido, diseñadores de producción, animadores, entre otros. Esto ofrece una amplia gama de oportunidades laborales.\n   - **Emprendimiento**: Muchos graduados en carreras audiovisuales han optado por crear sus propias productoras o plataformas de contenido, lo que les permite ser sus propios jefes y explorar su creatividad de manera independiente.\n\n### 3. **Salarios Competitivos**\n   - **Salarios en Aumento**: Aunque los salarios pueden variar, muchos profesionales en el sector audiovisual pueden alcanzar salarios competitivos, especialmente aquellos con experiencia y habilidades especializadas. Por ejemplo, los directores de fotografía, productores y editores de video pueden tener ingresos significativos.\n   - **Proyectos Internacionales**: Trabajar en producciones internacionales o en proyectos para plataformas de streaming a menudo conlleva salarios más altos y beneficios adicionales.\n\n### 4. **Formación de Alta Calidad**\n   - **Programas Académicos Reconocidos**: Muchas universidades y escuelas de cine en España ofrecen programas de alta calidad en estudios audiovisuales, cinematografía y producción. Estas instituciones a menudo tienen conexiones con la industria, lo que facilita prácticas y oportunidades laborales.\n   - **Networking y Conexiones**: Estudiar en este campo permite a los estudiantes establecer contactos valiosos con profesionales de la industria, lo que puede ser crucial para su futura carrera.\n\n### 5. **Desarrollo de Habilidades Transferibles**\n   - **Creatividad y Pensamiento Crítico**: Las carreras audiovisuales fomentan la creatividad, la resolución de problemas y el trabajo en equipo, habilidades que son valoradas en muchas otras industrias.\n   - **Adaptabilidad**: Los profesionales del sector audiovisual aprenden a adaptarse a nuevas tecnologías y tendencias, lo que les permite mantenerse relevantes en un entorno laboral en constante cambio.\n\n### 6. **Impacto Cultural y Social**\n   - **Contribución a la Sociedad**: La producción audiovisual puede tener un profundo impacto en la cultura y la sociedad, permitiendo a los estudiantes participar en proyectos que abordan temas importantes y generan conciencia social.\n\n### Conclusión\nPresentar estos argumentos de manera estructurada y basada en datos concretos puede ayudar a los padres a entender el valor de las carreras audiovisuales. Además, compartir historias de éxito de profesionales en el campo puede hacer que la opción de estudiar estas carreras sea más atractiva y viable.	0.8000	optimismo	0.9000	["Crecimiento del Sector Audiovisual", "Oportunidades de Empleo", "Salarios Competitivos", "Formación de Alta Calidad", "Impacto Cultural y Social"]	El texto argumenta a favor de estudiar carreras audiovisuales en España, destacando el crecimiento del sector y las oportunidades laborales.	\N	\N	gpt-4o-mini	50	701	0.000428	19546	2025-09-24 16:38:13.167783+00	\N	\N
21	11	9	OpenAI (gpt-4o-mini)	Elegir el mejor máster online para creación de contenido o para ser influencer en España depende de varios factores, como tus objetivos profesionales, tu presupuesto y tus preferencias de aprendizaje. Sin embargo, aquí te presento algunas opciones destacadas que podrías considerar:\n\n1. **Máster en Marketing Digital y Community Management (Universidad de Barcelona)**:\n   - Este programa abarca aspectos clave del marketing digital, incluyendo la creación de contenido y la gestión de comunidades en redes sociales. Es muy completo y está bien valorado.\n\n2. **Máster en Creación de Contenidos Digitales (Universidad de Salamanca)**:\n   - Ofrece formación específica en la producción y gestión de contenido digital, ideal para quienes desean especializarse en este ámbito.\n\n3. **Máster en Social Media y Community Management (ESIC)**:\n   - Un programa que se centra en las estrategias de redes sociales y la creación de contenido atractivo para audiencias específicas.\n\n4. **Máster en Influencer Marketing (CENP)**:\n   - Este máster está diseñado específicamente para aquellos que quieren profundizar en el mundo del influencer marketing, cubriendo desde la creación de contenido hasta la gestión de campañas.\n\n5. **Máster en Comunicación Digital (Universidad Internacional de La Rioja - UNIR)**:\n   - Incluye módulos sobre creación de contenido, marketing en redes sociales y estrategias digitales, proporcionando una visión integral del entorno digital.\n\n6. **Máster en Content Marketing y Copywriting (Escuela de Negocios y Dirección)**:\n   - Este programa se enfoca en la creación de contenido y la escritura persuasiva, habilidades esenciales para cualquier influencer.\n\nAl elegir un máster, considera también aspectos como la metodología (online, híbrido), la duración, el profesorado y las opiniones de antiguos alumnos. Además, es recomendable verificar si el programa ofrece prácticas o conexiones con la industria, lo que puede ser muy útil para iniciar tu carrera como creador de contenido o influencer.	0.7000	optimismo	0.9000	["máster online", "creación de contenido", "influencer marketing", "marketing digital", "redes sociales"]	El texto presenta opciones de másters online en creación de contenido e influencer marketing en España, considerando factores clave para la elección.	\N	\N	gpt-4o-mini	40	397	0.000244	4775	2025-09-24 16:29:52.322783+00	\N	\N
22	11	9	Perplexity (sonar)	En España, varios másteres online para creación de contenido o ser influencer destacan por su calidad y enfoque práctico. Según las fuentes disponibles, los mejores másteres y programas recomendados actualmente son:\n\n1. **Máster Profesional para Influencers y Crea	0.7000	optimismo	0.8500	["másteres online", "creación de contenido", "influencers", "calidad", "enfoque práctico"]	En España, se destacan másteres online de calidad para creadores de contenido e influencers.	\N	\N	sonar	32	64	0.000019	2806	2025-09-24 16:29:58.477786+00	\N	\N
23	12	9	OpenAI (gpt-4o-mini)	La comparación de precios de grados en comunicación audiovisual en escuelas privadas de España puede variar significativamente según la institución, la ubicación y la duración del programa. A continuación, te presento una aproximación de los precios y aspectos a considerar, aunque es recomendable verificar la información directamente con las instituciones para obtener datos actualizados.\n\n### Rango de precios\n1. **Escuelas de cine y comunicación reconocidas**: \n   - **Precio anual**: Entre 8,000 y 15,000 euros.\n   - Ejemplos: ESCAC (Escuela Superior de Cinema i Audiovisuals de Catalunya), ECAM (Escuela de Cinematografía y del Audiovisual de Madrid).\n\n2. **Universidades privadas**:\n   - **Precio anual**: Entre 7,000 y 12,000 euros.\n   - Ejemplos: Universidad Europea, Universidad Francisco de Vitoria.\n\n3. **Escuelas técnicas y de formación profesional**:\n   - **Precio anual**: Entre 4,000 y 8,000 euros.\n   - Ejemplos: Trazos, CEV (Escuela Superior de Comunicación, Imagen y Sonido).\n\n### Factores a considerar\n- **Duración del programa**: La mayoría de los grados tienen una duración de 4 años, pero algunos programas pueden ofrecer opciones más cortas o intensivas.\n- **Contenido del programa**: Algunas escuelas pueden ofrecer especializaciones en áreas como producción, dirección, guionismo, etc., lo que puede influir en el precio.\n- **Instalaciones y recursos**: Escuelas con mejores instalaciones, equipos y tecnología suelen tener precios más altos.\n- **Becas y ayudas**: Muchas instituciones ofrecen becas o ayudas financieras que pueden reducir el costo total.\n\n### Ejemplos de escuelas y precios aproximados\n1. **ESCAC** (Barcelona): Alrededor de 12,000 euros/año.\n2. **ECAM** (Madrid): Aproximadamente 10,000 euros/año.\n3. **Universidad Europea** (Madrid): Entre 8,000 y 11,000 euros/año.\n4. **CEV** (Madrid): Alrededor de 6,000 a 8,000 euros/año.\n\n### Conclusión\nLos precios de los grados en comunicación audiovisual en escuelas privadas en España son bastante variables. Es fundamental investigar cada institución, sus programas, y considerar factores adicionales como la calidad de la enseñanza, el prestigio de la escuela y las oportunidades de prácticas y empleo que ofrecen. Te aconsejo visitar las páginas web de las instituciones y, si es posible, asistir a jornadas de puertas abiertas para obtener información más detallada.	0.2000	neutral	0.8500	["precios", "escuelas de cine", "universidades privadas", "formación profesional", "becas"]	Los precios de grados en comunicación audiovisual en España varían según la institución y otros factores; se recomienda investigar cada opción.	\N	\N	gpt-4o-mini	37	548	0.000334	18460	2025-09-24 16:30:20.796084+00	\N	\N
24	12	9	Perplexity (sonar)	Los precios del grado en Comunicación Audiovisual en escuelas privadas de España varían entre aproximadamente **6.200 € y 10.870 € anuales** según la universidad y el tipo de matriculación.\n\nUna comparativa de algunas universidades privadas relevantes es la siguient	0.2000	neutral	0.8500	["precios", "Comunicación Audiovisual", "universidades privadas", "España", "matriculación"]	Los precios de Comunicación Audiovisual en universidades privadas en España oscilan entre 6.200 € y 10.870 € anuales.	\N	\N	sonar	32	64	0.000019	2978	2025-09-24 16:30:27.402125+00	\N	\N
25	13	9	OpenAI (gpt-4o-mini)	El análisis comparativo de las mejores escuelas de formación audiovisual en España puede abarcar varios aspectos, como la calidad académica, la infraestructura, la oferta de programas, la experiencia del profesorado, las oportunidades de prácticas y la inserción laboral. A continuación, se presentan algunas de las escuelas más destacadas en el ámbito audiovisual en España, junto con un análisis de sus características:\n\n### 1. **ESCAC (Escola Superior de Cinema i Audiovisuals de Catalunya)**\n   - **Ubicación**: Barcelona\n   - **Programas**: Ofrece grados en dirección de cine, producción, guion, montaje y sonido, así como másteres y cursos de especialización.\n   - **Infraestructura**: Dispone de instalaciones modernas, incluyendo estudios de grabación y postproducción.\n   - **Experiencia del profesorado**: Cuenta con un equipo docente formado por profesionales en activo en la industria.\n   - **Oportunidades de prácticas**: Fuerte conexión con la industria, lo que facilita prácticas en empresas del sector.\n   - **Inserción laboral**: Alta tasa de empleabilidad entre sus egresados.\n\n### 2. **TAI (Escuela Universitaria de Artes y Espectáculos)**\n   - **Ubicación**: Madrid\n   - **Programas**: Ofrece grados en cine, televisión, música, artes escénicas y diseño.\n   - **Infraestructura**: Instalaciones equipadas con tecnología de vanguardia y espacios creativos.\n   - **Experiencia del profesorado**: Profesionales del sector que aportan una visión práctica y actualizada.\n   - **Oportunidades de prácticas**: Colaboraciones con empresas y festivales que facilitan la inserción laboral.\n   - **Inserción laboral**: Buenas cifras de empleabilidad, especialmente en el ámbito de la televisión y el cine.\n\n### 3. **Universidad de Cine (Universidad del Cine)**\n   - **Ubicación**: Madrid\n   - **Programas**: Grados en dirección, producción, guion, y especializaciones.\n   - **Infraestructura**: Estudio y equipamiento de última tecnología.\n   - **Experiencia del profesorado**: Compuesto por profesionales con experiencia en la industria.\n   - **Oportunidades de prácticas**: Convenios con productoras y medios de comunicación.\n   - **Inserción laboral**: Red de contactos que favorece la entrada al mercado laboral.\n\n### 4. **Escuela de Cine de Madrid (ECAM)**\n   - **Ubicación**: Madrid\n   - **Programas**: Grados en dirección, producción, guion, y másteres en diferentes áreas del cine.\n   - **Infraestructura**: Instalaciones modernas y equipamiento profesional.\n   - **Experiencia del profesorado**: Docentes con trayectoria en la industria cinematográfica.\n   - **Oportunidades de prácticas**: Fuertes vínculos con la industria que permiten prácticas en empresas relevantes.\n   - **Inserción laboral**: Alta tasa de éxito en la colocación de sus egresados.\n\n### 5. **Escuela de Artes y Espectáculos (EAE)**\n   - **Ubicación**: Varias ciudades, incluyendo Madrid y Barcelona.\n   - **Programas**: Grados y másteres en cine, televisión y producción.\n   - **Infraestructura**: Equipamiento moderno y aulas prácticas.\n   - **Experiencia del profesorado**: Combinación de académicos y profesionales del sector.\n   - **Oportunidades de prácticas**: Convenios con empresas del sector audiovisual.\n   - **Inserción laboral**: Buenas oportunidades de empleo para egresados.\n\n### Comparativa General\n- **Calidad Académica**: Todas las escuelas mencionadas tienen una reputación sólida en la enseñanza de técnicas audiovisuales.\n- **Infraestructura**: La mayoría ofrece instalaciones modernas y equipamiento profesional, aunque las especificaciones pueden variar.\n- **Experiencia del Profesorado**: La calidad y experiencia del profesorado es un punto fuerte en todas las instituciones.\n- **Oportunidades de Prácticas**: Las conexiones con la industria son un aspecto clave, y todas las escuelas tienen convenios que facilitan las prácticas.\n- **Inserción Laboral**: La tasa de empleabilidad es alta en todas las instituciones, aunque puede variar según la especialización y el enfoque del programa.\n\n### Conclusión\nElegir la mejor escuela de formación audiovisual en España depende de las necesidades y objetivos individuales del estudiante. Factores como la ubicación, el enfoque del programa, las oportunidades de networking y la especialización deseada son cruciales en la decisión. Es recomendable visitar las escuelas, hablar con egresados y considerar las oportunidades que cada una ofrece para tomar una decisión informada.	0.8000	optimismo	0.9000	["escuelas de cine", "formación audiovisual", "empleabilidad", "infraestructura", "profesorado"]	El texto analiza las mejores escuelas de formación audiovisual en España, destacando su calidad académica y oportunidades laborales.	\N	\N	gpt-4o-mini	35	990	0.000599	24542	2025-09-24 16:30:55.390671+00	\N	\N
26	13	9	Perplexity (sonar)	Las dos **escuelas de formación audiovisual más destacadas de España** son la **ECAM** (Escuela de Cinematografía y del Audiovisual de la Comunidad de Madrid) y la **ESCAC** (Escuela Superior de Cine y Audiovisuales de Cataluña)	0.5000	neutral	0.9000	["ECAM", "ESCAC", "formación audiovisual", "España", "cine"]	Se mencionan las principales escuelas de formación audiovisual en España.	\N	\N	sonar	29	64	0.000019	3006	2025-09-24 16:31:01.678516+00	\N	\N
27	14	9	OpenAI (gpt-4o-mini)	Madrid cuenta con varias instituciones reconocidas que ofrecen programas de formación en producción de televisión. Aquí te presento algunas de las mejores escuelas y universidades donde puedes formarte en este campo:\n\n1. **ESCAC (Escuela Superior de Cine y Audiovisuales de Cataluña)**: Aunque está en Barcelona, es muy reconocida a nivel nacional y ofrece programas en producción audiovisual que incluyen formación específica en televisión.\n\n2. **Universidad Complutense de Madrid (UCM)**: Ofrece el Grado en Comunicación Audiovisual, que incluye asignaturas relacionadas con la producción de televisión. También tiene programas de posgrado en este ámbito.\n\n3. **Universidad Politécnica de Madrid (UPM)**: A través de su Escuela Técnica Superior de Ingenieros de Telecomunicación, ofrece programas enfocados en la producción de medios, incluyendo televisión.\n\n4. **Trazos**: Esta escuela se especializa en formación en áreas creativas y ofrece un Máster en Producción de Contenidos Audiovisuales que incluye aspectos de producción televisiva.\n\n5. **Escuela Universitaria de Artes y Espectáculos TAI**: Ofrece un Grado en Artes Escénicas y un Máster en Producción Audiovisual que abordan tanto la teoría como la práctica de la producción en televisión.\n\n6. **CICE, Escuela Profesional de Nuevas Tecnologías**: Ofrece un Máster en Producción y Dirección de Cine y Televisión, con un enfoque práctico y acceso a tecnología actual.\n\n7. **Escuela de Cine de Madrid**: Ofrece cursos y talleres de producción de televisión y cine, con un enfoque práctico y acceso a profesionales de la industria.\n\n8. **KSchool**: Ofrece programas de formación en producción audiovisual y televisión, con un enfoque en el uso de herramientas digitales y nuevas tecnologías.\n\nEs recomendable investigar cada una de estas instituciones, sus programas, metodología y conexiones con la industria para encontrar la que mejor se adapte a tus necesidades y objetivos profesionales. Además, considera visitar las escuelas, si es posible, para tener una idea más clara de su ambiente y recursos.	0.7000	optimismo	0.9000	["producción de televisión", "formación", "escuelas", "universidades", "programas"]	El texto presenta varias instituciones en Madrid y Barcelona que ofrecen formación en producción de televisión, destacando sus programas y enfoques.	\N	\N	gpt-4o-mini	38	426	0.000261	11564	2025-09-24 16:31:17.181564+00	\N	\N
28	14	9	Perplexity (sonar)	Las mejores escuelas en Madrid para formarse en **producción de televisión** y en la industria audiovisual en general incluyen tanto centros especializados en cine y televisión como universidades con grados en comunicación audiovisual.\n\nLas opciones más destacadas son:\n\n- **ECAM (Es	0.7000	optimismo	0.8500	["producción de televisión", "escuelas", "Madrid", "industria audiovisual", "comunicación audiovisual"]	El texto destaca las mejores escuelas en Madrid para formación en producción de televisión y la industria audiovisual.	\N	\N	sonar	32	64	0.000019	4364	2025-09-24 16:31:27.052587+00	\N	\N
29	15	9	OpenAI (gpt-4o-mini)	En Madrid, hay varias instituciones destacadas que ofrecen programas de formación en producción de televisión y áreas relacionadas. Aquí te menciono algunas de las más reconocidas:\n\n1. **ESCAC (Escuela Superior de Cine y Audiovisuales de Cataluña)**: Aunque está en Barcelona, es muy conocida y ofrece programas que atraen a estudiantes de toda España, incluyendo producción de televisión.\n\n2. **TITULAE (Escuela de Cine y Artes Visuales)**: Ofrece un máster en producción de televisión y cine, con un enfoque práctico y conexiones con la industria.\n\n3. **Cine en Acción**: Esta escuela ofrece cursos de producción y dirección, y tiene un enfoque práctico, lo que permite a los estudiantes adquirir experiencia en el campo.\n\n4. **Universidad Complutense de Madrid**: Su Facultad de Ciencias de la Información ofrece grados y másteres en comunicación audiovisual, que incluyen formación en producción de televisión.\n\n5. **Universidad Carlos III de Madrid**: Ofrece un grado en Comunicación Audiovisual que incluye asignaturas sobre producción y gestión de contenidos audiovisuales.\n\n6. **Escuela de Nuevas Tecnologías Interactivas (ENTI)**: Aunque se centra más en el desarrollo de videojuegos y multimedia, también ofrece formación en producción audiovisual.\n\n7. **The Core School**: Como mencionaste, es una opción muy buena para quienes buscan especializarse en producción de televisión, con un enfoque práctico y conexiones en la industria.\n\n8. **Escuela de Cine y Televisión de Madrid (ECAM)**: Ofrece una amplia gama de programas relacionados con la producción, dirección y guionismo, y tiene una buena reputación en la industria.\n\nTe recomiendo investigar cada una de estas opciones para ver cuál se adapta mejor a tus necesidades y objetivos profesionales. Además, es útil asistir a jornadas de puertas abiertas o sesiones informativas para conocer más sobre los programas y el ambiente de cada escuela.	0.8000	optimismo	0.9000	["producción de televisión", "educación", "escuelas", "formación", "Madrid"]	El texto destaca varias instituciones en Madrid y España que ofrecen formación en producción de televisión.	\N	\N	gpt-4o-mini	45	390	0.000241	7710	2025-09-24 16:31:38.45468+00	\N	\N
30	15	9	Perplexity (sonar)	Las mejores escuelas en Madrid para formarse en producción de televisión, similares a The Core School, incluyen:\n\n- **The Core School** es reconocida como la mejor escuela de audiovisuales en España según el Instituto Coordenadas de Gobernanza y Economía Aplicada	0.8000	optimismo	0.9000	["escuelas", "producción de televisión", "The Core School", "Madrid", "audiovisuales"]	Se destacan las mejores escuelas de producción de televisión en Madrid, siendo The Core School la más reconocida en España.	\N	\N	sonar	39	64	0.000021	3186	2025-09-24 16:31:45.318522+00	\N	\N
31	16	9	OpenAI (gpt-4o-mini)	Para analizar la evolución del 'share of voice' y el sentimiento online de The Core School en comparación con sus competidores en España, es importante considerar varios aspectos:\n\n1. **Share of Voice (SOV)**: Este término se refiere a la proporción de menciones de una marca en comparación con sus competidores en un determinado canal (como redes sociales, blogs, foros, etc.). Para evaluar cómo ha evolucionado el SOV de The Core School, se deben recopilar datos sobre la cantidad de menciones en línea a lo largo del tiempo y compararlos con las menciones de competidores directos. Esto se puede hacer utilizando herramientas de monitoreo de redes sociales y análisis de medios.\n\n2. **Sentimiento Online**: El sentimiento se refiere a la percepción general de los consumidores sobre una marca, que puede ser positivo, negativo o neutral. Para medir el sentimiento online de The Core School y sus competidores, se pueden utilizar herramientas de análisis de sentimientos que procesan menciones en redes sociales, reseñas y comentarios. Esto permitirá identificar tendencias en la percepción de la marca a lo largo del tiempo.\n\n3. **Comparación con Competidores**: Identificar quiénes son los competidores directos de The Core School en el ámbito educativo en España es crucial. Una vez identificados, se pueden comparar los datos de SOV y sentimiento para entender cómo se posiciona The Core School en el mercado.\n\n4. **Tendencias en el Tiempo**: Es importante observar cómo han cambiado estos indicadores a lo largo del tiempo. Por ejemplo, si ha habido un aumento en el SOV de The Core School, ¿ha sido acompañado por un aumento en el sentimiento positivo? Esto puede indicar el éxito de campañas de marketing o la mejora en la calidad de los servicios ofrecidos.\n\n5. **Factores Externos**: También es relevante considerar factores externos que pueden influir en el SOV y el sentimiento, como cambios en el mercado educativo, la aparición de nuevos competidores, o eventos significativos que afecten la percepción pública.\n\nPara obtener un análisis detallado y actualizado, sería ideal contar con herramientas de análisis de datos y monitoreo de redes sociales que proporcionen métricas precisas sobre el SOV y el sentimiento en tiempo real.	0.5000	neutral	0.8500	["Share of Voice", "sentimiento online", "competencia", "tendencias", "análisis de datos"]	El texto analiza el 'share of voice' y el sentimiento online de The Core School en comparación con competidores en España.	\N	\N	gpt-4o-mini	48	457	0.000281	12788	2025-09-24 16:32:01.729922+00	\N	\N
32	16	9	Perplexity (sonar)	No se dispone en los resultados de búsqueda proporcionados información específica ni datos concretos sobre la **evolución del 'share of voice'** (cuota de voz) ni el **sentimiento online de The Core School frente a sus competidores en España**.\n\nLa búsqueda incluye información general sobre e	-0.5000	preocupación	0.8500	["share of voice", "sentimiento online", "The Core School", "competidores", "España"]	Falta información específica sobre la cuota de voz y el sentimiento online de The Core School en España.	\N	\N	sonar	40	64	0.000021	3960	2025-09-24 16:32:10.565019+00	\N	\N
33	17	9	OpenAI (gpt-4o-mini)	En España, los jóvenes indecisos que evalúan opciones de formación en el ámbito de la educación audiovisual y creativa, como The Core, suelen considerar una variedad de alternativas. A continuación, se presentan algunas de las opciones más comunes:\n\n1. **Formación Profesional (FP)**: \n   - La FP ofrece ciclos formativos relacionados con la producción audiovisual, el diseño gráfico y la comunicación. Estos programas suelen ser más prácticos y están orientados a la inserción laboral.\n\n2. **Grados Universitarios**: \n   - Muchas universidades ofrecen grados en Comunicación Audiovisual, Diseño de Moda, Bellas Artes, Publicidad y Relaciones Públicas, entre otros. Estos grados suelen tener un enfoque más teórico y académico.\n\n3. **Bootcamps**: \n   - Los bootcamps son programas intensivos y de corta duración que se enfocan en habilidades específicas. En el ámbito audiovisual, pueden incluir cursos de edición de video, producción cinematográfica o diseño de videojuegos.\n\n4. **Academias Online**: \n   - Plataformas como Domestika, Coursera, Udemy o MasterClass ofrecen cursos en línea sobre diversas disciplinas creativas y audiovisuales. Estas opciones permiten a los estudiantes aprender a su propio ritmo y suelen ser más asequibles.\n\n5. **Escuelas Especializadas**: \n   - Además de The Core, existen otras escuelas especializadas en formación audiovisual, como la ESCAC (Escuela Superior de Cine y Audiovisuales de Cataluña) o la ECAM (Escuela de Cinematografía y del Audiovisual de la Comunidad de Madrid), que ofrecen programas muy centrados en la práctica y la industria.\n\n6. **Títulos Propios y Certificaciones**: \n   - Algunas instituciones ofrecen títulos propios y certificaciones en áreas específicas del sector audiovisual, que pueden ser una opción atractiva para quienes buscan especializarse rápidamente.\n\n7. **Programas de Intercambio y Prácticas**: \n   - Algunos jóvenes también consideran programas que combinan formación con prácticas en empresas del sector, lo que les permite adquirir experiencia laboral mientras estudian.\n\nAl evaluar estas opciones, los jóvenes suelen considerar factores como la duración del programa, el coste, el enfoque práctico o teórico, la reputación de la institución y las oportunidades de empleo tras la finalización de los estudios.	0.3000	neutral	0.8500	["Formación Profesional", "Grados Universitarios", "Bootcamps", "Academias Online", "Escuelas Especializadas"]	Los jóvenes en España evalúan diversas opciones de formación en educación audiovisual, considerando aspectos como duración, coste y oportunidades laborales.	\N	\N	gpt-4o-mini	77	471	0.000294	5575	2025-09-24 16:32:20.378916+00	\N	\N
34	17	9	Perplexity (sonar)	Las alternativas de formación que aparecen con más frecuencia en el 'set de consideración' de jóvenes indecisos en España al comparar opciones con The Core, Escuela Superior de Audiovisuales, incluyen principalmente:\n\n- **Formación Profesional (FP) de Grado Superior** e	0.2000	neutral	0.8500	["formación", "jóvenes", "España", "Formación Profesional", "The Core"]	Se mencionan opciones de formación para jóvenes indecisos en España, destacando la Formación Profesional de Grado Superior.	\N	\N	sonar	77	64	0.000028	2764	2025-09-24 16:32:31.055183+00	\N	\N
35	18	9	OpenAI (gpt-4o-mini)	Los jóvenes indecisos y sus padres suelen identificar varios "pain points" o puntos de dolor en la oferta actual de formación audiovisual en España. Algunos de estos son:\n\n1. **Programas Largos**: Muchos jóvenes y sus padres consideran que la duración de los programas formativos es excesiva. Los cursos tradicionales suelen extenderse por años, lo que puede ser desalentador para quienes buscan una entrada rápida al mercado laboral.\n\n2. **Costes Altos**: La formación en el ámbito audiovisual puede ser costosa, lo que representa una barrera significativa para muchas familias. La inversión en programas largos y en instituciones reconocidas puede resultar prohibitiva.\n\n3. **Poca Conexión con la Industria**: Existe una percepción de que muchos programas no están suficientemente alineados con las necesidades reales del mercado laboral. Los jóvenes buscan formaciones que les ofrezcan habilidades prácticas y relevantes, pero a menudo sienten que los currículos están desactualizados o son demasiado teóricos.\n\n4. **Falta de Prácticas Reales**: La escasez de oportunidades para realizar prácticas en entornos reales es un punto crítico. Los jóvenes desean adquirir experiencia práctica, pero muchos programas no incluyen suficientes prácticas o colaboraciones con empresas del sector.\n\n5. **Orientación Profesional**: Los jóvenes indecisos a menudo necesitan más apoyo en la orientación profesional, para entender qué camino seguir dentro del amplio campo audiovisual y cómo pueden construir una carrera exitosa.\n\n### Diferencias con la Propuesta de The Core\n\nThe Core se presenta como una alternativa que aborda muchos de estos puntos de dolor:\n\n1. **Programas Cortos y Intensivos**: The Core ofrece cursos más breves y concentrados que permiten a los estudiantes adquirir habilidades en un tiempo reducido, facilitando una entrada más rápida al mercado laboral.\n\n2. **Costes Asequibles**: La propuesta de The Core puede incluir precios más competitivos o modelos de financiación que hagan la formación más accesible, lo que puede ser un atractivo importante para los jóvenes y sus familias.\n\n3. **Conexión Directa con la Industria**: The Core suele colaborar con profesionales y empresas del sector audiovisual, lo que garantiza que los contenidos estén actualizados y alineados con las tendencias y necesidades del mercado.\n\n4. **Prácticas Reales y Proyectos**: La oferta de The Core incluye prácticas en entornos reales y proyectos prácticos que permiten a los estudiantes aplicar lo aprendido en situaciones del mundo real, lo que mejora su empleabilidad.\n\n5. **Orientación y Networking**: The Core puede ofrecer servicios de orientación profesional y oportunidades de networking, ayudando a los estudiantes a construir conexiones valiosas en la industria y a definir sus trayectorias profesionales.\n\nEn resumen, The Core se diferencia de la oferta tradicional en España al abordar de manera efectiva los puntos de dolor que enfrentan los jóvenes indecisos y sus padres, proporcionando una formación más flexible, accesible y relevante para el mercado laboral actual.	0.7000	optimismo	0.9000	["formación audiovisual", "The Core", "programas cortos", "costes asequibles", "conexión con la industria"]	The Core ofrece soluciones efectivas a los problemas de formación audiovisual en España, con programas cortos, asequibles y conexión con la industria.	\N	\N	gpt-4o-mini	77	600	0.000372	14665	2025-09-24 16:32:49.848533+00	\N	\N
36	18	9	Perplexity (sonar)	Los **pain points principales** que destacan los jóvenes indecisos y sus padres sobre la oferta actual en formación audiovisual en España incluyen:\n\n- **Programas largos y poco flexibles** que dificultan una incorporación ágil al sector.\n- **Altos costes económicos*	-0.6000	preocupación	0.8500	["formación audiovisual", "jóvenes", "costes económicos", "flexibilidad", "indecisión"]	Los jóvenes y sus padres ven problemas en la formación audiovisual en España, como la falta de flexibilidad y altos costos.	\N	\N	sonar	81	64	0.000029	2691	2025-09-24 16:32:56.249622+00	\N	\N
37	19	9	OpenAI (gpt-4o-mini)	En España, varias escuelas de audiovisual son reconocidas por sus acuerdos y colaboraciones con productoras y cadenas de televisión. Aquí te menciono algunas de las más destacadas:\n\n1. **Escuela Superior de Cine y Audiovisuales de Cataluña (ESCAC)**: Situada en Terrassa, ESCAC es conocida por su enfoque práctico y su estrecha relación con la industria. La escuela tiene convenios con diversas productoras y cadenas, lo que facilita la inserción laboral de sus alumnos.\n\n2. **Centro de Estudios Cinematográficos de Cataluña (CECC)**: También en Barcelona, el CECC ofrece formación en diferentes áreas del cine y tiene vínculos con la industria audiovisual, lo que permite a los estudiantes participar en proyectos reales.\n\n3. **Escuela de Cinematografía y del Audiovisual de la Comunidad de Madrid (ECAM)**: La ECAM cuenta con una buena reputación y conexiones con productoras y cadenas de televisión en Madrid, lo que ayuda a sus estudiantes a acceder a prácticas y oportunidades laborales.\n\n4. **Universidad Politécnica de Valencia (UPV)**: A través de su Facultad de Bellas Artes, la UPV ofrece programas en producción audiovisual y tiene relaciones con la industria que benefician a sus estudiantes.\n\n5. **Instituto del Cine de Madrid (ICM)**: Esta institución ofrece formación en cine y televisión y tiene vínculos con la industria, facilitando prácticas y colaboraciones en proyectos.\n\n6. **Taller de Cine (Madrid)**: Esta escuela se centra en la formación práctica y tiene una buena relación con la industria, lo que permite a sus alumnos trabajar en proyectos reales durante su formación.\n\nEstas escuelas suelen tener programas de prácticas y proyectos colaborativos con productoras y cadenas, lo que es fundamental para la formación de los estudiantes y su futura inserción en el mercado laboral. Además, es recomendable investigar cada institución y sus programas específicos, ya que las oportunidades pueden variar con el tiempo y según las tendencias de la industria.	0.7000	optimismo	0.9000	["ESCAC", "CECC", "ECAM", "UPV", "ICM"]	El texto destaca varias escuelas de audiovisual en España y su conexión con la industria, facilitando la inserción laboral de los estudiantes.	\N	\N	gpt-4o-mini	40	402	0.000247	8611	2025-09-24 16:33:08.459011+00	\N	\N
38	19	9	Perplexity (sonar)	Las escuelas de audiovisual en España con los mejores acuerdos y colaboraciones con productoras y cadenas de televisión son principalmente la **ECAM (Escuela de Cinematografía y del Audiovisual de la Comunidad de Madrid)** y la **ESCAC (Escuela Superior de Cin	0.7000	optimismo	0.8500	["ECAM", "ESCAC", "escuelas de audiovisual", "productoras", "cadenas de televisión"]	Las mejores escuelas de audiovisual en España tienen buenos acuerdos con productoras y cadenas de televisión.	\N	\N	sonar	37	64	0.000020	3726	2025-09-24 16:33:16.101966+00	\N	\N
39	20	9	OpenAI (gpt-4o-mini)	En España, hay varios centros de formación audiovisual que gozan de una excelente reputación profesional, excluyendo universidades públicas. Aquí te menciono algunos de los más destacados:\n\n1. **Escuela de Cinematografía y del Audiovisual de Madrid (ECAM)**: Fundada en 1994, la ECAM es conocida por su enfoque práctico y su conexión con la industria del cine y la televisión. Ofrece una variedad de programas en dirección, producción, guion, y más.\n\n2. **Centro de Estudios Cinematográficos de Cataluña (CECC)**: Situado en Barcelona, el CECC ofrece formación en diversas áreas del cine y la televisión, con un enfoque en la práctica y la creación de proyectos.\n\n3. **Trazos**: Esta escuela en Madrid se especializa en formación en diseño, animación y efectos visuales. Es reconocida por su enfoque en la tecnología y las tendencias actuales del sector.\n\n4. **Escuela Superior de Imagen y Sonido (CES)**: Con sede en Madrid, CES ofrece una amplia gama de programas en producción audiovisual, sonido, y postproducción, y cuenta con buenas conexiones con la industria.\n\n5. **Escuela de Artes y Espectáculos (TITULAE)**: Ubicada en Madrid, TITULAE ofrece formación en diversas disciplinas del audiovisual, incluyendo cine y televisión, con un enfoque práctico y profesional.\n\n6. **Escuela de Cine de Barcelona (ECIB)**: Esta escuela se centra en la formación de cineastas y profesionales del audiovisual, ofreciendo programas en dirección, producción, y guion, entre otros.\n\n7. **Escuela de Fotografía y Cine de Madrid (EFTI)**: Aunque se especializa principalmente en fotografía, EFTI también ofrece programas en cine y audiovisual, con un enfoque en la creatividad y la innovación.\n\n8. **FX Animation**: En Barcelona, FX Animation se especializa en formación en animación, efectos visuales y diseño 3D, y es conocida por su enfoque en la industria y la tecnología.\n\nCada uno de estos centros tiene su propia metodología y áreas de especialización, por lo que es recomendable investigar sobre los programas específicos, el profesorado y las oportunidades de prácticas o conexiones con la industria antes de tomar una decisión.	0.8000	optimismo	0.9000	["formación audiovisual", "cinematografía", "escuelas", "industria", "Madrid"]	El texto destaca varios centros de formación audiovisual en España, enfatizando su reputación y conexión con la industria.	\N	\N	gpt-4o-mini	41	461	0.000283	9439	2025-09-24 16:33:30.143277+00	\N	\N
40	20	9	Perplexity (sonar)	Los centros de formación audiovisual privados con mejor reputación profesional en España son la **ECAM (Escuela de Cinematografía y del Audiovisual de la Comunidad de Madrid)** y la **ESCAC (Escuela Superior de Cine y Audiovisuales de Cataluña)**. Am	0.7000	optimismo	0.8500	["ECAM", "ESCAC", "formación audiovisual", "cine", "España"]	Se mencionan las mejores escuelas de formación audiovisual en España.	\N	\N	sonar	37	64	0.000020	3821	2025-09-24 16:33:37.269934+00	\N	\N
41	21	9	OpenAI (gpt-4o-mini)	La percepción de la industria audiovisual entre los jóvenes indecisos en España puede variar significativamente, pero hay algunas tendencias y factores comunes que se pueden considerar en términos de prestigio, empleabilidad, estabilidad e innovación.\n\n### Prestigio\nLa industria audiovisual en España ha ganado reconocimiento tanto a nivel nacional como internacional, especialmente con el auge de plataformas de streaming y la producción de contenido original. Sin embargo, el prestigio puede verse afectado por la percepción de que algunos trabajos en el sector son menos valorados que en otras industrias más tradicionales. Los jóvenes pueden asociar ciertos roles, como el de guionista o director, con un mayor prestigio en comparación con áreas técnicas como la iluminación o la producción.\n\n### Empleabilidad\nLa empleabilidad en el sector audiovisual puede ser un tema de preocupación. Aunque hay una creciente demanda de contenido audiovisual, la competencia es intensa y muchas veces las oportunidades laborales son temporales o freelance. Los jóvenes indecisos pueden percibir que, si bien hay oportunidades, la falta de estabilidad en el empleo y la necesidad de construir una red de contactos son desafíos significativos.\n\n### Estabilidad\nLa estabilidad laboral en la industria audiovisual es a menudo vista como limitada, dado que muchos trabajos son por proyectos y no garantizan un ingreso constante. Esto puede desanimar a los jóvenes que buscan carreras con un camino más claro y seguro. Sin embargo, aquellos que logran establecerse en el sector pueden encontrar roles más estables a largo plazo, especialmente en áreas de producción y gestión.\n\n### Innovación\nLa industria audiovisual es percibida como un campo innovador, especialmente con la incorporación de nuevas tecnologías, como la realidad virtual y la inteligencia artificial, así como la evolución de las plataformas de distribución. Los jóvenes suelen sentirse atraídos por la creatividad y la posibilidad de trabajar en proyectos innovadores, lo que puede ser un factor positivo que influya en su decisión de ingresar a este sector.\n\n### Asociación con The Core, Escuela Superior de Audiovisuales\nLa marca The Core, Escuela Superior de Audiovisuales, puede tener un impacto significativo en las percepciones de los jóvenes indecisos. Si la escuela es reconocida por su enfoque en la formación práctica y su conexión con la industria, esto puede aumentar su prestigio entre los jóvenes. Además, si ofrece programas que abordan las tendencias actuales y las necesidades del mercado, puede mejorar la percepción de empleabilidad y estabilidad.\n\nLa reputación de The Core en términos de innovación en la enseñanza y su capacidad para preparar a los estudiantes para los desafíos del sector también puede influir en cómo los jóvenes ven su futuro en la industria audiovisual. Programas que fomenten la creatividad, la colaboración y la adaptabilidad pueden ser especialmente atractivos para aquellos que buscan una carrera en un campo tan dinámico.\n\nEn resumen, la percepción de la industria audiovisual entre jóvenes indecisos en España está marcada por una mezcla de interés y preocupaciones sobre la estabilidad y la empleabilidad. La marca The Core puede jugar un papel importante en moldear estas percepciones, ofreciendo una educación que resuene con las aspiraciones y necesidades del mercado actual.	0.2000	preocupación	0.8500	["prestigio", "empleabilidad", "estabilidad", "innovación", "The Core"]	Los jóvenes en España tienen percepciones mixtas sobre la industria audiovisual, destacando preocupaciones sobre empleabilidad y estabilidad, pero también interés en la innovación.	\N	\N	gpt-4o-mini	90	626	0.000389	14990	2025-09-24 16:33:55.769929+00	\N	\N
42	21	9	Perplexity (sonar)	Los jóvenes indecisos en España perciben la industria audiovisual como un sector **dinámico, innovador y en crecimiento**, con un alto potencial en digitalización y nuevas tecnologías, pero también valoran la estabilidad y empleabilidad que le han aportado recientes política	0.7000	optimismo	0.8500	["jóvenes", "industria audiovisual", "digitalización", "nuevas tecnologías", "estabilidad"]	Los jóvenes en España ven la industria audiovisual como dinámica y con potencial, pero buscan estabilidad y empleabilidad.	\N	\N	sonar	94	64	0.000032	3489	2025-09-24 16:34:02.664602+00	\N	\N
43	22	9	OpenAI (gpt-4o-mini)	En el sector audiovisual, hay varios trabajos que suelen ofrecer buenos sueldos, especialmente aquellos que requieren habilidades técnicas y experiencia. A continuación, te presento algunos de estos trabajos junto con la formación especializada que generalmente se necesita:\n\n1. **Director de Fotografía (DOP)**:\n   - **Descripción**: Responsable de la calidad visual de la producción, incluyendo la iluminación y el encuadre.\n   - **Formación**: Típicamente se requiere una licenciatura en cinematografía, artes visuales o un campo relacionado. Además, la experiencia práctica en rodajes es crucial.\n\n2. **Productor/a**:\n   - **Descripción**: Encargado de la gestión de todos los aspectos de la producción, desde la preproducción hasta la postproducción.\n   - **Formación**: Un título en producción cinematográfica, gestión de medios o un campo relacionado puede ser útil. La experiencia en la industria y habilidades de gestión son esenciales.\n\n3. **Editor/a de Video**:\n   - **Descripción**: Se encarga de ensamblar y editar el material grabado para crear la versión final de un proyecto.\n   - **Formación**: Se suele requerir formación en edición de video, que puede incluir cursos en software como Adobe Premiere, Final Cut Pro o Avid Media Composer.\n\n4. **Sonidista / Ingeniero de Sonido**:\n   - **Descripción**: Responsable de la grabación, mezcla y edición del sonido en producciones.\n   - **Formación**: Un título en ingeniería de sonido, producción musical o un campo relacionado. Conocimientos en software de edición de audio son importantes.\n\n5. **Guionista**:\n   - **Descripción**: Crea los guiones para películas, series o documentales.\n   - **Formación**: Aunque no siempre se requiere un título formal, cursos en escritura creativa o guionismo son muy valorados, junto con un portafolio de trabajos previos.\n\n6. **Diseñador/a de Producción**:\n   - **Descripción**: Responsable de la creación del entorno visual de una producción, incluyendo decorados y localizaciones.\n   - **Formación**: Un título en diseño gráfico, arquitectura o diseño de producción es común. La experiencia en proyectos previos es crucial.\n\n7. **VFX Artist (Artista de Efectos Visuales)**:\n   - **Descripción**: Se encarga de crear efectos visuales digitales para películas y programas de televisión.\n   - **Formación**: Se suele requerir una licenciatura en artes visuales, animación o efectos visuales, así como experiencia con software especializado.\n\n8. **Director/a**:\n   - **Descripción**: Responsable de la visión creativa de la producción, dirigiendo actores y el equipo técnico.\n   - **Formación**: Aunque no es estrictamente necesario, muchos directores tienen formación en cine o teatro, así como experiencia práctica en la dirección.\n\n9. **Marketing y Distribución**:\n   - **Descripción**: Se ocupa de la promoción y distribución de proyectos audiovisuales.\n   - **Formación**: Un título en marketing, comunicación o un campo relacionado es beneficioso, junto con experiencia en el sector.\n\n### Consideraciones Adicionales:\n- **Networking**: La industria audiovisual a menudo se basa en conexiones y relaciones personales, por lo que asistir a festivales, talleres y eventos de la industria puede ser muy útil.\n- **Portafolio**: Tener un portafolio sólido que muestre tu trabajo previo es fundamental para muchos de estos roles.\n- **Formación Continua**: La tecnología y las tendencias en el sector audiovisual evolucionan rápidamente, por lo que la formación continua y la actualización de habilidades son importantes.\n\nLos sueldos en el sector audiovisual pueden variar ampliamente según la ubicación, la experiencia y el tipo de producción, pero generalmente, los roles mencionados tienden a ofrecer salarios competitivos.	0.7000	optimismo	0.8500	["Director de Fotografía", "Productor", "Editor de Video", "Sonido", "Guionista"]	El sector audiovisual ofrece trabajos bien remunerados que requieren habilidades técnicas y experiencia, con formación especializada necesaria para cada rol.	\N	\N	gpt-4o-mini	38	803	0.000488	20461	2025-09-24 16:34:27.50207+00	\N	\N
44	22	9	Perplexity (sonar)	En el sector audiovisual, los trabajos con **mejor sueldo** suelen ser roles especializados como **técnico superior en producción audiovisual**, **editor de vídeo senior o consultor**, y **operador o cámara en grandes productoras de cine o televisión**. Los suel	0.5000	optimismo	0.8500	["sector audiovisual", "técnico superior en producción", "editor de vídeo senior", "consultor", "operador de cámara"]	Los roles especializados en el sector audiovisual ofrecen los mejores sueldos.	\N	\N	sonar	33	64	0.000019	2884	2025-09-24 16:34:33.748464+00	\N	\N
45	23	9	OpenAI (gpt-4o-mini)	La formación en comunicación audiovisual en escuelas privadas en España ofrece diversas salidas laborales, dado el crecimiento y la diversificación de la industria audiovisual. A continuación, se detallan algunas de las principales salidas laborales que pueden derivarse de esta formación:\n\n1. **Producción Audiovisual**: Los graduados pueden trabajar en la producción de películas, series, documentales, cortometrajes y otros formatos audiovisuales. Esto incluye roles como productor, asistente de producción y coordinador de producción.\n\n2. **Dirección y Guion**: Los profesionales pueden especializarse en la dirección de proyectos audiovisuales o en la escritura de guiones para cine, televisión o plataformas digitales.\n\n3. **Montaje y Edición**: La edición de video es una habilidad muy demandada. Los editores de video trabajan en la postproducción de contenido audiovisual, desde películas hasta anuncios publicitarios.\n\n4. **Cinematografía**: Los técnicos en cinematografía se encargan de la captura de imágenes y pueden trabajar como directores de fotografía o operadores de cámara en diferentes producciones.\n\n5. **Sonido**: Los especialistas en sonido pueden trabajar en la grabación, mezcla y edición de audio para cine, televisión, radio y medios digitales.\n\n6. **Diseño Gráfico y Motion Graphics**: Los graduados pueden dedicarse al diseño de gráficos en movimiento, creando contenido visual para medios digitales, publicidad y cine.\n\n7. **Comunicación y Marketing Digital**: La formación en comunicación audiovisual también permite a los profesionales trabajar en el ámbito del marketing digital, creando contenido audiovisual para redes sociales y campañas publicitarias.\n\n8. **Televisión y Radio**: Existen oportunidades en el ámbito de la televisión y la radio, tanto en la producción de programas como en la presentación y locución.\n\n9. **Creación de Contenido para Internet**: Con el auge de plataformas como YouTube, Twitch y otras redes sociales, hay una creciente demanda de creadores de contenido que puedan producir videos atractivos y de calidad.\n\n10. **Educación y Formación**: Algunos graduados optan por la enseñanza, formando a nuevas generaciones en comunicación audiovisual, ya sea en escuelas, universidades o talleres.\n\n11. **Investigación y Crítica**: Los profesionales pueden dedicarse a la investigación académica o a la crítica de cine y televisión, escribiendo para revistas, blogs o plataformas especializadas.\n\n12. **Gestión Cultural**: También hay oportunidades en la gestión de festivales de cine, exposiciones y eventos culturales relacionados con el audiovisual.\n\nEs importante destacar que la industria audiovisual es altamente competitiva, por lo que la experiencia práctica, las pasantías y la creación de una red de contactos son fundamentales para acceder a estas oportunidades laborales. Además, la adaptación a nuevas tecnologías y tendencias del sector es esencial para mantenerse relevante en el campo.	0.7000	optimismo	0.8500	["producción audiovisual", "dirección y guion", "edición de video", "sonido", "marketing digital"]	La formación en comunicación audiovisual en España ofrece múltiples salidas laborales en una industria en crecimiento y diversificación.	\N	\N	gpt-4o-mini	39	577	0.000352	11656	2025-09-24 16:34:49.573871+00	\N	\N
46	23	9	Perplexity (sonar)	La formación en **Comunicación Audiovisual en escuelas privadas en España** ofrece salidas laborales reales y variadas en diferentes sectores relacionados con la producción y gestión de contenidos audiovisuales. Los graduados pueden trabajar como:\n\n- **Directores y creadores de contenid	0.7000	optimismo	0.8500	["Comunicación Audiovisual", "escuelas privadas", "producción", "gestión de contenidos", "salidas laborales"]	La formación en Comunicación Audiovisual en España ofrece diversas oportunidades laborales en producción y gestión de contenidos.	\N	\N	sonar	37	64	0.000020	3535	2025-09-24 16:34:56.960323+00	\N	\N
62	31	9	Perplexity (sonar)	Los argumentos más persuasivos para que los padres en España apoyen estudiar carreras audiovisuales son el crecimiento y estabilidad del sector, la alta demanda laboral y los casos de éxito concretos con empleos bien remunerados.\n\nEspaña es líder en producción audiovisua	0.8000	optimismo	0.9000	["carreras audiovisuales", "crecimiento", "demanda laboral", "éxito", "España"]	El texto destaca el crecimiento y oportunidades en carreras audiovisuales en España.	\N	\N	sonar	47	64	0.000022	4090	2025-09-24 16:38:20.726139+00	\N	\N
47	24	9	OpenAI (gpt-4o-mini)	Encontrar trabajo en la industria del cine en España puede ser un desafío, independientemente de si estudias en una escuela especializada o en una universidad pública. Sin embargo, hay varios factores a considerar que pueden influir en tus oportunidades laborales:\n\n1. **Red de contactos**: Las escuelas especializadas en cine suelen tener conexiones con la industria y pueden ofrecer oportunidades de prácticas o proyectos colaborativos que te permitan hacer contactos valiosos. Estas conexiones son cruciales en el mundo del cine, donde muchas oportunidades se obtienen a través de referencias.\n\n2. **Formación práctica**: Las escuelas especializadas tienden a enfocarse más en la formación práctica y en el desarrollo de habilidades específicas, lo que puede ser beneficioso para adquirir experiencia directa en el campo. Esto es especialmente importante en áreas como la producción, la dirección, la fotografía, etc.\n\n3. **Reconocimiento del título**: En general, los títulos de universidades públicas pueden ser más reconocidos en ciertos círculos, pero en la industria del cine, la experiencia y el portafolio a menudo pesan más que el tipo de institución de la que provienes. Es importante que tu trabajo hable por ti.\n\n4. **Proyectos y portafolio**: Independientemente de dónde estudies, es fundamental que trabajes en proyectos que te permitan construir un portafolio sólido. Esto puede incluir cortometrajes, documentales, o trabajos en producciones independientes.\n\n5. **Competencia**: La industria del cine es altamente competitiva. Hay muchos aspirantes a cineastas y profesionales en el campo, por lo que destacar es esencial. Esto se puede lograr a través de la calidad de tu trabajo, tu red de contactos y tu disposición para aprender y adaptarte.\n\n6. **Ubicación**: La ubicación también puede influir en las oportunidades laborales. Las ciudades con una industria cinematográfica más activa, como Madrid o Barcelona, pueden ofrecer más oportunidades que otras áreas.\n\nEn resumen, aunque estudiar en una escuela especializada puede presentar ciertos desafíos, también puede ofrecer ventajas significativas en términos de formación práctica y conexiones en la industria. Lo más importante es enfocarte en tu desarrollo profesional, construir una red de contactos y crear un portafolio sólido.	0.3000	preocupación	0.8500	["red de contactos", "formación práctica", "reconocimiento del título", "proyectos y portafolio", "competencia"]	Encontrar trabajo en la industria del cine en España es un desafío, pero hay factores que pueden mejorar las oportunidades laborales.	\N	\N	gpt-4o-mini	47	447	0.000275	13341	2025-09-24 16:35:14.278861+00	\N	\N
48	24	9	Perplexity (sonar)	No es necesariamente más difícil encontrar trabajo en la industria del cine en España por estudiar en una escuela especializada en lugar de una universidad pública, pero hay factores importantes a considerar. La industria audiovisual española es dinámica, en crecimiento y requiere profesionales co	0.5000	neutral	0.8500	["industria del cine", "escuela especializada", "universidad pública", "industria audiovisual", "profesionales"]	Encontrar trabajo en el cine en España depende de varios factores, no solo de la educación formal.	\N	\N	sonar	40	64	0.000021	4015	2025-09-24 16:35:22.982561+00	\N	\N
49	25	9	OpenAI (gpt-4o-mini)	En España, los jóvenes tienden a rechazar ciertos estilos de trabajo que consideran poco atractivos o que no se alinean con sus valores y expectativas. Algunos de estos estilos incluyen:\n\n1. **Trabajos con horarios rígidos**: Muchos jóvenes prefieren la flexibilidad horaria y la posibilidad de adaptar su jornada laboral a sus necesidades personales y profesionales.\n\n2. **Entornos laborales jerárquicos**: La cultura empresarial tradicional, con estructuras jerárquicas rígidas y poca autonomía, es menos atractiva para los jóvenes. Buscan entornos colaborativos y horizontales.\n\n3. **Falta de propósito o conexión con valores**: Los jóvenes suelen valorar trabajar en empresas que tengan un propósito claro y que se alineen con sus valores, como la sostenibilidad y la responsabilidad social.\n\n4. **Contratos temporales y precariedad**: La falta de estabilidad laboral y la precariedad en los contratos son aspectos que muchos jóvenes desean evitar, prefiriendo empleos que ofrezcan seguridad y beneficios.\n\nEn cuanto a las carreras audiovisuales que perciben con mayor libertad y mejor sueldo, algunas de las más destacadas son:\n\n1. **Producción y dirección de cine y televisión**: Estas áreas ofrecen oportunidades creativas y, en muchos casos, pueden resultar en buenos salarios, especialmente en producciones de mayor envergadura.\n\n2. **Guionismo**: Los guionistas, especialmente aquellos que trabajan en proyectos con éxito, pueden alcanzar buenos ingresos y disfrutan de la libertad creativa en su trabajo.\n\n3. **Animación y efectos visuales**: Con el auge de la animación y los efectos especiales en cine y publicidad, los profesionales en estas áreas están en alta demanda y pueden obtener buenos salarios.\n\n4. **Fotografía y videografía**: Los fotógrafos y videógrafos autónomos pueden tener un alto grado de libertad creativa y, dependiendo de su clientela y proyectos, también pueden alcanzar buenos ingresos.\n\n5. **Marketing digital y redes sociales**: Aunque no son estrictamente carreras audiovisuales, muchos jóvenes se están orientando hacia el marketing digital, donde pueden combinar habilidades audiovisuales con estrategias de comunicación, y que a menudo ofrece buenas perspectivas salariales.\n\nEn resumen, los jóvenes en España buscan trabajos que les ofrezcan flexibilidad, propósito y estabilidad, y dentro del ámbito audiovisual, ciertas carreras como producción, guionismo y animación son percibidas como más atractivas en términos de libertad y remuneración.	0.6000	optimismo	0.8500	["flexibilidad laboral", "cultura empresarial", "estabilidad laboral", "carreras audiovisuales", "marketing digital"]	Los jóvenes en España prefieren trabajos flexibles y con propósito; carreras audiovisuales como producción y guionismo son valoradas por su libertad y salario.	\N	\N	gpt-4o-mini	46	502	0.000308	15811	2025-09-24 16:35:43.179527+00	\N	\N
50	25	9	Perplexity (sonar)	Los jóvenes en España rechazan principalmente **los estilos de trabajo que implican alta responsabilidad jerárquica, estrés y falta de equilibrio entre vida laboral y personal**, prefiriendo evitar cargos de jefatura que conllevan "quebraderos de cabez	-0.6000	preocupación	0.8500	["jóvenes", "trabajo", "responsabilidad", "estrés", "equilibrio"]	Los jóvenes en España evitan trabajos con alta responsabilidad y estrés, buscando un mejor equilibrio entre vida laboral y personal.	\N	\N	sonar	44	64	0.000022	2736	2025-09-24 16:35:50.011507+00	\N	\N
51	26	9	OpenAI (gpt-4o-mini)	En España, varias escuelas superiores privadas de cine ofrecen becas o ayudas al estudio. Aquí hay algunas de las más destacadas:\n\n1. **ESCAC (Escuela Superior de Cine y Audiovisuales de Cataluña)**: Ofrece diversas becas y ayudas para estudiantes, incluyendo becas por mérito académico y ayudas para estudiantes con dificultades económicas.\n\n2. **ECAM (Escuela de Cinematografía y del Audiovisual de la Comunidad de Madrid)**: Tiene programas de becas y ayudas económicas, así como convenios con instituciones que pueden ofrecer financiación a los estudiantes.\n\n3. **TAI (Escuela Universitaria de Artes y Espectáculos)**: Ofrece becas de excelencia y ayudas para estudiantes con dificultades económicas. También cuenta con programas de financiación.\n\n4. **Cine en el Aula (Cine y Audiovisuales de la Universidad de Navarra)**: Aunque es una universidad, ofrece programas relacionados con el cine y puede tener becas disponibles para estudiantes en sus programas relacionados.\n\n5. **Cine y Televisión de la Universidad de San Jorge**: Ofrece becas y ayudas para estudiantes en sus programas de cine y televisión.\n\n6. **Instituto del Cine de Madrid (ICM)**: Ofrece becas y ayudas económicas para sus programas de formación en cine.\n\nEs recomendable que los interesados consulten directamente en las páginas web de estas instituciones para obtener información actualizada sobre las becas disponibles, requisitos y plazos de solicitud. Además, algunas escuelas pueden tener convenios con entidades externas que ofrezcan financiación o becas adicionales.	0.8000	optimismo	0.9000	["becas", "escuelas de cine", "ayudas económicas", "financiación", "estudiantes"]	Varias escuelas de cine en España ofrecen becas y ayudas para estudiantes, destacando opciones para quienes enfrentan dificultades económicas.	\N	\N	gpt-4o-mini	38	316	0.000195	9676	2025-09-24 16:36:04.446569+00	\N	\N
52	26	9	Perplexity (sonar)	Algunas escuelas superiores privadas de cine en España que **ofrecen becas o ayudas al estudio** son:\n\n- **The Core School** (zona norte de la Comunidad de Madrid) ofrece un programa de becas asociado a la renta per cápita familia	0.7000	optimismo	0.8500	["escuelas de cine", "becas", "The Core School", "Comunidad de Madrid", "ayudas al estudio"]	Escuelas de cine en España ofrecen becas para estudios, destacando The Core School en Madrid.	\N	\N	sonar	34	64	0.000020	3814	2025-09-24 16:36:12.446995+00	\N	\N
63	32	9	OpenAI (gpt-4o-mini)	La estimación del número de jóvenes en España que se declaran indecisos sobre su futuro académico y profesional puede variar según las fuentes y los estudios realizados. Sin embargo, según algunos informes y encuestas recientes, se estima que un porcentaje significativo de jóvenes en el rango de 16 a 25 años se siente indeciso sobre su futuro, con cifras que pueden oscilar entre el 30% y el 50%. Esta indecisión puede estar influenciada por factores como la incertidumbre económica, la falta de orientación profesional y las cambiantes demandas del mercado laboral.\n\nEn cuanto a los intereses emergentes en el ámbito audiovisual, hay varias tendencias que destacan en las conversaciones online de este grupo demográfico:\n\n1. **Producción y realización**: Muchos jóvenes muestran un interés creciente por la producción de contenido audiovisual, incluyendo cortometrajes, documentales y series web. La accesibilidad de herramientas de producción y plataformas de distribución ha facilitado que los jóvenes experimenten en este campo.\n\n2. **Iluminación y técnicas visuales**: La iluminación es un aspecto crucial en la producción audiovisual, y hay un interés creciente en aprender sobre técnicas de iluminación y cinematografía, especialmente con la popularidad de plataformas como YouTube y TikTok, donde la calidad visual puede influir en el éxito del contenido.\n\n3. **Guion y narrativa**: La creación de guiones atractivos y la narrativa son áreas que capturan la atención de muchos jóvenes. Existe un interés particular en contar historias que reflejen experiencias personales y sociales, así como en desarrollar formatos innovadores.\n\n4. **Postproducción**: La edición de video y el trabajo en postproducción son habilidades valoradas, y muchos jóvenes están buscando aprender sobre software de edición y técnicas de montaje para mejorar sus proyectos.\n\n5. **Desarrollo de formatos televisivos**: Hay un creciente interés en la creación de formatos originales para televisión, incluyendo concursos y realities. La influencia de programas exitosos y la cultura de la realidad han motivado a los jóvenes a explorar cómo desarrollar y producir sus propios formatos.\n\nEn general, el ámbito audiovisual se percibe como una vía creativa y profesional atractiva para muchos jóvenes en España, quienes buscan oportunidades para expresar sus ideas y habilidades en un entorno dinámico y en constante evolución. Las plataformas digitales y las redes sociales juegan un papel fundamental en la formación de estas tendencias y en la facilitación del aprendizaje y la colaboración en proyectos creativos.	0.2000	preocupación	0.8500	["indecisión", "futuro académico", "producción audiovisual", "narrativa", "postproducción"]	Los jóvenes en España muestran indecisión sobre su futuro profesional, pero tienen un creciente interés en el ámbito audiovisual.	\N	\N	gpt-4o-mini	94	494	0.000311	10887	2025-09-24 16:38:35.701772+00	\N	\N
53	27	9	OpenAI (gpt-4o-mini)	Los jóvenes indecisos en España, al igual que en muchas otras partes del mundo, muestran una variedad de intereses en el sector audiovisual y la producción de contenidos. Algunos de los principales intereses incluyen:\n\n1. **Creación de Contenido Digital**: Muchos jóvenes están interesados en la creación de contenido para plataformas como YouTube, TikTok e Instagram. La producción de videos, vlogs, y contenido interactivo es una forma popular de expresión y comunicación.\n\n2. **Cinematografía y Producción de Películas**: Algunos jóvenes se sienten atraídos por el cine y la producción de películas, ya sea en roles técnicos como la dirección de fotografía, edición, o en la producción y guionismo.\n\n3. **Animación y Diseño Gráfico**: La animación, tanto 2D como 3D, así como el diseño gráfico, son áreas que despiertan el interés de muchos jóvenes, especialmente aquellos que disfrutan de la creatividad visual.\n\n4. **Narrativas Transmedia**: La posibilidad de contar historias a través de múltiples plataformas (videojuegos, series web, redes sociales) es un área que atrae a jóvenes interesados en la innovación en la narrativa.\n\n5. **Música y Producción Musical**: La producción musical y la creación de contenido relacionado con la música, como videoclips y podcasts, son también áreas de interés, especialmente con el auge de plataformas de streaming.\n\n6. **Realidad Virtual y Aumentada**: La tecnología emergente, como la realidad virtual (VR) y la realidad aumentada (AR), está captando la atención de los jóvenes, quienes ven en estas herramientas nuevas formas de contar historias y crear experiencias inmersivas.\n\n7. **Sostenibilidad y Contenidos Responsables**: Hay un creciente interés por la producción de contenidos que aborden temas de sostenibilidad, medio ambiente y responsabilidad social, reflejando una conciencia social entre los jóvenes.\n\n8. **Formación y Desarrollo Profesional**: Muchos jóvenes indecisos también buscan oportunidades de formación y desarrollo profesional en el ámbito audiovisual, ya sea a través de cursos, talleres o experiencias prácticas en la industria.\n\nEstos intereses están influenciados por tendencias globales, el acceso a la tecnología y la democratización de la producción de contenidos, lo que permite a los jóvenes explorar su creatividad de maneras antes impensables.	0.6000	optimismo	0.9000	["Creación de Contenido Digital", "Cinematografía", "Animación", "Narrativas Transmedia", "Sostenibilidad"]	Los jóvenes en España muestran un creciente interés en la creación de contenido audiovisual y desarrollo profesional en diversas áreas creativas.	\N	\N	gpt-4o-mini	41	478	0.000293	9642	2025-09-24 16:36:26.088939+00	\N	\N
54	27	9	Perplexity (sonar)	Los jóvenes indecisos en España muestran un interés creciente en el sector audiovisual, especialmente en áreas vinculadas con tecnologías emergentes como la inteligencia artificial, Big Data, realidad aumentada y virtual, además de contenidos originales y exclusivos en streaming. Pre	0.6000	optimismo	0.8500	["jóvenes", "sector audiovisual", "inteligencia artificial", "Big Data", "streaming"]	Los jóvenes en España muestran interés en el sector audiovisual y tecnologías emergentes.	\N	\N	sonar	37	64	0.000020	3275	2025-09-24 16:36:33.581085+00	\N	\N
55	28	9	OpenAI (gpt-4o-mini)	El interés de los jóvenes en España por carreras en el sector audiovisual se puede atribuir a varios "triggers" o referentes motivacionales, así como a una serie de emociones asociadas. Aquí hay algunos de los más relevantes:\n\n### Triggers o Referentes Motivacionales:\n\n1. **Influencia de las Redes Sociales**: Plataformas como Instagram, TikTok y YouTube permiten a los jóvenes ver el trabajo de creadores de contenido y profesionales del audiovisual. La posibilidad de hacerse viral y alcanzar un público amplio es un fuerte motivador.\n\n2. **Cultura Popular y Entretenimiento**: Series de televisión, películas y documentales que han tenido un gran impacto cultural, así como festivales de cine, generan interés en la creación de contenido audiovisual. Ejemplos incluyen producciones de Netflix, HBO y festivales como el de San Sebastián.\n\n3. **Accesibilidad de la Tecnología**: La democratización de la tecnología de grabación y edición (como smartphones y software accesible) permite que más jóvenes experimenten con la creación audiovisual, lo que despierta su interés en carreras relacionadas.\n\n4. **Modelos a Seguir**: La presencia de figuras públicas y profesionales del sector, como directores, actores y creadores de contenido, que comparten sus historias de éxito y procesos creativos, inspira a los jóvenes a seguir sus pasos.\n\n5. **Educación y Formación**: La oferta de programas académicos y talleres en escuelas de cine, universidades y plataformas online ha aumentado, facilitando el acceso a la formación en el sector audiovisual.\n\n6. **Tendencias Laborales**: La creciente demanda de contenido audiovisual en diversas plataformas y la expansión de la industria del entretenimiento crean un sentido de oportunidad laboral atractivo para los jóvenes.\n\n### Emociones Asociadas:\n\n1. **Creatividad y Expresión**: Muchos jóvenes sienten que el sector audiovisual les permite expresar su creatividad y contar historias que les apasionan, lo que les proporciona una gran satisfacción personal.\n\n2. **Entusiasmo y Pasión**: La posibilidad de trabajar en un campo dinámico y en constante evolución genera entusiasmo. La pasión por el cine, la televisión y otros formatos audiovisuales es un motor importante.\n\n3. **Pertenencia y Comunidad**: Participar en el sector audiovisual puede hacer que los jóvenes se sientan parte de una comunidad creativa, lo que fomenta un sentido de pertenencia.\n\n4. **Reconocimiento y Validación**: La posibilidad de recibir reconocimiento por su trabajo, ya sea a través de premios, críticas positivas o la conexión con una audiencia, puede ser una fuente de validación emocional.\n\n5. **Incertidumbre y Ansiedad**: A pesar de los aspectos positivos, también pueden surgir emociones negativas como la ansiedad por la competencia y la incertidumbre sobre el futuro laboral en un sector tan cambiante.\n\n6. **Inspiración y Motivación**: Ver el trabajo de otros en el sector puede inspirar a los jóvenes a seguir sus sueños y motivarles a superar obstáculos en su camino profesional.\n\nEn resumen, el interés de los jóvenes en el sector audiovisual en España está impulsado por una combinación de factores culturales, tecnológicos y educativos, y está asociado con una mezcla de emociones que van desde la creatividad y la pasión hasta la ansiedad y la incertidumbre.	0.7000	optimismo	0.8500	["redes sociales", "cultura popular", "tecnología", "modelos a seguir", "tendencias laborales"]	El interés juvenil en el sector audiovisual en España se debe a factores culturales, tecnológicos y educativos, generando diversas emociones positivas y negativas.	\N	\N	gpt-4o-mini	54	668	0.000409	15854	2025-09-24 16:36:54.346925+00	\N	\N
56	28	9	Perplexity (sonar)	Los jóvenes en España se sienten motivados a interesarse por carreras en el sector audiovisual principalmente por su pasión por el cine, la televisión, la narrativa audiovisual y el deseo de contar nuevas historias, así como por la percepción de viabilidad y futuro profesional en est	0.7000	optimismo	0.8500	["jóvenes", "carreras", "sector audiovisual", "cine", "televisión"]	Los jóvenes en España se sienten motivados por el cine y la narrativa audiovisual debido a sus perspectivas profesionales.	\N	\N	sonar	49	64	0.000023	3856	2025-09-24 16:37:03.081618+00	\N	\N
57	29	9	OpenAI (gpt-4o-mini)	La preferencia de los jóvenes en España por carreras creativas en el ámbito audiovisual en lugar de estudios tradicionales puede ser atribuida a varias motivaciones:\n\n1. **Interés por la creatividad y la autoexpresión**: Muchos jóvenes sienten una fuerte inclinación hacia la creatividad y buscan carreras que les permitan expresarse artísticamente. El sector audiovisual ofrece múltiples oportunidades para la creación y la innovación.\n\n2. **Influencia de los medios digitales**: La omnipresencia de plataformas como YouTube, Instagram y TikTok ha hecho que muchos jóvenes se interesen por la producción de contenido audiovisual. Estos medios les permiten ver ejemplos de éxito en el ámbito creativo y les inspiran a seguir carreras relacionadas.\n\n3. **Oportunidades laborales**: Aunque las carreras tradicionales suelen ofrecer una percepción de estabilidad, el sector audiovisual está en constante crecimiento, con una demanda creciente de profesionales en áreas como la producción, la dirección, la edición y el diseño. Los jóvenes pueden ver en esto una oportunidad para construir una carrera viable.\n\n4. **Flexibilidad y dinamismo**: Las carreras creativas suelen ofrecer un entorno laboral más flexible y menos rígido que las profesiones tradicionales. Muchos jóvenes valoran la posibilidad de trabajar en proyectos diversos y en entornos colaborativos.\n\n5. **Cultura de la innovación**: La sociedad actual valora cada vez más la innovación y la capacidad de adaptación. Las carreras creativas suelen estar en la vanguardia de estas tendencias, lo que atrae a jóvenes que desean estar a la vanguardia de la cultura y la tecnología.\n\n6. **Redes de apoyo y colaboración**: Las comunidades creativas suelen fomentar la colaboración y el trabajo en equipo, lo que puede ser un atractivo adicional para los jóvenes que buscan un entorno de trabajo más colaborativo y menos competitivo.\n\n7. **Percepción de éxito y reconocimiento**: La cultura popular a menudo glorifica a figuras del ámbito audiovisual, lo que puede llevar a los jóvenes a aspirar a carreras en este campo con la esperanza de alcanzar un reconocimiento similar.\n\n8. **Descontento con la educación tradicional**: Algunos jóvenes pueden sentir que la educación tradicional no se adapta a sus intereses o necesidades, llevando a una búsqueda de alternativas más alineadas con sus pasiones.\n\nEn resumen, la preferencia por carreras creativas en el ámbito audiovisual entre los jóvenes en España está influenciada por una combinación de factores culturales, económicos y personales que valoran la creatividad, la flexibilidad y las oportunidades de expresión personal.	0.7000	optimismo	0.8500	["carreras creativas", "sector audiovisual", "medios digitales", "oportunidades laborales", "flexibilidad"]	Los jóvenes en España prefieren carreras creativas audiovisuales por su interés en la creatividad, oportunidades laborales y flexibilidad.	\N	\N	gpt-4o-mini	44	501	0.000307	13723	2025-09-24 16:37:21.30613+00	\N	\N
58	29	9	Perplexity (sonar)	Los jóvenes en España prefieren carreras creativas en audiovisual frente a estudios tradicionales principalmente por la oportunidad de **contar nuevas historias** y **expresar su creatividad** mediante herramientas audiovisuales, además de la **alta empleabilidad y crecimiento del sector**. Tambié	0.7000	optimismo	0.8500	["carreras creativas", "audiovisual", "empleabilidad", "creatividad", "crecimiento del sector"]	Los jóvenes en España eligen carreras creativas en audiovisual por su creatividad y oportunidades laborales.	\N	\N	sonar	41	64	0.000021	2899	2025-09-24 16:37:27.597714+00	\N	\N
59	30	9	OpenAI (gpt-4o-mini)	Las preocupaciones de los padres en España sobre las carreras en el sector audiovisual pueden abarcar varios aspectos:\n\n1. **Empleabilidad**: Muchos padres se preocupan por las oportunidades laborales que ofrecen las carreras en el sector audiovisual. La percepción de que la industria es competitiva y que no siempre garantiza un empleo estable puede generar dudas sobre si es una opción viable para sus hijos.\n\n2. **Formación y calidad educativa**: Los padres suelen estar interesados en la calidad de la formación que recibirán sus hijos. Quieren asegurarse de que las instituciones educativas ofrezcan programas actualizados y que estén alineados con las demandas del mercado laboral.\n\n3. **Incertidumbre económica**: La inestabilidad económica del sector audiovisual, influenciada por cambios en la tecnología y en los hábitos de consumo, puede ser una preocupación. Los padres pueden cuestionar si invertir en una carrera en este campo es una decisión financiera prudente.\n\n4. **Desarrollo profesional**: Existe la inquietud sobre las posibilidades de crecimiento y desarrollo profesional en el sector. Los padres pueden preguntarse si las carreras en audiovisual ofrecen trayectorias claras y oportunidades de avance.\n\n5. **Impacto de la tecnología**: La rápida evolución de la tecnología en el sector audiovisual puede ser motivo de preocupación. Los padres pueden estar interesados en cómo estas transformaciones afectan la formación y las habilidades que se requieren en el mercado laboral.\n\nEn cuanto a las fuentes que los padres consultan para informarse sobre estas carreras, suelen incluir:\n\n- **Orientadores educativos**: Muchos padres recurren a los orientadores en los centros educativos para obtener información sobre las opciones de carrera y la viabilidad de las mismas.\n\n- **Instituciones educativas**: Las páginas web de universidades y escuelas de cine, así como ferias educativas y jornadas de puertas abiertas, son fuentes comunes de información.\n\n- **Foros y redes sociales**: Los grupos en redes sociales y foros en línea pueden ser utilizados por los padres para compartir experiencias y obtener opiniones de otros padres o profesionales del sector.\n\n- **Artículos y publicaciones especializadas**: Revistas, blogs y artículos sobre educación y el sector audiovisual pueden ser consultados para obtener una visión más amplia sobre las tendencias y oportunidades en el campo.\n\n- **Experiencias personales**: Muchos padres también se basan en experiencias de familiares o amigos que han trabajado o estudiado en el sector audiovisual para tomar decisiones informadas.\n\nEstas preocupaciones y fuentes de información reflejan el deseo de los padres de garantizar que sus hijos tomen decisiones educativas y profesionales que sean beneficiosas a largo plazo.	-0.5000	preocupación	0.8500	["empleabilidad", "formación", "incertidumbre económica", "desarrollo profesional", "tecnología"]	Los padres en España muestran preocupaciones sobre la empleabilidad y formación en carreras audiovisuales.	\N	\N	gpt-4o-mini	49	520	0.000319	10810	2025-09-24 16:37:42.24201+00	\N	\N
64	32	9	Perplexity (sonar)	En España, la estimación del porcentaje de jóvenes entre 16 y 25 años que se declaran indecisos sobre su futuro académico o profesional ronda aproximadamente el **32%**, según datos recientes basados en adolescentes de 15 años y jóvenes preuniversitarios	-0.2000	preocupación	0.8500	["España", "jóvenes", "futuro académico", "indecisión", "estadísticas"]	El 32% de los jóvenes en España se sienten indecisos sobre su futuro académico o profesional.	\N	\N	sonar	99	64	0.000033	3867	2025-09-24 16:38:42.704801+00	\N	\N
65	33	9	OpenAI (gpt-4o-mini)	Los jóvenes indecisos en España que muestran interés por carreras en el ámbito audiovisual suelen señalar varios 'triggers' o detonantes que les inspiran a explorar estas opciones. Algunos de los más comunes incluyen:\n\n1. **Experiencias Personales**:\n   - **Proyectos Escolares**: Participar en proyectos de clase relacionados con el cine o la televisión, como cortometrajes o programas de radio, puede despertar el interés.\n   - **Talleres y Cursos**: Asistir a talleres de cine, guion o producción puede ser una experiencia reveladora que les haga considerar una carrera en el sector.\n\n2. **Contenidos Audiovisuales**:\n   - **Películas y Series**: La influencia de series y películas populares, especialmente aquellas que abordan temáticas relevantes o innovadoras, puede despertar la curiosidad por cómo se crean.\n   - **Documentales y Making Of**: Ver documentales sobre el proceso de creación de películas o programas de televisión puede generar interés en los aspectos técnicos y creativos del audiovisual.\n\n3. **Referentes y Modelos a Seguir**:\n   - **Creadores y Directores**: La admiración por directores, guionistas o productores reconocidos puede inspirar a los jóvenes a seguir sus pasos.\n   - **Influencers y Creadores de Contenido**: La popularidad de influencers en plataformas como YouTube o TikTok, que crean contenido audiovisual, puede motivar a los jóvenes a explorar su propia creatividad en este ámbito.\n\n4. **Eventos y Festivales**:\n   - **Festivales de Cine**: Asistir a festivales de cine, donde pueden ver trabajos de otros y conocer a profesionales del sector, puede ser un gran motivador.\n   - **Conferencias y Charlas**: Eventos donde se discuten tendencias y experiencias en el mundo audiovisual también pueden despertar el interés.\n\n### Emociones Expresadas\n\nLos jóvenes suelen expresar una variedad de emociones al experimentar estos triggers:\n\n- **Curiosidad**: La fascinación por el proceso creativo y la posibilidad de contar historias a través de diferentes formatos.\n- **Esperanza**: La idea de que pueden hacer una carrera en un campo que les apasiona y que les permite expresarse.\n- **Inseguridad**: La duda sobre sus habilidades, la competencia en el sector y el futuro laboral en un campo que puede ser incierto.\n\nEn resumen, los jóvenes indecisos en España encuentran inspiración en una combinación de experiencias personales, contenidos audiovisuales, referentes y eventos, y experimentan una mezcla de curiosidad, esperanza e inseguridad al considerar sus opciones en el ámbito audiovisual.	0.5000	esperanza	0.8500	["carreras audiovisuales", "experiencias personales", "contenidos audiovisuales", "referentes", "eventos y festivales"]	Los jóvenes indecisos en España se inspiran en experiencias personales y referentes para explorar carreras en el ámbito audiovisual, sintiendo curiosidad y esperanza.	\N	\N	gpt-4o-mini	88	542	0.000338	11616	2025-09-24 16:39:01.45021+00	\N	\N
66	33	9	Perplexity (sonar)	Los jóvenes indecisos en España suelen interesarse por carreras audiovisuales a partir de **eventos y referentes relacionados con el cine, la televisión y los formatos digitales, así como experiencias donde experimentan creatividad y narración audiovisual**. Estos "trigger	0.5000	optimismo	0.8500	["jóvenes", "carreras audiovisuales", "cine", "televisión", "formatos digitales"]	Los jóvenes indecisos en España se sienten atraídos por carreras audiovisuales a través de eventos y experiencias creativas.	\N	\N	sonar	90	64	0.000031	2787	2025-09-24 16:39:08.356708+00	\N	\N
67	34	9	OpenAI (gpt-4o-mini)	Las motivaciones que impulsan a los jóvenes indecisos en España a considerar carreras fuera de las tradicionales son diversas y reflejan un cambio en las prioridades y expectativas de las nuevas generaciones. Aquí se detallan algunas de las principales motivaciones:\n\n### Motivaciones para considerar carreras no tradicionales:\n\n1. **Creatividad**: Muchos jóvenes buscan carreras que les permitan expresarse creativamente. La industria audiovisual, el diseño, la música y otras áreas creativas ofrecen oportunidades para desarrollar habilidades artísticas y trabajar en proyectos innovadores.\n\n2. **Flexibilidad**: Las nuevas carreras suelen ofrecer horarios más flexibles y la posibilidad de trabajar de forma remota. Esto es atractivo para aquellos que valoran un equilibrio entre la vida personal y profesional.\n\n3. **Propósito y significado**: Los jóvenes tienden a buscar trabajos que les permitan contribuir a causas sociales, medioambientales o culturales. Quieren que su trabajo tenga un impacto positivo en la sociedad.\n\n4. **Potencial de ingresos**: La industria audiovisual y otras áreas emergentes pueden ofrecer oportunidades económicas atractivas, especialmente con el crecimiento de plataformas digitales y el contenido en línea. Esto puede ser motivador para aquellos que buscan estabilidad financiera.\n\n5. **Innovación y tecnología**: Muchos jóvenes están interesados en campos que están en la vanguardia de la tecnología y la innovación, como el desarrollo de videojuegos, la programación y el marketing digital, que suelen estar menos ligados a trayectorias académicas tradicionales.\n\n### Factores que producen rechazo en los estudios convencionales:\n\n1. **Exigencia académica**: Algunos jóvenes sienten que los estudios tradicionales son demasiado exigentes y estresantes. La presión por obtener buenas calificaciones y cumplir con estándares académicos puede ser desalentadora.\n\n2. **Hartazgo y falta de motivación**: La percepción de que los estudios convencionales son monótonos o desconectados de la realidad laboral puede provocar desinterés. Muchos jóvenes no ven la relevancia de lo que están aprendiendo en su vida profesional futura.\n\n3. **Falta de libertad**: La estructura rígida de los programas académicos tradicionales puede ser vista como limitante. Los jóvenes valoran cada vez más la autonomía y la capacidad de elegir su propio camino.\n\n4. **Desajuste con el mercado laboral**: La desconexión entre lo que se enseña en las universidades y lo que demandan las empresas puede generar desconfianza en los estudios convencionales. Muchos jóvenes sienten que las carreras tradicionales no les preparan adecuadamente para el mundo laboral actual.\n\n5. **Influencia de las redes sociales**: La visibilidad de carreras no tradicionales a través de plataformas digitales y redes sociales puede influir en las decisiones de los jóvenes. La exposición a historias de éxito en campos creativos o emprendimientos puede motivarles a seguir caminos alternativos.\n\nEn resumen, los jóvenes en España están cada vez más interesados en carreras que les ofrezcan creatividad, flexibilidad y un sentido de propósito, mientras que los estudios convencionales enfrentan el rechazo debido a su rigidez, exigencia y falta de conexión con el mercado laboral actual.	0.6000	optimismo	0.8500	["creatividad", "flexibilidad", "propósito", "innovación", "redes sociales"]	Los jóvenes en España prefieren carreras creativas y flexibles, rechazando estudios convencionales por su rigidez y falta de conexión con el mercado laboral.	\N	\N	gpt-4o-mini	87	631	0.000392	15342	2025-09-24 16:39:27.445419+00	\N	\N
68	34	9	Perplexity (sonar)	Los jóvenes indecisos en España suelen motivarse para considerar carreras fuera de las tradicionales principalmente por el deseo de mayor **creatividad, flexibilidad, propósito y oportunidades en industrias emergentes**, como la audiovisual. Estas carreras ofrecen una conexión más c	0.7000	optimismo	0.8500	["jóvenes", "carreras", "creatividad", "flexibilidad", "industrias emergentes"]	Los jóvenes en España buscan carreras creativas y flexibles en industrias emergentes como la audiovisual.	\N	\N	sonar	97	64	0.000032	3174	2025-09-24 16:39:33.567335+00	\N	\N
69	35	9	OpenAI (gpt-4o-mini)	Los jóvenes indecisos en España suelen rechazar ciertos tipos de trabajos y estilos de vida que perciben como restrictivos o poco satisfactorios. Algunos de los trabajos que suelen ser menos atractivos para este grupo son:\n\n1. **Trabajo de oficina**: Muchos jóvenes prefieren evitar trabajos que impliquen estar en un entorno de oficina tradicional, con horarios rígidos y tareas repetitivas.\n\n2. **Trabajo de 9 a 5**: La jornada laboral convencional es vista como limitante, ya que muchos jóvenes buscan flexibilidad en sus horarios y la posibilidad de gestionar su tiempo de manera más autónoma.\n\n3. **Oposiciones**: Aunque algunas personas ven las oposiciones como una vía segura hacia un empleo estable, muchos jóvenes indecisos pueden considerarlas aburridas o poco creativas, prefiriendo carreras que ofrezcan más dinamismo.\n\nEn cuanto a las carreras vinculadas al audiovisual, hay varias áreas que se asocian con una mayor sensación de libertad y creatividad. Algunas de estas áreas son:\n\n1. **Realización**: Los realizadores suelen tener la oportunidad de trabajar en proyectos diversos, lo que les permite expresar su creatividad y experimentar con diferentes estilos.\n\n2. **Guion**: La escritura de guiones ofrece la posibilidad de contar historias y desarrollar ideas originales, lo que puede ser muy atractivo para quienes buscan un trabajo creativo.\n\n3. **Producción**: Aunque puede ser un trabajo que implique cierta organización y gestión, la producción también permite estar involucrado en diferentes aspectos de un proyecto audiovisual, lo que puede resultar estimulante.\n\n4. **Iluminación**: Este campo permite trabajar de manera creativa en la creación de atmósferas y estilos visuales, lo que puede ser muy gratificante.\n\n5. **Postproducción**: Aunque puede ser más técnico, el trabajo en postproducción también ofrece la oportunidad de dar forma final a un proyecto, lo que puede ser muy satisfactorio para quienes disfrutan del proceso creativo.\n\nEn cuanto a las perspectivas de remuneración, generalmente, las áreas de **producción** y **realización** suelen ofrecer mejores oportunidades económicas en comparación con otras especialidades, especialmente en contextos de creciente demanda como la televisión, el cine y las plataformas de streaming. Sin embargo, los salarios pueden variar significativamente según la experiencia, la ubicación y el tipo de proyecto. Por lo tanto, es recomendable que los jóvenes interesados en el audiovisual investiguen las tendencias del mercado y busquen oportunidades de formación y prácticas que les ayuden a mejorar sus perspectivas laborales.	0.3000	optimismo	0.8500	["trabajo de oficina", "trabajo de 9 a 5", "audiovisual", "producción", "realización"]	Los jóvenes en España buscan trabajos creativos y flexibles, rechazando opciones tradicionales como el trabajo de oficina y las oposiciones.	\N	\N	gpt-4o-mini	108	512	0.000323	12220	2025-09-24 16:39:49.007857+00	\N	\N
70	35	9	Perplexity (sonar)	Los jóvenes indecisos en España **rechazan explícitamente trabajos y estilos de vida asociados a estabilidad rígida y poca flexibilidad**, como el **trabajo de oficina tradicional (9 a 5)** y las **oposiciones** públicas, debid	-0.6000	preocupación	0.8500	["jóvenes", "trabajo de oficina", "oposiciones", "estabilidad", "flexibilidad"]	Los jóvenes en España rechazan trabajos tradicionales por su falta de flexibilidad.	\N	\N	sonar	121	64	0.000037	4675	2025-09-24 16:39:56.928713+00	\N	\N
71	36	9	OpenAI (gpt-4o-mini)	En España, los padres suelen tener varias preocupaciones al considerar carreras en el ámbito audiovisual para sus hijos. Algunas de las más comunes incluyen:\n\n1. **Empleabilidad**: Muchos padres se preocupan por las oportunidades laborales que existen en el sector audiovisual. La percepción de que es un campo muy competitivo y que puede haber escasez de puestos de trabajo estables puede generar dudas sobre la viabilidad de una carrera en este ámbito.\n\n2. **Coste**: La inversión económica necesaria para estudiar en escuelas de cine o audiovisuales puede ser elevada. Los padres suelen cuestionar si el coste de la educación se justifica con respecto a las posibles salidas laborales y el retorno de la inversión.\n\n3. **Prestigio**: Algunas familias pueden tener preocupaciones sobre la percepción social de las carreras en el ámbito audiovisual en comparación con otras profesiones más tradicionales o consideradas "prestigiosas". Esto puede influir en la decisión de los padres sobre el apoyo a la elección de carrera de sus hijos.\n\n4. **Seguridad laboral**: La incertidumbre inherente a las carreras creativas, donde los contratos pueden ser temporales y los ingresos inestables, es una fuente de preocupación. Los padres a menudo buscan carreras que ofrezcan mayor estabilidad y seguridad a largo plazo.\n\nEn cuanto a las fuentes de información que los padres consultan para informarse sobre instituciones como The Core, Escuela Superior de Audiovisuales, suelen incluir:\n\n- **Sitios web oficiales**: La mayoría de los padres revisan las páginas web de las instituciones educativas para conocer los programas, la metodología de enseñanza, el profesorado, y las tasas de empleabilidad de los graduados.\n\n- **Foros y grupos en redes sociales**: Las plataformas como Facebook, Twitter o foros especializados permiten a los padres conectarse con otros que han pasado por experiencias similares, lo que les brinda perspectivas y consejos prácticos.\n\n- **Opiniones de antiguos alumnos**: Las reseñas y testimonios de graduados pueden ser muy influyentes. Muchos padres buscan información sobre la experiencia de otros estudiantes y su éxito en el mercado laboral tras finalizar sus estudios.\n\n- **Orientadores educativos**: Algunos padres consultan con orientadores académicos o profesionales de la educación que pueden ofrecerles una visión más objetiva sobre las oportunidades en el sector audiovisual.\n\n- **Ferias y eventos educativos**: Participar en ferias de educación o jornadas de puertas abiertas en las instituciones permite a los padres obtener información de primera mano y hacer preguntas directas a los docentes y a los propios estudiantes.\n\nEstas preocupaciones y fuentes de información reflejan la complejidad de la decisión de elegir una carrera en el ámbito audiovisual, que combina factores personales, económicos y sociales.	-0.5000	preocupación	0.8500	["empleabilidad", "coste", "prestigio", "seguridad laboral", "fuentes de información"]	Los padres en España tienen preocupaciones sobre la empleabilidad, coste y prestigio de las carreras audiovisuales para sus hijos.	\N	\N	gpt-4o-mini	78	549	0.000341	13683	2025-09-24 16:40:14.128815+00	\N	\N
72	36	9	Perplexity (sonar)	Las preocupaciones más repetidas por los padres en España cuando sus hijos consideran carreras en el ámbito audiovisual suelen centrarse en la **empleabilidad, el costo, el prestigio y la seguridad laboral**. Aunque no hay un estudio específico exacto sobre estas preocupacione	-0.5000	preocupación	0.8500	["empleabilidad", "costo", "prestigio", "seguridad laboral", "carreras audiovisuales"]	Los padres en España están preocupados por la empleabilidad y seguridad laboral en carreras audiovisuales.	\N	\N	sonar	81	64	0.000029	2439	2025-09-24 16:40:20.223199+00	\N	\N
73	37	9	OpenAI (gpt-4o-mini)	Para convencer a los padres en España sobre la viabilidad de estudiar en el ámbito audiovisual, es importante presentar argumentos y datos que resalten tanto las oportunidades laborales como el desarrollo personal y profesional que ofrece esta industria. Aquí hay algunos tipos de argumentos y datos que pueden ser persuasivos:\n\n### 1. **Tasas de Empleo y Crecimiento del Sector**\n   - **Datos del Mercado Laboral**: Presentar estadísticas sobre el crecimiento del sector audiovisual en España y Europa. Según informes de la European Audiovisual Observatory, el sector audiovisual ha mostrado un crecimiento constante, con un aumento en la producción y consumo de contenido digital.\n   - **Empleo en Nuevas Plataformas**: Resaltar el aumento de oportunidades laborales en plataformas de streaming, redes sociales y producción independiente, que han generado una demanda significativa de profesionales cualificados.\n\n### 2. **Casos de Éxito**\n   - **Testimonios de Graduados**: Compartir historias de éxito de exalumnos que han logrado destacarse en la industria, ya sea trabajando en grandes producciones, creando sus propias empresas o ganando premios en festivales internacionales.\n   - **Colaboraciones con la Industria**: Mostrar ejemplos de colaboraciones con empresas del sector que han permitido a los estudiantes adquirir experiencia práctica y conexiones valiosas.\n\n### 3. **Salarios y Oportunidades de Crecimiento**\n   - **Datos sobre Salarios**: Proporcionar información sobre los salarios promedio en diferentes roles dentro del sector audiovisual, destacando que, aunque pueden variar, muchas posiciones ofrecen salarios competitivos y oportunidades de crecimiento a largo plazo.\n   - **Diversidad de Roles**: Explicar la variedad de roles disponibles (producción, dirección, edición, marketing digital, etc.) y cómo cada uno puede ser una puerta de entrada a diferentes trayectorias profesionales.\n\n### 4. **Trayectorias Internacionales**\n   - **Oportunidades Globales**: Resaltar que el ámbito audiovisual permite trabajar en un entorno internacional, con oportunidades en festivales, coproducciones y proyectos globales. Esto puede ser atractivo para padres que valoran la experiencia internacional para sus hijos.\n   - **Programas de Intercambio y Prácticas**: Informar sobre programas de intercambio y prácticas en empresas internacionales que pueden enriquecer la formación de los estudiantes.\n\n### 5. **Innovación y Tecnología**\n   - **Nuevas Tecnologías**: Hablar sobre la integración de nuevas tecnologías en el ámbito audiovisual (realidad virtual, producción 3D, etc.) y cómo esto está creando nuevas oportunidades de empleo y desarrollo profesional.\n   - **Formación Continua**: Destacar la importancia de la formación continua en un sector en constante evolución, y cómo instituciones como The Core preparan a los estudiantes para adaptarse a estos cambios.\n\n### Cómo puede **The Core** posicionarse como referencia:\n- **Calidad Educativa**: Resaltar el enfoque educativo innovador de The Core, que combina teoría y práctica, y la experiencia del profesorado, que incluye profesionales activos en la industria.\n- **Networking y Oportunidades**: Promover las conexiones que la institución tiene con la industria, incluyendo talleres, seminarios y eventos donde los estudiantes pueden interactuar con profesionales del sector.\n- **Resultados Comprobados**: Publicar estadísticas sobre la tasa de empleo de graduados de The Core y ejemplos concretos de exalumnos que han tenido éxito en el ámbito audiovisual.\n- **Testimonios y Reseñas**: Crear contenido en forma de videos o artículos que presenten testimonios de padres y estudiantes satisfechos con su experiencia en The Core, destacando la transformación profesional y personal que han vivido.\n\nAl presentar estos argumentos de manera clara y respaldada por datos concretos, The Core puede posicionarse como una opción atractiva y viable para los padres que consideran la educación en el ámbito audiovisual para sus hijos.	0.8000	optimismo	0.9000	["oportunidades laborales", "crecimiento del sector", "testimonios de graduados", "salarios competitivos", "nuevas tecnologías"]	El texto argumenta sobre la viabilidad de estudiar en el ámbito audiovisual, destacando oportunidades laborales y desarrollo personal en España.	\N	\N	gpt-4o-mini	85	792	0.000488	13585	2025-09-24 16:40:37.568808+00	\N	\N
74	37	9	Perplexity (sonar)	Los argumentos más persuasivos para convencer a los padres en España sobre la viabilidad de estudiar en el ámbito audiovisual son los siguientes:\n\n- **Crecimiento y dinamismo del empleo audiovisual:** El sector ha experimentado un notable aumento del 16,09% e	0.7000	optimismo	0.8500	["empleo audiovisual", "crecimiento", "persuasión", "padres", "España"]	El texto destaca el crecimiento del empleo en el sector audiovisual en España como un argumento persuasivo para los padres.	\N	\N	sonar	86	64	0.000030	3166	2025-09-24 16:40:43.89054+00	\N	\N
75	38	9	OpenAI (gpt-4o-mini)	Para llegar a jóvenes interesados en el ámbito audiovisual en España, es importante considerar una combinación de plataformas digitales que sean populares entre este grupo demográfico. Aquí hay algunos de los canales más efectivos:\n\n1. **Redes Sociales**:\n   - **Instagram**: Es una plataforma visual que permite compartir contenido atractivo, como cortometrajes, detrás de cámaras y proyectos creativos. La función de Stories y Reels también es muy popular entre los jóvenes.\n   - **TikTok**: Esta red ha crecido exponencialmente y es especialmente efectiva para contenido breve y creativo. Los jóvenes utilizan TikTok para descubrir nuevas tendencias y creadores.\n   - **YouTube**: Es la plataforma de video más utilizada y permite a los creadores compartir contenido más largo y detallado. Los tutoriales, documentales y cortometrajes pueden encontrar una buena audiencia aquí.\n\n2. **Plataformas de Streaming**:\n   - **Twitch**: Aunque es conocida principalmente por los videojuegos, Twitch también está ganando popularidad para la transmisión de contenido audiovisual y creativo en vivo, lo que puede atraer a jóvenes interesados en la producción y el entretenimiento.\n   - **Vimeo**: Aunque menos popular que YouTube, Vimeo es valorada por su comunidad de creadores y la calidad de su contenido. Es ideal para mostrar trabajos más artísticos y profesionales.\n\n3. **Comunidades y Foros**:\n   - **Discord**: Muchas comunidades de creadores y entusiastas del audiovisual se reúnen en servidores de Discord, donde pueden compartir proyectos, recibir retroalimentación y colaborar.\n   - **Reddit**: Subforos (subreddits) específicos sobre producción audiovisual, cine y video son buenos lugares para interactuar con jóvenes interesados en estos temas.\n\n4. **Blogs y Sitios Web**:\n   - Crear contenido en blogs o sitios web especializados en producción audiovisual puede atraer a un público más específico. El contenido educativo, como tutoriales y análisis de tendencias, es especialmente valioso.\n\n5. **Publicidad Digital**:\n   - Utilizar anuncios en redes sociales dirigidos a grupos demográficos específicos, como jóvenes interesados en el cine y la producción audiovisual, puede ser una estrategia efectiva para aumentar la visibilidad.\n\n6. **Colaboraciones con Influencers**:\n   - Colaborar con creadores de contenido e influencers que ya tienen la atención de la audiencia joven puede ser una forma efectiva de llegar a nuevos seguidores interesados en el audiovisual.\n\nAl combinar estos canales y adaptar el contenido a las preferencias y comportamientos de la audiencia joven, se puede lograr una mayor efectividad en la comunicación y el alcance.	0.7000	optimismo	0.8500	["Redes Sociales", "Plataformas de Streaming", "Comunidades", "Publicidad Digital", "Colaboraciones con Influencers"]	El texto sugiere estrategias efectivas para alcanzar a jóvenes interesados en el ámbito audiovisual en España mediante diversas plataformas digitales.	\N	\N	gpt-4o-mini	38	530	0.000324	15947	2025-09-24 16:41:02.927602+00	\N	\N
76	38	9	Perplexity (sonar)	Los canales digitales más efectivos para llegar a jóvenes interesados en audiovisual en España son **YouTube, Netflix y Amazon Prime Video**, con YouTube siendo el más predominante según varios estudios. Además, las plataformas de TV Conectada y servicios de vídeo bajo demanda (VOD	0.7000	optimismo	0.8500	["YouTube", "Netflix", "Amazon Prime Video", "TV Conectada", "VOD"]	YouTube, Netflix y Amazon Prime Video son los canales digitales más efectivos para jóvenes interesados en audiovisual en España.	\N	\N	sonar	34	64	0.000020	3117	2025-09-24 16:41:09.190136+00	\N	\N
77	39	9	OpenAI (gpt-4o-mini)	Las búsquedas y tendencias digitales en España relacionadas con "carreras audiovisuales", "profesiones creativas", "empleos del futuro" y "formación en realización, guion y producción" reflejan un creciente interés en la industria creativa y audiovisual. A continuación, se destacan algunas de estas tendencias y cómo pueden vincularse a la propuesta educativa de The Core, Escuela Superior de Audiovisuales.\n\n### Búsquedas y Tendencias Digitales Frecuentes:\n\n1. **Carreras Audiovisuales**:\n   - **Interés en la formación profesional**: Muchos usuarios buscan programas de grado y máster en áreas como dirección de cine, producción audiovisual, y guionismo.\n   - **Estudios de casos y experiencias**: Hay un aumento en las búsquedas de testimonios y casos de éxito de profesionales en el sector.\n\n2. **Profesiones Creativas**:\n   - **Diversificación de roles**: Se observa un interés en profesiones emergentes como creador de contenido, director de arte digital, y especialista en marketing de contenido.\n   - **Habilidades requeridas**: Búsquedas relacionadas con las habilidades necesarias para triunfar en estas profesiones, como el manejo de software de edición, storytelling, y marketing digital.\n\n3. **Empleos del Futuro**:\n   - **Tendencias en la industria**: Se investiga sobre el impacto de la inteligencia artificial y la automatización en el sector creativo, así como nuevas oportunidades laborales que surgen a partir de estas tecnologías.\n   - **Formación continua**: Hay un creciente interés en cursos cortos y talleres que ofrezcan habilidades específicas adaptadas a las demandas del mercado.\n\n4. **Formación en Realización, Guion y Producción**:\n   - **Programas de formación práctica**: Los usuarios buscan programas que ofrezcan experiencias prácticas y conexiones con la industria.\n   - **Networking y oportunidades laborales**: Interés en programas que faciliten la creación de redes profesionales y oportunidades de prácticas en empresas del sector.\n\n### Vinculación con la Propuesta Educativa de The Core, Escuela Superior de Audiovisuales:\n\n1. **Currículo Actualizado**: The Core puede ofrecer un currículo que incluya las tendencias actuales en la industria, asegurando que los estudiantes estén al tanto de las tecnologías emergentes y las nuevas profesiones creativas.\n\n2. **Enfoque Práctico**: Incorporar proyectos prácticos y colaborativos que permitan a los estudiantes trabajar en situaciones reales, facilitando así la adquisición de habilidades técnicas y creativas.\n\n3. **Networking y Oportunidades Laborales**: Fomentar alianzas con empresas del sector audiovisual para ofrecer prácticas, talleres y conferencias con profesionales de la industria, lo que puede ser un gran atractivo para los futuros estudiantes.\n\n4. **Formación Continua**: Ofrecer cursos cortos y especializaciones que respondan a las necesidades cambiantes del mercado laboral, como el uso de nuevas herramientas digitales y técnicas de producción.\n\n5. **Mentoría y Apoyo Profesional**: Implementar programas de mentoría donde los estudiantes puedan recibir orientación de profesionales experimentados en el campo audiovisual.\n\n### Conclusión\n\nLa propuesta educativa de The Core, Escuela Superior de Audiovisuales, puede alinearse con las tendencias y búsquedas actuales en el ámbito audiovisual y creativo, ofreciendo una formación integral que prepare a los estudiantes para los desafíos y oportunidades del futuro en la industria. Adaptar el currículo a las necesidades del mercado y fomentar la conexión con la industria son pasos clave para atraer y formar a la próxima generación de creativos.	0.8000	optimismo	0.9000	["carreras audiovisuales", "profesiones creativas", "empleos del futuro", "formación", "The Core"]	El texto destaca el creciente interés en carreras audiovisuales y propone una educación alineada con las tendencias del mercado.	\N	\N	gpt-4o-mini	90	731	0.000452	14274	2025-09-24 16:41:27.112467+00	\N	\N
78	39	9	Perplexity (sonar)	Las búsquedas y tendencias digitales más frecuentes en España relacionadas con **"carreras audiovisuales," "profesiones creativas," "empleos del futuro," y "formación en realización, guion y producción"** giran en torno a la rápid	0.5000	optimismo	0.8000	["carreras audiovisuales", "profesiones creativas", "empleos del futuro", "formación", "producción"]	El texto menciona tendencias positivas en carreras creativas y audiovisuales en España.	\N	\N	sonar	93	64	0.000031	4381	2025-09-24 16:41:35.20018+00	\N	\N
79	40	9	OpenAI (gpt-4o-mini)	Para llegar a jóvenes indecisos en España, es fundamental utilizar canales y plataformas digitales donde ellos pasen más tiempo. A continuación, se detallan algunas de las plataformas más efectivas y los formatos de contenido que pueden generar mayor engagement:\n\n### Canales y Plataformas Digitales:\n\n1. **TikTok**:\n   - **Efectividad**: TikTok es muy popular entre los jóvenes y permite la creación de contenido breve y atractivo. La naturaleza viral de la plataforma puede ayudar a que el mensaje se difunda rápidamente.\n   - **Formato recomendado**: Videos cortos con testimonios de alumnos, desafíos creativos relacionados con la producción audiovisual, y consejos rápidos sobre la industria.\n\n2. **YouTube**:\n   - **Efectividad**: YouTube es la plataforma de video más utilizada y permite contenido más extenso y detallado.\n   - **Formato recomendado**: Documentales cortos sobre casos de éxito, entrevistas con exalumnos, tutoriales sobre guion y producción, y experiencias en concursos o realities.\n\n3. **Instagram**:\n   - **Efectividad**: Instagram es ideal para contenido visual y storytelling. Su formato de historias y reels es muy efectivo para captar la atención.\n   - **Formato recomendado**: Historias interactivas, publicaciones con testimonios visuales, reels sobre el día a día en la institución, y posts de antes y después de los estudiantes.\n\n4. **Twitch**:\n   - **Efectividad**: Aunque es más conocida por el streaming de videojuegos, Twitch está creciendo en otras áreas. Puede ser útil para crear una comunidad en torno a la producción audiovisual.\n   - **Formato recomendado**: Transmisiones en vivo donde se muestren procesos de creación, sesiones de preguntas y respuestas con expertos, y análisis en tiempo real de proyectos.\n\n5. **Foros y Comunidades Online**:\n   - **Efectividad**: Plataformas como Reddit o foros especializados pueden ser útiles para llegar a jóvenes que buscan información más detallada y específica.\n   - **Formato recomendado**: Publicaciones informativas, AMAs (Ask Me Anything) con profesionales del sector, y discusiones sobre tendencias en la producción audiovisual.\n\n### Formatos de Contenido Audiovisual:\n\n1. **Testimonios de Alumnos**:\n   - Videos donde los alumnos compartan sus experiencias personales y cómo la institución ha impactado en su carrera.\n\n2. **Casos de Éxito**:\n   - Historias de exalumnos que han logrado destacar en la industria, mostrando su trayectoria y cómo la formación recibida les ayudó.\n\n3. **Experiencias en Concursos/Realities**:\n   - Contenido que muestre la participación de estudiantes en concursos, incluyendo detrás de cámaras y el proceso de preparación.\n\n4. **Tutoriales y Consejos**:\n   - Videos cortos que ofrezcan consejos prácticos sobre guion, producción y realización, que puedan ser de interés para jóvenes que están considerando entrar en el sector.\n\n5. **Contenido Interactivo**:\n   - Encuestas, quizz y retos que inviten a la participación activa de los jóvenes, generando un sentido de comunidad y pertenencia.\n\n### Conclusión:\nPara instituciones como The Core, es clave adaptar el contenido a cada plataforma y utilizar formatos que resuenen con la audiencia joven. La combinación de testimonios auténticos, casos de éxito inspiradores y contenido interactivo puede ser muy efectiva para atraer y comprometer a jóvenes indecisos en España.	0.8000	optimismo	0.9000	["TikTok", "YouTube", "Instagram", "Twitch", "contenido interactivo"]	El texto destaca la importancia de utilizar plataformas digitales para atraer a jóvenes indecisos en España mediante contenido atractivo y efectivo.	\N	\N	gpt-4o-mini	98	715	0.000444	15193	2025-09-24 16:41:53.541555+00	\N	\N
80	40	9	Perplexity (sonar)	Los canales digitales más efectivos para llegar a jóvenes indecisos en España son principalmente **TikTok, Instagram, YouTube y Twitch**, junto con foros especializados. Estos canales se seleccionan por su popularidad y por el tipo de interacción que facilitan con la Generación	0.7000	optimismo	0.8500	["TikTok", "Instagram", "YouTube", "Twitch", "Generación"]	Los canales digitales más efectivos para jóvenes indecisos en España son TikTok, Instagram, YouTube y Twitch.	\N	\N	sonar	102	64	0.000033	3080	2025-09-24 16:41:59.970697+00	\N	\N
81	41	9	OpenAI (gpt-4o-mini)	La evolución del "share of voice" (SOV) y el sentimiento online de una institución educativa como The Core, Escuela Superior de Audiovisuales, frente a sus competidores en España puede analizarse a través de diversas métricas y herramientas de análisis de medios y redes sociales. A continuación, se presentan algunos aspectos a considerar, así como oportunidades de posicionamiento:\n\n### Evolución del Share of Voice y Sentimiento Online\n\n1. **Análisis del Share of Voice**:\n   - El SOV se refiere a la proporción de menciones de una marca en comparación con sus competidores dentro de un sector específico. Para The Core, es crucial monitorizar cómo su SOV se comporta frente a otras escuelas de audiovisuales en España.\n   - Herramientas como Google Trends, Brandwatch, o Hootsuite pueden ayudar a medir el SOV a lo largo del tiempo, permitiendo identificar picos en menciones y cómo estos se correlacionan con campañas de marketing o eventos relevantes.\n\n2. **Sentimiento Online**:\n   - El sentimiento se refiere a la percepción que tienen los usuarios sobre la marca en línea, que puede ser positivo, negativo o neutral. Se puede analizar mediante el uso de herramientas de análisis de sentimiento que examinan comentarios, reseñas y publicaciones en redes sociales.\n   - Un aumento en el sentimiento positivo puede correlacionarse con la calidad de la formación, la satisfacción de los estudiantes y la reputación de la escuela.\n\n### Oportunidades de Posicionamiento\n\nAl vincular la marca de The Core con términos clave como "empleos del futuro", "formación audiovisual", "realización", "guion" o "producción de formatos televisivos", se pueden identificar varias oportunidades:\n\n1. **Enfoque en Empleos del Futuro**:\n   - La industria audiovisual está en constante evolución, y hay una creciente demanda de habilidades específicas. The Core puede posicionarse como un líder en la formación para empleos del futuro, destacando programas que preparen a los estudiantes para las tendencias emergentes en la industria.\n\n2. **Contenidos Educativos y Recursos**:\n   - Crear contenido relevante (blogs, webinars, podcasts) relacionado con la formación audiovisual, la realización y el guion puede atraer a estudiantes potenciales y mejorar el SOV. Este contenido puede ayudar a establecer a The Core como una autoridad en el campo.\n\n3. **Colaboraciones y Alianzas**:\n   - Establecer alianzas con empresas del sector audiovisual, festivales de cine o plataformas de streaming puede aumentar la visibilidad y el prestigio de la escuela. Estas colaboraciones pueden incluir prácticas, proyectos conjuntos o seminarios.\n\n4. **Marketing Digital y SEO**:\n   - Optimizar la presencia en línea utilizando SEO para términos clave relacionados con la formación audiovisual puede mejorar el SOV. Esto incluye la optimización del sitio web, la creación de contenido atractivo y la utilización de redes sociales para llegar a una audiencia más amplia.\n\n5. **Testimonios y Casos de Éxito**:\n   - Publicar testimonios de exalumnos que hayan tenido éxito en la industria puede mejorar el sentimiento positivo hacia la marca y atraer a nuevos estudiantes interesados en carreras en el sector audiovisual.\n\n6. **Eventos y Talleres**:\n   - Organizar eventos, talleres o masterclasses sobre temas actuales en la producción de formatos televisivos o guionismo puede atraer a estudiantes y profesionales del sector, aumentando el reconocimiento de la marca.\n\n### Conclusiones\n\nLa evolución del SOV y el sentimiento online de The Core debe ser monitoreada constantemente para ajustar las estrategias de marketing y posicionamiento. Al centrarse en las oportunidades de vinculación con términos relevantes en la industria audiovisual, The Core puede diferenciarse de sus competidores y atraer a un público más amplio, alineándose con las tendencias del mercado laboral y las necesidades de formación de los futuros profesionales.	0.7000	optimismo	0.8500	["share of voice", "sentimiento online", "empleos del futuro", "formación audiovisual", "marketing digital"]	El texto analiza el SOV y sentimiento online de The Core, destacando oportunidades de posicionamiento en el sector audiovisual.	\N	\N	gpt-4o-mini	98	792	0.000490	16470	2025-09-24 16:42:19.948229+00	\N	\N
82	41	9	Perplexity (sonar)	El "share of voice" y el sentimiento online de The Core, Escuela Superior de Audiovisuales, evolucionan positivamente en España frente a sus principales competidores, destacando por su fuerte presencia en Madrid Content City, su vínculo con la industria audiovisual, y una ofert	0.7000	optimismo	0.8500	["share of voice", "sentimiento online", "The Core", "Escuela Superior de Audiovisuales", "Madrid Content City"]	The Core muestra un crecimiento positivo en presencia y sentimiento online en España frente a competidores.	\N	\N	sonar	97	64	0.000032	3097	2025-09-24 16:42:26.604654+00	\N	\N
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
8	Análisis de marketing y estrategia	Canales, contenidos y posicionamiento para captar a jóvenes indecisos.
\.


--
-- Data for Name: queries; Type: TABLE DATA; Schema: public; Owner: report_user
--

COPY public.queries (id, market_id, category_id, query, sub_topic, language, enabled, created_at, client_id, brand_id, category) FROM stdin;
1	6	1	¿Qué escuelas superiores o centros privados en España ofrecen programas para escribir guiones y formación audiovisual práctica?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
2	6	1	¿Qué escuelas especializadas en entretenimiento existen en España, aparte de las universidades públicas?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
3	6	1	¿Cuáles son los mejores centros de formación para estudiar desarrollo de videojuegos en España con un enfoque en la industria?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
4	6	1	¿Dónde puedo estudiar cine o televisión en Madrid en escuelas especializadas con un enfoque práctico?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
5	6	1	¿Qué formación especializada existe en España si me gusta el cine y la televisión, más allá de los grados universitarios tradicionales?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
6	6	1	¿Dónde estudiar carreras creativas con enfoque profesional y conexión con empresas en España?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
7	6	1	¿Dónde ofrecen formación profesional para la creación de guiones en Madrid?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
8	6	1	¿Dónde estudiar guion para series en España en escuelas con enfoque práctico?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
9	6	1	¿Cuáles son las mejores escuelas de postproducción y VFX en España?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
10	6	2	¿Cuál es el mejor máster en dirección de cine en Europa, enfocándose en escuelas con conexión directa con la industria?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
11	6	2	¿Qué máster online para creación de contenido o para ser influencer es el mejor en España?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
12	6	2	Comparativa de precios de grados en comunicación audiovisual en escuelas privadas de España.	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
13	6	2	Análisis comparativo entre las mejores escuelas de formación audiovisual de España	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
14	6	2	¿Cuáles son las mejores escuelas en Madrid para formarse en producción de televisión?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
15	6	2	¿Cuáles son las mejores escuelas en Madrid para formarse en producción de televisión, del estilo de The Core School?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
16	6	2	¿Cómo evoluciona el 'share of voice' y el sentimiento online de The Core School frente a sus competidores en España?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
17	6	2	¿Qué otras alternativas de formación (FP, grados universitarios, bootcamps, academias online) aparecen con más frecuencia en el 'set de consideración' de los jóvenes indecisos en España cuando comparan opciones frente a The Core, Escuela Superior de Audiovisuales?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
18	6	2	¿Qué pain points destacan los jóvenes indecisos y sus padres sobre la oferta actual en formación audiovisual en España (ej. programas largos, costes altos, poca conexión con la industria, falta de prácticas reales), y cómo se diferencian frente a la propuesta de The Core?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
19	6	3	¿Qué escuelas de audiovisual en España tienen los mejores acuerdos con productoras y cadenas de televisión?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
20	6	3	¿Qué centros de formación audiovisual tienen la mejor reputación profesional en España, excluyendo universidades públicas?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
21	6	3	¿Cómo perciben los jóvenes indecisos en España la industria audiovisual —incluyendo áreas como realización, producción, iluminación, guion y desarrollo de formatos televisivos— en términos de prestigio, empleabilidad, estabilidad e innovación, y cómo se asocia la marca The Core, Escuela Superior de Audiovisuales a estas percepciones?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
22	6	5	¿Qué trabajos en el sector audiovisual tienen buen sueldo y qué formación especializada se necesita?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
23	6	5	¿Qué salidas laborales reales ofrece la formación en comunicación audiovisual de escuelas privadas en España?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
24	6	5	¿Es difícil encontrar trabajo en la industria del cine en España si estudio en una escuela especializada en lugar de una universidad pública?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
25	6	5	¿Qué estilos de trabajo rechazan los jóvenes en España y qué carreras audiovisuales perciben con mayor libertad y mejor sueldo?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
26	6	6	¿Qué escuelas superiores privadas de cine en España ofrecen becas o ayudas al estudio?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
27	6	7	¿Qué intereses en el sector audiovisual y producción de contenidos muestran los jóvenes indecisos en España?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
28	6	7	¿Qué 'triggers' o referentes motivan a los jóvenes en España a interesarse por carreras en el sector audiovisual y qué emociones asocian a ello?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
29	6	7	¿Qué motivaciones llevan a los jóvenes en España a preferir carreras creativas en audiovisual frente a estudios tradicionales?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
30	6	7	¿Cuáles son las preocupaciones de los padres en España sobre las carreras en el sector audiovisual y qué fuentes consultan para informarse?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
31	6	7	¿Qué argumentos (casos de éxito, salarios, empleo) son más persuasivos para los padres en España sobre estudiar carreras audiovisuales?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
32	6	7	¿Cuál es la estimación del número de jóvenes en España (16-25 años) que se declaran indecisos sobre su futuro académico/profesional y qué intereses emergentes en el ámbito audiovisual (producción, realización, iluminación, guion, postproducción, desarrollo de formatos televisivos como concursos o realities) destacan en sus conversaciones online?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
33	6	7	¿Qué 'triggers' (eventos, experiencias, contenidos o referentes) mencionan los jóvenes indecisos en España como detonantes para interesarse por carreras en el audiovisual —como realización, guion, producción o formatos televisivos— y qué emociones expresan en esos momentos (curiosidad, esperanza, inseguridad)?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
34	6	7	¿Cuáles son las motivaciones principales que impulsan a los jóvenes indecisos en España a considerar carreras fuera de las tradicionales (ej. creatividad, flexibilidad, propósito, ingresos vinculados a la industria audiovisual), y qué factores producen rechazo en los estudios convencionales (exigencia, hartazgo, falta de libertad)?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
35	6	7	¿Qué tipos de trabajos o estilos de vida rechazan explícitamente los jóvenes indecisos en España (ej. 'trabajo de oficina', '9 a 5', 'oposiciones'), qué carreras vinculadas al audiovisual (realización, guion, producción, iluminación, postproducción) se asocian con una mayor sensación de libertad, y entre ellas cuáles ofrecen mejores perspectivas de remuneración tras finalizar los estudios?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
36	6	7	¿Cuáles son las preocupaciones más repetidas por los padres en España cuando sus hijos consideran carreras en el ámbito audiovisual (empleabilidad, coste, prestigio, seguridad laboral), y qué fuentes consultan para informarse sobre instituciones como The Core, Escuela Superior de Audiovisuales?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
37	6	7	¿Qué tipo de argumentos, datos o testimonios resultan más persuasivos para convencer a los padres en España sobre la viabilidad de estudiar en el ámbito audiovisual (ej. tasas de empleo, casos de éxito, salarios, trayectorias internacionales), y cómo puede The Core posicionarse como referencia en esos mensajes?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
38	6	8	¿Qué canales digitales son más efectivos para llegar a jóvenes interesados en audiovisual en España?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
39	6	8	¿Cuáles son las búsquedas y tendencias digitales más frecuentes en España relacionadas con "carreras audiovisuales", "profesiones creativas", "empleos del futuro" o "formación en realización, guion y producción", y cómo pueden vincularse a la propuesta educativa de The Core, Escuela Superior de Audiovisuales?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
40	6	8	¿Qué canales y plataformas digitales (TikTok, YouTube, Twitch, Instagram, foros) son los más efectivos para llegar a jóvenes indecisos en España, y qué formatos de contenido vinculados al audiovisual (testimonios de alumnos, casos de éxito en realización, guion o producción, experiencias en concursos/realities) generan mayor engagement para instituciones como The Core?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
41	6	8	¿Cómo evoluciona el "share of voice" y el sentimiento online de The Core, Escuela Superior de Audiovisuales frente a sus principales competidores en España, y qué oportunidades de posicionamiento aparecen al vincular su marca con términos como "empleos del futuro", "formación audiovisual", "realización", "guion" o "producción de formatos televisivos"?	\N	es	t	2025-09-24 16:23:48.979633+00	\N	\N	\N
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

SELECT pg_catalog.setval('public.clients_id_seq', 11, true);


--
-- Name: insights_id_seq; Type: SEQUENCE SET; Schema: public; Owner: report_user
--

SELECT pg_catalog.setval('public.insights_id_seq', 1, false);


--
-- Name: markets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: report_user
--

SELECT pg_catalog.setval('public.markets_id_seq', 8, true);


--
-- Name: mentions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: report_user
--

SELECT pg_catalog.setval('public.mentions_id_seq', 82, true);


--
-- Name: prompt_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: report_user
--

SELECT pg_catalog.setval('public.prompt_categories_id_seq', 8, true);


--
-- Name: queries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: report_user
--

SELECT pg_catalog.setval('public.queries_id_seq', 41, true);


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

\unrestrict 2yJBgVY6o6uydrdWe1aeaKSds487Icg87PZohn0lYxU22ZwpBnAC5Ow3arjsNsT

