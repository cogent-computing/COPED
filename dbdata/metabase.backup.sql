--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4 (Debian 13.4-4.pgdg110+1)
-- Dumped by pg_dump version 13.4 (Debian 13.4-4.pgdg110+1)

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

--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activity (
    id integer NOT NULL,
    topic character varying(32) NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    user_id integer,
    model character varying(16),
    model_id integer,
    database_id integer,
    table_id integer,
    custom_id character varying(48),
    details character varying NOT NULL
);


ALTER TABLE public.activity OWNER TO postgres;

--
-- Name: activity_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activity_id_seq OWNER TO postgres;

--
-- Name: activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.activity_id_seq OWNED BY public.activity.id;


--
-- Name: card_label; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.card_label (
    id integer NOT NULL,
    card_id integer NOT NULL,
    label_id integer NOT NULL
);


ALTER TABLE public.card_label OWNER TO postgres;

--
-- Name: card_label_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.card_label_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.card_label_id_seq OWNER TO postgres;

--
-- Name: card_label_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.card_label_id_seq OWNED BY public.card_label.id;


--
-- Name: collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collection (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    color character(7) NOT NULL,
    archived boolean DEFAULT false NOT NULL,
    location character varying(254) DEFAULT '/'::character varying NOT NULL,
    personal_owner_id integer,
    slug character varying(254) NOT NULL,
    namespace character varying(254),
    authority_level character varying(255)
);


ALTER TABLE public.collection OWNER TO postgres;

--
-- Name: TABLE collection; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.collection IS 'Collections are an optional way to organize Cards and handle permissions for them.';


--
-- Name: COLUMN collection.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection.name IS 'The user-facing name of this Collection.';


--
-- Name: COLUMN collection.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection.description IS 'Optional description for this Collection.';


--
-- Name: COLUMN collection.color; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection.color IS 'Seven-character hex color for this Collection, including the preceding hash sign.';


--
-- Name: COLUMN collection.archived; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection.archived IS 'Whether this Collection has been archived and should be hidden from users.';


--
-- Name: COLUMN collection.location; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection.location IS 'Directory-structure path of ancestor Collections. e.g. "/1/2/" means our Parent is Collection 2, and their parent is Collection 1.';


--
-- Name: COLUMN collection.personal_owner_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection.personal_owner_id IS 'If set, this Collection is a personal Collection, for exclusive use of the User with this ID.';


--
-- Name: COLUMN collection.slug; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection.slug IS 'Sluggified version of the Collection name. Used only for display purposes in URL; not unique or indexed.';


--
-- Name: COLUMN collection.namespace; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection.namespace IS 'The namespace (hierachy) this Collection belongs to. NULL means the Collection is in the default namespace.';


--
-- Name: COLUMN collection.authority_level; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection.authority_level IS 'Nullable column to incidate collection''s authority level. Initially values are "official" and nil.';


--
-- Name: collection_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.collection_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.collection_id_seq OWNER TO postgres;

--
-- Name: collection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.collection_id_seq OWNED BY public.collection.id;


--
-- Name: collection_permission_graph_revision; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collection_permission_graph_revision (
    id integer NOT NULL,
    before text NOT NULL,
    after text NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    remark text
);


ALTER TABLE public.collection_permission_graph_revision OWNER TO postgres;

--
-- Name: TABLE collection_permission_graph_revision; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.collection_permission_graph_revision IS 'Used to keep track of changes made to collections.';


--
-- Name: COLUMN collection_permission_graph_revision.before; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection_permission_graph_revision.before IS 'Serialized JSON of the collections graph before the changes.';


--
-- Name: COLUMN collection_permission_graph_revision.after; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection_permission_graph_revision.after IS 'Serialized JSON of the collections graph after the changes.';


--
-- Name: COLUMN collection_permission_graph_revision.user_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection_permission_graph_revision.user_id IS 'The ID of the admin who made this set of changes.';


--
-- Name: COLUMN collection_permission_graph_revision.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection_permission_graph_revision.created_at IS 'The timestamp of when these changes were made.';


--
-- Name: COLUMN collection_permission_graph_revision.remark; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.collection_permission_graph_revision.remark IS 'Optional remarks explaining why these changes were made.';


--
-- Name: collection_permission_graph_revision_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.collection_permission_graph_revision_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.collection_permission_graph_revision_id_seq OWNER TO postgres;

--
-- Name: collection_permission_graph_revision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.collection_permission_graph_revision_id_seq OWNED BY public.collection_permission_graph_revision.id;


--
-- Name: computation_job; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.computation_job (
    id integer NOT NULL,
    creator_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    type character varying(254) NOT NULL,
    status character varying(254) NOT NULL,
    context text,
    ended_at timestamp without time zone
);


ALTER TABLE public.computation_job OWNER TO postgres;

--
-- Name: TABLE computation_job; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.computation_job IS 'Stores submitted async computation jobs.';


--
-- Name: computation_job_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.computation_job_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.computation_job_id_seq OWNER TO postgres;

--
-- Name: computation_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.computation_job_id_seq OWNED BY public.computation_job.id;


--
-- Name: computation_job_result; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.computation_job_result (
    id integer NOT NULL,
    job_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    permanence character varying(254) NOT NULL,
    payload text NOT NULL
);


ALTER TABLE public.computation_job_result OWNER TO postgres;

--
-- Name: TABLE computation_job_result; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.computation_job_result IS 'Stores results of async computation jobs.';


--
-- Name: computation_job_result_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.computation_job_result_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.computation_job_result_id_seq OWNER TO postgres;

--
-- Name: computation_job_result_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.computation_job_result_id_seq OWNED BY public.computation_job_result.id;


--
-- Name: core_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_session (
    id character varying(254) NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    anti_csrf_token text
);


ALTER TABLE public.core_session OWNER TO postgres;

--
-- Name: COLUMN core_session.anti_csrf_token; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.core_session.anti_csrf_token IS 'Anti-CSRF token for full-app embed sessions.';


--
-- Name: core_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.core_user (
    id integer NOT NULL,
    email public.citext NOT NULL,
    first_name character varying(254) NOT NULL,
    last_name character varying(254) NOT NULL,
    password character varying(254) NOT NULL,
    password_salt character varying(254) DEFAULT 'default'::character varying NOT NULL,
    date_joined timestamp with time zone NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    reset_token character varying(254),
    reset_triggered bigint,
    is_qbnewb boolean DEFAULT true NOT NULL,
    google_auth boolean DEFAULT false NOT NULL,
    ldap_auth boolean DEFAULT false NOT NULL,
    login_attributes text,
    updated_at timestamp without time zone,
    sso_source character varying(254),
    locale character varying(5)
);


ALTER TABLE public.core_user OWNER TO postgres;

--
-- Name: COLUMN core_user.login_attributes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.core_user.login_attributes IS 'JSON serialized map with attributes used for row level permissions';


--
-- Name: COLUMN core_user.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.core_user.updated_at IS 'When was this User last updated?';


--
-- Name: COLUMN core_user.sso_source; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.core_user.sso_source IS 'String to indicate the SSO backend the user is from';


--
-- Name: COLUMN core_user.locale; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.core_user.locale IS 'Preferred ISO locale (language/country) code, e.g "en" or "en-US", for this User. Overrides site default.';


--
-- Name: core_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.core_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_user_id_seq OWNER TO postgres;

--
-- Name: core_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.core_user_id_seq OWNED BY public.core_user.id;


--
-- Name: dashboard_favorite; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dashboard_favorite (
    id integer NOT NULL,
    user_id integer NOT NULL,
    dashboard_id integer NOT NULL
);


ALTER TABLE public.dashboard_favorite OWNER TO postgres;

--
-- Name: TABLE dashboard_favorite; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.dashboard_favorite IS 'Presence of a row here indicates a given User has favorited a given Dashboard.';


--
-- Name: COLUMN dashboard_favorite.user_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dashboard_favorite.user_id IS 'ID of the User who favorited the Dashboard.';


--
-- Name: COLUMN dashboard_favorite.dashboard_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dashboard_favorite.dashboard_id IS 'ID of the Dashboard favorited by the User.';


--
-- Name: dashboard_favorite_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dashboard_favorite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dashboard_favorite_id_seq OWNER TO postgres;

--
-- Name: dashboard_favorite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dashboard_favorite_id_seq OWNED BY public.dashboard_favorite.id;


--
-- Name: dashboardcard_series; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dashboardcard_series (
    id integer NOT NULL,
    dashboardcard_id integer NOT NULL,
    card_id integer NOT NULL,
    "position" integer NOT NULL
);


ALTER TABLE public.dashboardcard_series OWNER TO postgres;

--
-- Name: dashboardcard_series_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dashboardcard_series_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dashboardcard_series_id_seq OWNER TO postgres;

--
-- Name: dashboardcard_series_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dashboardcard_series_id_seq OWNED BY public.dashboardcard_series.id;


--
-- Name: data_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data_migrations (
    id character varying(254) NOT NULL,
    "timestamp" timestamp without time zone NOT NULL
);


ALTER TABLE public.data_migrations OWNER TO postgres;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO postgres;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO postgres;

--
-- Name: dependency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dependency (
    id integer NOT NULL,
    model character varying(32) NOT NULL,
    model_id integer NOT NULL,
    dependent_on_model character varying(32) NOT NULL,
    dependent_on_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.dependency OWNER TO postgres;

--
-- Name: dependency_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dependency_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dependency_id_seq OWNER TO postgres;

--
-- Name: dependency_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dependency_id_seq OWNED BY public.dependency.id;


--
-- Name: dimension; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dimension (
    id integer NOT NULL,
    field_id integer NOT NULL,
    name character varying(254) NOT NULL,
    type character varying(254) NOT NULL,
    human_readable_field_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.dimension OWNER TO postgres;

--
-- Name: TABLE dimension; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.dimension IS 'Stores references to alternate views of existing fields, such as remapping an integer to a description, like an enum';


--
-- Name: COLUMN dimension.field_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dimension.field_id IS 'ID of the field this dimension row applies to';


--
-- Name: COLUMN dimension.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dimension.name IS 'Short description used as the display name of this new column';


--
-- Name: COLUMN dimension.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dimension.type IS 'Either internal for a user defined remapping or external for a foreign key based remapping';


--
-- Name: COLUMN dimension.human_readable_field_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dimension.human_readable_field_id IS 'Only used with external type remappings. Indicates which field on the FK related table to use for display';


--
-- Name: COLUMN dimension.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dimension.created_at IS 'The timestamp of when the dimension was created.';


--
-- Name: COLUMN dimension.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.dimension.updated_at IS 'The timestamp of when these dimension was last updated.';


--
-- Name: dimension_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dimension_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dimension_id_seq OWNER TO postgres;

--
-- Name: dimension_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dimension_id_seq OWNED BY public.dimension.id;


--
-- Name: group_table_access_policy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_table_access_policy (
    id integer NOT NULL,
    group_id integer NOT NULL,
    table_id integer NOT NULL,
    card_id integer,
    attribute_remappings text
);


ALTER TABLE public.group_table_access_policy OWNER TO postgres;

--
-- Name: TABLE group_table_access_policy; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.group_table_access_policy IS 'Records that a given Card (Question) should automatically replace a given Table as query source for a given a Perms Group.';


--
-- Name: COLUMN group_table_access_policy.group_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.group_table_access_policy.group_id IS 'ID of the Permissions Group this policy affects.';


--
-- Name: COLUMN group_table_access_policy.table_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.group_table_access_policy.table_id IS 'ID of the Table that should get automatically replaced as query source for the Permissions Group.';


--
-- Name: COLUMN group_table_access_policy.card_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.group_table_access_policy.card_id IS 'ID of the Card (Question) to be used to replace the Table.';


--
-- Name: COLUMN group_table_access_policy.attribute_remappings; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.group_table_access_policy.attribute_remappings IS 'JSON-encoded map of user attribute identifier to the param name used in the Card.';


--
-- Name: group_table_access_policy_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.group_table_access_policy_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.group_table_access_policy_id_seq OWNER TO postgres;

--
-- Name: group_table_access_policy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.group_table_access_policy_id_seq OWNED BY public.group_table_access_policy.id;


--
-- Name: label; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.label (
    id integer NOT NULL,
    name character varying(254) NOT NULL,
    slug character varying(254) NOT NULL,
    icon character varying(128)
);


ALTER TABLE public.label OWNER TO postgres;

--
-- Name: label_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.label_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.label_id_seq OWNER TO postgres;

--
-- Name: label_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.label_id_seq OWNED BY public.label.id;


--
-- Name: login_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.login_history (
    id integer NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL,
    user_id integer NOT NULL,
    session_id character varying(254),
    device_id character(36) NOT NULL,
    device_description text NOT NULL,
    ip_address text NOT NULL
);


ALTER TABLE public.login_history OWNER TO postgres;

--
-- Name: TABLE login_history; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.login_history IS 'Keeps track of various logins for different users and additional info such as location and device';


--
-- Name: COLUMN login_history."timestamp"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.login_history."timestamp" IS 'When this login occurred.';


--
-- Name: COLUMN login_history.user_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.login_history.user_id IS 'ID of the User that logged in.';


--
-- Name: COLUMN login_history.session_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.login_history.session_id IS 'ID of the Session created by this login if one is currently active. NULL if Session is no longer active.';


--
-- Name: COLUMN login_history.device_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.login_history.device_id IS 'Cookie-based unique identifier for the device/browser the user logged in from.';


--
-- Name: COLUMN login_history.device_description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.login_history.device_description IS 'Description of the device that login happened from, for example a user-agent string, but this might be something different if we support alternative auth mechanisms in the future.';


--
-- Name: COLUMN login_history.ip_address; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.login_history.ip_address IS 'IP address of the device that login happened from, so we can geocode it and determine approximate location.';


--
-- Name: login_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.login_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.login_history_id_seq OWNER TO postgres;

--
-- Name: login_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.login_history_id_seq OWNED BY public.login_history.id;


--
-- Name: metabase_database; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metabase_database (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    details text,
    engine character varying(254) NOT NULL,
    is_sample boolean DEFAULT false NOT NULL,
    is_full_sync boolean DEFAULT true NOT NULL,
    points_of_interest text,
    caveats text,
    metadata_sync_schedule character varying(254) DEFAULT '0 50 * * * ? *'::character varying NOT NULL,
    cache_field_values_schedule character varying(254) DEFAULT '0 50 0 * * ? *'::character varying NOT NULL,
    timezone character varying(254),
    is_on_demand boolean DEFAULT false NOT NULL,
    options text,
    auto_run_queries boolean DEFAULT true NOT NULL,
    refingerprint boolean,
    cache_ttl integer
);


ALTER TABLE public.metabase_database OWNER TO postgres;

--
-- Name: COLUMN metabase_database.metadata_sync_schedule; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_database.metadata_sync_schedule IS 'The cron schedule string for when this database should undergo the metadata sync process (and analysis for new fields).';


--
-- Name: COLUMN metabase_database.cache_field_values_schedule; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_database.cache_field_values_schedule IS 'The cron schedule string for when FieldValues for eligible Fields should be updated.';


--
-- Name: COLUMN metabase_database.timezone; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_database.timezone IS 'Timezone identifier for the database, set by the sync process';


--
-- Name: COLUMN metabase_database.is_on_demand; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_database.is_on_demand IS 'Whether we should do On-Demand caching of FieldValues for this DB. This means FieldValues are updated when their Field is used in a Dashboard or Card param.';


--
-- Name: COLUMN metabase_database.options; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_database.options IS 'Serialized JSON containing various options like QB behavior.';


--
-- Name: COLUMN metabase_database.auto_run_queries; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_database.auto_run_queries IS 'Whether to automatically run queries when doing simple filtering and summarizing in the Query Builder.';


--
-- Name: COLUMN metabase_database.refingerprint; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_database.refingerprint IS 'Whether or not to enable periodic refingerprinting for this Database.';


--
-- Name: COLUMN metabase_database.cache_ttl; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_database.cache_ttl IS 'Granular cache TTL for specific database.';


--
-- Name: metabase_database_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.metabase_database_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metabase_database_id_seq OWNER TO postgres;

--
-- Name: metabase_database_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.metabase_database_id_seq OWNED BY public.metabase_database.id;


--
-- Name: metabase_field; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metabase_field (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(254) NOT NULL,
    base_type character varying(255) NOT NULL,
    semantic_type character varying(255),
    active boolean DEFAULT true NOT NULL,
    description text,
    preview_display boolean DEFAULT true NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    table_id integer NOT NULL,
    parent_id integer,
    display_name character varying(254),
    visibility_type character varying(32) DEFAULT 'normal'::character varying NOT NULL,
    fk_target_field_id integer,
    last_analyzed timestamp with time zone,
    points_of_interest text,
    caveats text,
    fingerprint text,
    fingerprint_version integer DEFAULT 0 NOT NULL,
    database_type text NOT NULL,
    has_field_values text,
    settings text,
    database_position integer DEFAULT 0 NOT NULL,
    custom_position integer DEFAULT 0 NOT NULL,
    effective_type character varying(255),
    coercion_strategy character varying(255)
);


ALTER TABLE public.metabase_field OWNER TO postgres;

--
-- Name: COLUMN metabase_field.fingerprint; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_field.fingerprint IS 'Serialized JSON containing non-identifying information about this Field, such as min, max, and percent JSON. Used for classification.';


--
-- Name: COLUMN metabase_field.fingerprint_version; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_field.fingerprint_version IS 'The version of the fingerprint for this Field. Used so we can keep track of which Fields need to be analyzed again when new things are added to fingerprints.';


--
-- Name: COLUMN metabase_field.database_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_field.database_type IS 'The actual type of this column in the database. e.g. VARCHAR or TEXT.';


--
-- Name: COLUMN metabase_field.has_field_values; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_field.has_field_values IS 'Whether we have FieldValues ("list"), should ad-hoc search ("search"), disable entirely ("none"), or infer dynamically (null)"';


--
-- Name: COLUMN metabase_field.settings; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_field.settings IS 'Serialized JSON FE-specific settings like formatting, etc. Scope of what is stored here may increase in future.';


--
-- Name: COLUMN metabase_field.effective_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_field.effective_type IS 'The effective type of the field after any coercions.';


--
-- Name: COLUMN metabase_field.coercion_strategy; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.metabase_field.coercion_strategy IS 'A strategy to coerce the base_type into the effective_type.';


--
-- Name: metabase_field_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.metabase_field_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metabase_field_id_seq OWNER TO postgres;

--
-- Name: metabase_field_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.metabase_field_id_seq OWNED BY public.metabase_field.id;


--
-- Name: metabase_fieldvalues; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metabase_fieldvalues (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    "values" text,
    human_readable_values text,
    field_id integer NOT NULL
);


ALTER TABLE public.metabase_fieldvalues OWNER TO postgres;

--
-- Name: metabase_fieldvalues_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.metabase_fieldvalues_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metabase_fieldvalues_id_seq OWNER TO postgres;

--
-- Name: metabase_fieldvalues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.metabase_fieldvalues_id_seq OWNED BY public.metabase_fieldvalues.id;


--
-- Name: metabase_table; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metabase_table (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    entity_name character varying(254),
    entity_type character varying(254),
    active boolean NOT NULL,
    db_id integer NOT NULL,
    display_name character varying(254),
    visibility_type character varying(254),
    schema character varying(254),
    points_of_interest text,
    caveats text,
    show_in_getting_started boolean DEFAULT false NOT NULL,
    field_order character varying(254) DEFAULT 'database'::character varying NOT NULL
);


ALTER TABLE public.metabase_table OWNER TO postgres;

--
-- Name: metabase_table_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.metabase_table_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metabase_table_id_seq OWNER TO postgres;

--
-- Name: metabase_table_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.metabase_table_id_seq OWNED BY public.metabase_table.id;


--
-- Name: metric; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metric (
    id integer NOT NULL,
    table_id integer NOT NULL,
    creator_id integer NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    archived boolean DEFAULT false NOT NULL,
    definition text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    points_of_interest text,
    caveats text,
    how_is_this_calculated text,
    show_in_getting_started boolean DEFAULT false NOT NULL
);


ALTER TABLE public.metric OWNER TO postgres;

--
-- Name: metric_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.metric_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metric_id_seq OWNER TO postgres;

--
-- Name: metric_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.metric_id_seq OWNED BY public.metric.id;


--
-- Name: metric_important_field; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metric_important_field (
    id integer NOT NULL,
    metric_id integer NOT NULL,
    field_id integer NOT NULL
);


ALTER TABLE public.metric_important_field OWNER TO postgres;

--
-- Name: metric_important_field_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.metric_important_field_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metric_important_field_id_seq OWNER TO postgres;

--
-- Name: metric_important_field_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.metric_important_field_id_seq OWNED BY public.metric_important_field.id;


--
-- Name: moderation_review; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.moderation_review (
    id integer NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    status character varying(255),
    text text,
    moderated_item_id integer NOT NULL,
    moderated_item_type character varying(255) NOT NULL,
    moderator_id integer NOT NULL,
    most_recent boolean NOT NULL
);


ALTER TABLE public.moderation_review OWNER TO postgres;

--
-- Name: TABLE moderation_review; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.moderation_review IS 'Reviews (from moderators) for a given question/dashboard (BUCM)';


--
-- Name: COLUMN moderation_review.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.moderation_review.updated_at IS 'most recent modification time';


--
-- Name: COLUMN moderation_review.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.moderation_review.created_at IS 'creation time';


--
-- Name: COLUMN moderation_review.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.moderation_review.status IS 'verified, misleading, confusing, not_misleading, pending';


--
-- Name: COLUMN moderation_review.text; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.moderation_review.text IS 'Explanation of the review';


--
-- Name: COLUMN moderation_review.moderated_item_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.moderation_review.moderated_item_id IS 'either a document or question ID; the item that needs review';


--
-- Name: COLUMN moderation_review.moderated_item_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.moderation_review.moderated_item_type IS 'whether it''s a question or dashboard';


--
-- Name: COLUMN moderation_review.moderator_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.moderation_review.moderator_id IS 'ID of the user who did the review';


--
-- Name: COLUMN moderation_review.most_recent; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.moderation_review.most_recent IS 'tag for most recent review';


--
-- Name: moderation_review_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.moderation_review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.moderation_review_id_seq OWNER TO postgres;

--
-- Name: moderation_review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.moderation_review_id_seq OWNED BY public.moderation_review.id;


--
-- Name: native_query_snippet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.native_query_snippet (
    id integer NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    content text NOT NULL,
    creator_id integer NOT NULL,
    archived boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    collection_id integer
);


ALTER TABLE public.native_query_snippet OWNER TO postgres;

--
-- Name: TABLE native_query_snippet; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.native_query_snippet IS 'Query snippets (raw text) to be substituted in native queries';


--
-- Name: COLUMN native_query_snippet.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.native_query_snippet.name IS 'Name of the query snippet';


--
-- Name: COLUMN native_query_snippet.content; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.native_query_snippet.content IS 'Raw query snippet';


--
-- Name: COLUMN native_query_snippet.collection_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.native_query_snippet.collection_id IS 'ID of the Snippet Folder (Collection) this Snippet is in, if any';


--
-- Name: native_query_snippet_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.native_query_snippet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.native_query_snippet_id_seq OWNER TO postgres;

--
-- Name: native_query_snippet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.native_query_snippet_id_seq OWNED BY public.native_query_snippet.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id integer NOT NULL,
    object character varying(254) NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- Name: permissions_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions_group (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.permissions_group OWNER TO postgres;

--
-- Name: permissions_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_group_id_seq OWNER TO postgres;

--
-- Name: permissions_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_group_id_seq OWNED BY public.permissions_group.id;


--
-- Name: permissions_group_membership; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions_group_membership (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.permissions_group_membership OWNER TO postgres;

--
-- Name: permissions_group_membership_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_group_membership_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_group_membership_id_seq OWNER TO postgres;

--
-- Name: permissions_group_membership_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_group_membership_id_seq OWNED BY public.permissions_group_membership.id;


--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_id_seq OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- Name: permissions_revision; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions_revision (
    id integer NOT NULL,
    before text NOT NULL,
    after text NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    remark text
);


ALTER TABLE public.permissions_revision OWNER TO postgres;

--
-- Name: TABLE permissions_revision; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.permissions_revision IS 'Used to keep track of changes made to permissions.';


--
-- Name: COLUMN permissions_revision.before; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.permissions_revision.before IS 'Serialized JSON of the permissions before the changes.';


--
-- Name: COLUMN permissions_revision.after; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.permissions_revision.after IS 'Serialized JSON of the permissions after the changes.';


--
-- Name: COLUMN permissions_revision.user_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.permissions_revision.user_id IS 'The ID of the admin who made this set of changes.';


--
-- Name: COLUMN permissions_revision.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.permissions_revision.created_at IS 'The timestamp of when these changes were made.';


--
-- Name: COLUMN permissions_revision.remark; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.permissions_revision.remark IS 'Optional remarks explaining why these changes were made.';


--
-- Name: permissions_revision_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_revision_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_revision_id_seq OWNER TO postgres;

--
-- Name: permissions_revision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_revision_id_seq OWNED BY public.permissions_revision.id;


--
-- Name: pulse; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pulse (
    id integer NOT NULL,
    creator_id integer NOT NULL,
    name character varying(254),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    skip_if_empty boolean DEFAULT false NOT NULL,
    alert_condition character varying(254),
    alert_first_only boolean,
    alert_above_goal boolean,
    collection_id integer,
    collection_position smallint,
    archived boolean DEFAULT false,
    dashboard_id integer,
    parameters text NOT NULL
);


ALTER TABLE public.pulse OWNER TO postgres;

--
-- Name: COLUMN pulse.skip_if_empty; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pulse.skip_if_empty IS 'Skip a scheduled Pulse if none of its questions have any results';


--
-- Name: COLUMN pulse.alert_condition; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pulse.alert_condition IS 'Condition (i.e. "rows" or "goal") used as a guard for alerts';


--
-- Name: COLUMN pulse.alert_first_only; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pulse.alert_first_only IS 'True if the alert should be disabled after the first notification';


--
-- Name: COLUMN pulse.alert_above_goal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pulse.alert_above_goal IS 'For a goal condition, alert when above the goal';


--
-- Name: COLUMN pulse.collection_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pulse.collection_id IS 'Options ID of Collection this Pulse belongs to.';


--
-- Name: COLUMN pulse.collection_position; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pulse.collection_position IS 'Optional pinned position for this item in its Collection. NULL means item is not pinned.';


--
-- Name: COLUMN pulse.archived; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pulse.archived IS 'Has this pulse been archived?';


--
-- Name: COLUMN pulse.dashboard_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pulse.dashboard_id IS 'ID of the Dashboard if this Pulse is a Dashboard Subscription.';


--
-- Name: COLUMN pulse.parameters; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pulse.parameters IS 'Let dashboard subscriptions have their own filters';


--
-- Name: pulse_card; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pulse_card (
    id integer NOT NULL,
    pulse_id integer NOT NULL,
    card_id integer NOT NULL,
    "position" integer NOT NULL,
    include_csv boolean DEFAULT false NOT NULL,
    include_xls boolean DEFAULT false NOT NULL,
    dashboard_card_id integer
);


ALTER TABLE public.pulse_card OWNER TO postgres;

--
-- Name: COLUMN pulse_card.include_csv; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pulse_card.include_csv IS 'True if a CSV of the data should be included for this pulse card';


--
-- Name: COLUMN pulse_card.include_xls; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pulse_card.include_xls IS 'True if a XLS of the data should be included for this pulse card';


--
-- Name: COLUMN pulse_card.dashboard_card_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.pulse_card.dashboard_card_id IS 'If this Pulse is a Dashboard subscription, the ID of the DashboardCard that corresponds to this PulseCard.';


--
-- Name: pulse_card_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pulse_card_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pulse_card_id_seq OWNER TO postgres;

--
-- Name: pulse_card_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pulse_card_id_seq OWNED BY public.pulse_card.id;


--
-- Name: pulse_channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pulse_channel (
    id integer NOT NULL,
    pulse_id integer NOT NULL,
    channel_type character varying(32) NOT NULL,
    details text NOT NULL,
    schedule_type character varying(32) NOT NULL,
    schedule_hour integer,
    schedule_day character varying(64),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    schedule_frame character varying(32),
    enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public.pulse_channel OWNER TO postgres;

--
-- Name: pulse_channel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pulse_channel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pulse_channel_id_seq OWNER TO postgres;

--
-- Name: pulse_channel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pulse_channel_id_seq OWNED BY public.pulse_channel.id;


--
-- Name: pulse_channel_recipient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pulse_channel_recipient (
    id integer NOT NULL,
    pulse_channel_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.pulse_channel_recipient OWNER TO postgres;

--
-- Name: pulse_channel_recipient_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pulse_channel_recipient_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pulse_channel_recipient_id_seq OWNER TO postgres;

--
-- Name: pulse_channel_recipient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pulse_channel_recipient_id_seq OWNED BY public.pulse_channel_recipient.id;


--
-- Name: pulse_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pulse_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pulse_id_seq OWNER TO postgres;

--
-- Name: pulse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pulse_id_seq OWNED BY public.pulse.id;


--
-- Name: qrtz_blob_triggers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_blob_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    blob_data bytea
);


ALTER TABLE public.qrtz_blob_triggers OWNER TO postgres;

--
-- Name: TABLE qrtz_blob_triggers; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_blob_triggers IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_calendars; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_calendars (
    sched_name character varying(120) NOT NULL,
    calendar_name character varying(200) NOT NULL,
    calendar bytea NOT NULL
);


ALTER TABLE public.qrtz_calendars OWNER TO postgres;

--
-- Name: TABLE qrtz_calendars; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_calendars IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_cron_triggers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_cron_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    cron_expression character varying(120) NOT NULL,
    time_zone_id character varying(80)
);


ALTER TABLE public.qrtz_cron_triggers OWNER TO postgres;

--
-- Name: TABLE qrtz_cron_triggers; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_cron_triggers IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_fired_triggers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_fired_triggers (
    sched_name character varying(120) NOT NULL,
    entry_id character varying(95) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    instance_name character varying(200) NOT NULL,
    fired_time bigint NOT NULL,
    sched_time bigint,
    priority integer NOT NULL,
    state character varying(16) NOT NULL,
    job_name character varying(200),
    job_group character varying(200),
    is_nonconcurrent boolean,
    requests_recovery boolean
);


ALTER TABLE public.qrtz_fired_triggers OWNER TO postgres;

--
-- Name: TABLE qrtz_fired_triggers; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_fired_triggers IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_job_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_job_details (
    sched_name character varying(120) NOT NULL,
    job_name character varying(200) NOT NULL,
    job_group character varying(200) NOT NULL,
    description character varying(250),
    job_class_name character varying(250) NOT NULL,
    is_durable boolean NOT NULL,
    is_nonconcurrent boolean NOT NULL,
    is_update_data boolean NOT NULL,
    requests_recovery boolean NOT NULL,
    job_data bytea
);


ALTER TABLE public.qrtz_job_details OWNER TO postgres;

--
-- Name: TABLE qrtz_job_details; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_job_details IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_locks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_locks (
    sched_name character varying(120) NOT NULL,
    lock_name character varying(40) NOT NULL
);


ALTER TABLE public.qrtz_locks OWNER TO postgres;

--
-- Name: TABLE qrtz_locks; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_locks IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_paused_trigger_grps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_paused_trigger_grps (
    sched_name character varying(120) NOT NULL,
    trigger_group character varying(200) NOT NULL
);


ALTER TABLE public.qrtz_paused_trigger_grps OWNER TO postgres;

--
-- Name: TABLE qrtz_paused_trigger_grps; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_paused_trigger_grps IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_scheduler_state; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_scheduler_state (
    sched_name character varying(120) NOT NULL,
    instance_name character varying(200) NOT NULL,
    last_checkin_time bigint NOT NULL,
    checkin_interval bigint NOT NULL
);


ALTER TABLE public.qrtz_scheduler_state OWNER TO postgres;

--
-- Name: TABLE qrtz_scheduler_state; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_scheduler_state IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_simple_triggers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_simple_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    repeat_count bigint NOT NULL,
    repeat_interval bigint NOT NULL,
    times_triggered bigint NOT NULL
);


ALTER TABLE public.qrtz_simple_triggers OWNER TO postgres;

--
-- Name: TABLE qrtz_simple_triggers; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_simple_triggers IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_simprop_triggers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_simprop_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    str_prop_1 character varying(512),
    str_prop_2 character varying(512),
    str_prop_3 character varying(512),
    int_prop_1 integer,
    int_prop_2 integer,
    long_prop_1 bigint,
    long_prop_2 bigint,
    dec_prop_1 numeric(13,4),
    dec_prop_2 numeric(13,4),
    bool_prop_1 boolean,
    bool_prop_2 boolean
);


ALTER TABLE public.qrtz_simprop_triggers OWNER TO postgres;

--
-- Name: TABLE qrtz_simprop_triggers; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_simprop_triggers IS 'Used for Quartz scheduler.';


--
-- Name: qrtz_triggers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qrtz_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    job_name character varying(200) NOT NULL,
    job_group character varying(200) NOT NULL,
    description character varying(250),
    next_fire_time bigint,
    prev_fire_time bigint,
    priority integer,
    trigger_state character varying(16) NOT NULL,
    trigger_type character varying(8) NOT NULL,
    start_time bigint NOT NULL,
    end_time bigint,
    calendar_name character varying(200),
    misfire_instr smallint,
    job_data bytea
);


ALTER TABLE public.qrtz_triggers OWNER TO postgres;

--
-- Name: TABLE qrtz_triggers; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.qrtz_triggers IS 'Used for Quartz scheduler.';


--
-- Name: query; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.query (
    query_hash bytea NOT NULL,
    average_execution_time integer NOT NULL,
    query text
);


ALTER TABLE public.query OWNER TO postgres;

--
-- Name: TABLE query; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.query IS 'Information (such as average execution time) for different queries that have been previously ran.';


--
-- Name: COLUMN query.query_hash; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query.query_hash IS 'The hash of the query dictionary. (This is a 256-bit SHA3 hash of the query dict.)';


--
-- Name: COLUMN query.average_execution_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query.average_execution_time IS 'Average execution time for the query, round to nearest number of milliseconds. This is updated as a rolling average.';


--
-- Name: COLUMN query.query; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query.query IS 'The actual "query dictionary" for this query.';


--
-- Name: query_cache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.query_cache (
    query_hash bytea NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    results bytea NOT NULL
);


ALTER TABLE public.query_cache OWNER TO postgres;

--
-- Name: TABLE query_cache; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.query_cache IS 'Cached results of queries are stored here when using the DB-based query cache.';


--
-- Name: COLUMN query_cache.query_hash; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_cache.query_hash IS 'The hash of the query dictionary. (This is a 256-bit SHA3 hash of the query dict).';


--
-- Name: COLUMN query_cache.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_cache.updated_at IS 'The timestamp of when these query results were last refreshed.';


--
-- Name: COLUMN query_cache.results; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_cache.results IS 'Cached, compressed results of running the query with the given hash.';


--
-- Name: query_execution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.query_execution (
    id integer NOT NULL,
    hash bytea NOT NULL,
    started_at timestamp with time zone NOT NULL,
    running_time integer NOT NULL,
    result_rows integer NOT NULL,
    native boolean NOT NULL,
    context character varying(32),
    error text,
    executor_id integer,
    card_id integer,
    dashboard_id integer,
    pulse_id integer,
    database_id integer,
    cache_hit boolean
);


ALTER TABLE public.query_execution OWNER TO postgres;

--
-- Name: TABLE query_execution; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.query_execution IS 'A log of executed queries, used for calculating historic execution times, auditing, and other purposes.';


--
-- Name: COLUMN query_execution.hash; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.hash IS 'The hash of the query dictionary. This is a 256-bit SHA3 hash of the query.';


--
-- Name: COLUMN query_execution.started_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.started_at IS 'Timestamp of when this query started running.';


--
-- Name: COLUMN query_execution.running_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.running_time IS 'The time, in milliseconds, this query took to complete.';


--
-- Name: COLUMN query_execution.result_rows; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.result_rows IS 'Number of rows in the query results.';


--
-- Name: COLUMN query_execution.native; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.native IS 'Whether the query was a native query, as opposed to an MBQL one (e.g., created with the GUI).';


--
-- Name: COLUMN query_execution.context; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.context IS 'Short string specifying how this query was executed, e.g. in a Dashboard or Pulse.';


--
-- Name: COLUMN query_execution.error; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.error IS 'Error message returned by failed query, if any.';


--
-- Name: COLUMN query_execution.executor_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.executor_id IS 'The ID of the User who triggered this query execution, if any.';


--
-- Name: COLUMN query_execution.card_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.card_id IS 'The ID of the Card (Question) associated with this query execution, if any.';


--
-- Name: COLUMN query_execution.dashboard_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.dashboard_id IS 'The ID of the Dashboard associated with this query execution, if any.';


--
-- Name: COLUMN query_execution.pulse_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.pulse_id IS 'The ID of the Pulse associated with this query execution, if any.';


--
-- Name: COLUMN query_execution.database_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.database_id IS 'ID of the database this query was ran against.';


--
-- Name: COLUMN query_execution.cache_hit; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.query_execution.cache_hit IS 'Cache hit on query execution';


--
-- Name: query_execution_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.query_execution_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.query_execution_id_seq OWNER TO postgres;

--
-- Name: query_execution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.query_execution_id_seq OWNED BY public.query_execution.id;


--
-- Name: report_card; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report_card (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    display character varying(254) NOT NULL,
    dataset_query text NOT NULL,
    visualization_settings text NOT NULL,
    creator_id integer NOT NULL,
    database_id integer,
    table_id integer,
    query_type character varying(16),
    archived boolean DEFAULT false NOT NULL,
    collection_id integer,
    public_uuid character(36),
    made_public_by_id integer,
    enable_embedding boolean DEFAULT false NOT NULL,
    embedding_params text,
    cache_ttl integer,
    result_metadata text,
    collection_position smallint
);


ALTER TABLE public.report_card OWNER TO postgres;

--
-- Name: COLUMN report_card.collection_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_card.collection_id IS 'Optional ID of Collection this Card belongs to.';


--
-- Name: COLUMN report_card.public_uuid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_card.public_uuid IS 'Unique UUID used to in publically-accessible links to this Card.';


--
-- Name: COLUMN report_card.made_public_by_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_card.made_public_by_id IS 'The ID of the User who first publically shared this Card.';


--
-- Name: COLUMN report_card.enable_embedding; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_card.enable_embedding IS 'Is this Card allowed to be embedded in different websites (using a signed JWT)?';


--
-- Name: COLUMN report_card.embedding_params; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_card.embedding_params IS 'Serialized JSON containing information about required parameters that must be supplied when embedding this Card.';


--
-- Name: COLUMN report_card.cache_ttl; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_card.cache_ttl IS 'The maximum time, in seconds, to return cached results for this Card rather than running a new query.';


--
-- Name: COLUMN report_card.result_metadata; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_card.result_metadata IS 'Serialized JSON containing metadata about the result columns from running the query.';


--
-- Name: COLUMN report_card.collection_position; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_card.collection_position IS 'Optional pinned position for this item in its Collection. NULL means item is not pinned.';


--
-- Name: report_card_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.report_card_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_card_id_seq OWNER TO postgres;

--
-- Name: report_card_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.report_card_id_seq OWNED BY public.report_card.id;


--
-- Name: report_cardfavorite; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report_cardfavorite (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    card_id integer NOT NULL,
    owner_id integer NOT NULL
);


ALTER TABLE public.report_cardfavorite OWNER TO postgres;

--
-- Name: report_cardfavorite_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.report_cardfavorite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_cardfavorite_id_seq OWNER TO postgres;

--
-- Name: report_cardfavorite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.report_cardfavorite_id_seq OWNED BY public.report_cardfavorite.id;


--
-- Name: report_dashboard; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report_dashboard (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    creator_id integer NOT NULL,
    parameters text NOT NULL,
    points_of_interest text,
    caveats text,
    show_in_getting_started boolean DEFAULT false NOT NULL,
    public_uuid character(36),
    made_public_by_id integer,
    enable_embedding boolean DEFAULT false NOT NULL,
    embedding_params text,
    archived boolean DEFAULT false NOT NULL,
    "position" integer,
    collection_id integer,
    collection_position smallint,
    cache_ttl integer
);


ALTER TABLE public.report_dashboard OWNER TO postgres;

--
-- Name: COLUMN report_dashboard.public_uuid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_dashboard.public_uuid IS 'Unique UUID used to in publically-accessible links to this Dashboard.';


--
-- Name: COLUMN report_dashboard.made_public_by_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_dashboard.made_public_by_id IS 'The ID of the User who first publically shared this Dashboard.';


--
-- Name: COLUMN report_dashboard.enable_embedding; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_dashboard.enable_embedding IS 'Is this Dashboard allowed to be embedded in different websites (using a signed JWT)?';


--
-- Name: COLUMN report_dashboard.embedding_params; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_dashboard.embedding_params IS 'Serialized JSON containing information about required parameters that must be supplied when embedding this Dashboard.';


--
-- Name: COLUMN report_dashboard.archived; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_dashboard.archived IS 'Is this Dashboard archived (effectively treated as deleted?)';


--
-- Name: COLUMN report_dashboard."position"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_dashboard."position" IS 'The position this Dashboard should appear in the Dashboards list, lower-numbered positions appearing before higher numbered ones.';


--
-- Name: COLUMN report_dashboard.collection_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_dashboard.collection_id IS 'Optional ID of Collection this Dashboard belongs to.';


--
-- Name: COLUMN report_dashboard.collection_position; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_dashboard.collection_position IS 'Optional pinned position for this item in its Collection. NULL means item is not pinned.';


--
-- Name: COLUMN report_dashboard.cache_ttl; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.report_dashboard.cache_ttl IS 'Granular cache TTL for specific dashboard.';


--
-- Name: report_dashboard_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.report_dashboard_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_dashboard_id_seq OWNER TO postgres;

--
-- Name: report_dashboard_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.report_dashboard_id_seq OWNED BY public.report_dashboard.id;


--
-- Name: report_dashboardcard; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report_dashboardcard (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    "sizeX" integer NOT NULL,
    "sizeY" integer NOT NULL,
    "row" integer DEFAULT 0 NOT NULL,
    col integer DEFAULT 0 NOT NULL,
    card_id integer,
    dashboard_id integer NOT NULL,
    parameter_mappings text NOT NULL,
    visualization_settings text NOT NULL
);


ALTER TABLE public.report_dashboardcard OWNER TO postgres;

--
-- Name: report_dashboardcard_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.report_dashboardcard_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_dashboardcard_id_seq OWNER TO postgres;

--
-- Name: report_dashboardcard_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.report_dashboardcard_id_seq OWNED BY public.report_dashboardcard.id;


--
-- Name: revision; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.revision (
    id integer NOT NULL,
    model character varying(16) NOT NULL,
    model_id integer NOT NULL,
    user_id integer NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    object character varying NOT NULL,
    is_reversion boolean DEFAULT false NOT NULL,
    is_creation boolean DEFAULT false NOT NULL,
    message text
);


ALTER TABLE public.revision OWNER TO postgres;

--
-- Name: revision_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.revision_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.revision_id_seq OWNER TO postgres;

--
-- Name: revision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.revision_id_seq OWNED BY public.revision.id;


--
-- Name: segment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.segment (
    id integer NOT NULL,
    table_id integer NOT NULL,
    creator_id integer NOT NULL,
    name character varying(254) NOT NULL,
    description text,
    archived boolean DEFAULT false NOT NULL,
    definition text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    points_of_interest text,
    caveats text,
    show_in_getting_started boolean DEFAULT false NOT NULL
);


ALTER TABLE public.segment OWNER TO postgres;

--
-- Name: segment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.segment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.segment_id_seq OWNER TO postgres;

--
-- Name: segment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.segment_id_seq OWNED BY public.segment.id;


--
-- Name: setting; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.setting (
    key character varying(254) NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.setting OWNER TO postgres;

--
-- Name: task_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_history (
    id integer NOT NULL,
    task character varying(254) NOT NULL,
    db_id integer,
    started_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ended_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    duration integer NOT NULL,
    task_details text
);


ALTER TABLE public.task_history OWNER TO postgres;

--
-- Name: TABLE task_history; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.task_history IS 'Timing and metadata info about background/quartz processes';


--
-- Name: COLUMN task_history.task; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.task_history.task IS 'Name of the task';


--
-- Name: COLUMN task_history.task_details; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.task_history.task_details IS 'JSON string with additional info on the task';


--
-- Name: task_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.task_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_history_id_seq OWNER TO postgres;

--
-- Name: task_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.task_history_id_seq OWNED BY public.task_history.id;


--
-- Name: view_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.view_log (
    id integer NOT NULL,
    user_id integer,
    model character varying(16) NOT NULL,
    model_id integer NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    metadata text
);


ALTER TABLE public.view_log OWNER TO postgres;

--
-- Name: COLUMN view_log.metadata; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.view_log.metadata IS 'Serialized JSON corresponding to metadata for view.';


--
-- Name: view_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.view_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.view_log_id_seq OWNER TO postgres;

--
-- Name: view_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.view_log_id_seq OWNED BY public.view_log.id;


--
-- Name: activity id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity ALTER COLUMN id SET DEFAULT nextval('public.activity_id_seq'::regclass);


--
-- Name: card_label id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_label ALTER COLUMN id SET DEFAULT nextval('public.card_label_id_seq'::regclass);


--
-- Name: collection id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection ALTER COLUMN id SET DEFAULT nextval('public.collection_id_seq'::regclass);


--
-- Name: collection_permission_graph_revision id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection_permission_graph_revision ALTER COLUMN id SET DEFAULT nextval('public.collection_permission_graph_revision_id_seq'::regclass);


--
-- Name: computation_job id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computation_job ALTER COLUMN id SET DEFAULT nextval('public.computation_job_id_seq'::regclass);


--
-- Name: computation_job_result id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computation_job_result ALTER COLUMN id SET DEFAULT nextval('public.computation_job_result_id_seq'::regclass);


--
-- Name: core_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_user ALTER COLUMN id SET DEFAULT nextval('public.core_user_id_seq'::regclass);


--
-- Name: dashboard_favorite id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_favorite ALTER COLUMN id SET DEFAULT nextval('public.dashboard_favorite_id_seq'::regclass);


--
-- Name: dashboardcard_series id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboardcard_series ALTER COLUMN id SET DEFAULT nextval('public.dashboardcard_series_id_seq'::regclass);


--
-- Name: dependency id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dependency ALTER COLUMN id SET DEFAULT nextval('public.dependency_id_seq'::regclass);


--
-- Name: dimension id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dimension ALTER COLUMN id SET DEFAULT nextval('public.dimension_id_seq'::regclass);


--
-- Name: group_table_access_policy id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_table_access_policy ALTER COLUMN id SET DEFAULT nextval('public.group_table_access_policy_id_seq'::regclass);


--
-- Name: label id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.label ALTER COLUMN id SET DEFAULT nextval('public.label_id_seq'::regclass);


--
-- Name: login_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_history ALTER COLUMN id SET DEFAULT nextval('public.login_history_id_seq'::regclass);


--
-- Name: metabase_database id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_database ALTER COLUMN id SET DEFAULT nextval('public.metabase_database_id_seq'::regclass);


--
-- Name: metabase_field id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_field ALTER COLUMN id SET DEFAULT nextval('public.metabase_field_id_seq'::regclass);


--
-- Name: metabase_fieldvalues id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_fieldvalues ALTER COLUMN id SET DEFAULT nextval('public.metabase_fieldvalues_id_seq'::regclass);


--
-- Name: metabase_table id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_table ALTER COLUMN id SET DEFAULT nextval('public.metabase_table_id_seq'::regclass);


--
-- Name: metric id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metric ALTER COLUMN id SET DEFAULT nextval('public.metric_id_seq'::regclass);


--
-- Name: metric_important_field id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metric_important_field ALTER COLUMN id SET DEFAULT nextval('public.metric_important_field_id_seq'::regclass);


--
-- Name: moderation_review id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moderation_review ALTER COLUMN id SET DEFAULT nextval('public.moderation_review_id_seq'::regclass);


--
-- Name: native_query_snippet id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.native_query_snippet ALTER COLUMN id SET DEFAULT nextval('public.native_query_snippet_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- Name: permissions_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_group ALTER COLUMN id SET DEFAULT nextval('public.permissions_group_id_seq'::regclass);


--
-- Name: permissions_group_membership id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_group_membership ALTER COLUMN id SET DEFAULT nextval('public.permissions_group_membership_id_seq'::regclass);


--
-- Name: permissions_revision id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_revision ALTER COLUMN id SET DEFAULT nextval('public.permissions_revision_id_seq'::regclass);


--
-- Name: pulse id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse ALTER COLUMN id SET DEFAULT nextval('public.pulse_id_seq'::regclass);


--
-- Name: pulse_card id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_card ALTER COLUMN id SET DEFAULT nextval('public.pulse_card_id_seq'::regclass);


--
-- Name: pulse_channel id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_channel ALTER COLUMN id SET DEFAULT nextval('public.pulse_channel_id_seq'::regclass);


--
-- Name: pulse_channel_recipient id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_channel_recipient ALTER COLUMN id SET DEFAULT nextval('public.pulse_channel_recipient_id_seq'::regclass);


--
-- Name: query_execution id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.query_execution ALTER COLUMN id SET DEFAULT nextval('public.query_execution_id_seq'::regclass);


--
-- Name: report_card id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_card ALTER COLUMN id SET DEFAULT nextval('public.report_card_id_seq'::regclass);


--
-- Name: report_cardfavorite id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_cardfavorite ALTER COLUMN id SET DEFAULT nextval('public.report_cardfavorite_id_seq'::regclass);


--
-- Name: report_dashboard id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_dashboard ALTER COLUMN id SET DEFAULT nextval('public.report_dashboard_id_seq'::regclass);


--
-- Name: report_dashboardcard id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_dashboardcard ALTER COLUMN id SET DEFAULT nextval('public.report_dashboardcard_id_seq'::regclass);


--
-- Name: revision id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revision ALTER COLUMN id SET DEFAULT nextval('public.revision_id_seq'::regclass);


--
-- Name: segment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.segment ALTER COLUMN id SET DEFAULT nextval('public.segment_id_seq'::regclass);


--
-- Name: task_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_history ALTER COLUMN id SET DEFAULT nextval('public.task_history_id_seq'::regclass);


--
-- Name: view_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_log ALTER COLUMN id SET DEFAULT nextval('public.view_log_id_seq'::regclass);


--
-- Data for Name: activity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.activity (id, topic, "timestamp", user_id, model, model_id, database_id, table_id, custom_id, details) FROM stdin;
1	install	2021-12-23 10:40:02.330336+00	\N	install	\N	\N	\N	\N	{}
2	user-joined	2021-12-23 10:42:33.082635+00	1	user	1	\N	\N	\N	{}
3	card-create	2021-12-23 10:51:20.433041+00	1	card	1	2	\N	\N	{"name":"Organisation Map Filtered by Subject(s)","description":"Show locations of organisations who have an association to a project with the given subject(s)."}
4	card-update	2021-12-23 10:51:57.95495+00	1	card	1	2	\N	\N	{"name":"Organisation Map Filtered by Subject(s)","description":"Show locations of organisations who have an association to a project with the given subject(s)."}
5	card-update	2021-12-23 10:54:30.535482+00	1	card	1	2	\N	\N	{"name":"Organisation Map Filtered by Subject(s)","description":"Show locations of organisations who have an association to a project with the given subject(s)."}
6	dashboard-create	2021-12-23 10:56:01.119484+00	1	dashboard	1	\N	\N	\N	{"description":"View locations and details of organisations. Filter them by project subject topics.","name":"CoPED Organisation Map"}
7	dashboard-add-cards	2021-12-23 10:57:08.637058+00	1	dashboard	1	\N	\N	\N	{"description":"View locations and details of organisations. Filter them by project subject topics.","name":"CoPED Organisation Map","dashcards":[{"name":"Organisation Map Filtered by Subject(s)","description":"Show locations of organisations who have an association to a project with the given subject(s).","id":1,"card_id":1}]}
8	card-update	2021-12-23 10:59:06.393675+00	1	card	1	2	\N	\N	{"name":"Organisation Map Filtered by Subject(s)","description":"Show locations of organisations who have an association to a project with the given subject(s)."}
9	card-update	2021-12-23 11:06:04.801324+00	1	card	1	2	\N	\N	{"name":"Organisation Map Filtered by Subject(s)","description":"Show locations of organisations who have an association to a project with the given subject(s)."}
10	card-update	2021-12-23 11:06:50.11869+00	1	card	1	2	\N	\N	{"name":"Organisation Map Filtered by Subject(s)","description":"Show locations of organisations who have an association to a project with the given subject(s)."}
11	card-update	2021-12-23 11:07:50.011401+00	1	card	1	2	\N	\N	{"name":"Organisation Map Filtered by Subject(s)","description":"Show locations of organisations who have an association to a project with the given subject(s)."}
12	dashboard-add-cards	2021-12-23 11:16:05.256706+00	1	dashboard	1	\N	\N	\N	{"description":"View locations and details of organisations. Filter them by project subject topics.","name":"CoPED Organisation Map","dashcards":[{"id":2,"card_id":null}]}
13	card-update	2021-12-23 11:20:45.163078+00	1	card	1	2	\N	\N	{"name":"Organisation Map Filtered by Subject(s)","description":"Show locations of organisations who have an association to a project with the given subject(s)."}
14	card-create	2021-12-23 11:49:21.551798+00	1	card	2	2	\N	\N	{"name":"Counts of Subject Hits by Organisation","description":"Count number of projects in each organisation associated to the given subject(s)."}
15	dashboard-add-cards	2021-12-23 11:51:00.382968+00	1	dashboard	1	\N	\N	\N	{"description":"View locations and details of organisations. Filter them by project subject topics.","name":"CoPED Organisation Map","dashcards":[{"name":"Counts of Subject Hits by Organisation","description":"Count number of projects in each organisation associated to the given subject(s).","id":3,"card_id":2}]}
16	dashboard-create	2021-12-23 12:31:42.532389+00	1	dashboard	2	\N	\N	\N	{"description":"Summary information on projects in the CoPED database.","name":"Project Detail Dashboard"}
17	card-create	2021-12-23 12:40:42.515368+00	1	card	3	2	7	\N	{"name":"Coped Projects","description":null}
18	card-update	2021-12-23 12:43:52.211905+00	1	card	3	2	\N	\N	{"name":"Coped Projects","description":null}
19	card-update	2021-12-23 12:49:50.370529+00	1	card	3	2	\N	\N	{"name":"Coped Projects","description":null}
20	card-create	2021-12-23 12:56:06.500636+00	1	card	4	2	7	\N	{"name":"Coped Project Organisations, Filtered by ID","description":null}
21	card-update	2021-12-24 00:07:29.717691+00	1	card	2	2	\N	\N	{"name":"Counts of Subject Hits by Organisation","description":"Count number of projects in each organisation associated to the given subject(s)."}
22	user-joined	2021-12-24 04:04:14.073082+00	4	user	4	\N	\N	\N	{}
23	card-update	2021-12-24 14:40:18.941745+00	4	card	4	2	7	\N	{"name":"Coped Project Organisations, Filtered by ID","description":null}
24	card-update	2021-12-24 14:40:48.763545+00	1	card	4	2	7	\N	{"name":"Coped Project Organisations, Filtered by ID","description":null}
25	dashboard-create	2021-12-24 16:18:09.925941+00	1	dashboard	3	\N	\N	\N	{"description":null,"name":"Testing 123"}
26	dashboard-delete	2021-12-24 16:18:36.731387+00	1	dashboard	3	\N	\N	\N	{"description":null,"name":"Testing 123"}
27	card-create	2021-12-24 17:05:43.750158+00	4	card	5	2	7	\N	{"name":"Coped Projects by Standard User","description":null}
28	dashboard-create	2021-12-24 17:06:01.660407+00	4	dashboard	4	\N	\N	\N	{"description":null,"name":"Regular User Dashboard"}
29	dashboard-add-cards	2021-12-24 17:08:30.699988+00	4	dashboard	4	\N	\N	\N	{"description":null,"name":"Regular User Dashboard","dashcards":[{"name":"Coped Projects by Standard User","description":null,"id":4,"card_id":5}]}
\.


--
-- Data for Name: card_label; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.card_label (id, card_id, label_id) FROM stdin;
\.


--
-- Data for Name: collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.collection (id, name, description, color, archived, location, personal_owner_id, slug, namespace, authority_level) FROM stdin;
1	Colin Stephen's Personal Collection	\N	#31698A	f	/	1	colin_stephen_s_personal_collection	\N	\N
2	Test User's Personal Collection	\N	#31698A	f	/	3	test_user_s_personal_collection	\N	\N
3	Site Tester's Personal Collection	\N	#31698A	f	/	4	site_tester_s_personal_collection	\N	\N
\.


--
-- Data for Name: collection_permission_graph_revision; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.collection_permission_graph_revision (id, before, after, user_id, created_at, remark) FROM stdin;
\.


--
-- Data for Name: computation_job; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.computation_job (id, creator_id, created_at, updated_at, type, status, context, ended_at) FROM stdin;
\.


--
-- Data for Name: computation_job_result; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.computation_job_result (id, job_id, created_at, updated_at, permanence, payload) FROM stdin;
\.


--
-- Data for Name: core_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.core_session (id, user_id, created_at, anti_csrf_token) FROM stdin;
2ebd7ca9-a63d-42ab-99a4-f6271147dd1b	1	2021-12-23 10:42:32.809842+00	\N
9e8a11f4-7f5b-4ace-bf32-ab9a7678044a	3	2021-12-24 04:00:03.098302+00	7ce81632f0f51ba890eac258e3153c6d
5273cd13-50be-42d5-9879-0ef9978d93a4	1	2021-12-24 04:00:36.360063+00	cb2375a2bc9ce4e133f69ff9a5f5e68f
2028f564-145c-4a04-b885-e67a2fc1f3e4	4	2021-12-24 04:04:14.03487+00	04bd6de3dea3d9fb11eb8d86bf547390
7b7e3b07-6e6c-46a8-8448-a28571dbe44a	4	2021-12-24 04:04:50.715657+00	19d5835aa5b2b41e29f755b32f86d4df
da83704a-93d0-46c1-b6fb-7ff3e5dc61af	4	2021-12-24 04:06:44.293506+00	\N
b9fe34b0-d360-4ed8-8653-15b1ee612025	1	2021-12-24 14:40:33.757846+00	\N
\.


--
-- Data for Name: core_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.core_user (id, email, first_name, last_name, password, password_salt, date_joined, last_login, is_superuser, is_active, reset_token, reset_triggered, is_qbnewb, google_auth, ldap_auth, login_attributes, updated_at, sso_source, locale) FROM stdin;
3	metabase.test@c0l.in	Test	User	$2a$10$5jRVjhwcFAlinGNtwVlzOOKdTfoCk7jBDQL/10.J/Jz.M2wixGjxi	2c2065b1-8d62-41bb-a44f-36bfd33cef54	2021-12-23 10:42:32.809842+00	2021-12-24 04:00:03.128156+00	f	f	\N	\N	t	f	f	\N	2021-12-24 04:01:26.643998	\N	\N
1	metabase.local@c0l.in	Colin	Stephen	$2a$10$5jRVjhwcFAlinGNtwVlzOOKdTfoCk7jBDQL/10.J/Jz.M2wixGjxi	2c2065b1-8d62-41bb-a44f-36bfd33cef54	2021-12-23 10:42:32.809842+00	2021-12-24 14:40:33.784851+00	t	t	\N	\N	f	f	f	\N	2021-12-24 14:40:33.784851	\N	\N
4	metabase.site.tester@c0l.in	Site	Tester	$2a$10$9CPsd0coj0Ats.D0cF6xsu1A9X896UGSUqTGitel.q0QMmYF6Ev/u	a558723a-0fd4-4e2e-bd73-cd52863b839b	2021-12-24 04:01:46.847493+00	2021-12-24 04:06:44.318304+00	f	t	$2a$10$OOFmhDCUmDR8b5/tkfuk3OTF8VwJt9ZpgEjUiCR4llhLu.z4kVhyi	1640318506982	f	f	f	\N	2021-12-24 17:09:00.660058	\N	\N
\.


--
-- Data for Name: dashboard_favorite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dashboard_favorite (id, user_id, dashboard_id) FROM stdin;
\.


--
-- Data for Name: dashboardcard_series; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dashboardcard_series (id, dashboardcard_id, card_id, "position") FROM stdin;
\.


--
-- Data for Name: data_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.data_migrations (id, "timestamp") FROM stdin;
add-users-to-default-permissions-groups	2021-12-23 10:40:01.160121
add-admin-group-root-entry	2021-12-23 10:40:01.268917
add-databases-to-magic-permissions-groups	2021-12-23 10:40:01.306438
copy-site-url-setting-and-remove-trailing-slashes	2021-12-23 10:40:01.407602
ensure-protocol-specified-in-site-url	2021-12-23 10:40:01.459256
populate-card-database-id	2021-12-23 10:40:01.494646
migrate-humanization-setting	2021-12-23 10:40:01.537448
mark-category-fields-as-list	2021-12-23 10:40:01.58824
add-legacy-sql-directive-to-bigquery-sql-cards	2021-12-23 10:40:01.625322
clear-ldap-user-local-passwords	2021-12-23 10:40:01.667995
add-migrated-collections	2021-12-23 10:40:01.779109
migrate-click-through	2021-12-23 10:40:01.809854
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
2	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:38.716067	2	EXECUTED	8:bdcf1238e2ccb4fbe66d7f9e1d9b9529	createTable tableName=core_session		\N	3.6.3	\N	\N	0255974901
21	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:40.833053	20	EXECUTED	8:fb2cd308b17ab81b502d057ecde4fc1b	createTable tableName=segment; createIndex indexName=idx_segment_creator_id, tableName=segment; createIndex indexName=idx_segment_table_id, tableName=segment		\N	3.6.3	\N	\N	0255974901
22	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:40.870788	21	EXECUTED	8:80bc8a62a90791a79adedcf1ac3c6f08	addColumn tableName=revision		\N	3.6.3	\N	\N	0255974901
23	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:41.059993	22	EXECUTED	8:b6f054835db2b2688a1be1de3707f9a9	modifyDataType columnName=rows, tableName=metabase_table		\N	3.6.3	\N	\N	0255974901
24	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:41.329083	23	EXECUTED	8:60825b125b452747098b577310c142b1	createTable tableName=dependency; createIndex indexName=idx_dependency_model, tableName=dependency; createIndex indexName=idx_dependency_model_id, tableName=dependency; createIndex indexName=idx_dependency_dependent_on_model, tableName=dependency;...		\N	3.6.3	\N	\N	0255974901
25	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:41.547529	24	EXECUTED	8:61f25563911117df72f5621d78f10089	createTable tableName=metric; createIndex indexName=idx_metric_creator_id, tableName=metric; createIndex indexName=idx_metric_table_id, tableName=metric		\N	3.6.3	\N	\N	0255974901
26	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:41.59204	25	EXECUTED	8:ddef40b95c55cf4ac0e6a5161911a4cb	addColumn tableName=metabase_database; sql		\N	3.6.3	\N	\N	0255974901
27	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:41.784182	26	EXECUTED	8:001855139df2d5dac4eb954e5abe6486	createTable tableName=dashboardcard_series; createIndex indexName=idx_dashboardcard_series_dashboardcard_id, tableName=dashboardcard_series; createIndex indexName=idx_dashboardcard_series_card_id, tableName=dashboardcard_series		\N	3.6.3	\N	\N	0255974901
28	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:41.870186	27	EXECUTED	8:428e4eb05e4e29141735adf9ae141a0b	addColumn tableName=core_user		\N	3.6.3	\N	\N	0255974901
29	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:41.91133	28	EXECUTED	8:8b02731cc34add3722c926dfd7376ae0	addColumn tableName=pulse_channel		\N	3.6.3	\N	\N	0255974901
30	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:41.954871	29	EXECUTED	8:2c3a50cef177cb90d47a9973cd5934e5	addColumn tableName=metabase_field; addNotNullConstraint columnName=visibility_type, tableName=metabase_field		\N	3.6.3	\N	\N	0255974901
31	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:41.999629	30	EXECUTED	8:30a33a82bab0bcbb2ccb6738d48e1421	addColumn tableName=metabase_field		\N	3.6.3	\N	\N	0255974901
57	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:46.602417	56	EXECUTED	8:aab81d477e2d19a9ab18c58b78c9af88	addColumn tableName=report_card	Added 0.25.0	\N	3.6.3	\N	\N	0255974901
32	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:42.402391	31	EXECUTED	8:40830260b92cedad8da273afd5eca678	createTable tableName=label; createIndex indexName=idx_label_slug, tableName=label; createTable tableName=card_label; addUniqueConstraint constraintName=unique_card_label_card_id_label_id, tableName=card_label; createIndex indexName=idx_card_label...		\N	3.6.3	\N	\N	0255974901
32	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:42.79316	32	EXECUTED	8:483c6c6c8e0a8d056f7b9112d0b0125c	createTable tableName=raw_table; createIndex indexName=idx_rawtable_database_id, tableName=raw_table; addUniqueConstraint constraintName=uniq_raw_table_db_schema_name, tableName=raw_table; createTable tableName=raw_column; createIndex indexName=id...		\N	3.6.3	\N	\N	0255974901
34	tlrobinson	migrations/000_migrations.yaml	2021-12-23 10:39:42.842004	33	EXECUTED	8:52b082600b05bbbc46bfe837d1f37a82	addColumn tableName=pulse_channel		\N	3.6.3	\N	\N	0255974901
36	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:42.98445	35	EXECUTED	8:252e08892449dceb16c3d91337bd9573	addColumn tableName=report_dashboard; addNotNullConstraint columnName=parameters, tableName=report_dashboard; addColumn tableName=report_dashboardcard; addNotNullConstraint columnName=parameter_mappings, tableName=report_dashboardcard		\N	3.6.3	\N	\N	0255974901
37	tlrobinson	migrations/000_migrations.yaml	2021-12-23 10:39:43.120391	36	EXECUTED	8:07d959eff81777e5690e2920583cfe5f	addColumn tableName=query_queryexecution; addNotNullConstraint columnName=query_hash, tableName=query_queryexecution; createIndex indexName=idx_query_queryexecution_query_hash, tableName=query_queryexecution; createIndex indexName=idx_query_querye...		\N	3.6.3	\N	\N	0255974901
38	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:43.548554	37	EXECUTED	8:43604ab55179b50306eb39353e760b46	addColumn tableName=metabase_database; addColumn tableName=metabase_table; addColumn tableName=metabase_field; addColumn tableName=report_dashboard; addColumn tableName=metric; addColumn tableName=segment; addColumn tableName=metabase_database; ad...		\N	3.6.3	\N	\N	0255974901
39	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:43.592905	38	EXECUTED	8:334adc22af5ded71ff27759b7a556951	addColumn tableName=core_user		\N	3.6.3	\N	\N	0255974901
40	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:44.466731	39	EXECUTED	8:ee7f50a264d6cf8d891bd01241eebd2c	createTable tableName=permissions_group; createIndex indexName=idx_permissions_group_name, tableName=permissions_group; createTable tableName=permissions_group_membership; addUniqueConstraint constraintName=unique_permissions_group_membership_user...		\N	3.6.3	\N	\N	0255974901
41	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:44.516604	40	EXECUTED	8:fae0855adf2f702f1133e32fc98d02a5	dropColumn columnName=field_type, tableName=metabase_field; addDefaultValue columnName=active, tableName=metabase_field; addDefaultValue columnName=preview_display, tableName=metabase_field; addDefaultValue columnName=position, tableName=metabase_...		\N	3.6.3	\N	\N	0255974901
42	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:44.575507	41	EXECUTED	8:e32b3a1624fa289a6ee1f3f0a2dac1f6	dropForeignKeyConstraint baseTableName=query_queryexecution, constraintName=fk_queryexecution_ref_query_id; dropColumn columnName=query_id, tableName=query_queryexecution; dropColumn columnName=is_staff, tableName=core_user; dropColumn columnName=...		\N	3.6.3	\N	\N	0255974901
43	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:44.703533	42	EXECUTED	8:165e9384e46d6f9c0330784955363f70	createTable tableName=permissions_revision		\N	3.6.3	\N	\N	0255974901
44	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:44.745719	43	EXECUTED	8:2e356e8a1049286f1c78324828ee7867	dropColumn columnName=public_perms, tableName=report_card; dropColumn columnName=public_perms, tableName=report_dashboard; dropColumn columnName=public_perms, tableName=pulse		\N	3.6.3	\N	\N	0255974901
45	tlrobinson	migrations/000_migrations.yaml	2021-12-23 10:39:44.791264	44	EXECUTED	8:421edd38ee0cb0983162f57193f81b0b	addColumn tableName=report_dashboardcard; addNotNullConstraint columnName=visualization_settings, tableName=report_dashboardcard		\N	3.6.3	\N	\N	0255974901
46	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:44.839973	45	EXECUTED	8:131df3cdd9a8c67b32c5988a3fb7fe3d	addNotNullConstraint columnName=row, tableName=report_dashboardcard; addNotNullConstraint columnName=col, tableName=report_dashboardcard; addDefaultValue columnName=row, tableName=report_dashboardcard; addDefaultValue columnName=col, tableName=rep...		\N	3.6.3	\N	\N	0255974901
47	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:45.136118	46	EXECUTED	8:1d2474e49a27db344c250872df58a6ed	createTable tableName=collection; createIndex indexName=idx_collection_slug, tableName=collection; addColumn tableName=report_card; createIndex indexName=idx_card_collection_id, tableName=report_card		\N	3.6.3	\N	\N	0255974901
49	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:45.517829	48	EXECUTED	8:4508e7d5f6d4da3c4a2de3bf5e3c5851	addColumn tableName=report_card; addColumn tableName=report_card; createIndex indexName=idx_card_public_uuid, tableName=report_card; addColumn tableName=report_dashboard; addColumn tableName=report_dashboard; createIndex indexName=idx_dashboard_pu...		\N	3.6.3	\N	\N	0255974901
50	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:45.565187	49	EXECUTED	8:98a6ab6428ea7a589507464e34ade58a	addColumn tableName=report_card; addColumn tableName=report_card; addColumn tableName=report_dashboard; addColumn tableName=report_dashboard		\N	3.6.3	\N	\N	0255974901
51	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:45.865546	50	EXECUTED	8:43c90b5b9f6c14bfd0e41cc0b184617e	createTable tableName=query_execution; createIndex indexName=idx_query_execution_started_at, tableName=query_execution; createIndex indexName=idx_query_execution_query_hash_started_at, tableName=query_execution		\N	3.6.3	\N	\N	0255974901
52	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:46.064996	51	EXECUTED	8:5af9ea2a96cd6e75a8ac1e6afde7126b	createTable tableName=query_cache; createIndex indexName=idx_query_cache_updated_at, tableName=query_cache; addColumn tableName=report_card		\N	3.6.3	\N	\N	0255974901
53	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:46.202213	52	EXECUTED	8:78d015c5090c57cd6972eb435601d3d0	createTable tableName=query		\N	3.6.3	\N	\N	0255974901
54	tlrobinson	migrations/000_migrations.yaml	2021-12-23 10:39:46.250499	53	EXECUTED	8:e410005b585f5eeb5f202076ff9468f7	addColumn tableName=pulse		\N	3.6.3	\N	\N	0255974901
55	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:46.513184	54	EXECUTED	8:11bbd199bfa57b908ea3b1a470197de9	addColumn tableName=report_dashboard; addColumn tableName=report_dashboard; createTable tableName=dashboard_favorite; addUniqueConstraint constraintName=unique_dashboard_favorite_user_id_dashboard_id, tableName=dashboard_favorite; createIndex inde...		\N	3.6.3	\N	\N	0255974901
56	wwwiiilll	migrations/000_migrations.yaml	2021-12-23 10:39:46.560466	55	EXECUTED	8:9f46051abaee599e2838733512a32ad0	addColumn tableName=core_user	Added 0.25.0	\N	3.6.3	\N	\N	0255974901
58	senior	migrations/000_migrations.yaml	2021-12-23 10:39:46.816797	57	EXECUTED	8:3554219ca39e0fd682d0fba57531e917	createTable tableName=dimension; addUniqueConstraint constraintName=unique_dimension_field_id_name, tableName=dimension; createIndex indexName=idx_dimension_field_id, tableName=dimension	Added 0.25.0	\N	3.6.3	\N	\N	0255974901
59	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:46.866607	58	EXECUTED	8:5b6ce52371e0e9eee88e6d766225a94b	addColumn tableName=metabase_field	Added 0.26.0	\N	3.6.3	\N	\N	0255974901
60	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:46.916476	59	EXECUTED	8:2141162a1c99a5dd95e5a67c5595e6d7	addColumn tableName=metabase_database; addColumn tableName=metabase_database	Added 0.26.0	\N	3.6.3	\N	\N	0255974901
61	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:46.962447	60	EXECUTED	8:7dded6fd5bf74d79b9a0b62511981272	addColumn tableName=metabase_field	Added 0.26.0	\N	3.6.3	\N	\N	0255974901
62	senior	migrations/000_migrations.yaml	2021-12-23 10:39:47.01089	61	EXECUTED	8:cb32e6eaa1a2140703def2730f81fef2	addColumn tableName=metabase_database	Added 0.26.0	\N	3.6.3	\N	\N	0255974901
63	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:47.059523	62	EXECUTED	8:226f73b9f6617495892d281b0f8303db	addColumn tableName=metabase_database	Added 0.26.0	\N	3.6.3	\N	\N	0255974901
64	senior	migrations/000_migrations.yaml	2021-12-23 10:39:47.107599	63	EXECUTED	8:4dcc8ffd836b56756f494d5dfce07b50	dropForeignKeyConstraint baseTableName=raw_table, constraintName=fk_rawtable_ref_database	Added 0.26.0	\N	3.6.3	\N	\N	0255974901
66	senior	migrations/000_migrations.yaml	2021-12-23 10:39:47.153362	64	EXECUTED	8:e77d66af8e3b83d46c5a0064a75a1aac	sql; sql	Added 0.26.0	\N	3.6.3	\N	\N	0255974901
67	attekei	migrations/000_migrations.yaml	2021-12-23 10:39:47.352122	65	EXECUTED	8:59dfc37744fc362e0e312488fbc9a69b	createTable tableName=computation_job; createTable tableName=computation_job_result	Added 0.27.0	\N	3.6.3	\N	\N	0255974901
68	sbelak	migrations/000_migrations.yaml	2021-12-23 10:39:47.392047	66	EXECUTED	8:b4ac06d133dfbdc6567d992c7e18c6ec	addColumn tableName=computation_job; addColumn tableName=computation_job	Added 0.27.0	\N	3.6.3	\N	\N	0255974901
69	senior	migrations/000_migrations.yaml	2021-12-23 10:39:47.491923	67	EXECUTED	8:eadbe00e97eb53df4b3df60462f593f6	addColumn tableName=pulse; addColumn tableName=pulse; addColumn tableName=pulse; dropNotNullConstraint columnName=name, tableName=pulse	Added 0.27.0	\N	3.6.3	\N	\N	0255974901
70	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:47.53947	68	EXECUTED	8:4e4eff7abb983b1127a32ba8107e7fb8	addColumn tableName=metabase_field; addNotNullConstraint columnName=database_type, tableName=metabase_field	Added 0.28.0	\N	3.6.3	\N	\N	0255974901
71	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:47.585383	69	EXECUTED	8:755e5c3dd8a55793f29b2c95cb79c211	dropNotNullConstraint columnName=card_id, tableName=report_dashboardcard	Added 0.28.0	\N	3.6.3	\N	\N	0255974901
72	senior	migrations/000_migrations.yaml	2021-12-23 10:39:47.631839	70	EXECUTED	8:4dc6debdf779ab9273cf2158a84bb154	addColumn tableName=pulse_card; addColumn tableName=pulse_card	Added 0.28.0	\N	3.6.3	\N	\N	0255974901
73	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:47.672844	71	EXECUTED	8:3c0f03d18ff78a0bcc9915e1d9c518d6	addColumn tableName=metabase_database	Added 0.29.0	\N	3.6.3	\N	\N	0255974901
74	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:47.712269	72	EXECUTED	8:16726d6560851325930c25caf3c8ab96	addColumn tableName=metabase_field	Added 0.29.0	\N	3.6.3	\N	\N	0255974901
75	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:47.787175	73	EXECUTED	8:6072cabfe8188872d8e3da9a675f88c1	addColumn tableName=report_card	Added 0.28.2	\N	3.6.3	\N	\N	0255974901
76	senior	migrations/000_migrations.yaml	2021-12-23 10:39:47.829303	74	EXECUTED	8:9b7190c9171ccca72617d508875c3c82	addColumn tableName=metabase_table	Added 0.30.0	\N	3.6.3	\N	\N	0255974901
77	senior	migrations/000_migrations.yaml	2021-12-23 10:39:47.871372	75	EXECUTED	8:07f0a6cd8dbbd9b89be0bd7378f7bdc8	addColumn tableName=core_user	Added 0.30.0	\N	3.6.3	\N	\N	0255974901
78	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:48.126528	76	EXECUTED	8:1977d7278269cdd0dc4f941f9e82f548	createTable tableName=group_table_access_policy; createIndex indexName=idx_gtap_table_id_group_id, tableName=group_table_access_policy; addUniqueConstraint constraintName=unique_gtap_table_id_group_id, tableName=group_table_access_policy	Added 0.30.0	\N	3.6.3	\N	\N	0255974901
79	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:48.251798	77	EXECUTED	8:3f31cb67f9cdf7754ca95cade22d87a2	addColumn tableName=report_dashboard; createIndex indexName=idx_dashboard_collection_id, tableName=report_dashboard; addColumn tableName=pulse; createIndex indexName=idx_pulse_collection_id, tableName=pulse	Added 0.30.0	\N	3.6.3	\N	\N	0255974901
80	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:48.340482	78	EXECUTED	8:199d0ce28955117819ca15bcc29323e5	addColumn tableName=collection; createIndex indexName=idx_collection_location, tableName=collection		\N	3.6.3	\N	\N	0255974901
81	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:48.387216	79	EXECUTED	8:3a6dc22403660529194d004ca7f7ad39	addColumn tableName=report_dashboard; addColumn tableName=report_card; addColumn tableName=pulse	Added 0.30.0	\N	3.6.3	\N	\N	0255974901
82	senior	migrations/000_migrations.yaml	2021-12-23 10:39:48.426869	80	EXECUTED	8:ac4b94df8c648f88cfff661284d6392d	addColumn tableName=core_user; sql	Added 0.30.0	\N	3.6.3	\N	\N	0255974901
83	senior	migrations/000_migrations.yaml	2021-12-23 10:39:48.46474	81	EXECUTED	8:ccd897d737737c05248293c7d56efe96	dropNotNullConstraint columnName=card_id, tableName=group_table_access_policy	Added 0.30.0	\N	3.6.3	\N	\N	0255974901
84	senior	migrations/000_migrations.yaml	2021-12-23 10:39:48.506202	82	EXECUTED	8:58afc10c3e283a8050ea471aac447a97	renameColumn newColumnName=archived, oldColumnName=is_active, tableName=metric; addDefaultValue columnName=archived, tableName=metric; renameColumn newColumnName=archived, oldColumnName=is_active, tableName=segment; addDefaultValue columnName=arch...	Added 0.30.0	\N	3.6.3	\N	\N	0255974901
85	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:48.632562	83	EXECUTED	8:9b4c9878a5018452dd63eb6d7c17f415	addColumn tableName=collection; createIndex indexName=idx_collection_personal_owner_id, tableName=collection; addColumn tableName=collection; sql; addNotNullConstraint columnName=_slug, tableName=collection; dropColumn columnName=slug, tableName=c...	Added 0.30.0	\N	3.6.3	\N	\N	0255974901
86	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:48.653387	84	EXECUTED	8:50c75bb29f479e0b3fb782d89f7d6717	sql	Added 0.30.0	\N	3.6.3	\N	\N	0255974901
87	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:48.693913	85	EXECUTED	8:0eccf19a93cb0ba4017aafd1d308c097	dropTable tableName=raw_column; dropTable tableName=raw_table	Added 0.30.0	\N	3.6.3	\N	\N	0255974901
88	senior	migrations/000_migrations.yaml	2021-12-23 10:39:48.732835	86	EXECUTED	8:04ff5a0738473938fc31d68c1d9952e1	addColumn tableName=core_user	Added 0.30.0	\N	3.6.3	\N	\N	0255974901
129	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.169448	125	MARK_RAN	8:f890168c47cc2113a8af77ed3875c4b3	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
130	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.193491	126	MARK_RAN	8:ecdcf1fd66b3477e5b6882c3286b2fd8	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
89	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:50.558192	87	EXECUTED	8:94d5c406e3ec44e2bc85abe96f6fd91c	createTable tableName=QRTZ_JOB_DETAILS; addPrimaryKey constraintName=PK_QRTZ_JOB_DETAILS, tableName=QRTZ_JOB_DETAILS; createTable tableName=QRTZ_TRIGGERS; addPrimaryKey constraintName=PK_QRTZ_TRIGGERS, tableName=QRTZ_TRIGGERS; addForeignKeyConstra...	Added 0.30.0	\N	3.6.3	\N	\N	0255974901
90	senior	migrations/000_migrations.yaml	2021-12-23 10:39:50.612719	88	EXECUTED	8:8562a72a1190deadc5fa59a23a6396dc	addColumn tableName=core_user; sql; dropColumn columnName=saml_auth, tableName=core_user	Added 0.30.0	\N	3.6.3	\N	\N	0255974901
91	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:50.65771	89	EXECUTED	8:9b8831e1e409f08e874c4ece043d0340	dropColumn columnName=raw_table_id, tableName=metabase_table; dropColumn columnName=raw_column_id, tableName=metabase_field	Added 0.30.0	\N	3.6.3	\N	\N	0255974901
92	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:50.698012	90	EXECUTED	8:1e5bc2d66778316ea640a561862c23b4	addColumn tableName=query_execution	Added 0.31.0	\N	3.6.3	\N	\N	0255974901
94	senior	migrations/000_migrations.yaml	2021-12-23 10:39:50.945456	92	EXECUTED	8:a2a1eedf1e8f8756856c9d49c7684bfe	createTable tableName=task_history; createIndex indexName=idx_task_history_end_time, tableName=task_history; createIndex indexName=idx_task_history_db_id, tableName=task_history	Added 0.31.0	\N	3.6.3	\N	\N	0255974901
95	senior	migrations/000_migrations.yaml	2021-12-23 10:39:51.040891	93	EXECUTED	8:9824808283004e803003b938399a4cf0	addUniqueConstraint constraintName=idx_databasechangelog_id_author_filename, tableName=DATABASECHANGELOG	Added 0.31.0	\N	3.6.3	\N	\N	0255974901
96	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.090689	94	EXECUTED	8:5cb2f36edcca9c6e14c5e109d6aeb68b	addColumn tableName=metabase_field	Added 0.31.0	\N	3.6.3	\N	\N	0255974901
97	senior	migrations/000_migrations.yaml	2021-12-23 10:39:51.115746	95	MARK_RAN	8:9169e238663c5d036bd83428d2fa8e4b	modifyDataType columnName=results, tableName=query_cache	Added 0.32.0	\N	3.6.3	\N	\N	0255974901
98	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.256094	96	EXECUTED	8:f036d20a4dc86fb60ffb64ea838ed6b9	addUniqueConstraint constraintName=idx_uniq_table_db_id_schema_name, tableName=metabase_table; sql	Added 0.32.0	\N	3.6.3	\N	\N	0255974901
99	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.377578	97	EXECUTED	8:274bb516dd95b76c954b26084eed1dfe	addUniqueConstraint constraintName=idx_uniq_field_table_id_parent_id_name, tableName=metabase_field; sql	Added 0.32.0	\N	3.6.3	\N	\N	0255974901
100	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.407737	98	EXECUTED	8:948014f13b6198b50e3b7a066fae2ae0	sql	Added 0.32.0	\N	3.6.3	\N	\N	0255974901
101	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.4945	99	EXECUTED	8:58eabb08a175fafe8985208545374675	createIndex indexName=idx_field_parent_id, tableName=metabase_field	Added 0.32.0	\N	3.6.3	\N	\N	0255974901
103	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.54237	100	EXECUTED	8:fda3670fd16a40fd9d0f89a003098d54	addColumn tableName=metabase_database	Added 0.32.10	\N	3.6.3	\N	\N	0255974901
104	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.617812	101	EXECUTED	8:21709f17e6d1b521d3d3b8cbb5445218	addColumn tableName=core_session	Added EE 1.1.6/CE 0.33.0	\N	3.6.3	\N	\N	0255974901
106	sb	migrations/000_migrations.yaml	2021-12-23 10:39:51.664082	102	EXECUTED	8:a3dd42bbe25c415ce21e4c180dc1c1d7	modifyDataType columnName=database_type, tableName=metabase_field	Added 0.33.5	\N	3.6.3	\N	\N	0255974901
107	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.689983	103	MARK_RAN	8:605c2b4d212315c83727aa3d914cf57f	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
108	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.715003	104	MARK_RAN	8:d11419da9384fd27d7b1670707ac864c	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
109	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.7371	105	MARK_RAN	8:a5f4ea412eb1d5c1bc824046ad11692f	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
110	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.757449	106	MARK_RAN	8:82343097044b9652f73f3d3a2ddd04fe	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
111	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.777956	107	MARK_RAN	8:528de1245ba3aa106871d3e5b3eee0ba	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
112	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.797665	108	MARK_RAN	8:010a3931299429d1adfa91941c806ea4	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
113	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.817199	109	MARK_RAN	8:8f8e0836064bdea82487ecf64a129767	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
114	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.836906	110	MARK_RAN	8:7a0bcb25ece6d9a311d6c6be7ed89bb7	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
115	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.857116	111	MARK_RAN	8:55c10c2ff7e967e3ea1fdffc5aeed93a	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
116	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.877294	112	MARK_RAN	8:dbf7c3a1d8b1eb77b7f5888126b13c2e	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
117	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.897401	113	MARK_RAN	8:f2d7f9fb1b6713bc5362fe40bfe3f91f	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
118	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.917759	114	MARK_RAN	8:17f4410e30a0c7e84a36517ebf4dab64	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
119	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.939537	115	MARK_RAN	8:195cf171ac1d5531e455baf44d9d6561	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
120	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.962249	116	MARK_RAN	8:61f53fac337020aec71868656a719bba	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
121	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:51.984874	117	MARK_RAN	8:1baa145d2ffe1e18d097a63a95476c5f	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
122	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.005399	118	MARK_RAN	8:929b3c551a8f631cdce2511612d82d62	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
123	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.028786	119	MARK_RAN	8:35e5baddf78df5829fe6889d216436e5	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
124	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.052062	120	MARK_RAN	8:ce2322ca187dfac51be8f12f6a132818	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
125	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.075693	121	MARK_RAN	8:dd948ac004ceb9d0a300a8e06806945f	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
126	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.099763	122	MARK_RAN	8:3d34c0d4e5dbb32b432b83d5322e2aa3	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
127	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.12168	123	MARK_RAN	8:18314b269fe11898a433ca9048400975	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
128	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.146227	124	MARK_RAN	8:44acbe257817286d88b7892e79363b66	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
131	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.232595	127	MARK_RAN	8:453af2935194978c65b19eae445d85c9	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
132	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.259779	128	MARK_RAN	8:d2c37bc80b42a15b65f148bcb1daa86e	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
133	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.284987	129	MARK_RAN	8:5b9b539d146fbdb762577dc98e7f3430	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
134	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.30793	130	MARK_RAN	8:4d0f688a168db3e357a808263b6ad355	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
135	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.33239	131	MARK_RAN	8:2ca54b0828c6aca615fb42064f1ec728	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
136	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.356153	132	MARK_RAN	8:7115eebbcf664509b9fc0c39cb6f29e9	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
137	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.380037	133	MARK_RAN	8:da754ac6e51313a32de6f6389b29e1ca	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
138	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.4039	134	MARK_RAN	8:bfb201761052189e96538f0de3ac76cf	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
140	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.45075	136	MARK_RAN	8:a0cfe6468160bba8c9d602da736c41fb	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
141	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.473504	137	MARK_RAN	8:b6b7faa02cba069e1ed13e365f59cb6b	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
142	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.498432	138	MARK_RAN	8:0c291eb50cc0f1fef3d55cfe6b62bedb	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
143	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.521671	139	MARK_RAN	8:3d9a5cb41f77a33e834d0562fdddeab6	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
144	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.545665	140	MARK_RAN	8:1d5b7f79f97906105e90d330a17c4062	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
145	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.569749	141	MARK_RAN	8:b162dd48ef850ab4300e2d714eac504e	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
146	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.592107	142	MARK_RAN	8:8c0c1861582d15fe7859358f5d553c91	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
147	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.613166	143	MARK_RAN	8:5ccf590332ea0744414e40a990a43275	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
148	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.635007	144	MARK_RAN	8:12b42e87d40cd7b6399c1fb0c6704fa7	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
149	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.656703	145	MARK_RAN	8:dd45bfc4af5e05701a064a5f2a046d7f	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
150	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.67913	146	MARK_RAN	8:48beda94aeaa494f798c38a66b90fb2a	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
151	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.702148	147	MARK_RAN	8:bb752a7d09d437c7ac294d5ab2600079	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
152	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.723703	148	MARK_RAN	8:4bcbc472f2d6ae3a5e7eca425940e52b	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
153	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.745454	149	MARK_RAN	8:adce2cca96fe0531b00f9bed6bed8352	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
154	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.766423	150	MARK_RAN	8:7a1df4f7a679f47459ea1a1c0991cfba	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
155	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.786058	151	MARK_RAN	8:3c78b79c784e3a3ce09a77db1b1d0374	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
156	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.805998	152	MARK_RAN	8:51859ee6cca4aca9d141a3350eb5d6b1	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
157	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.825934	153	MARK_RAN	8:0197c46bf8536a75dbf7e9aee731f3b2	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
158	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.845933	154	MARK_RAN	8:2ebdd5a179ce2487b2e23b6be74a407c	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
159	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.866061	155	MARK_RAN	8:c62719dad239c51f045315273b56e2a9	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
162	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.936436	157	EXECUTED	8:c37f015ad11d77d66e09925eed605cdf	dropTable tableName=query_queryexecution	Added 0.23.0 as a data migration; converted to Liquibase migration in 0.35.0	\N	3.6.3	\N	\N	0255974901
163	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.976675	158	EXECUTED	8:9ef66a82624d70738fc89807a2398ed1	dropColumn columnName=read_permissions, tableName=report_card	Added 0.35.0	\N	3.6.3	\N	\N	0255974901
164	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:53.021579	159	EXECUTED	8:f19470701bbb33f19f91b1199a915881	addColumn tableName=core_user	Added 0.35.0	\N	3.6.3	\N	\N	0255974901
165	sb	migrations/000_migrations.yaml	2021-12-23 10:39:53.072745	160	EXECUTED	8:b3ae2b90db5c4264ea2ac50d304d6ad4	addColumn tableName=metabase_field; addColumn tableName=metabase_field; addColumn tableName=metabase_table; sql	Added field_order to Table and database_position to Field	\N	3.6.3	\N	\N	0255974901
166	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:53.157038	161	EXECUTED	8:92dafa5c15c46e2af8380304449c7dfa	modifyDataType columnName=updated_at, tableName=metabase_fieldvalues; modifyDataType columnName=updated_at, tableName=query_cache	Added 0.36.0/1.35.4	\N	3.6.3	\N	\N	0255974901
167	walterl, camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:53.382658	162	EXECUTED	8:4c11dc8c5e829b5263c198fe7879f161	sql; createTable tableName=native_query_snippet; createIndex indexName=idx_snippet_name, tableName=native_query_snippet	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
168	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:53.510597	163	EXECUTED	8:6d40bfa472bccd2d54284aeb89e1ec3c	modifyDataType columnName=started_at, tableName=query_execution	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
169	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:53.557138	164	EXECUTED	8:2b97e6eaa7854e179abb9f3749f73b18	dropColumn columnName=rows, tableName=metabase_table	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
170	sb	migrations/000_migrations.yaml	2021-12-23 10:39:53.603236	165	EXECUTED	8:dbd6ee52b0f9195e449a6d744606b599	dropColumn columnName=fields_hash, tableName=metabase_table	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
171	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:53.699322	166	EXECUTED	8:0798080c0796e6ab3e791bff007118b8	addColumn tableName=native_query_snippet; createIndex indexName=idx_snippet_collection_id, tableName=native_query_snippet	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
172	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:53.747125	167	EXECUTED	8:212f4010b504e358853fd017032f844f	addColumn tableName=collection	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
173	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:53.791505	168	EXECUTED	8:4d32b4b7be3f4801e51aeffa5dd47649	dropForeignKeyConstraint baseTableName=activity, constraintName=fk_activity_ref_user_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
174	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:53.83598	169	EXECUTED	8:66f31503ba532702e54ea531af668531	addForeignKeyConstraint baseTableName=activity, constraintName=fk_activity_ref_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
175	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:53.892508	170	EXECUTED	8:c3ceddfca8827d73474cd9a70ea01d1c	dropForeignKeyConstraint baseTableName=card_label, constraintName=fk_card_label_ref_card_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
176	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:53.937456	171	EXECUTED	8:89c918faa84b7f3f5fa291d4da74414c	addForeignKeyConstraint baseTableName=card_label, constraintName=fk_card_label_ref_card_id, referencedTableName=report_card	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
177	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:53.979106	172	EXECUTED	8:d45f2198befc83de1f1f963c750607af	dropForeignKeyConstraint baseTableName=card_label, constraintName=fk_card_label_ref_label_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
178	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:54.025224	173	EXECUTED	8:63d396999449da2d42b3d3e22f3454fa	addForeignKeyConstraint baseTableName=card_label, constraintName=fk_card_label_ref_label_id, referencedTableName=label	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
179	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:54.072165	174	EXECUTED	8:2a0a7956402ef074e5d54c73ac2d5405	dropForeignKeyConstraint baseTableName=collection, constraintName=fk_collection_personal_owner_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
180	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:54.123339	175	EXECUTED	8:b02225e5940a2bcca3d550f24f80123e	addForeignKeyConstraint baseTableName=collection, constraintName=fk_collection_personal_owner_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
181	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:54.171033	176	EXECUTED	8:16923f06b2bbb60c6ac78a0c4b7e4d4f	dropForeignKeyConstraint baseTableName=collection_revision, constraintName=fk_collection_revision_user_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
182	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:54.2178	177	EXECUTED	8:d59d864c038c530a49056704c93f231d	addForeignKeyConstraint baseTableName=collection_revision, constraintName=fk_collection_revision_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
183	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:54.264483	178	EXECUTED	8:c5ed9a4f44ee92af620a47c80e010a6b	dropForeignKeyConstraint baseTableName=computation_job, constraintName=fk_computation_job_ref_user_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
184	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:54.311371	179	EXECUTED	8:70317e2bdaac90b9ddc33b1b93ada479	addForeignKeyConstraint baseTableName=computation_job, constraintName=fk_computation_job_ref_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
185	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:54.357174	180	EXECUTED	8:12e7457ec2d2b1a99a3fadfc64d7b7f9	dropForeignKeyConstraint baseTableName=computation_job_result, constraintName=fk_computation_result_ref_job_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
186	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:54.40769	181	EXECUTED	8:526987d0f6b2f01d7bfc9e3179721be6	addForeignKeyConstraint baseTableName=computation_job_result, constraintName=fk_computation_result_ref_job_id, referencedTableName=computation_job	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
187	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:54.455142	182	EXECUTED	8:3fbb75c0c491dc6628583184202b8f39	dropForeignKeyConstraint baseTableName=core_session, constraintName=fk_session_ref_user_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
188	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:54.502273	183	EXECUTED	8:4dc500830cd4c5715ca8b0956e37b3d5	addForeignKeyConstraint baseTableName=core_session, constraintName=fk_session_ref_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
189	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:54.549074	184	EXECUTED	8:e07396e0ee587dcf321d21cffa9eec29	dropForeignKeyConstraint baseTableName=dashboardcard_series, constraintName=fk_dashboardcard_series_ref_card_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
190	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:54.608608	185	EXECUTED	8:eded791094a16bf398896c790645c411	addForeignKeyConstraint baseTableName=dashboardcard_series, constraintName=fk_dashboardcard_series_ref_card_id, referencedTableName=report_card	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
191	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:54.655269	186	EXECUTED	8:bb5b9a3d64b2e44318e159e7f1fecde2	dropForeignKeyConstraint baseTableName=dashboardcard_series, constraintName=fk_dashboardcard_series_ref_dashboardcard_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
192	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:54.703377	187	EXECUTED	8:7d96911036dec2fee64fe8ae57c131b3	addForeignKeyConstraint baseTableName=dashboardcard_series, constraintName=fk_dashboardcard_series_ref_dashboardcard_id, referencedTableName=report_dashboardcard	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
193	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:54.749344	188	EXECUTED	8:db171179fe094db9fee7e2e7df60fa4e	dropForeignKeyConstraint baseTableName=group_table_access_policy, constraintName=fk_gtap_card_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
194	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:54.797072	189	EXECUTED	8:fccb724d7ae7606e2e7638de1791392a	addForeignKeyConstraint baseTableName=group_table_access_policy, constraintName=fk_gtap_card_id, referencedTableName=report_card	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
195	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:54.838093	190	EXECUTED	8:1d720af9f917007024c91d40410bc91d	dropForeignKeyConstraint baseTableName=metabase_field, constraintName=fk_field_parent_ref_field_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
196	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:54.878803	191	EXECUTED	8:c52f5dbf742feef12a3803bda92a425b	addForeignKeyConstraint baseTableName=metabase_field, constraintName=fk_field_parent_ref_field_id, referencedTableName=metabase_field	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
197	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:54.919592	192	EXECUTED	8:9c1c950b709050abe91cea17fd5970cc	dropForeignKeyConstraint baseTableName=metabase_field, constraintName=fk_field_ref_table_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
198	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:54.96339	193	EXECUTED	8:e24198ff4825a41d17ceaebd71692103	addForeignKeyConstraint baseTableName=metabase_field, constraintName=fk_field_ref_table_id, referencedTableName=metabase_table	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
199	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:55.007537	194	EXECUTED	8:146efae3f2938538961835fe07433ee1	dropForeignKeyConstraint baseTableName=metabase_fieldvalues, constraintName=fk_fieldvalues_ref_field_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
200	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:55.050384	195	EXECUTED	8:f5e7e79cb81b8d2245663c482746c853	addForeignKeyConstraint baseTableName=metabase_fieldvalues, constraintName=fk_fieldvalues_ref_field_id, referencedTableName=metabase_field	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
201	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:55.091935	196	EXECUTED	8:2d79321a27fde6cb3c4fabdb86dc60ec	dropForeignKeyConstraint baseTableName=metabase_table, constraintName=fk_table_ref_database_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
202	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:55.139536	197	EXECUTED	8:d0cefed061c4abbf2b0a0fd2a66817cb	addForeignKeyConstraint baseTableName=metabase_table, constraintName=fk_table_ref_database_id, referencedTableName=metabase_database	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
203	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:55.185832	198	EXECUTED	8:28b4ec07bfbf4b86532fe9357effdb8b	dropForeignKeyConstraint baseTableName=metric, constraintName=fk_metric_ref_creator_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
204	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:55.240781	199	EXECUTED	8:7195937fd2144533edfa2302ba2ae653	addForeignKeyConstraint baseTableName=metric, constraintName=fk_metric_ref_creator_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
205	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:55.286753	200	EXECUTED	8:4b2d5f1458641dd1b9dbc5f41600be8e	dropForeignKeyConstraint baseTableName=metric, constraintName=fk_metric_ref_table_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
207	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:55.380569	202	EXECUTED	8:18135d674f2fe502313adb0475f5f139	dropForeignKeyConstraint baseTableName=metric_important_field, constraintName=fk_metric_important_field_metabase_field_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
208	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:55.426305	203	EXECUTED	8:4c86c17a00a81dfdf35a181e3dd3b08f	addForeignKeyConstraint baseTableName=metric_important_field, constraintName=fk_metric_important_field_metabase_field_id, referencedTableName=metabase_field	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
209	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:55.473587	204	EXECUTED	8:1b9c3544bf89093fc9e4f7f191fdc6df	dropForeignKeyConstraint baseTableName=metric_important_field, constraintName=fk_metric_important_field_metric_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
210	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:55.521994	205	EXECUTED	8:842d166cdf7b0a29c88efdaf95c9d0bf	addForeignKeyConstraint baseTableName=metric_important_field, constraintName=fk_metric_important_field_metric_id, referencedTableName=metric	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
211	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:55.567538	206	EXECUTED	8:91c64815a1aefb07dd124d493bfeeea9	dropForeignKeyConstraint baseTableName=native_query_snippet, constraintName=fk_snippet_collection_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
212	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:55.615758	207	EXECUTED	8:b25064ee26b71f61906a833bc22ebbc2	addForeignKeyConstraint baseTableName=native_query_snippet, constraintName=fk_snippet_collection_id, referencedTableName=collection	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
213	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:55.662699	208	EXECUTED	8:60a7d628e4f68ee4c85f5f298b1d9865	dropForeignKeyConstraint baseTableName=permissions, constraintName=fk_permissions_group_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
214	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:55.712768	209	EXECUTED	8:1c3c480313967a2d9f324a094ba25f4d	addForeignKeyConstraint baseTableName=permissions, constraintName=fk_permissions_group_id, referencedTableName=permissions_group	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
215	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:55.759296	210	EXECUTED	8:5d2c67ccead52970e9d85beb7eda48b9	dropForeignKeyConstraint baseTableName=permissions_group_membership, constraintName=fk_permissions_group_group_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
216	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:55.810291	211	EXECUTED	8:35fcd5d48600e887188eb1b990e6cc35	addForeignKeyConstraint baseTableName=permissions_group_membership, constraintName=fk_permissions_group_group_id, referencedTableName=permissions_group	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
217	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:55.850663	212	EXECUTED	8:da7460a35a724109ae9b5096cd18666b	dropForeignKeyConstraint baseTableName=permissions_group_membership, constraintName=fk_permissions_group_membership_user_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
218	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:55.908973	213	EXECUTED	8:dc04b7eb04cd870c53102cb37fd75a5f	addForeignKeyConstraint baseTableName=permissions_group_membership, constraintName=fk_permissions_group_membership_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
206	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:55.334803	201	EXECUTED	8:959ef448c23aaf3acf5b69f297fe4b2f	addForeignKeyConstraint baseTableName=metric, constraintName=fk_metric_ref_table_id, referencedTableName=metabase_table	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
219	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:55.983359	214	EXECUTED	8:02c690f34fe8803e42441f5037d33017	dropForeignKeyConstraint baseTableName=permissions_revision, constraintName=fk_permissions_revision_user_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
220	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.025385	215	EXECUTED	8:8b8447405d7b2b52358c9676d64b7651	addForeignKeyConstraint baseTableName=permissions_revision, constraintName=fk_permissions_revision_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
221	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.064846	216	EXECUTED	8:54a4c0d8a4eda80dc81fb549a629d075	dropForeignKeyConstraint baseTableName=pulse, constraintName=fk_pulse_collection_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
222	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.108361	217	EXECUTED	8:c5f22e925be3a8fd0e4f47a491f599ee	addForeignKeyConstraint baseTableName=pulse, constraintName=fk_pulse_collection_id, referencedTableName=collection	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
223	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.147648	218	EXECUTED	8:de743e384ff90a6a31a3caebe0abb775	dropForeignKeyConstraint baseTableName=pulse, constraintName=fk_pulse_ref_creator_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
224	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.186763	219	EXECUTED	8:b8fdf9c14d7ea3131a0a6b1f1036f91a	addForeignKeyConstraint baseTableName=pulse, constraintName=fk_pulse_ref_creator_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
225	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.225701	220	EXECUTED	8:495a4e12cf75cac5ff54738772e6a998	dropForeignKeyConstraint baseTableName=pulse_card, constraintName=fk_pulse_card_ref_card_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
226	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.264925	221	EXECUTED	8:cf383d74bc407065c78c060203ba4560	addForeignKeyConstraint baseTableName=pulse_card, constraintName=fk_pulse_card_ref_card_id, referencedTableName=report_card	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
227	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.305455	222	EXECUTED	8:e23eaf74ab7edacfb34bd5caf05cf66f	dropForeignKeyConstraint baseTableName=pulse_card, constraintName=fk_pulse_card_ref_pulse_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
228	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.346882	223	EXECUTED	8:d458ddb160f61e93bb69738f262de2b4	addForeignKeyConstraint baseTableName=pulse_card, constraintName=fk_pulse_card_ref_pulse_id, referencedTableName=pulse	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
229	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.386316	224	EXECUTED	8:1cb939d172989cb1629e9a3da768596d	dropForeignKeyConstraint baseTableName=pulse_channel, constraintName=fk_pulse_channel_ref_pulse_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
230	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.426824	225	EXECUTED	8:62baea3334ac5f21feac84497f6bf643	addForeignKeyConstraint baseTableName=pulse_channel, constraintName=fk_pulse_channel_ref_pulse_id, referencedTableName=pulse	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
231	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.46572	226	EXECUTED	8:d096a9ce70fc0b7dfbc67ee1be4c3e31	dropForeignKeyConstraint baseTableName=pulse_channel_recipient, constraintName=fk_pulse_channel_recipient_ref_pulse_channel_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
294	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:59.565202	287	EXECUTED	8:88d7a9c88866af42b9f0e7c1df9c2fd0	createIndex indexName=idx_session_id, tableName=login_history	Added 0.39.0	\N	3.6.3	\N	\N	0255974901
232	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.505779	227	EXECUTED	8:be2457ae1e386c9d5ec5bfa4ae681fd6	addForeignKeyConstraint baseTableName=pulse_channel_recipient, constraintName=fk_pulse_channel_recipient_ref_pulse_channel_id, referencedTableName=pulse_channel	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
233	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.544708	228	EXECUTED	8:d5c018882af16093de446e025e2599b7	dropForeignKeyConstraint baseTableName=pulse_channel_recipient, constraintName=fk_pulse_channel_recipient_ref_user_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
234	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.58605	229	EXECUTED	8:edb6ced6c353064c46fa00b54e187aef	addForeignKeyConstraint baseTableName=pulse_channel_recipient, constraintName=fk_pulse_channel_recipient_ref_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
235	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.628513	230	EXECUTED	8:550c64e41e55233d52ac3ef24d664be1	dropForeignKeyConstraint baseTableName=report_card, constraintName=fk_card_collection_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
236	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.674024	231	EXECUTED	8:04300b298b663fc2a2f3a324d1051c3c	addForeignKeyConstraint baseTableName=report_card, constraintName=fk_card_collection_id, referencedTableName=collection	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
237	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.715098	232	EXECUTED	8:227a9133cdff9f1b60d8af53688ab12e	dropForeignKeyConstraint baseTableName=report_card, constraintName=fk_card_made_public_by_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
238	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.756364	233	EXECUTED	8:7000766ddca2c914ac517611e7d86549	addForeignKeyConstraint baseTableName=report_card, constraintName=fk_card_made_public_by_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
239	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.799644	234	EXECUTED	8:672f4972653f70464982008a7abea3e1	dropForeignKeyConstraint baseTableName=report_card, constraintName=fk_card_ref_user_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
240	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.847391	235	EXECUTED	8:165b07c8ceb004097c83ee1b689164e4	addForeignKeyConstraint baseTableName=report_card, constraintName=fk_card_ref_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
241	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.88934	236	EXECUTED	8:b0a9e3d801e64e0a66c3190e458c01ae	dropForeignKeyConstraint baseTableName=report_card, constraintName=fk_report_card_ref_database_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
242	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.929039	237	EXECUTED	8:bf10f944715f87c3ad0dd7472d84df62	addForeignKeyConstraint baseTableName=report_card, constraintName=fk_report_card_ref_database_id, referencedTableName=metabase_database	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
243	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.952859	238	EXECUTED	8:cba5d2bfb36e13c60d82cc6cca659b61	dropForeignKeyConstraint baseTableName=report_card, constraintName=fk_report_card_ref_table_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
244	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:56.995259	239	EXECUTED	8:4d40104eaa47d01981644462ef56f369	addForeignKeyConstraint baseTableName=report_card, constraintName=fk_report_card_ref_table_id, referencedTableName=metabase_table	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
245	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:57.037067	240	EXECUTED	8:a8f9206dadfe23662d547035f71e3846	dropForeignKeyConstraint baseTableName=report_cardfavorite, constraintName=fk_cardfavorite_ref_card_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
246	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:57.088096	241	EXECUTED	8:e5db34b9db22254f7445fd65ecf45356	addForeignKeyConstraint baseTableName=report_cardfavorite, constraintName=fk_cardfavorite_ref_card_id, referencedTableName=report_card	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
247	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:57.136094	242	EXECUTED	8:76de7337a12a5ef42dcbb9274bd2d70f	dropForeignKeyConstraint baseTableName=report_cardfavorite, constraintName=fk_cardfavorite_ref_user_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
248	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:57.185303	243	EXECUTED	8:0640fb00a090cbe5dc545afbe0d25811	addForeignKeyConstraint baseTableName=report_cardfavorite, constraintName=fk_cardfavorite_ref_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
249	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:57.23316	244	EXECUTED	8:16ef5909a72ac4779427e432b3b3ce18	dropForeignKeyConstraint baseTableName=report_dashboard, constraintName=fk_dashboard_collection_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
250	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:57.281166	245	EXECUTED	8:2e80ebe19816b7bde99050638772cf99	addForeignKeyConstraint baseTableName=report_dashboard, constraintName=fk_dashboard_collection_id, referencedTableName=collection	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
251	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:57.327793	246	EXECUTED	8:c12aa099f293b1e3d71da5e3edb3c45a	dropForeignKeyConstraint baseTableName=report_dashboard, constraintName=fk_dashboard_made_public_by_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
252	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:57.391676	247	EXECUTED	8:26b16d4d0cf7a77c1d687f49b029f421	addForeignKeyConstraint baseTableName=report_dashboard, constraintName=fk_dashboard_made_public_by_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
253	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:57.439363	248	EXECUTED	8:bbf118edaa88a8ad486ec0d6965504b6	dropForeignKeyConstraint baseTableName=report_dashboard, constraintName=fk_dashboard_ref_user_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
254	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:57.489541	249	EXECUTED	8:7fc35d78c63f41eb4dbd23cfd1505f0b	addForeignKeyConstraint baseTableName=report_dashboard, constraintName=fk_dashboard_ref_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
255	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:57.537442	250	EXECUTED	8:f6564a7516ace55104a3173eebf4c629	dropForeignKeyConstraint baseTableName=report_dashboardcard, constraintName=fk_dashboardcard_ref_card_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
256	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:57.590438	251	EXECUTED	8:61db9be3b4dd7ed1e9d01a7254e87544	addForeignKeyConstraint baseTableName=report_dashboardcard, constraintName=fk_dashboardcard_ref_card_id, referencedTableName=report_card	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
257	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:57.639586	252	EXECUTED	8:c8b51dc7ba4da9f7995a0b0c17fadad2	dropForeignKeyConstraint baseTableName=report_dashboardcard, constraintName=fk_dashboardcard_ref_dashboard_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
258	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:57.688234	253	EXECUTED	8:58974c6ad8aee63f09e6e48b1a78c267	addForeignKeyConstraint baseTableName=report_dashboardcard, constraintName=fk_dashboardcard_ref_dashboard_id, referencedTableName=report_dashboard	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
259	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:57.733347	254	EXECUTED	8:be4a52feb3b12e655c0bbd34477749b0	dropForeignKeyConstraint baseTableName=revision, constraintName=fk_revision_ref_user_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
260	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:57.774417	255	EXECUTED	8:4b370f9c9073a6f8f585aab713c57f47	addForeignKeyConstraint baseTableName=revision, constraintName=fk_revision_ref_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
261	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:57.835097	256	EXECUTED	8:173fe552fdf72fdb4efbc01a6ac4f7ad	dropForeignKeyConstraint baseTableName=segment, constraintName=fk_segment_ref_creator_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
262	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:57.908398	257	EXECUTED	8:50927b8b1d1809f32c11d2e649dbcb94	addForeignKeyConstraint baseTableName=segment, constraintName=fk_segment_ref_creator_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
263	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:57.947895	258	EXECUTED	8:0b10c8664506917cc50359e9634c121c	dropForeignKeyConstraint baseTableName=segment, constraintName=fk_segment_ref_table_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
264	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:57.986887	259	EXECUTED	8:b132aedf6fbdcc5d956a2d3a154cc035	addForeignKeyConstraint baseTableName=segment, constraintName=fk_segment_ref_table_id, referencedTableName=metabase_table	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
265	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:58.044082	260	EXECUTED	8:2e339ecb05463b3765f9bb266bd28297	dropForeignKeyConstraint baseTableName=view_log, constraintName=fk_view_log_ref_user_id	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
266	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:58.085783	261	EXECUTED	8:31506e118764f5e520f755f26c696bb8	addForeignKeyConstraint baseTableName=view_log, constraintName=fk_view_log_ref_user_id, referencedTableName=core_user	Added 0.36.0	\N	3.6.3	\N	\N	0255974901
268	rlotun	migrations/000_migrations.yaml	2021-12-23 10:39:58.164206	262	EXECUTED	8:9da2f706a7cd42b5101601e0106fa929	createIndex indexName=idx_lower_email, tableName=core_user	Added 0.37.0	\N	3.6.3	\N	\N	0255974901
269	rlotun	migrations/000_migrations.yaml	2021-12-23 10:39:58.190326	263	EXECUTED	8:215609ca9dce2181687b4fa65e7351ba	sql	Added 0.37.0	\N	3.6.3	\N	\N	0255974901
270	rlotun	migrations/000_migrations.yaml	2021-12-23 10:39:58.322136	264	EXECUTED	8:17001a192ba1df02104cc0d15569cbe5	sql	Added 0.37.0	\N	3.6.3	\N	\N	0255974901
271	rlotun	migrations/000_migrations.yaml	2021-12-23 10:39:58.444799	265	EXECUTED	8:ce8ddb253a303d4f8924ff5a187080c0	modifyDataType columnName=email, tableName=core_user	Added 0.37.0	\N	3.6.3	\N	\N	0255974901
273	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:58.487249	266	EXECUTED	8:5348576bb9852f6f947e1aa39cd1626f	addDefaultValue columnName=is_superuser, tableName=core_user	Added 0.37.1	\N	3.6.3	\N	\N	0255974901
274	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:58.530417	267	EXECUTED	8:11a8a84b9ba7634aeda625ff3f487d22	addDefaultValue columnName=is_active, tableName=core_user	Added 0.37.1	\N	3.6.3	\N	\N	0255974901
275	dpsutton	migrations/000_migrations.yaml	2021-12-23 10:39:58.57333	268	EXECUTED	8:447d9e294f59dd1058940defec7e0f40	addColumn tableName=metabase_database	Added 0.38.0 refingerprint to Database	\N	3.6.3	\N	\N	0255974901
93	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:50.73796	91	EXECUTED	8:93b0d408a3970e30d7184ed1166b5476	addColumn tableName=query	Added 0.31.0	\N	3.6.3	\N	\N	0255974901
276	robroland	migrations/000_migrations.yaml	2021-12-23 10:39:58.62741	269	EXECUTED	8:59dd1fb0732c7a9b78bce896c0cff3c0	addColumn tableName=pulse_card	Added 0.38.0 - Dashboard subscriptions	\N	3.6.3	\N	\N	0255974901
277	tsmacdonald	migrations/000_migrations.yaml	2021-12-23 10:39:58.674845	270	EXECUTED	8:367180f0820b72ad2c60212e67ae53e7	dropForeignKeyConstraint baseTableName=pulse_card, constraintName=fk_pulse_card_ref_pulse_card_id	Added 0.38.0 - Dashboard subscriptions	\N	3.6.3	\N	\N	0255974901
278	tsmacdonald	migrations/000_migrations.yaml	2021-12-23 10:39:58.723264	271	EXECUTED	8:fc4fb1c1e3344374edd7b9f1f0d34c89	addForeignKeyConstraint baseTableName=pulse_card, constraintName=fk_pulse_card_ref_pulse_card_id, referencedTableName=report_dashboardcard	Added 0.38.0 - Dashboard subscrptions	\N	3.6.3	\N	\N	0255974901
279	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:58.770628	272	EXECUTED	8:63dfccd51b62b939da71fe4435f58679	addColumn tableName=pulse	Added 0.38.0 - Dashboard subscriptions	\N	3.6.3	\N	\N	0255974901
280	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:58.820701	273	EXECUTED	8:ae966ee1e40f20ea438daba954a8c2a6	addForeignKeyConstraint baseTableName=pulse, constraintName=fk_pulse_ref_dashboard_id, referencedTableName=report_dashboard	Added 0.38.0 - Dashboard subscriptions	\N	3.6.3	\N	\N	0255974901
281	dpsutton	migrations/000_migrations.yaml	2021-12-23 10:39:58.867935	274	EXECUTED	8:3039286581c58eee7cca9c25fdf6d792	renameColumn newColumnName=semantic_type, oldColumnName=special_type, tableName=metabase_field	Added 0.39 - Semantic type system - rename special_type	\N	3.6.3	\N	\N	0255974901
282	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:58.918163	275	EXECUTED	8:d4b8566ee11d9f8a3d6c8c9539f6526d	sql; sql; sql	Added 0.39.0	\N	3.6.3	\N	\N	0255974901
283	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:59.001425	276	EXECUTED	8:2220e1b1cdb57212820b96fa3107f7c3	sql; sql; sql	Added 0.39.0	\N	3.6.3	\N	\N	0255974901
284	dpsutton	migrations/000_migrations.yaml	2021-12-23 10:39:59.040971	277	EXECUTED	8:c7dc9a60bcaf9b2ffcbaabd650c959b2	addColumn tableName=metabase_field	Added 0.39 - Semantic type system - add effective type	\N	3.6.3	\N	\N	0255974901
285	dpsutton	migrations/000_migrations.yaml	2021-12-23 10:39:59.065529	278	EXECUTED	8:cf7d6f5135fa3397a7dc67509d1c286e	addColumn tableName=metabase_field	Added 0.39 - Semantic type system - add coercion column	\N	3.6.3	\N	\N	0255974901
286	dpsutton	migrations/000_migrations.yaml	2021-12-23 10:39:59.090791	279	EXECUTED	8:bce9ab328411f05d8c52d64bff5bded0	sql	Added 0.39 - Semantic type system - set effective_type default	\N	3.6.3	\N	\N	0255974901
287	dpsutton	migrations/000_migrations.yaml	2021-12-23 10:39:59.117933	280	EXECUTED	8:0679eedae767a8648383aac2f923e413	sql	Added 0.39 - Semantic type system - migrate ISO8601 strings	\N	3.6.3	\N	\N	0255974901
288	dpsutton	migrations/000_migrations.yaml	2021-12-23 10:39:59.14417	281	EXECUTED	8:943c6dd0c9339729fefcee9207227849	sql	Added 0.39 - Semantic type system - migrate unix timestamps	\N	3.6.3	\N	\N	0255974901
289	dpsutton	migrations/000_migrations.yaml	2021-12-23 10:39:59.170597	282	EXECUTED	8:9f7f2e9bbf3236f204c644dc8ea7abef	sql	Added 0.39 - Semantic type system - migrate unix timestamps (corrects typo- seconds was migrated correctly, not millis and micros)	\N	3.6.3	\N	\N	0255974901
290	dpsutton	migrations/000_migrations.yaml	2021-12-23 10:39:59.195995	283	EXECUTED	8:98ea7254bc843302db4afe493c4c75e6	sql	Added 0.39 - Semantic type system - Clobber semantic_type where there was a coercion	\N	3.6.3	\N	\N	0255974901
291	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:59.341075	284	EXECUTED	8:b3b15e2ad791618e3ab1300a5d4f072f	createTable tableName=login_history	Added 0.39.0	\N	3.6.3	\N	\N	0255974901
292	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:59.424311	285	EXECUTED	8:e4ac005f4d4e73d5e1176bcbde510d6e	createIndex indexName=idx_user_id, tableName=login_history	Added 0.39.0	\N	3.6.3	\N	\N	0255974901
1	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:38.587209	1	EXECUTED	8:7182ca8e82947c24fa827d31f78b19aa	createTable tableName=core_organization; createTable tableName=core_user; createTable tableName=core_userorgperm; addUniqueConstraint constraintName=idx_unique_user_id_organization_id, tableName=core_userorgperm; createIndex indexName=idx_userorgp...		\N	3.6.3	\N	\N	0255974901
4	cammsaul	migrations/000_migrations.yaml	2021-12-23 10:39:38.853068	3	EXECUTED	8:a8e7822a91ea122212d376f5c2d4158f	createTable tableName=setting		\N	3.6.3	\N	\N	0255974901
5	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:38.900669	4	EXECUTED	8:4f8653d16f4b102b3dff647277b6b988	addColumn tableName=core_organization		\N	3.6.3	\N	\N	0255974901
35	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:42.887454	34	EXECUTED	8:91b72167fca724e6b6a94b64f886cf09	modifyDataType columnName=value, tableName=setting		\N	3.6.3	\N	\N	0255974901
293	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:59.477204	286	EXECUTED	8:7ba1bd887f8ae11a186b0e3fe69ab3e0	addForeignKeyConstraint baseTableName=login_history, constraintName=fk_login_history_session_id, referencedTableName=core_session	Added 0.39.0	\N	3.6.3	\N	\N	0255974901
310	howonlee	migrations/000_migrations.yaml	2021-12-23 10:40:00.313866	300	EXECUTED	8:eeba2296f23236d035812360122fd065	update tableName=setting	Added 0.40.0 Migrate friendly field names	\N	3.6.3	\N	\N	0255974901
311	howonlee	migrations/000_migrations.yaml	2021-12-23 10:40:00.335183	301	EXECUTED	8:a26e31914822a5176848abbb7c5415bd	sql; sql	Added 0.40.0 Migrate friendly field names, not noop	\N	3.6.3	\N	\N	0255974901
312	noahmoss	migrations/000_migrations.yaml	2021-12-23 10:40:00.358065	302	EXECUTED	8:77ef89ba2e7bc19231d9364492091764	sql; sql; sql	Added 0.41.0 Backfill collection_id for dashboard subscriptions	\N	3.6.3	\N	\N	0255974901
314	howonlee	migrations/000_migrations.yaml	2021-12-23 10:40:00.401113	303	EXECUTED	8:c9ad2637412d91b26b616a4df4190704	addColumn tableName=metabase_database	Added 0.41.0 Fine grained caching controls	\N	3.6.3	\N	\N	0255974901
315	howonlee	migrations/000_migrations.yaml	2021-12-23 10:40:00.448331	304	EXECUTED	8:5b186b8ab743cde5a7f4bf5eadcd520c	addColumn tableName=report_dashboard	Added 0.41.0 Fine grained caching controls, pt 2	\N	3.6.3	\N	\N	0255974901
316	howonlee	migrations/000_migrations.yaml	2021-12-23 10:40:00.539432	305	EXECUTED	8:1b7c340684b27af9179613bc351e444f	addColumn tableName=view_log	Added 0.41.0 Fine grained caching controls, pt 3	\N	3.6.3	\N	\N	0255974901
381	camsaul	migrations/000_migrations.yaml	2021-12-23 10:40:00.630884	306	EXECUTED	8:048be5b22042724ab3db240e14e43886	createIndex indexName=idx_query_execution_card_id, tableName=query_execution	Added 0.41.2 Add index to QueryExecution card_id to fix performance issues (#18759)	\N	3.6.3	\N	\N	0255974901
382	camsaul	migrations/000_migrations.yaml	2021-12-23 10:40:00.718262	307	EXECUTED	8:e8c01b2cf428b1e8968393cf31afb188	createIndex indexName=idx_moderation_review_item_type_item_id, tableName=moderation_review	Added 0.41.2 Add index to ModerationReview moderated_item_type + moderated_item_id to fix performance issues (#18759)	\N	3.6.3	\N	\N	0255974901
6	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:38.967335	5	EXECUTED	8:2d2f5d1756ecb81da7c09ccfb9b1565a	dropNotNullConstraint columnName=organization_id, tableName=metabase_database; dropForeignKeyConstraint baseTableName=metabase_database, constraintName=fk_database_ref_organization_id; dropNotNullConstraint columnName=organization_id, tableName=re...		\N	3.6.3	\N	\N	0255974901
7	cammsaul	migrations/000_migrations.yaml	2021-12-23 10:39:39.017149	6	EXECUTED	8:c57c69fd78d804beb77d261066521f7f	addColumn tableName=metabase_field		\N	3.6.3	\N	\N	0255974901
8	tlrobinson	migrations/000_migrations.yaml	2021-12-23 10:39:39.064656	7	EXECUTED	8:960ec59bbcb4c9f3fa8362eca9af4075	addColumn tableName=metabase_table; addColumn tableName=metabase_field		\N	3.6.3	\N	\N	0255974901
9	tlrobinson	migrations/000_migrations.yaml	2021-12-23 10:39:39.111083	8	EXECUTED	8:d560283a190e3c60802eb04f5532a49d	addColumn tableName=metabase_table		\N	3.6.3	\N	\N	0255974901
10	cammsaul	migrations/000_migrations.yaml	2021-12-23 10:39:39.303467	9	EXECUTED	8:9f03a236be31f54e8e5c894fe5fc7f00	createTable tableName=revision; createIndex indexName=idx_revision_model_model_id, tableName=revision		\N	3.6.3	\N	\N	0255974901
11	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:39.335613	10	EXECUTED	8:ca6561cab1eedbcf4dcb6d6e22cd46c6	sql		\N	3.6.3	\N	\N	0255974901
12	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:39.381517	11	EXECUTED	8:e862a199cba5b4ce0cba713110f66cfb	addColumn tableName=report_card; addColumn tableName=report_card; addColumn tableName=report_card		\N	3.6.3	\N	\N	0255974901
13	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:39.638207	12	EXECUTED	8:c2c65930bad8d3e9bab3bb6ae562fe0c	createTable tableName=activity; createIndex indexName=idx_activity_timestamp, tableName=activity; createIndex indexName=idx_activity_user_id, tableName=activity; createIndex indexName=idx_activity_custom_id, tableName=activity		\N	3.6.3	\N	\N	0255974901
14	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:39.809258	13	EXECUTED	8:320d2ca8ead3f31309674b2b7f54f395	createTable tableName=view_log; createIndex indexName=idx_view_log_user_id, tableName=view_log; createIndex indexName=idx_view_log_timestamp, tableName=view_log		\N	3.6.3	\N	\N	0255974901
15	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:39.847728	14	EXECUTED	8:505b91530103673a9be3382cd2db1070	addColumn tableName=revision		\N	3.6.3	\N	\N	0255974901
16	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:39.885795	15	EXECUTED	8:ecc7f02641a589e6d35f88587ac6e02b	dropNotNullConstraint columnName=last_login, tableName=core_user		\N	3.6.3	\N	\N	0255974901
17	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:39.944143	16	EXECUTED	8:051c23cd15359364b9895c1569c319e7	addColumn tableName=metabase_database; sql		\N	3.6.3	\N	\N	0255974901
18	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:40.069511	17	EXECUTED	8:62a0483dde183cfd18dd0a86e9354288	createTable tableName=data_migrations; createIndex indexName=idx_data_migrations_id, tableName=data_migrations		\N	3.6.3	\N	\N	0255974901
19	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:40.117439	18	EXECUTED	8:269b129dbfc39a6f9e0d3bc61c3c3b70	addColumn tableName=metabase_table		\N	3.6.3	\N	\N	0255974901
20	agilliland	migrations/000_migrations.yaml	2021-12-23 10:39:40.622444	19	EXECUTED	8:0afa34e8b528b83aa19b4142984f8095	createTable tableName=pulse; createIndex indexName=idx_pulse_creator_id, tableName=pulse; createTable tableName=pulse_card; createIndex indexName=idx_pulse_card_pulse_id, tableName=pulse_card; createIndex indexName=idx_pulse_card_card_id, tableNam...		\N	3.6.3	\N	\N	0255974901
48	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:45.279523	47	EXECUTED	8:720ce9d4b9e6f0917aea035e9dc5d95d	createTable tableName=collection_revision		\N	3.6.3	\N	\N	0255974901
160	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.886407	156	MARK_RAN	8:1441c71af662abb809cba3b3b360ce81	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
383	camsaul	migrations/000_migrations.yaml	2021-12-23 10:40:00.808028	308	EXECUTED	8:eacd3281e0397c61047e4a69e725a5ec	createIndex indexName=idx_query_execution_card_id_started_at, tableName=query_execution	Added 0.41.3 -- Add index to QueryExecution card_id + started_at to fix performance issue	\N	3.6.3	\N	\N	0255974901
139	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:52.427044	135	MARK_RAN	8:fdad4ec86aefb0cdf850b1929b618508	sql	Added 0.34.2	\N	3.6.3	\N	\N	0255974901
295	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:59.658889	288	EXECUTED	8:501e85a50912649416ec22b2871af087	createIndex indexName=idx_timestamp, tableName=login_history	Added 0.39.0	\N	3.6.3	\N	\N	0255974901
296	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:59.74787	289	EXECUTED	8:f9eb8b15c2c889334f3848a6bb4ebdb4	createIndex indexName=idx_user_id_device_id, tableName=login_history	Added 0.39.0	\N	3.6.3	\N	\N	0255974901
297	camsaul	migrations/000_migrations.yaml	2021-12-23 10:39:59.844308	290	EXECUTED	8:06c180e4c8361f7550f6f4deaf9fc855	createIndex indexName=idx_user_id_timestamp, tableName=login_history	Added 0.39.0	\N	3.6.3	\N	\N	0255974901
298	tsmacdonald	migrations/000_migrations.yaml	2021-12-23 10:39:59.892693	291	EXECUTED	8:3c73f77d8d939d14320964a35aeaad5e	addColumn tableName=pulse	Added 0.39.0	\N	3.6.3	\N	\N	0255974901
299	tsmacdonald	migrations/000_migrations.yaml	2021-12-23 10:39:59.94189	292	EXECUTED	8:ee3a96e30b07f37240a933e2f0710082	addNotNullConstraint columnName=parameters, tableName=pulse	Added 0.39.0	\N	3.6.3	\N	\N	0255974901
300	dpsutton	migrations/000_migrations.yaml	2021-12-23 10:39:59.988284	293	EXECUTED	8:8b142aea1e3697d8630a4620ae763c4d	renameTable newTableName=collection_permission_graph_revision, oldTableName=collection_revision	Added 0.40.0	\N	3.6.3	\N	\N	0255974901
301	dpsutton	migrations/000_migrations.yaml	2021-12-23 10:40:00.030433	294	EXECUTED	8:aaf1a546a6f5932a157d016f72c02f8a	sql	Added 0.40.0 renaming collection_revision to collection_permission_graph_revision	\N	3.6.3	\N	\N	0255974901
303	tsmacdonald	migrations/000_migrations.yaml	2021-12-23 10:40:00.160324	295	EXECUTED	8:506e174d6656b09ddedf19e97c0d3c3d	createTable tableName=moderation_review	Added 0.40.0	\N	3.6.3	\N	\N	0255974901
304	camsaul	migrations/000_migrations.yaml	2021-12-23 10:40:00.190011	296	EXECUTED	8:35960cd7ee3081be719bfb5267ae1a83	sql	Added 0.40.0 (replaces a data migration dating back to 0.20.0)	\N	3.6.3	\N	\N	0255974901
305	camsaul	migrations/000_migrations.yaml	2021-12-23 10:40:00.213935	297	EXECUTED	8:0a0c65f58b80bf74c149a3854cbeeae4	sql	Added 0.40.0 (replaces a data migration dating back to 0.20.0)	\N	3.6.3	\N	\N	0255974901
308	howonlee	migrations/000_migrations.yaml	2021-12-23 10:40:00.252859	298	EXECUTED	8:4a52c3a0391a0313a062b60a52c0d7de	addColumn tableName=query_execution	Added 0.40.0 Track cache hits in query_execution table	\N	3.6.3	\N	\N	0255974901
309	dpsutton	migrations/000_migrations.yaml	2021-12-23 10:40:00.292551	299	EXECUTED	8:26cc1f3ba949d8ce0d56350caacffbd8	addColumn tableName=collection	Added 0.40.0 - Add type to collections	\N	3.6.3	\N	\N	0255974901
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
\.


--
-- Data for Name: dependency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dependency (id, model, model_id, dependent_on_model, dependent_on_id, created_at) FROM stdin;
\.


--
-- Data for Name: dimension; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dimension (id, field_id, name, type, human_readable_field_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: group_table_access_policy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_table_access_policy (id, group_id, table_id, card_id, attribute_remappings) FROM stdin;
\.


--
-- Data for Name: label; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.label (id, name, slug, icon) FROM stdin;
\.


--
-- Data for Name: login_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.login_history (id, "timestamp", user_id, session_id, device_id, device_description, ip_address) FROM stdin;
1	2021-12-23 10:48:55.513704+00	1	\N	b16204e7-b725-42fc-a589-d46bc639c179	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36	172.19.0.1
3	2021-12-24 00:20:06.841795+00	3	\N	fd3f734f-4bc2-4d8b-9710-b4aa60321c13	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36	172.25.0.7
2	2021-12-24 00:00:14.238313+00	1	\N	b16204e7-b725-42fc-a589-d46bc639c179	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36	172.25.0.7
4	2021-12-24 03:59:32.133297+00	1	\N	b16204e7-b725-42fc-a589-d46bc639c179	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36	172.27.0.7
5	2021-12-24 04:00:03.12554+00	3	9e8a11f4-7f5b-4ace-bf32-ab9a7678044a	b16204e7-b725-42fc-a589-d46bc639c179	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36	172.27.0.7
6	2021-12-24 04:00:36.385233+00	1	5273cd13-50be-42d5-9879-0ef9978d93a4	b16204e7-b725-42fc-a589-d46bc639c179	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36	172.27.0.7
7	2021-12-24 04:01:10.073504+00	1	\N	b16204e7-b725-42fc-a589-d46bc639c179	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36	172.27.0.7
9	2021-12-24 04:04:14.057532+00	4	2028f564-145c-4a04-b885-e67a2fc1f3e4	b16204e7-b725-42fc-a589-d46bc639c179	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36	172.27.0.7
8	2021-12-24 04:03:57.450806+00	1	\N	b16204e7-b725-42fc-a589-d46bc639c179	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36	172.27.0.7
10	2021-12-24 04:04:50.740181+00	4	7b7e3b07-6e6c-46a8-8448-a28571dbe44a	b16204e7-b725-42fc-a589-d46bc639c179	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36	172.27.0.7
11	2021-12-24 04:05:15.141336+00	1	\N	b16204e7-b725-42fc-a589-d46bc639c179	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36	172.27.0.7
12	2021-12-24 04:06:44.315691+00	4	da83704a-93d0-46c1-b6fb-7ff3e5dc61af	b16204e7-b725-42fc-a589-d46bc639c179	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36	172.27.0.7
13	2021-12-24 14:40:33.780277+00	1	b9fe34b0-d360-4ed8-8653-15b1ee612025	fd3f734f-4bc2-4d8b-9710-b4aa60321c13	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36	172.27.0.7
\.


--
-- Data for Name: metabase_database; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.metabase_database (id, created_at, updated_at, name, description, details, engine, is_sample, is_full_sync, points_of_interest, caveats, metadata_sync_schedule, cache_field_values_schedule, timezone, is_on_demand, options, auto_run_queries, refingerprint, cache_ttl) FROM stdin;
2	2021-12-23 10:42:32.809842+00	2021-12-23 10:48:34.31186+00	CoPED Development	\N	{"host":"coped_postgres","port":5432,"dbname":"coped_development","user":"postgres","password":"password","ssl":false,"additional-options":null,"tunnel-enabled":false}	postgres	f	t	\N	\N	0 46 * * * ? *	0 0 18 * * ? *	UTC	f	\N	t	\N	\N
\.


--
-- Data for Name: metabase_field; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.metabase_field (id, created_at, updated_at, name, base_type, semantic_type, active, description, preview_display, "position", table_id, parent_id, display_name, visibility_type, fk_target_field_id, last_analyzed, points_of_interest, caveats, fingerprint, fingerprint_version, database_type, has_field_values, settings, database_position, custom_position, effective_type, coercion_strategy) FROM stdin;
146	2021-12-23 10:42:36.718883+00	2021-12-23 11:02:15.538364+00	label	type/Text	type/Category	t	\N	t	2	38	\N	Label	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":4422,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":13.990504182681438}}}	5	varchar	search	\N	2	0	type/Text	\N
78	2021-12-23 10:42:35.008508+00	2021-12-23 10:42:35.008508+00	id	type/BigInteger	type/PK	t	\N	t	0	37	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
83	2021-12-23 10:42:35.192691+00	2021-12-23 10:42:35.192691+00	id	type/BigInteger	type/PK	t	\N	t	0	5	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
85	2021-12-23 10:42:35.243278+00	2021-12-23 10:42:35.243278+00	id	type/BigInteger	type/PK	t	\N	t	0	33	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
88	2021-12-23 10:42:35.310226+00	2021-12-23 10:42:35.310226+00	id	type/BigInteger	type/PK	t	\N	t	0	21	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
94	2021-12-23 10:42:35.455154+00	2021-12-23 10:42:35.455154+00	id	type/BigInteger	type/PK	t	\N	t	0	10	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
140	2021-12-23 10:42:36.567232+00	2021-12-23 10:42:36.567232+00	id	type/BigInteger	type/PK	t	\N	t	0	19	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
144	2021-12-23 10:42:36.673169+00	2021-12-23 10:42:36.673169+00	id	type/BigInteger	type/PK	t	\N	t	0	6	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
145	2021-12-23 10:42:36.692118+00	2021-12-23 10:42:36.692118+00	json	type/Structured	type/SerializedJSON	t	\N	t	3	6	\N	Json	normal	\N	\N	\N	\N	\N	0	jsonb	\N	\N	3	0	type/Structured	\N
148	2021-12-23 10:42:36.756582+00	2021-12-23 10:42:36.756582+00	id	type/BigInteger	type/PK	t	\N	t	0	38	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
150	2021-12-23 10:42:36.802191+00	2021-12-23 10:42:36.802191+00	id	type/BigInteger	type/PK	t	\N	t	0	36	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
151	2021-12-23 10:42:36.829785+00	2021-12-23 10:42:36.829785+00	f_table_catalog	type/*	\N	t	\N	t	0	27	\N	F Table Catalog	normal	\N	\N	\N	\N	\N	0	name	\N	\N	0	0	type/*	\N
152	2021-12-23 10:42:36.848781+00	2021-12-23 10:42:36.848781+00	coord_dimension	type/Integer	\N	t	\N	t	4	27	\N	Coord Dimension	normal	\N	\N	\N	\N	\N	0	int4	\N	\N	4	0	type/Integer	\N
153	2021-12-23 10:42:36.868918+00	2021-12-23 10:42:36.868918+00	srid	type/Integer	\N	t	\N	t	5	27	\N	Srid	normal	\N	\N	\N	\N	\N	0	int4	\N	\N	5	0	type/Integer	\N
154	2021-12-23 10:42:36.888541+00	2021-12-23 10:42:36.888541+00	f_geography_column	type/*	\N	t	\N	t	3	27	\N	F Geography Column	normal	\N	\N	\N	\N	\N	0	name	\N	\N	3	0	type/*	\N
155	2021-12-23 10:42:36.91035+00	2021-12-23 10:42:36.91035+00	f_table_name	type/*	\N	t	\N	t	2	27	\N	F Table Name	normal	\N	\N	\N	\N	\N	0	name	\N	\N	2	0	type/*	\N
156	2021-12-23 10:42:36.931344+00	2021-12-23 10:42:36.931344+00	f_table_schema	type/*	\N	t	\N	t	1	27	\N	F Table Schema	normal	\N	\N	\N	\N	\N	0	name	\N	\N	1	0	type/*	\N
157	2021-12-23 10:42:36.951122+00	2021-12-23 10:42:36.951122+00	type	type/Text	\N	t	\N	t	6	27	\N	Type	normal	\N	\N	\N	\N	\N	0	text	\N	\N	6	0	type/Text	\N
158	2021-12-23 10:42:36.987006+00	2021-12-23 10:42:36.987006+00	f_geometry_column	type/*	\N	t	\N	t	3	32	\N	F Geometry Column	normal	\N	\N	\N	\N	\N	0	name	\N	\N	3	0	type/*	\N
159	2021-12-23 10:42:37.005142+00	2021-12-23 10:42:37.005142+00	coord_dimension	type/Integer	\N	t	\N	t	4	32	\N	Coord Dimension	normal	\N	\N	\N	\N	\N	0	int4	\N	\N	4	0	type/Integer	\N
80	2021-12-23 10:42:35.134686+00	2021-12-23 10:42:40.303334+00	coped_id	type/UUID	\N	t	\N	t	1	5	\N	Coped ID	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":3155,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":36.0}}}	5	uuid	\N	\N	1	0	type/UUID	\N
89	2021-12-23 10:42:35.328378+00	2021-12-23 10:42:40.483446+00	organisation_id	type/BigInteger	type/FK	t	\N	t	1	21	\N	Organisation ID	normal	83	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":3155,"nil%":0.0}}	5	int8	\N	\N	1	0	type/BigInteger	\N
99	2021-12-23 10:42:35.590066+00	2021-12-23 10:42:35.590066+00	id	type/BigInteger	type/PK	t	\N	t	0	30	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
105	2021-12-23 10:42:35.726207+00	2021-12-23 10:42:35.726207+00	id	type/BigInteger	type/PK	t	\N	t	0	12	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
108	2021-12-23 10:42:35.792786+00	2021-12-23 10:42:35.792786+00	id	type/BigInteger	type/PK	t	\N	t	0	7	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
116	2021-12-23 10:42:35.965495+00	2021-12-23 10:42:35.965495+00	id	type/BigInteger	type/PK	t	\N	t	0	28	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
119	2021-12-23 10:42:36.040701+00	2021-12-23 10:42:36.040701+00	id	type/BigInteger	type/PK	t	\N	t	0	9	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
127	2021-12-23 10:42:36.250622+00	2021-12-23 10:42:36.250622+00	id	type/BigInteger	type/PK	t	\N	t	0	11	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
133	2021-12-23 10:42:36.375187+00	2021-12-23 10:42:36.375187+00	id	type/BigInteger	type/PK	t	\N	t	0	8	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
123	2021-12-23 10:42:36.127662+00	2021-12-23 10:42:44.877048+00	start_date	type/Date	type/CreationDate	t	\N	t	2	9	\N	Start Date	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":439,"nil%":0.0},"type":{"type/DateTime":{"earliest":"1999-02-01","latest":"2021-11-01"}}}	5	date	\N	\N	2	0	type/Date	\N
103	2021-12-23 10:42:35.686378+00	2021-12-23 10:42:40.958592+00	person_id	type/BigInteger	type/FK	t	\N	t	3	12	\N	Person ID	normal	94	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":3131,"nil%":0.0}}	5	int8	\N	\N	3	0	type/BigInteger	\N
136	2021-12-23 10:42:36.439816+00	2021-12-23 10:42:36.439816+00	id	type/BigInteger	type/PK	t	\N	t	0	18	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
42	2021-12-23 10:42:34.211395+00	2021-12-23 10:42:34.211395+00	id	type/Integer	type/PK	t	\N	t	0	34	\N	ID	normal	\N	\N	\N	\N	\N	0	serial	\N	\N	0	0	type/Integer	\N
49	2021-12-23 10:42:34.329469+00	2021-12-23 10:42:34.329469+00	group_id	type/Integer	\N	t	\N	t	2	23	\N	Group ID	normal	\N	\N	\N	\N	\N	0	int4	\N	\N	2	0	type/Integer	\N
50	2021-12-23 10:42:34.349427+00	2021-12-23 10:42:34.349427+00	id	type/BigInteger	type/PK	t	\N	t	0	23	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
52	2021-12-23 10:42:34.399009+00	2021-12-23 10:42:34.399009+00	id	type/BigInteger	type/PK	t	\N	t	0	26	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
53	2021-12-23 10:42:34.422884+00	2021-12-23 10:42:34.422884+00	permission_id	type/Integer	\N	t	\N	t	2	26	\N	Permission ID	normal	\N	\N	\N	\N	\N	0	int4	\N	\N	2	0	type/Integer	\N
61	2021-12-23 10:42:34.596049+00	2021-12-23 10:42:34.596049+00	id	type/BigInteger	type/PK	t	\N	t	0	17	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
69	2021-12-23 10:42:34.793353+00	2021-12-23 10:42:34.793353+00	id	type/BigInteger	type/PK	t	\N	t	0	22	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
72	2021-12-23 10:42:34.871503+00	2021-12-23 10:42:34.871503+00	id	type/BigInteger	type/PK	t	\N	t	0	35	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
74	2021-12-23 10:42:34.920793+00	2021-12-23 10:42:34.920793+00	id	type/BigInteger	type/PK	t	\N	t	0	31	\N	ID	normal	\N	\N	\N	\N	\N	0	bigserial	\N	\N	0	0	type/BigInteger	\N
54	2021-12-23 10:42:34.443334+00	2021-12-23 10:42:37.199001+00	user_id	type/Integer	type/FK	t	\N	t	1	26	\N	User ID	normal	42	\N	\N	\N	\N	0	int4	\N	\N	1	0	type/Integer	\N
70	2021-12-23 10:42:34.813355+00	2021-12-23 10:42:44.486949+00	link	type/Text	type/URL	t	\N	f	1	22	\N	Link	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":9999,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":1.0,"percent-email":0.0,"percent-state":0.0,"average-length":51.4074}}}	5	varchar	\N	\N	1	0	type/Text	\N
55	2021-12-23 10:42:34.489614+00	2021-12-23 10:42:38.990821+00	county	type/Text	\N	t	\N	t	7	17	\N	County	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":164,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":3.918495297805643E-4,"average-length":1.5991379310344827}}}	5	varchar	\N	\N	7	0	type/Text	\N
58	2021-12-23 10:42:34.534961+00	2021-12-23 10:42:39.050889+00	geo_id	type/BigInteger	type/FK	t	\N	t	12	17	\N	Geo ID	normal	72	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":1616,"nil%":0.0}}	5	int8	\N	\N	12	0	type/BigInteger	\N
160	2021-12-23 10:42:37.024423+00	2021-12-23 10:42:37.024423+00	srid	type/Integer	\N	t	\N	t	5	32	\N	Srid	normal	\N	\N	\N	\N	\N	0	int4	\N	\N	5	0	type/Integer	\N
161	2021-12-23 10:42:37.044103+00	2021-12-23 10:42:37.044103+00	type	type/Text	\N	t	\N	t	6	32	\N	Type	normal	\N	\N	\N	\N	\N	0	varchar	\N	\N	6	0	type/Text	\N
162	2021-12-23 10:42:37.064091+00	2021-12-23 10:42:37.064091+00	f_table_name	type/*	\N	t	\N	t	2	32	\N	F Table Name	normal	\N	\N	\N	\N	\N	0	name	\N	\N	2	0	type/*	\N
163	2021-12-23 10:42:37.08407+00	2021-12-23 10:42:37.08407+00	f_table_catalog	type/Text	\N	t	\N	t	0	32	\N	F Table Catalog	normal	\N	\N	\N	\N	\N	0	varchar	\N	\N	0	0	type/Text	\N
164	2021-12-23 10:42:37.104433+00	2021-12-23 10:42:37.104433+00	f_table_schema	type/*	\N	t	\N	t	1	32	\N	F Table Schema	normal	\N	\N	\N	\N	\N	0	name	\N	\N	1	0	type/*	\N
51	2021-12-23 10:42:34.368532+00	2021-12-23 10:42:37.165699+00	user_id	type/Integer	type/FK	t	\N	t	1	23	\N	User ID	normal	42	\N	\N	\N	\N	0	int4	\N	\N	1	0	type/Integer	\N
76	2021-12-23 10:42:34.966869+00	2021-12-23 10:42:40.119744+00	project_id	type/BigInteger	type/FK	t	\N	t	3	37	\N	Project ID	normal	108	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":60,"nil%":0.0}}	5	int8	\N	\N	3	0	type/BigInteger	\N
84	2021-12-23 10:42:35.21228+00	2021-12-23 10:42:40.378722+00	raw_data_id	type/BigInteger	type/FK	t	\N	t	4	5	\N	Raw Data ID	normal	144	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":3155,"nil%":0.0}}	5	int8	\N	\N	4	0	type/BigInteger	\N
97	2021-12-23 10:42:35.518917+00	2021-12-23 10:42:40.759537+00	raw_data_id	type/BigInteger	type/FK	t	\N	t	7	10	\N	Raw Data ID	normal	144	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":3262,"nil%":0.0}}	5	int8	\N	\N	7	0	type/BigInteger	\N
115	2021-12-23 10:42:35.94559+00	2021-12-23 10:42:41.619546+00	project_id	type/BigInteger	type/FK	t	\N	t	1	28	\N	Project ID	normal	108	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":2034,"nil%":0.0}}	5	int8	\N	\N	1	0	type/BigInteger	\N
39	2021-12-23 10:42:34.153872+00	2021-12-23 10:42:44.257672+00	password	type/Text	type/Category	t	\N	t	1	34	\N	Password	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":2,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":88.0}}}	5	varchar	auto-list	\N	1	0	type/Text	\N
91	2021-12-23 10:42:35.394871+00	2021-12-23 10:42:44.618082+00	first_name	type/Text	type/Name	t	\N	t	3	10	\N	First Name	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":1410,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":9.196811771919068E-4,"average-length":6.017473942366646}}}	5	varchar	\N	\N	3	0	type/Text	\N
121	2021-12-23 10:42:36.083327+00	2021-12-23 10:42:44.855472+00	currency	type/Text	type/Category	t	\N	t	5	9	\N	Currency	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":3.0}}}	5	varchar	auto-list	\N	5	0	type/Text	\N
79	2021-12-23 10:42:35.08002+00	2021-12-23 10:42:40.100009+00	link_id	type/BigInteger	type/FK	t	\N	t	2	37	\N	Link ID	normal	108	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":60,"nil%":0.0}}	5	int8	\N	\N	2	0	type/BigInteger	\N
138	2021-12-23 10:42:36.494994+00	2021-12-23 10:42:44.979874+00	score	type/Decimal	type/Score	t	\N	t	1	19	\N	Score	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":9289,"nil%":0.0},"type":{"type/Number":{"min":0.001269582659,"q1":0.05346390035327949,"q3":0.1473711611995744,"max":0.79920732975,"sd":0.10399124681528962,"avg":0.11944947726330857}}}	5	numeric	\N	\N	1	0	type/Decimal	\N
132	2021-12-23 10:42:36.355965+00	2021-12-23 10:42:42.058152+00	organisation_id	type/BigInteger	type/FK	t	\N	t	2	8	\N	Organisation ID	normal	83	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":3089,"nil%":0.0}}	5	int8	\N	\N	2	0	type/BigInteger	\N
142	2021-12-23 10:42:36.632731+00	2021-12-23 10:42:45.003665+00	bot	type/Text	type/Category	t	\N	t	1	6	\N	Bot	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":20.0}}}	5	varchar	auto-list	\N	1	0	type/Text	\N
143	2021-12-23 10:42:36.653331+00	2021-12-23 10:42:45.025258+00	url	type/Text	type/URL	t	\N	t	2	6	\N	URL	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":10000,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":1.0,"percent-email":0.0,"percent-state":0.0,"average-length":78.619}}}	5	varchar	\N	\N	2	0	type/Text	\N
75	2021-12-23 10:42:34.940262+00	2021-12-23 10:42:40.028981+00	text	type/Text	\N	t	\N	t	1	31	\N	Text	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":9997,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":1.0E-4,"average-length":20.9234}}}	5	varchar	\N	\N	1	0	type/Text	\N
98	2021-12-23 10:42:35.539318+00	2021-12-23 10:42:40.739599+00	orcid_id	type/Text	\N	t	\N	t	6	10	\N	Orcid ID	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":695,"nil%":0.7872470876762722},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":4.042305334150828}}}	5	varchar	\N	\N	6	0	type/Text	\N
104	2021-12-23 10:42:35.706402+00	2021-12-23 10:42:40.97714+00	organisation_id	type/BigInteger	type/FK	t	\N	t	2	12	\N	Organisation ID	normal	83	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":617,"nil%":0.0}}	5	int8	\N	\N	2	0	type/BigInteger	\N
112	2021-12-23 10:42:35.871143+00	2021-12-23 10:42:41.521705+00	raw_data_id	type/BigInteger	type/FK	t	\N	t	5	7	\N	Raw Data ID	normal	144	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":2034,"nil%":0.0}}	5	int8	\N	\N	5	0	type/BigInteger	\N
122	2021-12-23 10:42:36.105448+00	2021-12-23 10:42:41.7373+00	amount	type/Decimal	\N	t	\N	t	1	9	\N	Amount	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":1602,"nil%":0.0},"type":{"type/Number":{"min":0.0,"q1":45323.41628859482,"q3":508213.7055048734,"max":1.29118513E8,"sd":3217714.063957214,"avg":659756.5204332841}}}	5	numeric	\N	\N	1	0	type/Decimal	\N
124	2021-12-23 10:42:36.150044+00	2021-12-23 10:42:41.777238+00	raw_data_id	type/BigInteger	type/FK	t	\N	t	7	9	\N	Raw Data ID	normal	144	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":2030,"nil%":9.847365829640572E-4}}	5	int8	\N	\N	7	0	type/BigInteger	\N
125	2021-12-23 10:42:36.173024+00	2021-12-23 10:42:41.797045+00	organisation_id	type/BigInteger	type/FK	t	\N	t	6	9	\N	Organisation ID	normal	83	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":12,"nil%":0.0}}	5	int8	\N	\N	6	0	type/BigInteger	\N
139	2021-12-23 10:42:36.514268+00	2021-12-23 10:42:42.389906+00	project_id	type/BigInteger	type/FK	t	\N	t	2	19	\N	Project ID	normal	108	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":502,"nil%":0.0}}	5	int8	\N	\N	2	0	type/BigInteger	\N
86	2021-12-23 10:42:35.263458+00	2021-12-23 10:42:40.418737+00	organisation_id	type/BigInteger	type/FK	t	\N	t	1	33	\N	Organisation ID	normal	83	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":2618,"nil%":0.0}}	5	int8	\N	\N	1	0	type/BigInteger	\N
87	2021-12-23 10:42:35.283023+00	2021-12-23 10:42:40.43974+00	address_id	type/BigInteger	type/FK	t	\N	t	2	33	\N	Address ID	normal	61	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":2552,"nil%":0.0}}	5	int8	\N	\N	2	0	type/BigInteger	\N
106	2021-12-23 10:42:35.754282+00	2021-12-23 10:42:41.420115+00	coped_id	type/UUID	\N	t	\N	t	1	7	\N	Coped ID	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":2034,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":36.0}}}	5	uuid	\N	\N	1	0	type/UUID	\N
111	2021-12-23 10:42:35.852033+00	2021-12-23 10:42:41.502171+00	end	type/Date	\N	t	\N	t	6	7	\N	End	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":4,"nil%":0.9985250737463127},"type":{"type/DateTime":{"earliest":"2021-04-02","latest":"2021-10-28"}}}	5	date	\N	\N	6	0	type/Date	\N
117	2021-12-23 10:42:35.985235+00	2021-12-23 10:42:41.607568+00	externallink_id	type/BigInteger	type/FK	t	\N	t	2	28	\N	Externallink ID	normal	69	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":2034,"nil%":0.0}}	5	int8	\N	\N	2	0	type/BigInteger	\N
120	2021-12-23 10:42:36.062033+00	2021-12-23 10:42:41.698061+00	project_id	type/BigInteger	type/FK	t	\N	t	4	9	\N	Project ID	normal	108	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":2029,"nil%":0.0}}	5	int8	\N	\N	4	0	type/BigInteger	\N
126	2021-12-23 10:42:36.230197+00	2021-12-23 10:42:41.905361+00	project_id	type/BigInteger	type/FK	t	\N	t	3	11	\N	Project ID	normal	108	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":532,"nil%":0.0}}	5	int8	\N	\N	3	0	type/BigInteger	\N
128	2021-12-23 10:42:36.270081+00	2021-12-23 10:42:41.92478+00	keyword_id	type/BigInteger	type/FK	t	\N	t	2	11	\N	Keyword ID	normal	74	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":8751,"nil%":0.0}}	5	int8	\N	\N	2	0	type/BigInteger	\N
131	2021-12-23 10:42:36.336213+00	2021-12-23 10:42:44.928162+00	role	type/Text	type/Category	t	\N	t	1	8	\N	Role	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":7,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":9.487073560767591}}}	5	varchar	auto-list	\N	1	0	type/Text	\N
130	2021-12-23 10:42:36.3169+00	2021-12-23 10:42:42.077678+00	project_id	type/BigInteger	type/FK	t	\N	t	3	8	\N	Project ID	normal	108	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":2000,"nil%":0.0}}	5	int8	\N	\N	3	0	type/BigInteger	\N
135	2021-12-23 10:42:36.419986+00	2021-12-23 10:42:44.952464+00	role	type/Text	type/Category	t	\N	t	1	18	\N	Role	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":9,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":7.446153846153846}}}	5	varchar	auto-list	\N	1	0	type/Text	\N
134	2021-12-23 10:42:36.400149+00	2021-12-23 10:42:42.217801+00	project_id	type/BigInteger	type/FK	t	\N	t	3	18	\N	Project ID	normal	108	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":1883,"nil%":0.0}}	5	int8	\N	\N	3	0	type/BigInteger	\N
102	2021-12-23 10:42:35.66602+00	2021-12-23 10:42:44.689773+00	role	type/Text	type/Category	t	\N	t	1	12	\N	Role	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":8.0}}}	5	varchar	auto-list	\N	1	0	type/Text	\N
100	2021-12-23 10:42:35.610848+00	2021-12-23 10:42:40.818837+00	externallink_id	type/BigInteger	type/FK	t	\N	t	2	30	\N	Externallink ID	normal	69	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":3262,"nil%":0.0}}	5	int8	\N	\N	2	0	type/BigInteger	\N
101	2021-12-23 10:42:35.630973+00	2021-12-23 10:42:40.839063+00	person_id	type/BigInteger	type/FK	t	\N	t	1	30	\N	Person ID	normal	94	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":3262,"nil%":0.0}}	5	int8	\N	\N	1	0	type/BigInteger	\N
118	2021-12-23 10:42:36.020117+00	2021-12-23 10:42:41.67915+00	end_date	type/Date	\N	t	\N	t	3	9	\N	End Date	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":504,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2007-05-30","latest":"2028-03-30"}}}	5	date	\N	\N	3	0	type/Date	\N
129	2021-12-23 10:42:36.290134+00	2021-12-23 10:42:44.904188+00	score	type/Float	type/Score	t	\N	t	1	11	\N	Score	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":9812,"nil%":0.0},"type":{"type/Number":{"min":0.004352848320064665,"q1":0.013668447814553626,"q3":0.030924350318211873,"max":0.5272647919576312,"sd":0.018511399557045626,"avg":0.025359297696684397}}}	5	float8	\N	\N	1	0	type/Float	\N
56	2021-12-23 10:42:34.510388+00	2021-12-23 10:42:39.011998+00	line2	type/Text	\N	t	\N	t	8	17	\N	Line2	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":961,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":3.918495297805643E-4,"average-length":6.190438871473354}}}	5	varchar	\N	\N	8	0	type/Text	\N
57	2021-12-23 10:42:34.531345+00	2021-12-23 10:42:39.031726+00	coped_id	type/UUID	\N	t	\N	t	1	17	\N	Coped ID	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":2552,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":36.0}}}	5	uuid	\N	\N	1	0	type/UUID	\N
59	2021-12-23 10:42:34.554875+00	2021-12-23 10:42:39.07074+00	line1	type/Text	\N	t	\N	t	6	17	\N	Line1	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":2445,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":23.604623824451412}}}	5	varchar	\N	\N	6	0	type/Text	\N
71	2021-12-23 10:42:34.842109+00	2021-12-23 10:42:44.508886+00	lat	type/Float	type/Latitude	t	\N	t	1	35	\N	Lat	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":1612,"nil%":0.0},"type":{"type/Number":{"min":-36.8927049,"q1":51.475573928530174,"q3":53.22943086720539,"max":59.041694,"sd":3.5081851197939296,"avg":52.22022573351794}}}	5	float8	\N	\N	1	0	type/Float	\N
73	2021-12-23 10:42:34.891058+00	2021-12-23 10:42:44.528155+00	lon	type/Float	type/Longitude	t	\N	t	2	35	\N	Lon	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":1611,"nil%":0.0},"type":{"type/Number":{"min":-101.8920203,"q1":-2.2763528222659066,"q3":-0.20437942885208174,"max":144.8013711,"sd":10.716894183348401,"avg":-1.0171349895833446}}}	5	float8	\N	\N	2	0	type/Float	\N
41	2021-12-23 10:42:34.192476+00	2021-12-23 10:42:44.216176+00	is_active	type/Boolean	type/Category	t	\N	t	8	34	\N	Is Active	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0}}	5	bool	auto-list	\N	8	0	type/Boolean	\N
68	2021-12-23 10:42:34.773336+00	2021-12-23 10:42:44.466198+00	description	type/Text	type/Description	t	\N	t	2	22	\N	Description	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":5,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":19.2471}}}	5	varchar	auto-list	\N	2	0	type/Text	\N
37	2021-12-23 10:42:34.120438+00	2021-12-23 10:42:38.276434+00	last_login	type/DateTimeWithLocalTZ	\N	t	\N	t	2	34	\N	Last Login	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":2,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2021-12-03T10:57:07.126529Z","latest":"2021-12-05T22:46:19.195495Z"}}}	5	timestamptz	\N	\N	2	0	type/DateTimeWithLocalTZ	\N
63	2021-12-23 10:42:34.646862+00	2021-12-23 10:42:39.131885+00	line5	type/Text	\N	t	\N	t	11	17	\N	Line5	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":161,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.006269592476489028,"average-length":1.0474137931034482}}}	5	varchar	\N	\N	11	0	type/Text	\N
64	2021-12-23 10:42:34.670643+00	2021-12-23 10:42:39.15214+00	postcode	type/Text	\N	t	\N	t	4	17	\N	Postcode	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":1890,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":6.30564263322884}}}	5	varchar	\N	\N	4	0	type/Text	\N
65	2021-12-23 10:42:34.69385+00	2021-12-23 10:42:39.172608+00	line3	type/Text	\N	t	\N	t	9	17	\N	Line3	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":348,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":7.836990595611285E-4,"average-length":1.9886363636363635}}}	5	varchar	\N	\N	9	0	type/Text	\N
67	2021-12-23 10:42:34.736535+00	2021-12-23 10:42:39.218019+00	line4	type/Text	\N	t	\N	t	10	17	\N	Line4	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":296,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.002351097178683386,"average-length":1.5552507836990597}}}	5	varchar	\N	\N	10	0	type/Text	\N
90	2021-12-23 10:42:35.364342+00	2021-12-23 10:42:40.502776+00	externallink_id	type/BigInteger	type/FK	t	\N	t	2	21	\N	Externallink ID	normal	69	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":3156,"nil%":0.0}}	5	int8	\N	\N	2	0	type/BigInteger	\N
92	2021-12-23 10:42:35.414697+00	2021-12-23 10:42:40.658447+00	coped_id	type/UUID	\N	t	\N	t	1	10	\N	Coped ID	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":3262,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":36.0}}}	5	uuid	\N	\N	1	0	type/UUID	\N
95	2021-12-23 10:42:35.47624+00	2021-12-23 10:42:40.697658+00	other_name	type/Text	\N	t	\N	t	4	10	\N	Other Name	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":399,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":1.6060698957694666}}}	5	varchar	\N	\N	4	0	type/Text	\N
137	2021-12-23 10:42:36.460063+00	2021-12-23 10:42:42.257502+00	person_id	type/BigInteger	type/FK	t	\N	t	2	18	\N	Person ID	normal	94	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":3262,"nil%":0.0}}	5	int8	\N	\N	2	0	type/BigInteger	\N
38	2021-12-23 10:42:34.134089+00	2021-12-23 10:42:44.237123+00	email	type/Text	type/Email	t	\N	t	6	34	\N	Email	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":2,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":1.0,"percent-state":0.0,"average-length":19.5}}}	5	varchar	auto-list	\N	6	0	type/Text	\N
40	2021-12-23 10:42:34.172801+00	2021-12-23 10:42:44.27931+00	first_name	type/Text	type/Name	t	\N	t	4	34	\N	First Name	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":0.0}}}	5	varchar	auto-list	\N	4	0	type/Text	\N
43	2021-12-23 10:42:34.230488+00	2021-12-23 10:42:44.287703+00	username	type/Text	type/Category	t	\N	t	11	34	\N	Username	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":2,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":5.5}}}	5	varchar	auto-list	\N	11	0	type/Text	\N
44	2021-12-23 10:42:34.249583+00	2021-12-23 10:42:44.307369+00	date_joined	type/DateTimeWithLocalTZ	type/JoinTimestamp	t	\N	t	9	34	\N	Date Joined	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":2,"nil%":0.0},"type":{"type/DateTime":{"earliest":"2021-11-16T09:40:49.335093Z","latest":"2021-12-02T11:21:39.077463Z"}}}	5	timestamptz	\N	\N	9	0	type/DateTimeWithLocalTZ	\N
45	2021-12-23 10:42:34.267538+00	2021-12-23 10:42:44.324656+00	coped_id	type/UUID	type/Category	t	\N	t	10	34	\N	Coped ID	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":2,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":36.0}}}	5	uuid	auto-list	\N	10	0	type/UUID	\N
46	2021-12-23 10:42:34.27251+00	2021-12-23 10:42:44.340474+00	is_superuser	type/Boolean	type/Category	t	\N	t	3	34	\N	Is Superuser	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":2,"nil%":0.0}}	5	bool	auto-list	\N	3	0	type/Boolean	\N
47	2021-12-23 10:42:34.27811+00	2021-12-23 10:42:44.360974+00	last_name	type/Text	type/Name	t	\N	t	5	34	\N	Last Name	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":1,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":0.0}}}	5	varchar	auto-list	\N	5	0	type/Text	\N
48	2021-12-23 10:42:34.28235+00	2021-12-23 10:42:44.381354+00	is_staff	type/Boolean	type/Category	t	\N	t	7	34	\N	Is Staff	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":2,"nil%":0.0}}	5	bool	auto-list	\N	7	0	type/Boolean	\N
60	2021-12-23 10:42:34.575374+00	2021-12-23 10:42:44.404849+00	country	type/Text	type/Country	t	\N	t	3	17	\N	Country	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":45,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":4.828369905956113}}}	5	varchar	auto-list	\N	3	0	type/Text	\N
62	2021-12-23 10:42:34.618516+00	2021-12-23 10:42:44.424345+00	region	type/Text	type/Category	t	\N	t	5	17	\N	Region	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":14,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":9.772335423197493}}}	5	varchar	auto-list	\N	5	0	type/Text	\N
66	2021-12-23 10:42:34.715962+00	2021-12-23 10:42:44.445122+00	city	type/Text	type/City	t	\N	t	2	17	\N	City	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":458,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":2.915752351097179}}}	5	varchar	\N	\N	2	0	type/Text	\N
77	2021-12-23 10:42:34.988059+00	2021-12-23 10:42:44.551493+00	relation	type/Text	type/Category	t	\N	t	1	37	\N	Relation	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":4,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":11.614285714285714}}}	5	varchar	auto-list	\N	1	0	type/Text	\N
81	2021-12-23 10:42:35.154098+00	2021-12-23 10:42:44.573306+00	about	type/Text	\N	t	\N	t	3	5	\N	About	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":80,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":0.9014263074484945}}}	5	text	auto-list	\N	3	0	type/Text	\N
82	2021-12-23 10:42:35.172843+00	2021-12-23 10:42:44.594142+00	name	type/Text	type/Name	t	\N	t	2	5	\N	Name	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":3101,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":23.089698890649764}}}	5	varchar	\N	\N	2	0	type/Text	\N
93	2021-12-23 10:42:35.435465+00	2021-12-23 10:42:44.640487+00	email	type/Text	\N	t	\N	t	2	10	\N	Email	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":1,"nil%":1.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":0.0}}}	5	varchar	auto-list	\N	2	0	type/Text	\N
141	2021-12-23 10:42:36.586499+00	2021-12-23 10:42:42.409521+00	subject_id	type/BigInteger	type/FK	t	\N	t	3	19	\N	Subject ID	normal	148	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":1790,"nil%":0.0}}	5	int8	\N	\N	3	0	type/BigInteger	\N
147	2021-12-23 10:42:36.737916+00	2021-12-23 10:42:43.914043+00	coped_id	type/UUID	\N	t	\N	t	1	38	\N	Coped ID	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":4422,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":36.0}}}	5	uuid	\N	\N	1	0	type/UUID	\N
149	2021-12-23 10:42:36.776291+00	2021-12-23 10:42:43.935237+00	external_link_id	type/BigInteger	type/FK	t	\N	t	3	38	\N	External Link ID	normal	69	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":4423,"nil%":0.0}}	5	int8	\N	\N	3	0	type/BigInteger	\N
96	2021-12-23 10:42:35.498069+00	2021-12-23 10:42:44.661133+00	last_name	type/Text	type/Name	t	\N	t	5	10	\N	Last Name	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":2513,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.001532801961986511,"average-length":6.706928264868179}}}	5	varchar	\N	\N	5	0	type/Text	\N
107	2021-12-23 10:42:35.77413+00	2021-12-23 10:42:44.718914+00	title	type/Text	type/Title	t	\N	t	2	7	\N	Title	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":1831,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":68.91937069813176}}}	5	varchar	\N	\N	2	0	type/Text	\N
109	2021-12-23 10:42:35.811998+00	2021-12-23 10:42:44.740145+00	description	type/Text	type/Description	t	\N	t	3	7	\N	Description	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":1819,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":1152.9341199606686}}}	5	text	\N	\N	3	0	type/Text	\N
110	2021-12-23 10:42:35.831819+00	2021-12-23 10:42:44.761299+00	status	type/Text	type/Category	t	\N	t	4	7	\N	Status	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":2,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":6.0}}}	5	varchar	auto-list	\N	4	0	type/Text	\N
113	2021-12-23 10:42:35.889114+00	2021-12-23 10:42:44.784014+00	start	type/Date	type/CreationDate	t	\N	t	7	7	\N	Start	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":4,"nil%":0.9985250737463127},"type":{"type/DateTime":{"earliest":"2017-05-01","latest":"2020-10-02"}}}	5	date	\N	\N	7	0	type/Date	\N
114	2021-12-23 10:42:35.909169+00	2021-12-23 10:42:44.829244+00	extra_text	type/Text	\N	t	\N	f	8	7	\N	Extra Text	normal	\N	2021-12-23 10:42:45.758099+00	\N	\N	{"global":{"distinct-count":581,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":375.007866273353}}}	5	text	\N	\N	8	0	type/Text	\N
\.


--
-- Data for Name: metabase_fieldvalues; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.metabase_fieldvalues (id, created_at, updated_at, "values", human_readable_values, field_id) FROM stdin;
6	2021-12-23 10:42:45.823589+00	2021-12-23 10:42:45.823589+00	["pbkdf2_sha256$260000$5nFQvpK8rrbBO9sabnNB9w$T/O5nSknFmuuE7neeGtpsH4GjvnlLIYLa7x1W3OqBDI=","pbkdf2_sha256$260000$XsDz6rh3HvjzJS8VbhEYrm$vBEhfwLlTykjGUBQtoboHuLarZbQhiCGXHrail2wj3w="]	\N	39
7	2021-12-23 10:42:45.853474+00	2021-12-23 10:42:45.853474+00	[true]	\N	41
8	2021-12-23 10:42:45.884613+00	2021-12-23 10:42:45.884613+00	["admin@coped.coventry.ac.uk","colin6@c0l.in"]	\N	38
9	2021-12-23 10:42:45.911812+00	2021-12-23 10:42:45.911812+00	[""]	\N	40
10	2021-12-23 10:42:45.942398+00	2021-12-23 10:42:45.942398+00	["admin","colin6"]	\N	43
11	2021-12-23 10:42:45.955589+00	2021-12-23 10:42:45.955589+00	["ad284af2-e4c3-4289-b464-9444671f0301","e1c70276-451f-402a-a567-62b3c2066d08"]	\N	45
12	2021-12-23 10:42:45.982088+00	2021-12-23 10:42:45.982088+00	[false,true]	\N	46
13	2021-12-23 10:42:46.014507+00	2021-12-23 10:42:46.014507+00	[""]	\N	47
14	2021-12-23 10:42:46.070359+00	2021-12-23 10:42:46.070359+00	[false,true]	\N	48
15	2021-12-23 10:42:46.132643+00	2021-12-23 10:42:46.132643+00	["","Argentina","Australia","Austria","Belgium","Brazil","Canada","China","Czech Republic","Denmark","Finland","France","Germany","Ghana","Hong Kong","Iceland","India","Ireland","Israel","Italy","Japan","Korea, Republic of","Madagascar","Malaysia","Mexico","Montserrat","Netherlands","New Zealand","Norway","Pakistan","Poland","Portugal","Qatar","Saudi Arabia","Singapore","South Africa","Spain","Sweden","Switzerland","Taiwan, Province of China","Thailand","United kingdom","United Kingdom","UNITED KINGDOM","United States"]	\N	60
16	2021-12-23 10:42:46.162547+00	2021-12-23 10:42:46.162547+00	["East Midlands","East of England","London","North East","Northern Ireland","North West","Outside UK","Scotland","South East","South West","Unknown","Wales","West Midlands","Yorkshire and The Humber"]	\N	62
17	2021-12-23 10:42:46.216759+00	2021-12-23 10:42:46.216759+00	["Finto term ontology","Organisation website","UKRI organisation entry","UKRI person entry","UKRI project entry"]	\N	68
18	2021-12-23 10:42:46.247705+00	2021-12-23 10:42:46.247705+00	["STUDENTSHIP","STUDENTSHIP_FROM","TRANSFER","TRANSFER_FROM"]	\N	77
19	2021-12-23 10:42:46.281081+00	2021-12-23 10:42:46.281081+00	["","0058C3CB-BF17-49E7-8231-EF3C4F748714","04E5D059-24C8-4DB1-87EC-0B30241F4806","05923FEC-036B-4EA9-8068-0AD5AE082931","08D74A3A-9B7E-43E9-82D6-B67C15DAFE35","0CEE3590-0453-46F8-84BE-AE273C10883F","0E5B16E0-327D-42B9-89F7-A2CA75EADF96","1203204D-2927-4149-B36B-50506E5B4A47","12664A88-5976-4A80-A410-C6A2E1B0AEBE","194B59B9-9FAC-435B-9CCA-36CA21A159D1","1B794BDD-D765-43FE-A98B-188C0734CFBC","1BA40F6F-B54C-43B3-B760-FF767F0CDB6C","1F78979A-B6FF-49AB-8651-07D4259D7AD1","214390F8-135B-4775-8608-472DB534DD2B","2926BF91-EAA0-4DF9-B7D4-7F6F340EE808","2A33079C-1E49-41B8-995D-C15BA03F035D","30A429E3-83B7-4E41-99C0-14A144F07DFE","323E99F1-F3B7-4329-8946-9E84834A3C07","36D0DB66-DDD4-4C4A-B459-8615A407B44A","3A5E126D-C175-4730-9B7B-E6D8CF447F83","3D3E9F8B-3B76-42BC-9BA0-6BC172233707","3EAE04CA-9D62-4483-B9C4-F91AD9F4C5A9","46387D84-F71E-4B7D-8C7D-9C288F113510","48851736-51ED-4960-A07C-050AFE40C8F7","4FC7A6A0-586F-44B0-9BAE-1B60AC21C472","5249C490-2AFF-4EA9-A558-311CCE014203","56292F36-651B-487F-A273-4AC48706B4FE","5BB4F8BF-B4E0-4EAF-9AF5-885E19D64850","5BFB9036-9D16-4AB9-A9EF-097BB6FBD69A","5DF1460B-3CAF-4266-8105-C69EBCB59E9D","6ACB561B-0F92-447B-92E7-E8B983C1E908","6DC5B36A-ED4C-4283-8601-8F4DEAA0630C","73BA00FA-BAD7-4FE2-B1DE-76B8E83C1869","772A1E12-7175-46C0-B665-CE27930D15A8","77388B7E-90D0-485D-9A0C-23C37178B746","778E07DF-EEA0-4208-BA30-AF5921745246","798CB33D-C79E-4578-83F2-72606407192C","7A0397DD-E0C6-4EA3-8031-B841D2503C4D","7C8177A6-1546-4AA9-8872-410224E7A63A","818CD6C9-61EE-41F2-9F37-0C7A8F43E25D","87791282-4F57-4029-A2EE-176B1CE69143","909C646F-C9A3-42E9-BB1D-579B9B63772D","90C7C7A9-18C9-432D-B812-80417574E5D6","936D002F-A8D1-4A93-AE5D-825ED0903D8D","94739255-BBBD-46E6-9F11-333F0A740BF9","961756BF-E31F-4A13-836F-0A09BA02385C","99DE356A-7D8B-4C73-97C4-A20F3E35D9D5","9C10D78F-6430-4CA7-9528-B96B0762A4C6","9F01BA24-9ACC-4303-9BD3-E4595C9BC61C","A1F6B475-48DF-4649-845E-8A2FACDA2524","A9862E6C-E96E-4077-B117-22C675667715","AA4C7DD1-A45B-4434-8287-423B892D0C4C","AAC08DDE-A268-45C9-B0CC-7A2D564C4A03","AB6523D9-4909-42BC-AF27-600E7C9D6BE2","AFADBBA0-77DF-471E-A102-FAB224095715","B6FB652A-60C3-48DD-9A33-075D1F759B48","B916CBD5-C485-400E-9973-216992E6F5DE","BB12A8E2-9FD6-47D7-ACD3-CDD2D2C5A1BB","BB60D144-E04F-440A-A89C-1722AE1297A5","BD903DB5-1CED-4D34-913B-F41A38F027B6","C99FB228-04C1-4C8F-A5C0-66EB3B718CF2","CAA9A40D-0226-4A4F-AC0D-D8299E30A1EF","CACA848E-DE90-40BA-8B81-77E131BBE24C","CF4992DF-2888-4716-BEEC-8C1AE0C18008","CF8E0E30-8309-4717-A60E-33FD91E87515","D23981F6-2A41-4555-95B8-020177BD2DCD","D446F3B8-D9C3-4B5B-82CA-07608A3C27A9","D59A5463-6F6E-4356-AFCC-1CAF4ECB058B","D5AB48C4-C535-4BC8-8B85-74716FB478AF","DCA80740-9A72-4923-9613-6EEE115E0D96","E4C81782-DEDB-4303-91A8-2C6FD26234C7","E72A7C7F-9DC7-4E1A-BCB1-25218B11EE10","EAAD4D43-BD15-432B-9385-2DBD0C65958D","ECD9820C-EEE0-411E-9735-655EE4010B12","F0D6AD04-B3AC-4A75-AAAF-6FB072E2632D","F45A4578-F962-4EFA-9CC1-9F2FF4F760AE","F5D087B7-3FBA-46C8-914A-3604B763438E","F75CE62B-8A78-4277-97AD-4DFA7BA58016","F7900C60-3A5E-4F22-9DC8-BFF83C561C65","FA4DFCAF-F99C-472A-AAA8-09DFF4571A76"]	\N	81
20	2021-12-23 10:42:46.321017+00	2021-12-23 10:42:46.321017+00	[null]	\N	93
21	2021-12-23 10:42:46.355253+00	2021-12-23 10:42:46.355253+00	["EMPLOYED"]	\N	102
22	2021-12-23 10:42:46.394742+00	2021-12-23 10:42:46.394742+00	["Active","Closed"]	\N	110
23	2021-12-23 10:42:46.428468+00	2021-12-23 10:42:46.428468+00	["GBP"]	\N	121
24	2021-12-23 10:42:46.464684+00	2021-12-23 10:42:46.464684+00	["COFUND_ORG","COLLAB_ORG","FELLOW_ORG","LEAD_ORG","PARTICIPANT_ORG","PP_ORG","STUDENT_PP_ORG"]	\N	131
25	2021-12-23 10:42:46.499445+00	2021-12-23 10:42:46.499445+00	["COI_PER","FELLOW_PER","PI_PER","PM_PER","RESEARCH_COI_PER","RESEARCH_PER","STUDENT_PER","SUPER_PER","TGH_PER"]	\N	135
26	2021-12-23 10:42:46.565894+00	2021-12-23 10:42:46.565894+00	["ukri-projects-spider"]	\N	142
\.


--
-- Data for Name: metabase_table; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.metabase_table (id, created_at, updated_at, name, description, entity_name, entity_type, active, db_id, display_name, visibility_type, schema, points_of_interest, caveats, show_in_getting_started, field_order) FROM stdin;
37	2021-12-23 10:42:34.041038+00	2021-12-23 10:42:45.250464+00	coped_linked_project	\N	\N	entity/GenericTable	t	2	Coped Linked Project	\N	public	\N	\N	f	database
5	2021-12-23 10:42:33.318151+00	2021-12-23 10:42:45.270576+00	coped_organisation	\N	\N	entity/GenericTable	t	2	Coped Organisation	\N	public	\N	\N	f	database
33	2021-12-23 10:42:33.925601+00	2021-12-23 10:42:45.291479+00	coped_organisation_addresses	\N	\N	entity/GenericTable	t	2	Coped Organisation Addresses	\N	public	\N	\N	f	database
21	2021-12-23 10:42:33.65741+00	2021-12-23 10:42:45.312865+00	coped_organisation_external_links	\N	\N	entity/GenericTable	t	2	Coped Organisation External Links	\N	public	\N	\N	f	database
13	2021-12-23 10:42:33.479818+00	2021-12-23 10:42:33.479818+00	django_admin_log	\N	\N	\N	t	2	Django Admin Log	cruft	public	\N	\N	f	database
14	2021-12-23 10:42:33.500955+00	2021-12-23 10:42:33.500955+00	django_migrations	\N	\N	\N	t	2	Django Migrations	cruft	public	\N	\N	f	database
15	2021-12-23 10:42:33.522323+00	2021-12-23 10:42:33.522323+00	auth_permission	\N	\N	\N	t	2	Auth Permission	cruft	public	\N	\N	f	database
16	2021-12-23 10:42:33.543412+00	2021-12-23 10:42:33.543412+00	spatial_ref_sys	\N	\N	\N	t	2	Spatial Ref Sys	cruft	public	\N	\N	f	database
20	2021-12-23 10:42:33.635407+00	2021-12-23 10:42:33.635407+00	auth_group	\N	\N	\N	t	2	Auth Group	cruft	public	\N	\N	f	database
24	2021-12-23 10:42:33.72669+00	2021-12-23 10:42:33.72669+00	django_content_type	\N	\N	\N	t	2	Django Content Type	cruft	public	\N	\N	f	database
25	2021-12-23 10:42:33.748769+00	2021-12-23 10:42:33.748769+00	auth_group_permissions	\N	\N	\N	t	2	Auth Group Permissions	cruft	public	\N	\N	f	database
29	2021-12-23 10:42:33.83349+00	2021-12-23 10:42:33.83349+00	django_session	\N	\N	\N	t	2	Django Session	cruft	public	\N	\N	f	database
17	2021-12-23 10:42:33.565381+00	2021-12-23 10:42:45.135923+00	coped_address	\N	\N	entity/GenericTable	t	2	Coped Address	\N	public	\N	\N	f	database
22	2021-12-23 10:42:33.679784+00	2021-12-23 10:42:45.173461+00	coped_external_link	\N	\N	entity/GenericTable	t	2	Coped External Link	\N	public	\N	\N	f	database
35	2021-12-23 10:42:33.976895+00	2021-12-23 10:42:45.19345+00	coped_geo_data	\N	\N	entity/GenericTable	t	2	Coped Geo Data	\N	public	\N	\N	f	database
31	2021-12-23 10:42:33.878095+00	2021-12-23 10:42:45.229903+00	coped_keyword	\N	\N	entity/GenericTable	t	2	Coped Keyword	\N	public	\N	\N	f	database
10	2021-12-23 10:42:33.416097+00	2021-12-23 10:42:45.333069+00	coped_person	\N	\N	entity/UserTable	t	2	Coped Person	\N	public	\N	\N	f	database
30	2021-12-23 10:42:33.855857+00	2021-12-23 10:42:45.354292+00	coped_person_external_links	\N	\N	entity/GenericTable	t	2	Coped Person External Links	\N	public	\N	\N	f	database
12	2021-12-23 10:42:33.458044+00	2021-12-23 10:42:45.374827+00	coped_person_organisation	\N	\N	entity/GenericTable	t	2	Coped Person Organisation	\N	public	\N	\N	f	database
7	2021-12-23 10:42:33.353443+00	2021-12-23 10:42:45.396538+00	coped_project	\N	\N	entity/GenericTable	t	2	Coped Project	\N	public	\N	\N	f	database
28	2021-12-23 10:42:33.812285+00	2021-12-23 10:42:45.428149+00	coped_project_external_links	\N	\N	entity/GenericTable	t	2	Coped Project External Links	\N	public	\N	\N	f	database
9	2021-12-23 10:42:33.39515+00	2021-12-23 10:42:45.456778+00	coped_project_fund	\N	\N	entity/GenericTable	t	2	Coped Project Fund	\N	public	\N	\N	f	database
11	2021-12-23 10:42:33.437759+00	2021-12-23 10:42:45.481898+00	coped_project_keyword	\N	\N	entity/GenericTable	t	2	Coped Project Keyword	\N	public	\N	\N	f	database
8	2021-12-23 10:42:33.37424+00	2021-12-23 10:42:45.508583+00	coped_project_organisation	\N	\N	entity/GenericTable	t	2	Coped Project Organisation	\N	public	\N	\N	f	database
18	2021-12-23 10:42:33.588028+00	2021-12-23 10:42:45.529404+00	coped_project_person	\N	\N	entity/UserTable	t	2	Coped Project Person	\N	public	\N	\N	f	database
19	2021-12-23 10:42:33.613075+00	2021-12-23 10:42:45.550735+00	coped_project_subject	\N	\N	entity/GenericTable	t	2	Coped Project Subject	\N	public	\N	\N	f	database
6	2021-12-23 10:42:33.332435+00	2021-12-23 10:42:45.572273+00	coped_raw_data	\N	\N	entity/GenericTable	t	2	Coped Raw Data	\N	public	\N	\N	f	database
38	2021-12-23 10:42:34.069677+00	2021-12-23 10:42:45.59338+00	coped_subject	\N	\N	entity/GenericTable	t	2	Coped Subject	\N	public	\N	\N	f	database
34	2021-12-23 10:42:33.949448+00	2021-12-23 10:44:56.878406+00	auth_user	\N	\N	entity/UserTable	t	2	Auth User	hidden	public	\N	\N	f	database
23	2021-12-23 10:42:33.702863+00	2021-12-23 10:44:57.78023+00	auth_user_groups	\N	\N	entity/GenericTable	t	2	Auth User Groups	hidden	public	\N	\N	f	database
26	2021-12-23 10:42:33.769775+00	2021-12-23 10:44:58.550999+00	auth_user_user_permissions	\N	\N	entity/GenericTable	t	2	Auth User User Permissions	hidden	public	\N	\N	f	database
36	2021-12-23 10:42:34.012676+00	2021-12-23 10:45:12.440918+00	core_geotag	\N	\N	entity/GenericTable	t	2	Core Geotag	hidden	public	\N	\N	f	database
27	2021-12-23 10:42:33.790955+00	2021-12-23 10:45:13.491884+00	geography_columns	\N	\N	entity/GenericTable	t	2	Geography Columns	hidden	public	\N	\N	f	database
32	2021-12-23 10:42:33.901414+00	2021-12-23 10:45:14.873234+00	geometry_columns	\N	\N	entity/GenericTable	t	2	Geometry Columns	hidden	public	\N	\N	f	database
\.


--
-- Data for Name: metric; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.metric (id, table_id, creator_id, name, description, archived, definition, created_at, updated_at, points_of_interest, caveats, how_is_this_calculated, show_in_getting_started) FROM stdin;
\.


--
-- Data for Name: metric_important_field; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.metric_important_field (id, metric_id, field_id) FROM stdin;
\.


--
-- Data for Name: moderation_review; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.moderation_review (id, updated_at, created_at, status, text, moderated_item_id, moderated_item_type, moderator_id, most_recent) FROM stdin;
\.


--
-- Data for Name: native_query_snippet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.native_query_snippet (id, name, description, content, creator_id, archived, created_at, updated_at, collection_id) FROM stdin;
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (id, object, group_id) FROM stdin;
1	/	2
2	/collection/root/	1
3	/collection/root/	3
7	/db/2/schema/	1
8	/db/2/native/	1
\.


--
-- Data for Name: permissions_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions_group (id, name) FROM stdin;
1	All Users
2	Administrators
3	MetaBot
\.


--
-- Data for Name: permissions_group_membership; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions_group_membership (id, user_id, group_id) FROM stdin;
1	1	1
2	1	2
3	3	1
4	4	1
\.


--
-- Data for Name: permissions_revision; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions_revision (id, before, after, user_id, created_at, remark) FROM stdin;
1	{"1":{"2":{"schemas":"all","native":"write"}}}	{"1":{"2":{"schemas":"none","native":"none"}}}	1	2021-12-24 04:06:07.673748	\N
2	{}	{"1":{"2":{"schemas":"all"}}}	1	2021-12-24 14:54:40.359352	\N
3	{}	{"1":{"2":{"native":"write"}}}	1	2021-12-24 17:02:25.962545	\N
\.


--
-- Data for Name: pulse; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pulse (id, creator_id, name, created_at, updated_at, skip_if_empty, alert_condition, alert_first_only, alert_above_goal, collection_id, collection_position, archived, dashboard_id, parameters) FROM stdin;
\.


--
-- Data for Name: pulse_card; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pulse_card (id, pulse_id, card_id, "position", include_csv, include_xls, dashboard_card_id) FROM stdin;
\.


--
-- Data for Name: pulse_channel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pulse_channel (id, pulse_id, channel_type, details, schedule_type, schedule_hour, schedule_day, created_at, updated_at, schedule_frame, enabled) FROM stdin;
\.


--
-- Data for Name: pulse_channel_recipient; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pulse_channel_recipient (id, pulse_channel_id, user_id) FROM stdin;
\.


--
-- Data for Name: qrtz_blob_triggers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_blob_triggers (sched_name, trigger_name, trigger_group, blob_data) FROM stdin;
\.


--
-- Data for Name: qrtz_calendars; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_calendars (sched_name, calendar_name, calendar) FROM stdin;
\.


--
-- Data for Name: qrtz_cron_triggers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_cron_triggers (sched_name, trigger_name, trigger_group, cron_expression, time_zone_id) FROM stdin;
MetabaseScheduler	metabase.task.update-field-values.trigger.2	DEFAULT	0 0 18 * * ? *	Etc/UTC
MetabaseScheduler	metabase.task.upgrade-checks.trigger	DEFAULT	0 15 6,18 * * ? *	Etc/UTC
MetabaseScheduler	metabase.task.send-pulses.trigger	DEFAULT	0 0 * * * ? *	Etc/UTC
MetabaseScheduler	metabase.task.task-history-cleanup.trigger	DEFAULT	0 0 * * * ? *	Etc/UTC
MetabaseScheduler	metabase.task.sync-and-analyze.trigger.2	DEFAULT	0 46 * * * ? *	Etc/UTC
MetabaseScheduler	metabase.task.abandonment-emails.trigger	DEFAULT	0 0 12 * * ? *	Etc/UTC
MetabaseScheduler	metabase.task.follow-up-emails.trigger	DEFAULT	0 0 12 * * ? *	Etc/UTC
MetabaseScheduler	metabase.task.anonymous-stats.trigger	DEFAULT	0 15 7 * * ? *	Etc/UTC
\.


--
-- Data for Name: qrtz_fired_triggers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_fired_triggers (sched_name, entry_id, trigger_name, trigger_group, instance_name, fired_time, sched_time, priority, state, job_name, job_group, is_nonconcurrent, requests_recovery) FROM stdin;
\.


--
-- Data for Name: qrtz_job_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_job_details (sched_name, job_name, job_group, description, job_class_name, is_durable, is_nonconcurrent, is_update_data, requests_recovery, job_data) FROM stdin;
MetabaseScheduler	metabase.task.upgrade-checks.job	DEFAULT	\N	metabase.task.upgrade_checks.CheckForNewVersions	f	f	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
MetabaseScheduler	metabase.task.anonymous-stats.job	DEFAULT	\N	metabase.task.send_anonymous_stats.SendAnonymousUsageStats	f	f	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
MetabaseScheduler	metabase.task.abandonment-emails.job	DEFAULT	\N	metabase.task.follow_up_emails.AbandonmentEmail	f	f	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
MetabaseScheduler	metabase.task.send-pulses.job	DEFAULT	\N	metabase.task.send_pulses.SendPulses	f	f	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
MetabaseScheduler	metabase.task.follow-up-emails.job	DEFAULT	\N	metabase.task.follow_up_emails.FollowUpEmail	f	f	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
MetabaseScheduler	metabase.task.task-history-cleanup.job	DEFAULT	\N	metabase.task.task_history_cleanup.TaskHistoryCleanup	f	f	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
MetabaseScheduler	metabase.task.sync-and-analyze.job	DEFAULT	sync-and-analyze for all databases	metabase.task.sync_databases.SyncAndAnalyzeDatabase	t	t	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
MetabaseScheduler	metabase.task.update-field-values.job	DEFAULT	update-field-values for all databases	metabase.task.sync_databases.UpdateFieldValues	t	t	f	f	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787000737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f40000000000010770800000010000000007800
\.


--
-- Data for Name: qrtz_locks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_locks (sched_name, lock_name) FROM stdin;
MetabaseScheduler	STATE_ACCESS
MetabaseScheduler	TRIGGER_ACCESS
\.


--
-- Data for Name: qrtz_paused_trigger_grps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_paused_trigger_grps (sched_name, trigger_group) FROM stdin;
\.


--
-- Data for Name: qrtz_scheduler_state; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_scheduler_state (sched_name, instance_name, last_checkin_time, checkin_interval) FROM stdin;
MetabaseScheduler	44df0389dec31640307475325	1640386184496	7500
\.


--
-- Data for Name: qrtz_simple_triggers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_simple_triggers (sched_name, trigger_name, trigger_group, repeat_count, repeat_interval, times_triggered) FROM stdin;
\.


--
-- Data for Name: qrtz_simprop_triggers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_simprop_triggers (sched_name, trigger_name, trigger_group, str_prop_1, str_prop_2, str_prop_3, int_prop_1, int_prop_2, long_prop_1, long_prop_2, dec_prop_1, dec_prop_2, bool_prop_1, bool_prop_2) FROM stdin;
\.


--
-- Data for Name: qrtz_triggers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.qrtz_triggers (sched_name, trigger_name, trigger_group, job_name, job_group, description, next_fire_time, prev_fire_time, priority, trigger_state, trigger_type, start_time, end_time, calendar_name, misfire_instr, job_data) FROM stdin;
MetabaseScheduler	metabase.task.update-field-values.trigger.2	DEFAULT	metabase.task.update-field-values.job	DEFAULT	update-field-values Database 2	1640455200000	1640368800000	5	WAITING	CRON	1640256514000	0	\N	2	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787001737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f4000000000000c7708000000100000000174000564622d6964737200116a6176612e6c616e672e496e746567657212e2a0a4f781873802000149000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000027800
MetabaseScheduler	metabase.task.abandonment-emails.trigger	DEFAULT	metabase.task.abandonment-emails.job	DEFAULT	\N	1640433600000	1640347200000	5	WAITING	CRON	1640307475000	0	\N	0	\\x
MetabaseScheduler	metabase.task.upgrade-checks.trigger	DEFAULT	metabase.task.upgrade-checks.job	DEFAULT	\N	1640412900000	1640369700000	5	WAITING	CRON	1640307475000	0	\N	0	\\x
MetabaseScheduler	metabase.task.follow-up-emails.trigger	DEFAULT	metabase.task.follow-up-emails.job	DEFAULT	\N	1640433600000	1640347200000	5	WAITING	CRON	1640307475000	0	\N	0	\\x
MetabaseScheduler	metabase.task.anonymous-stats.trigger	DEFAULT	metabase.task.anonymous-stats.job	DEFAULT	\N	1640416500000	1640356742362	5	WAITING	CRON	1640307475000	0	\N	0	\\x
MetabaseScheduler	metabase.task.send-pulses.trigger	DEFAULT	metabase.task.send-pulses.job	DEFAULT	\N	1640386800000	1640385824702	5	WAITING	CRON	1640307475000	0	\N	1	\\x
MetabaseScheduler	metabase.task.task-history-cleanup.trigger	DEFAULT	metabase.task.task-history-cleanup.job	DEFAULT	\N	1640386800000	1640385824718	5	WAITING	CRON	1640307475000	0	\N	0	\\x
MetabaseScheduler	metabase.task.sync-and-analyze.trigger.2	DEFAULT	metabase.task.sync-and-analyze.job	DEFAULT	sync-and-analyze Database 2	1640389560000	1640385960000	5	WAITING	CRON	1640256514000	0	\N	2	\\xaced0005737200156f72672e71756172747a2e4a6f62446174614d61709fb083e8bfa9b0cb020000787200266f72672e71756172747a2e7574696c732e537472696e674b65794469727479466c61674d61708208e8c3fbc55d280200015a0013616c6c6f77735472616e7369656e74446174617872001d6f72672e71756172747a2e7574696c732e4469727479466c61674d617013e62ead28760ace0200025a000564697274794c00036d617074000f4c6a6176612f7574696c2f4d61703b787001737200116a6176612e7574696c2e486173684d61700507dac1c31660d103000246000a6c6f6164466163746f724900097468726573686f6c6478703f4000000000000c7708000000100000000174000564622d6964737200116a6176612e6c616e672e496e746567657212e2a0a4f781873802000149000576616c7565787200106a6176612e6c616e672e4e756d62657286ac951d0b94e08b0200007870000000027800
\.


--
-- Data for Name: query; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.query (query_hash, average_execution_time, query) FROM stdin;
\\xeda8a8294ae62b519a7a42329d086bf06cdf2923f995fe0e36afd0644bbdc2e9	568	{"type":"native","native":{"query":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x5193da9d9a97c75c6d5b356bf554cb0c20ea11480e57454219d05ead2e6ad224	299	{"type":"native","native":{"query":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000","template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x2da9f9523b755dcc19677021956b0c46505e1291b32e85535b8ea502b48a3e39	444	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],66.51326189011355,-179.99999564141046,0.0,-89.99999782070523]},"async?":false}
\\xaf7d51af1e1e44105f7d9cf77a3eb5cffb1466e2fa471b15fe57a0c94bb7294f	447	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],0.0,0.0,-66.51326189011354,89.99999782070523]},"async?":false}
\\x46b2679839b4d2fca6a469c1a7b840a63b4887dbf73cf950aee973f3eb17a8e9	466	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],66.51326189011355,89.99999782070523,0.0,179.99999564141046]},"async?":false}
\\x4bddc5e37dda79ab045bd7021da216cea0f2d5acfb87bd085660aad64bb6b669	474	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],66.51326189011355,0.0,0.0,89.99999782070523]},"async?":false}
\\x55a1cff7e7ec87b1eef3375cf96015b48f1592e9b6dafba27b7fed5b48345dde	500	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],66.51326189011355,-89.99999782070523,0.0,0.0]},"async?":false}
\\x13221743ab863724383f65832795aa9da0d4da21e190c019ac61057af94a63a5	517	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],0.0,-89.99999782070523,-66.51326189011354,0.0]},"async?":false}
\\x95b204c2c64cd3dc83e11f2607f2812cfe3ff54cf01a167315da98ac74b34964	185	{"type":"query","query":{"source-table":9,"breakout":[["field",122,{"binning":{"strategy":"num-bins","num-bins":50}}]]},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x69cd509ec3c627bdfbdde787a829830c9e794d2cde471be492f83852c642d898	136	{"type":"query","query":{"source-table":9,"aggregation":[["count"]],"breakout":[["field",122,{"binning":{"strategy":"num-bins","num-bins":10}}]]},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xd33ff3da05076ce75cd1de247ac1a5a01d11225f42d1b9e7c34b4b868998480a	238	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],0.0,-179.99999564141046,-66.51326189011354,-89.99999782070523]},"async?":false}
\\x733c7b9f5ea32e82626c12eb37e1491bd52a9e9df7730d2350d726210c27d943	268	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],66.51326189011355,0.0,55.77657455019159,22.499999455176308]},"async?":false}
\\x925fba84ef382e55b74e728e7543364bbc8bc50451efb2f7453f5445e9eaf3a8	320	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],40.97989944013221,-134.99999673105785,0.0,-89.99999782070523]},"async?":false}
\\x8b5835bd4c15c8c90a1ba62d50e51d91490cb08ba4ca5d03e2316f46358894c6	273	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],66.51326189011355,89.99999782070523,40.97989944013221,134.99999673105785]},"async?":false}
\\x86f19ad3542457632eb5fa21b3d83c5a2760b08244532cb16492a95731d9c91e	225	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],0.0,89.99999782070523,-66.51326189011354,179.99999564141046]},"async?":false}
\\x97610bc510076979c902381f014a4c8f245ffd7d186af66617231fcf4129c8ac	332	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],55.77657455019159,44.999998910352616,40.97989944013221,67.49999836552892]},"async?":false}
\\x3b8ecbce6ce766576b895414b44dd88027c422757250fa795b8cb0a81bd65c08	331	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],61.60639788210258,0.0,55.77657455019159,11.249999727588154]},"async?":false}
\\x9cc97607be56e635a20722351afbcce09da2a2148a4096a1f3dca32ba1f6cfe8	448	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],48.922500754829464,-11.249999727588154,40.97989944013221,0.0]},"async?":false}
\\x4ad15a5b84640eeb669da82a59f65cdcf8dc9c72d2a93f3587f71c6479184e44	231	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],58.813743243289096,0.0,55.77657455019159,5.624999863794077]},"async?":false}
\\x724448dbbfa00c7504ab3631ae64d6891202f39abccaa22e644bce5e67ffdc6c	42	{"type":"query","query":{"source-table":9,"aggregation":[["count"]],"breakout":[["field",122,{"binning":{"strategy":"num-bins","num-bins":100}}],["expression","pivot-grouping"]],"filter":[">",["field",123,null],"2019-01-01"],"expressions":{"pivot-grouping":["abs",0]}},"database":2,"pivot-rows":[0],"async?":true,"middleware":{"add-default-userland-constraints?":true}}
\\xc2f8c615dd5793256936713f763c975498684fe361f96e9a323d495876a13d75	283	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],40.97989944013221,44.999998910352616,0.0,89.99999782070523]},"async?":false}
\\x9874682a930cd29c37fa2558429daf223e1fbe7fc43140b1073b272545a8c30e	426	{"type":"query","query":{"source-table":9},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x132b90d3fd407749d3211e6ded523d3442d157965d389a98bae7b3870e453803	74	{"database":2,"query":{"source-table":9,"aggregation":[["count"]],"breakout":[["field",122,{"binning":{"strategy":"default"}}]]},"type":"query","middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x621fc8c07059b989c744ca528d74ab0d137cc1d31c86dc1d3f55c0e98d13989d	85	{"type":"query","query":{"source-table":9,"aggregation":[["count"]],"breakout":[["field",122,null]]},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x20cd93e3247b9603dfbde06c32ca7da73c7b20d752b92bfb6a66731da172ecd9	49	{"type":"query","query":{"source-table":9,"aggregation":[["count"]],"breakout":[["expression","pivot-grouping"]],"filter":[">",["field",123,null],"2019-01-01"],"expressions":{"pivot-grouping":["abs",1]}},"database":2,"pivot-rows":[0],"async?":true}
\\x4602a8a37df601374ab921cb4b2a5b7cf46ad2d8093c82fdac614ed6c5191d80	22	{"type":"query","query":{"source-table":9,"aggregation":[["count"]],"breakout":[["field",122,{"binning":{"strategy":"num-bins","num-bins":100}}],["expression","pivot-grouping"]],"filter":["<",["field",122,null],2000000],"expressions":{"pivot-grouping":["abs",0]}},"database":2,"pivot-rows":[0],"async?":true,"middleware":{"add-default-userland-constraints?":true}}
\\x924c8abf8c19f8ae0817935d94412cba682eacfbb93a49e3f13df1cb29907291	270	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],55.77657455019159,22.499999455176308,40.97989944013221,44.999998910352616]},"async?":false}
\\xd596ef813b477386a5dd4658ef37cf0fa823f09d81cb260b810afc0ca890c456	374	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],52.4827817422423,-11.249999727588154,48.922500754829464,-5.624999863794077]},"async?":false}
\\x42ccd8ec457aaf10ff87dfa8628ee769bdff32be2a632051e0a46569772b05c5	300	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],55.77657455019159,11.249999727588154,52.4827817422423,16.87499959138223]},"async?":false}
\\x101ecbe78efeac4b0f9d0b9713c9c774eef8ca939185760cc2d74dda9335c786	49	{"type":"query","query":{"source-table":9,"aggregation":[["count"]],"breakout":[["field",122,{"binning":{"strategy":"num-bins","num-bins":100}}],["expression","pivot-grouping"]],"filter":["<",["field",122,null],0],"expressions":{"pivot-grouping":["abs",0]}},"database":2,"pivot-rows":[0],"async?":true,"middleware":{"add-default-userland-constraints?":true}}
\\x987975585cc7d0516eeb13a8ddc5c7b60d5af2dbe57142ebd7c214b004e86eef	442	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],66.51326189011355,-89.99999782070523,40.97989944013221,-44.999998910352616]},"async?":false}
\\x15a7d97e469fe688a1bd14e4f47acffab86f8c4945fb9006f00b8a8a6ae9cb2b	303	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],66.51326189011355,-134.99999673105785,40.97989944013221,-89.99999782070523]},"async?":false}
\\x3e4704da1170c5967b9456ab5aee9a1a41c9c3479a66812a3e217d758c764c50	73	{"database":2,"query":{"source-table":9,"aggregation":[["count"]],"breakout":[["field",122,{"binning":{"strategy":"num-bins","num-bins":100}}]]},"type":"query","middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xd184b5ab326f6701187f94f4ea3d548eccb5426d0760d2af2f62f087c45c462a	223	{"type":"query","query":{"source-table":9,"aggregation":[["count"]],"breakout":[["field",122,{"binning":{"strategy":"num-bins","num-bins":100}}]],"filter":[">",["field",123,null],"2019-01-01"]},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x2f3e74479b843dfe48b2f835ff77cad5d7cc150b498723227573be7c0ab4b4fa	46	{"database":2,"query":{"source-table":9,"aggregation":[["count"]],"breakout":[["field",122,{"binning":{"strategy":"num-bins","num-bins":100}}],["expression","pivot-grouping"]],"expressions":{"pivot-grouping":["abs",0]}},"type":"query","pivot-rows":[0],"async?":true,"middleware":{"add-default-userland-constraints?":true}}
\\xf7161638cce0cfad0788869b96fcb6ab8d79f1d1062b72f020dd4652fe490b42	14	{"type":"query","query":{"source-table":9,"aggregation":[["count"]],"breakout":[["expression","pivot-grouping"]],"filter":["<",["field",122,null],2000000],"expressions":{"pivot-grouping":["abs",1]}},"database":2,"pivot-rows":[0],"async?":true}
\\x59a97a72d539aa24ab72ed4dc592e17f75fac9d0336a0c521234a2f51e7954b3	96	{"type":"query","query":{"source-table":9,"filter":["between",["field",122,null],80000,100000]},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xdb9c57d31134c3ff2e89ff6b0f6bd558fcf76b1fdd3dc9e755a94559af1239f0	13	{"database":2,"type":"query","query":{"source-table":12,"aggregation":["count"],"filter":["=",["field",104,null],"9"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x04252b71b17c25f8796cc0f1caad389468b9b20165e14d1e6717d26f92563263	9	{"database":2,"type":"query","query":{"source-table":21,"aggregation":["count"],"filter":["=",["field",89,null],"10"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xb1ff40cb696bb05fc7dad435dcaf66bc572f16cd16de28b4eaa0b5e3421beb8a	16	{"database":2,"type":"query","query":{"source-table":33,"aggregation":["count"],"filter":["=",["field",86,null],"11"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xe1457f3aa694fd12c68c409cbe7f32c736cb72c96b6a7791358ceef6e2c8c85e	7	{"database":2,"type":"query","query":{"source-table":8,"aggregation":["count"],"filter":["=",["field",132,null],"11"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x4bc592522851871c1f26593de72543582efdc09939f220ce278f1c6537c21938	269	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],40.97989944013221,0.0,21.94304637537721,22.499999455176308]},"async?":false}
\\x1fc465697c499eb9733b2f99974165dba0485f615be29ace31e84b3a2b23d929	314	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],66.51326189011355,-22.499999455176308,55.77657455019159,0.0]},"async?":false}
\\xa8dbd8b30ec00b5d36ca0e07681a3ef1448f0c7706ea76f499fb5799e8407c06	417	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],55.77657455019159,0.0,40.97989944013221,22.499999455176308]},"async?":false}
\\x48b6f8d53092abc62e3725d3000cb5f1a789e16fbf07a8aaf1aa94b962119d59	513	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],55.77657455019159,-22.499999455176308,40.97989944013221,0.0]},"async?":false}
\\x5655936eaf7b21a6e626f76c66bfd4d52485c089070da1238263912798cf6cee	264	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],66.51326189011355,22.499999455176308,55.77657455019159,44.999998910352616]},"async?":false}
\\xcb43928c81700537fffde5999a627c87ab15788eba218e3d55ba0250eefedd2b	323	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],40.97989944013221,-22.499999455176308,21.94304637537721,0.0]},"async?":false}
\\xa08acb372f80c62d52451943b2ff09d434dd57df5258a3dc09294a098cee7381	10	{"type":"query","query":{"source-table":9,"aggregation":[["count"]],"breakout":[["expression","pivot-grouping"]],"filter":["<",["field",122,null],0],"expressions":{"pivot-grouping":["abs",1]}},"database":2,"pivot-rows":[0],"async?":true}
\\xb929ff29ddaf975c341c721d7d3424e8b2dbefc95401e4eaf6a4b496061bd77a	12	{"database":2,"query":{"source-table":9,"aggregation":[["count"]],"breakout":[["expression","pivot-grouping"]],"expressions":{"pivot-grouping":["abs",1]}},"type":"query","pivot-rows":[0],"async?":true}
\\x9ca912290e54faa0306ac23bb83857a9a5c04317722c9709cc15014b01823f75	169	{"database":2,"query":{"source-table":5},"type":"query","middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xa5673548119c698018d6a8ad4a1aadd644372c9fc6cfbd04f55c60f906ea6e12	60	{"query":{"source-table":5,"filter":["=",["field",83,null],"9"]},"type":"query","database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x56995c94c322377c0141fe7659b75fe3646009efc5dfb98a7fef6aec0a9c0a37	11	{"database":2,"type":"query","query":{"source-table":8,"aggregation":["count"],"filter":["=",["field",132,null],"9"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x47492ce57e9b5420274b4aaff04060c0c9884b7610f1f88d11da8bd7f0ef8ab5	52	{"database":2,"type":"query","query":{"source-table":5,"filter":["=",["field",83,null],8]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xd686fe2693d3a140a076e0cdc3fede19204157c5fda63db14842f166c4577dcd	23	{"database":2,"type":"query","query":{"source-table":33,"aggregation":["count"],"filter":["=",["field",86,null],"8"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x2ad9b9ebae64e08c847ab1f19c6c594e3bd5c50dd089ec1199795a2e7635d39d	345	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],40.97989944013221,22.499999455176308,21.94304637537721,44.999998910352616]},"async?":false}
\\xd923216e2a8438d421131221408964e2f6f4e6476a6c6a0ed86e48684d3d689e	303	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],40.97989944013221,-44.999998910352616,21.94304637537721,-22.499999455176308]},"async?":false}
\\xb82bcfac3d2dc84933b1e4197e814067bc8c9ffcd2775b57c0b34eee586a7ee6	378	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],55.77657455019159,-11.249999727588154,48.922500754829464,0.0]},"async?":false}
\\xecd2dbad0bcf401ed7c94392f5d8bc03f0e842275e20328bc72161ba6e2f630c	245	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],55.77657455019159,-33.74999918276446,48.922500754829464,-22.499999455176308]},"async?":false}
\\xce5a23258fc6738292389c0bea25ef70d1f1c966f4754601b6cf2fc0a91eff7d	251	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],48.922500754829464,11.249999727588154,40.97989944013221,22.499999455176308]},"async?":false}
\\x80b59442213ee010c00087ad6ae810e814f6be2eea991945bb85ccf0701147d3	249	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],55.77657455019159,0.0,52.4827817422423,5.624999863794077]},"async?":false}
\\xb105866d928b58a5fabf215a21896a2894ce8c64fa9cf943e5e8d3d96e901178	406	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],55.77657455019159,-44.999998910352616,40.97989944013221,-22.499999455176308]},"async?":false}
\\x2519ff936278c9cb4f262d0c37d6d8dcb79c3a7a22e5496bfec33b21c782331c	344	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],66.51326189011355,-44.999998910352616,55.77657455019159,-22.499999455176308]},"async?":false}
\\xe6066acd4ef11e943f85aa1af2051111ed438d2b6bf32dd97cb4de5500a0fba1	398	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],66.51326189011355,44.999998910352616,55.77657455019159,67.49999836552892]},"async?":false}
\\x69136de2dee104edd39838b6b9d756e929e52813f29422180a2e3d254bc8b959	331	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],40.97989944013221,44.999998910352616,21.94304637537721,67.49999836552892]},"async?":false}
\\x747ffe1c1d85520b64f7ed559c9a765b15e1e5c9a5169895a3e29dbdfece35cb	296	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],55.77657455019159,67.49999836552892,40.97989944013221,89.99999782070523]},"async?":false}
\\x141bff3f70fe2793060d83ba6dd88ab42a6663fe6717c0312dadadea07a61f5f	302	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],66.51326189011355,-67.49999836552892,55.77657455019159,-44.999998910352616]},"async?":false}
\\x428a1cb93232f93987082948dacc7733fda66dd322ebb90f917480dc74dd9330	283	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],66.51326189011355,67.49999836552892,55.77657455019159,89.99999782070523]},"async?":false}
\\x3b104704dd1e85cec684e37288d08f898003c98a753a138365d595ef850da731	222	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],40.97989944013221,67.49999836552892,21.94304637537721,89.99999782070523]},"async?":false}
\\x6b39ad90b860fc040fe16aece13150de3c7e7bafefb9f340c9ddf931a9063a4d	305	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],55.77657455019159,-67.49999836552892,40.97989944013221,-44.999998910352616]},"async?":false}
\\xab3b99b034298297343fd0f3c75988fb959427e00ed08519f26a50bf5a04dfe5	236	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],40.97989944013221,-67.49999836552892,21.94304637537721,-44.999998910352616]},"async?":false}
\\x43da9244d1716c5df1c9b9d6b06e82a8c9083a6d5f66462a4e5bfb8fac9d31b9	159	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],66.51326189011355,-89.99999782070523,55.77657455019159,-67.49999836552892]},"async?":false}
\\xd8e7d7f3b92e4985d5839f5fadc5e60c856cea86586ec87616b97d32f25a3871	209	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],61.60639788210258,11.249999727588154,55.77657455019159,22.499999455176308]},"async?":false}
\\x99668c6a40609eb3de3eb6d4276c6f3ec3b01f8232bc4225251d757db05b9a89	283	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],61.60639788210258,-11.249999727588154,55.77657455019159,0.0]},"async?":false}
\\x4b44cff3c4805cd6f61b45d3086be48924f94e419a230d87fd78d72e0d4191bd	224	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],55.77657455019159,11.249999727588154,48.922500754829464,22.499999455176308]},"async?":false}
\\xcdef3df58a85e4862fd19294ebce32ff85b3f360f5e3638c7cbd9f9816f36de9	214	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],55.77657455019159,22.499999455176308,48.922500754829464,33.74999918276446]},"async?":false}
\\x934e3bbe8883cdc7bd753d421b53d37b19624c49e0a06eb6d9db7956957324d7	251	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],48.922500754829464,-33.74999918276446,40.97989944013221,-22.499999455176308]},"async?":false}
\\xf125cf055044687de7b7f379394fe7060d4083b3e8eab6bcde45d3b6e8386994	159	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],55.77657455019159,-89.99999782070523,40.97989944013221,-67.49999836552892]},"async?":false}
\\x5dbddd1474749061b1ca75d5cb7c2f39edd11e285cd7ad74d1419025d493665a	212	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],61.60639788210258,-22.499999455176308,55.77657455019159,-11.249999727588154]},"async?":false}
\\xa382bbfe8e7b77413dbe4996ae515c05144f2ec31f98a354f3e2ed1728b8d4a0	382	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],55.77657455019159,0.0,48.922500754829464,11.249999727588154]},"async?":false}
\\x37558eca98d5b92fb1880b74e1064e28aee70986ce95208a4d16a497df01c164	311	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],55.77657455019159,-22.499999455176308,48.922500754829464,-11.249999727588154]},"async?":false}
\\x899158e89e5fef030e48c635f3534260734fc69592dfcc9d5d4ea70d7e80a262	247	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],61.60639788210258,-33.74999918276446,55.77657455019159,-22.499999455176308]},"async?":false}
\\x0c9c8e0740d8e0af0560e37d084e10be8925c39fa61dc83949a3efe5d35642c0	245	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],61.60639788210258,-44.999998910352616,55.77657455019159,-33.74999918276446]},"async?":false}
\\x158b0a706c60798b6884b0df1c83ed1650980476bfeb764be5e0e534c974127e	498	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],52.4827817422423,-5.624999863794077,48.922500754829464,0.0]},"async?":false}
\\xcc8a91fcd3b99399464a0677802dcc05a799b4198652d8d4edeeef8825b29f71	219	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],61.60639788210258,22.499999455176308,55.77657455019159,33.74999918276446]},"async?":false}
\\xae659868f115358167a10de37a094b51d356fbd8d43f1ee2d5bd8396de0db03e	291	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],55.77657455019159,-44.999998910352616,48.922500754829464,-33.74999918276446]},"async?":false}
\\xfe5997de8b0017532371df75c68f0c5269938fdcd8b1fee4f37c9bce81379eec	327	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],48.922500754829464,0.0,40.97989944013221,11.249999727588154]},"async?":false}
\\xc83ddbfd9c105dbba302433629052eb13d5b1ce181d442fba3f804e270f5157e	434	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],48.922500754829464,-22.499999455176308,40.97989944013221,-11.249999727588154]},"async?":false}
\\x80f5457ebd19de72de5cec95cf1782ac8fe19d625b258494947f60a26972c2f4	226	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],48.922500754829464,-44.999998910352616,40.97989944013221,-33.74999918276446]},"async?":false}
\\xfebce0b891246c768ae4d1f0e491968586bba20bff767f500388b6ac6e398732	224	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],55.77657455019159,-5.624999863794077,52.4827817422423,0.0]},"async?":false}
\\x2f24ad66870225819dde1abb0b2476ceae9a614c28843b2782bcc60f3331d2db	392	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],58.813743243289096,5.624999863794077,55.77657455019159,11.249999727588154]},"async?":false}
\\x4f2876b150131a771bc026cdfcf751b10be999ebe35c4002f94d9638cb102f9f	241	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],48.922500754829464,22.499999455176308,40.97989944013221,33.74999918276446]},"async?":false}
\\xc50e375eef500082b38117e57714dc5b544053a486b9bda4671b7a83ec92f9c0	238	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],52.4827817422423,0.0,48.922500754829464,5.624999863794077]},"async?":false}
\\x92f44430568748bfcfb66f5614a56c00c731131266e08e30acc8ea7ed06c1d76	293	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],58.813743243289096,-16.87499959138223,55.77657455019159,-11.249999727588154]},"async?":false}
\\xa7b8fb02309c60bab2acee7b8fd7212661e66404068317298f8797d56235add0	276	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],52.4827817422423,11.249999727588154,48.922500754829464,16.87499959138223]},"async?":false}
\\x3af208d9c5f3f9a7a5951b3e843884ef57ab1c2898ec18144af4eec00983b3aa	454	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],40.97989944013221,-44.999998910352616,0.0,0.0]},"async?":false}
\\x9470375fc40f3298e816f9b146d70f1cb6f058b03231ecb30cc49af02f55adc3	261	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],40.97989944013221,89.99999782070523,0.0,134.99999673105785]},"async?":false}
\\xe1b15bd16fc410faebe50de81983874aa7901398560d9b7bd72664204eb3ba5d	329	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],58.813743243289096,-5.624999863794077,55.77657455019159,0.0]},"async?":false}
\\xcfad7386c2888f6bdf9aa3ff8e46890082f04189d698df26d7325b9cde1242a7	318	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],55.77657455019159,5.624999863794077,52.4827817422423,11.249999727588154]},"async?":false}
\\x996c578cc647ea3aa922fb9e8b5bcd0e37fba109d8d57bf9238ecd6878a10146	368	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],58.813743243289096,-11.249999727588154,55.77657455019159,-5.624999863794077]},"async?":false}
\\xf7c7d3d25ea7641400d5211c3b7ff189bd120e9855f664355cb7b02526d98cea	443	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],55.77657455019159,-11.249999727588154,52.4827817422423,-5.624999863794077]},"async?":false}
\\xf3ff42f6c4509c391734672bd94b71b7fd01109e00b58bc52f2ae052bf4aba9d	312	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],52.4827817422423,5.624999863794077,48.922500754829464,11.249999727588154]},"async?":false}
\\xe412f094c680f8c6c07b13947a1144fcf65de38ab04863d59921636e3b930f16	313	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],55.77657455019159,-16.87499959138223,52.4827817422423,-11.249999727588154]},"async?":false}
\\xdfaa5120852d90e896604b587826cf08abfe0b978ac78b0c765a409451c8aff7	333	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],52.4827817422423,-16.87499959138223,48.922500754829464,-11.249999727588154]},"async?":false}
\\x88e7ca436a9a0da7b300996f886e91c3be5f4ba8d7d1967681571495d199a9e7	12	{"database":2,"type":"query","query":{"source-table":21,"aggregation":["count"],"filter":["=",["field",89,null],"8"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x7d7189db0a2c4dd9ed89a07fe5672ee05cd23f827f6670a77630e157c5cf6515	31	{"query":{"source-table":5,"filter":["=",["field",83,null],11]},"type":"query","database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xb2a2e30b071630dd8782f89876190084b98e1de7e7415adbd042c8abbbedc3df	9	{"database":2,"type":"query","query":{"source-table":9,"aggregation":["count"],"filter":["=",["field",125,null],"11"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x98f6b7dc331cd92a90249f32ea525fd85cf177d5b9bd7e44b3b7562710e8ece1	5	{"database":2,"type":"query","query":{"source-table":12,"aggregation":["count"],"filter":["=",["field",104,null],"12"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xa1f60147e9f3550df35a28afe5fb8dde431613a9ca2125c1e259d587e3a9f170	390	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],58.813743243289096,11.249999727588154,55.77657455019159,16.87499959138223]},"async?":false}
\\x865d39687342e1e56ae32e270cbcb95fd3510c4d98fbba17ff79c5be18f1009f	336	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],40.97989944013221,-89.99999782070523,0.0,-44.999998910352616]},"async?":false}
\\xd9a259374dc55c4824aef4258fe0b727b4f50e1c09b31f3d95afefc511b88ece	411	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],66.51326189011355,44.999998910352616,40.97989944013221,89.99999782070523]},"async?":false}
\\xb6ba3f385bf6d2a6b17a05f015ef411947082b59e1f6c28014598ec3e365e6ad	193	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],79.17133566400783,-89.99999782070523,66.51326189011355,-44.999998910352616]},"async?":false}
\\xc4d9eef8fc848246cffac7293839532e00cdbc83e26e4739e96912e57d7c72e8	195	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],79.17133566400783,-44.999998910352616,66.51326189011355,0.0]},"async?":false}
\\x801caa26f4809005aad28c6188b8df20df5a6b837c963923a2e1c73b1d2f9b00	199	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],79.17133566400783,44.999998910352616,66.51326189011355,89.99999782070523]},"async?":false}
\\x84e2a619c0782d5a5140ec015dc60d533eb9fbd3daf0ddaf59eced071bf8e939	182	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],66.51326189011355,134.99999673105785,40.97989944013221,179.99999564141046]},"async?":false}
\\x22856f7b62d38f8adaf1ce1b3347de27aa0cd04adf6fbd1db976533efaaae846	151	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],40.97989944013221,-179.99999564141046,0.0,-134.99999673105785]},"async?":false}
\\x3b641b2a829e79935b414b0deccd81e5902ba79e2e478393a11790423433e187	151	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],66.51326189011355,-179.99999564141046,40.97989944013221,-134.99999673105785]},"async?":false}
\\x819d1d03e90554be4ce2c323e06a5095e37f32a8253f6c8451ad8f60430f2a8f	11	{"database":2,"type":"query","query":{"source-table":12,"aggregation":["count"],"filter":["=",["field",104,null],"8"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x160dbf17b4ae39219d84b5487b644809fd8b3015c9b17064dfbb25242da0715d	15	{"database":2,"type":"query","query":{"source-table":33,"aggregation":["count"],"filter":["=",["field",87,null],"140"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xb5d9300076e7a755d0a0f425e1a3e3a1ed16657f5289974270ddda11537400d7	16	{"database":2,"type":"query","query":{"source-table":33,"aggregation":["count"],"filter":["=",["field",86,null],"12"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xccd8a0eb0567337853613c4b326a9b688f791c149304c8bd808ed4d03c796b61	111	{"type":"query","query":{"source-table":7,"fields":[["field",108,null],["field",106,null],["field",107,null],["field",110,null]]},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x0f242a4fd2c83d4d03c25de2317e06a964d6c105233b5c987eb91e22ab3e1c3e	276	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],79.17133566400783,0.0,66.51326189011355,44.999998910352616]},"async?":false}
\\xe60920169ce7d644d38c55b144df6c8ee333fabff7e7058941096b7fb79d40c8	284	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],79.17133566400783,-179.99999564141046,66.51326189011355,-134.99999673105785]},"async?":false}
\\xe471ff3b8eebbe453c4a64db46acdc117175e729a5d33f82f39eba3a43b750d0	296	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":true,"process-viz-settings?":false},"native":{"query":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000","template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}}},"database":2,"async?":true,"cache-ttl":null}
\\x88e2e98c3705884cdf0ad5744df3b1a2d43840f8ed6f53266eb3ab20cb621c07	475	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],0.0,0.0,-40.97989944013222,44.999998910352616]},"async?":false}
\\xd8fbfef809accf8859695c4869b982fb5dd31884f5d8fb88fdc1c09447dc7175	476	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],40.97989944013221,0.0,0.0,44.999998910352616]},"async?":false}
\\x222d41b8f44ce7759696ab2198f6f3f95710430a283c677c1af9d92326c380d6	495	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],0.0,44.999998910352616,-40.97989944013222,89.99999782070523]},"async?":false}
\\x4703924e65f8fd01ca356b03497f18d563eb2794db70f86b7eefdc3f174d957b	392	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],0.0,89.99999782070523,-40.97989944013222,134.99999673105785]},"async?":false}
\\x81a631f020f63cb6874357decc7e68623ddd4619c5d7c46886d6749e00b020f2	15	{"database":2,"type":"query","query":{"source-table":9,"aggregation":["count"],"filter":["=",["field",125,null],"8"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x362e81a74964512f80b760d067d1796c66fd1b3515da01d307c932892bb9356c	8	{"database":2,"type":"query","query":{"source-table":9,"aggregation":["count"],"filter":["=",["field",125,null],"9"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x5240e0d7368f48673177fecfa335bbbfb27d3134c949c2eef293c73a40daf140	8	{"database":2,"type":"query","query":{"source-table":12,"aggregation":["count"],"filter":["=",["field",104,null],"11"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xab87e6db3799e56c8ae3290eb00684fbb8fb7590d85092f4d8a193974a9ca2b5	34	{"database":2,"type":"query","query":{"source-table":5,"filter":["=",["field",83,null],12]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xcc349628549d7363e84f77c609b2202bdc67f6b0264acae87b717993309d42b4	280	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],79.17133566400783,-134.99999673105785,66.51326189011355,-89.99999782070523]},"async?":false}
\\x1702094699eec4c1a70acb35fc88b7a1cdeb6fd34dd7cc928342701a93a88116	138	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],79.17133566400783,89.99999782070523,66.51326189011355,134.99999673105785]},"async?":false}
\\x2947dcda9b4ab2d2568f98c0e9baa4c8ffbc95cbaf36a8bb1a1645451359d659	413	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],0.0,-44.999998910352616,-40.97989944013222,0.0]},"async?":false}
\\x6ed14a822a0bb354e541bacbf727db17f683dfa48b248c3d9dbcd8ffdc9f1fd6	481	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],0.0,-134.99999673105785,-40.97989944013222,-89.99999782070523]},"async?":false}
\\xc89a90901d35c57ef626a5b5d6da2ff8c8b89e90f38b00f14bedfdae4f65641f	199	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],0.0,-179.99999564141046,-40.97989944013222,-134.99999673105785]},"async?":false}
\\xa5d3629622db75c69e0199319c972cd6fe6469686216a91a8a004bb8eacdbf3f	304	{"type":"native","native":{"query":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x808cf743361f6ea779b7e8aea8a84bc9cfd91919bb2caef999e550824ebae141	316	{"type":"native","native":{"query":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"ad9abaa9-855e-ea5a-4c44-cca70c68afb8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x18ce3f9aa25f3dc51ad5999c65d9a243ad5b437b852e48b96b7b2dfea9c70c8c	159	{"database":2,"type":"query","query":{"source-table":8,"aggregation":["count"],"filter":["=",["field",132,null],"8"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xf63f061593cea5a9b7ef72226c437ef731ca86a9d67adc1892f963edc37b033c	52	{"query":{"source-table":5,"filter":["=",["field",83,null],9]},"type":"query","database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x0d1ab058e666f51685780a30c5a1384efd47eb5099e36e613cb139c8ff364fd9	13	{"database":2,"type":"query","query":{"source-table":21,"aggregation":["count"],"filter":["=",["field",89,null],"9"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xb7a87ef9f0705bc605a0abb00150c2f182e692cce142cbe340a3e72a6a9d3803	13	{"database":2,"type":"query","query":{"source-table":33,"aggregation":["count"],"filter":["=",["field",86,null],"10"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x0ae1c258cab2ef074b1a5ae262fd818ed753858c7beab2dfe34c25d622b363cb	478	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],66.51326189011355,-44.999998910352616,40.97989944013221,0.0]},"async?":false}
\\xad3ad6b865c4f34cb73b23c0b38679948fc38bfa4297eb881bc45c375638d0f7	412	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],0.0,-89.99999782070523,-40.97989944013222,-44.999998910352616]},"async?":false}
\\xb44649533f1194150a91d05ad43a6de04930ef53305b09bb6a1cef1375a0d1a0	197	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],0.0,134.99999673105785,-40.97989944013222,179.99999564141046]},"async?":false}
\\x530dc3c69db39f873e426bdc5df39e77723273f13304b4114f1ae754b8c4b9f5	292	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":true,"process-viz-settings?":false},"native":{"query":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"ad9abaa9-855e-ea5a-4c44-cca70c68afb8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}}},"database":2,"async?":true,"cache-ttl":null}
\\x1a11ac0f8eafa38a087e13b048d225885c3d3e03cd7730b03a7065ea4874c6f7	295	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],66.51326189011355,0.0,40.97989944013221,44.999998910352616]},"async?":false}
\\xe6a4947e7bf41b3cdc84cee8cf665bee38cad7c2c6a2c329d551fe6a3fe0b082	182	{"database":2,"type":"query","query":{"source-query":{"template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}},"native":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000"},"filter":["inside",["field","lat",{"base-type":"type/Float"}],["field","lon",{"base-type":"type/Float"}],40.97989944013221,134.99999673105785,0.0,179.99999564141046]},"async?":false}
\\x77502fc5f3f2405eecccf43df8040034b1f25997931256435e70e0acdb53079b	328	{"type":"native","native":{"query":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\nLIMIT 999","template-tags":{}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x4fdd5eed1e7783daeada5db86bab1283280a7bc738ca35cc1c1a1b98e19f0b3d	297	{"database":2,"native":{"template-tags":{"label":{"id":"80873c2a-5a22-a76c-40be-31e2cefba87d","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"default":null}},"query":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999"},"type":"native","middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x647f87c67b1686e383ec5fa2e608102b6058ea0474662b53a2de08945fca23a5	281	{"database":2,"native":{"template-tags":{},"query":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\nLIMIT 999"},"type":"native","middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x4652c67c65ba9529d2a8c870a3cc06613a25b3f2c27fc49cbcd6c6efcc4ed75a	257	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"native":{"template-tags":{},"query":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\nLIMIT 999"},"database":2,"async?":true,"cache-ttl":null}
\\x9b3e76400f990f7bcec51bc860a1fd87c208b24935e2d12cd0f9a6abba0eb355	141	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"native":{"query":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["microgrids"],"target":["dimension",["template-tag","label"]]}],"async?":true,"cache-ttl":null}
\\x395533263f41f80651ec6a595c28b207afc0cf4aa925f77ee74a4ecc799bb9ad	297	{"type":"native","native":{"query":"SELECT DISTINCT name, lat, lon, co.id\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x6b49cf02d639fc411c819f25a74bca437a76fe410299321098757bb1a303d23a	331	{"type":"native","native":{"query":"SELECT DISTINCT name organisation_name, lat latitude, lon longitude, co.id organisation_id\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xd1c762900eff64000e576bd377a48ab1de6a130571b025c1c8640960a15f7e7d	254	{"type":"native","native":{"query":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x3fbbf2fc60de4c8491d051ee70c8d075b096325689179bbf5d40ebe9d88a865a	268	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"native":{"query":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"async?":true,"cache-ttl":null}
\\xcc3ebd1f86e4c25f33ef92b7d6311d12421f4137a1b010926cda9086b6ccb781	318	{"type":"native","native":{"query":"SELECT DISTINCT name, lat, lon, co.id organisation_id\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x9ed4ae9be53962b589c3bace6b41ccff5272d9558d12182573384c5be4a18375	302	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"fields":[["field",146,{"join-alias":"Coped Subject - Subject"}]],"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"fields":[["field",83,null],["field",82,null]]},"type":"query","middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x2078b60fdd0903363dd504dc0214045cdac92a8e7536226fad2aa8c87235288c	173	{"type":"query","query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"fields":[],"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"fields":[["field",83,null],["field",82,null]]},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xb0122c462b6a64594dca7f9ad14e13a934527251c5cf01cf2b36276de6234022	395	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"fields":[],"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null]]},"type":"query","middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x199853bd47d42f2f9e8fc434ab32d7b3cd118800e1e1afea4616c5affb2dcc86	194	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"fields":[],"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null]]},"type":"query","middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x3cd729ba00dcdf770f56b2d64140e804c16e4c9c0bb428b437b969fbcb274456	257	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"fields":[],"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]]},"type":"query","middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xd6cddbb87759af9d0b525bbc08606e434910e68b7337aab38ec8a22def8b66e2	156	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],40.97989944013221,-22.499999455176308,21.94304637537721,0.0]},"type":"query","async?":false}
\\xf060a1845adbd2cb04d13f1eae45c50abfac8257afbf9ffb8540cdc853fa2e08	208	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],66.51326189011355,0.0,55.77657455019159,22.499999455176308]},"type":"query","async?":false}
\\x5ffb99c4e962a21711b31eea56f695f0d2147a4a7cde2b9ec788dd0c1d590441	216	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],40.97989944013221,0.0,21.94304637537721,22.499999455176308]},"type":"query","async?":false}
\\x750b718b9765c0b1d78d33596f90e7e45a91f779482af894fccaf6baac6a95d0	21	{"database":2,"type":"query","query":{"source-table":33,"aggregation":["count"],"filter":["=",["field",86,null],"9"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x1343a9aa28f52fcb839280bbde10a1523d333a076f89b1800f237ca62f940110	37	{"database":2,"type":"query","query":{"source-table":5,"filter":["=",["field",83,null],10]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x420fd78ba8bd6f32db80f0787f7f56129e7aa1ad5aa59223011643766490465a	11	{"database":2,"type":"query","query":{"source-table":12,"aggregation":["count"],"filter":["=",["field",104,null],"10"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xc940ece80b962b7bb3ee21c87e1be4188c14fcd93241e222fb4176b206ab46ca	6	{"database":2,"type":"query","query":{"source-table":8,"aggregation":["count"],"filter":["=",["field",132,null],"10"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xf0f1a490980ed5ff55c0d67f16966839f5e56190fb3da1bc555559f78dd2c81f	7	{"database":2,"type":"query","query":{"source-table":21,"aggregation":["count"],"filter":["=",["field",89,null],"11"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xc0a31c03b6c131abed915f9d01c16fd51260097e99989f19dfc1d3310926788d	312	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],66.51326189011355,-22.499999455176308,55.77657455019159,0.0]},"type":"query","async?":false}
\\x22f572ca191f0e65fdf76199b95ad951e88ee2e9caeba885f678fc57333c868b	324	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],55.77657455019159,0.0,40.97989944013221,22.499999455176308]},"type":"query","async?":false}
\\xc31893774379a04516692a2e4dfc4f79d58c003c8c31bb2a14306f91602f173c	210	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],55.77657455019159,-44.999998910352616,40.97989944013221,-22.499999455176308]},"type":"query","async?":false}
\\xbb0c66a9a59bbe2d192911a160cbfd03fcb9744e5582f5fb2b124d325c553b2c	138	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],21.94304637537721,-44.999998910352616,0.0,-22.499999455176308]},"type":"query","async?":false}
\\x926cb9cb3ac592383eb0ecc5fb6eef02c2a0e18924c8015b831d4dbbd55c7832	14	{"database":2,"type":"query","query":{"source-table":9,"aggregation":["count"],"filter":["=",["field",125,null],"10"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xbdebf4183ee91651d92f348b6e35c11741f85ded17255ab360c7370dbf7f9898	385	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],55.77657455019159,-22.499999455176308,40.97989944013221,0.0]},"type":"query","async?":false}
\\x02bb3a091d02bd44a4dff564200a85c33c5e739330b9e2b216b32bc76459455d	90	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],40.97989944013221,-44.999998910352616,21.94304637537721,-22.499999455176308]},"type":"query","async?":false}
\\xfa869469cddf098ebd80f5b37202fae506914d74e1ed598a2e3b41423f9288b3	77	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],21.94304637537721,-22.499999455176308,0.0,0.0]},"type":"query","async?":false}
\\xe44c6d3a869cf36c175cecdcf429bc63c7b7cd69e04eccc64bbb65441606e13f	91	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],40.97989944013221,-67.49999836552892,21.94304637537721,-44.999998910352616]},"type":"query","async?":false}
\\x47fa55c8f318bf389b20509d3fe487156fea302fc6460605fbdbd8ea400a9c6b	7	{"database":2,"type":"query","query":{"source-table":21,"aggregation":["count"],"filter":["=",["field",89,null],"12"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xdaf21033590c9807aeb3c1acaf56ed840d563bd2f98eaa1c6ef8e91471a6589c	5	{"database":2,"type":"query","query":{"source-table":8,"aggregation":["count"],"filter":["=",["field",132,null],"12"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xb3eeaae2ce6bfb41368b0766224b99f38ebc03c0adc32d764465ed3ee25326b7	131	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],55.77657455019159,22.499999455176308,40.97989944013221,44.999998910352616]},"type":"query","async?":false}
\\xf5f2efba3424420c4be60664c080f2232dad83d76f404688223658305480a5b0	119	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],40.97989944013221,22.499999455176308,21.94304637537721,44.999998910352616]},"type":"query","async?":false}
\\x54b127416496fe733869382c1eec8fb63bd5fad1a5095f7cffb336b2c2c421cf	192	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],21.94304637537721,0.0,0.0,22.499999455176308]},"type":"query","async?":false}
\\x2bdd76c2b5352189c91d60232e3ff386026763b50bad6403f94b8cea7f4b6080	158	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],40.97989944013221,44.999998910352616,21.94304637537721,67.49999836552892]},"type":"query","async?":false}
\\x7fedff04ea1029158fdc64e6d54d8aab894b8510dc8880985efbf819dc24b01d	13	{"database":2,"type":"query","query":{"source-table":12,"aggregation":["count"],"filter":["=",["field",104,null],"360"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xfc78787126d4c451a298d7313af1202a1a27b621897b9fb7f63ee4313118a2c6	182	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],66.51326189011355,-44.999998910352616,55.77657455019159,-22.499999455176308]},"type":"query","async?":false}
\\x68c2eeb93301acd5bdf051d1dda1e77736ed00f021b0bcf66c72a3b11324fcc3	185	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],66.51326189011355,22.499999455176308,55.77657455019159,44.999998910352616]},"type":"query","async?":false}
\\x80daa4c76563e7a6057cd7871f0f4b9fa0b504c1dc063a35a5ce7cdce3bfd5ca	109	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],66.51326189011355,-67.49999836552892,55.77657455019159,-44.999998910352616]},"type":"query","async?":false}
\\xff3f9fc63fbeee1541de1c2e43511b275fffe40d5076f3f5bf5d8582196b0692	55	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],21.94304637537721,67.49999836552892,0.0,89.99999782070523]},"type":"query","async?":false}
\\x80244f9b15812e6722e87ad491a7e920572ce32460d5e6849746808d5e409405	86	{"query":{"source-table":17,"filter":["=",["field",61,null],"140"]},"type":"query","database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x87a6e0e3a067a907992cd5469dc15de0f3833ea199550cee1bbc2f04951647e6	35	{"database":2,"type":"query","query":{"source-table":33,"filter":["=",["field",86,null],"12"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x9155ab84fc16c81aabd47a2556bdb2b1f487ffe0c3b2749cad1487506f81a585	7	{"database":2,"type":"query","query":{"source-table":9,"aggregation":["count"],"filter":["=",["field",125,null],"12"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x56fcaf2e9db8ee4fbbe082735a1e73ac2cc2a35287d5e4c1f7bc89cb6a70f67c	178	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],55.77657455019159,-67.49999836552892,40.97989944013221,-44.999998910352616]},"type":"query","async?":false}
\\xe47de4523d89435bc9c46d78f965fda218e58d800e2dabce42638f533ed79b3f	155	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],21.94304637537721,22.499999455176308,0.0,44.999998910352616]},"type":"query","async?":false}
\\xb823f6610e7746f57cae0e33cef6c17458344430d0f1fa2bf4fe50ded8e1f5c4	182	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],55.77657455019159,44.999998910352616,40.97989944013221,67.49999836552892]},"type":"query","async?":false}
\\xd6a5c8b8ce050f6089234f81db474ea3fdaa0865c49a323817c1837387099e10	96	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],66.51326189011355,44.999998910352616,55.77657455019159,67.49999836552892]},"type":"query","async?":false}
\\xd2311268b06b381fe95b25d3e0152b0ff0deb8cb052fbbcf9f8934f03bd14284	81	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],21.94304637537721,-67.49999836552892,0.0,-44.999998910352616]},"type":"query","async?":false}
\\x1ee06ef9e3313b7f6f5fd35278e1db918a1fe6b3836bdaac8688c8899b9debcc	237	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],66.51326189011355,-89.99999782070523,55.77657455019159,-67.49999836552892]},"type":"query","async?":false}
\\x8ba698af78d89001a5c7acba2814a86fa229341569f680a060664b1fe99060d1	59	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],21.94304637537721,-89.99999782070523,0.0,-67.49999836552892]},"type":"query","async?":false}
\\x09f418a3c55081b5ee631ba74f8507d74f0f8397f786550cbde92d74425e60f2	64	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],21.94304637537721,44.999998910352616,0.0,67.49999836552892]},"type":"query","async?":false}
\\x47086e4042e0df24e62a54157ea2eb2f9a498342d93607613349b4899ea33c0f	186	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],40.97989944013221,67.49999836552892,21.94304637537721,89.99999782070523]},"type":"query","async?":false}
\\x3dc4bb7dcca2a19ddaedf3abefcd50380f3f4472c410e3e9cfceb613efff2947	87	{"database":2,"type":"query","query":{"source-table":21,"aggregation":["count"],"filter":["=",["field",89,null],"360"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x8c75d66996c877432fbd78fbda49732c695c0a3620c01d3fe675fd50fb6f39d2	11	{"database":2,"type":"query","query":{"source-table":8,"aggregation":["count"],"filter":["=",["field",132,null],"360"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xc26165fa8289f779826039e06c0c6b1ec35cd682bbd38df1234bb0a1c767a98b	167	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],40.97989944013221,-89.99999782070523,21.94304637537721,-67.49999836552892]},"type":"query","async?":false}
\\xa98f3ef4eb52ada75427ceefbea83f1fc3bd89ac41460efb8624d6cbb18549e3	9	{"database":2,"type":"query","query":{"source-table":9,"aggregation":["count"],"filter":["=",["field",125,null],"360"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	438	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"native":{"query":"SELECT DISTINCT name organisation_name, lat latitude, lon longitude, co.id organisation_id\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"async?":true,"cache-ttl":null}
\\x383f830b253551a87126b3674602de760eb793096d1c58326a28c619c61a2ae1	138	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(coped_subject.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["gas turbines","hydraulic turbines","turbines","wind turbines"],"target":["dimension",["template-tag","label"]]}],"async?":true,"cache-ttl":null}
\\x1b1948b9ee043c61eb7181d9a5bd8604a6a50f60d53d2fc079c18bef14d29a5e	162	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"native":{"query":"SELECT DISTINCT name organisation_name, lat latitude, lon longitude, co.id organisation_id\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["power lines","power plants"],"target":["dimension",["template-tag","label"]]}],"async?":true,"cache-ttl":null}
\\x3d9676ce950d9644e626d1b45b59b76c810a9261edb7cfe68de29712d18b7e0f	193	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],55.77657455019159,-89.99999782070523,40.97989944013221,-67.49999836552892]},"type":"query","async?":false}
\\xa70a8263ca485ce66e8a3060c84629190136f400ef0a88091ac649e7df802d2b	151	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(coped_subject.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["solar wind","wind energy","wind","wind farms","wind generators","wind power stations","wind turbines","windmills"],"target":["dimension",["template-tag","label"]]}],"async?":true,"cache-ttl":null}
\\x843be1249548c86e1aa01484fab7e0738ffb98e2211fe77e19504341fda085a0	170	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"native":{"query":"SELECT DISTINCT name organisation_name, lat latitude, lon longitude, co.id organisation_id\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["solar wind","wind energy","wind","wind farms","wind generators","wind power stations","wind turbines","windmills"],"target":["dimension",["template-tag","label"]]}],"async?":true,"cache-ttl":null}
\\x7adfbfea82cfe295bb8811856818d4194f4d9f23c0fbcc4b554aca3d4f4919d2	224	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],66.51326189011355,67.49999836552892,55.77657455019159,89.99999782070523]},"type":"query","async?":false}
\\x94e2217f3e136ee51d08c309635f6d09776f4d2d38015fe8bac3699f6b816c8b	21	{"type":"native","native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(coped_subject.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["solar wind","wind energy","wind","wind farms","wind generators","wind power stations","wind turbines","windmills"],"target":["dimension",["template-tag","label"]]}],"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xc188816f405b5ec24f719402801a75436de548fe92d756d0e2c88b52e6563ddd	28	{"type":"native","native":{"query":"select cp.id, cp.title, cpf.amount from coped_project cp\\n    join coped_project_fund cpf ON cpf.project_id = coped_project.id\\nwhere cpf.amount < 100000","template-tags":{}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xeeb31de90894f938da633da15b7300d96d4fe808d947860b3b132c9a758bee6d	174	{"type":"native","native":{"query":"select cp.id, cp.title, cpf.amount from coped_project cp\\n    join coped_project_fund cpf ON cpf.project_id = cp.id\\nwhere cpf.amount < 100000","template-tags":{}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x093bbe641c9df92bc13d8b371ade7506ffb3f344742716e86d49315e61433ba8	96	{"query":{"source-table":5,"filter":["=",["field",83,null],360]},"type":"query","database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x17dd2df67d58c680618608f148780b880b018444453a51b1a5b79acd833456c7	146	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"fields":[],"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"limit":999},"type":"query","middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x7b506848a55c4e731fc032bfa2a16d79ef2533bf881b4e3ee9b7f83db59d0b67	50	{"type":"native","native":{"query":"SELECT DISTINCT name organisation_name, lat latitude, lon longitude, co.id organisation_id\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["power lines","power plants"],"target":["dimension",["template-tag","label"]]}],"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x2380eddd44728b365c00374d118847eedcfadd74d3847ae1e7da90b6dc12d937	84	{"type":"native","native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(coped_subject.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\nGROUP BY organisation_id, organisation_name\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["power lines","power plants"],"target":["dimension",["template-tag","label"]]}],"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xcb82f7e9429133eea78ec94bcedb81900323c6ed3324d04169910b492b39dc8f	30	{"type":"native","native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(coped_subject.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY organisation_id, organisation_name\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["power lines","power plants"],"target":["dimension",["template-tag","label"]]}],"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xb3d335e0ae18bf7265e4ee73e5e76eca586dd727ba12e38bee0f3c134fcb595b	105	{"type":"native","native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(coped_subject.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["power lines","power plants"],"target":["dimension",["template-tag","label"]]}],"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xe130a237fade7b51ee9a25dc8108770aff017b986ef034275fc0df4466d7f45a	75	{"type":"native","native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(coped_subject.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name\\nORDER BY project_hits DESC\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["power lines","power plants"],"target":["dimension",["template-tag","label"]]}],"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x3b24f72327d8f0d4599fb56ec93156f7a8eb04f1046cac64cd9f9f6bf4d28e27	219	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"query","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"database":2,"query":{"source-table":7},"async?":true,"cache-ttl":null}
\\x53bb9e762a93d5c662022ac943c6b0a29572a791e8f23fdc153cbfdfe320b3a7	75	{"type":"native","native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(coped_subject.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["power lines","power plants"],"target":["dimension",["template-tag","label"]]}],"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x4590ee10c49cba0550f14ef9ef7752f6d5ce493e5af5750eaf86a2b709064527	177	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"native":{"query":"SELECT DISTINCT name organisation_name, lat latitude, lon longitude, co.id organisation_id\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["gas turbines","hydraulic turbines","turbines","wind turbines"],"target":["dimension",["template-tag","label"]]}],"async?":true,"cache-ttl":null}
\\x5836f3b01301ec1b70166bda95a2b7104ebefe0716f2a8e62c9ceb6d8b39ca78	181	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"query","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"database":2,"query":{"source-table":7,"fields":[["field",108,null]],"joins":[{"fields":[["field",131,{"join-alias":"Coped Project Organisation"}]],"source-table":8,"condition":["=",["field",108,null],["field",130,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":[["field",82,{"join-alias":"Coped Organisation - Organisation"}]],"source-table":5,"condition":["=",["field",132,{"join-alias":"Coped Project Organisation"}],["field",83,{"join-alias":"Coped Organisation - Organisation"}]],"alias":"Coped Organisation - Organisation"}],"filter":["=",["field",108,null],80]},"async?":true,"cache-ttl":null}
\\x09e3cd6972b75f995fcdaccdc4113b72232d26645caed5b0d0df62dafc5f215a	80	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"native":{"query":"SELECT DISTINCT name organisation_name, lat latitude, lon longitude, co.id organisation_id\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["microgrids"],"target":["dimension",["template-tag","label"]]}],"async?":true,"cache-ttl":null}
\\xe446109e4719cbc9db5747190ed4481c06c6eabc962c6e2c5382afad4f14f48c	122	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(coped_subject.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["power plants"],"target":["dimension",["template-tag","label"]]}],"async?":true,"cache-ttl":null}
\\x2c3c9426c189a16fe53bdccfa21c5cb514692d929af673d66288f870c33bd828	636	{"database":2,"query":{"source-table":7,"fields":[["field",106,null],["field",107,null],["field",109,null],["field",110,null],["field",111,null],["field",113,null],["field",114,null]]},"type":"query","middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x88d885960f3013363f1ea6e564e70a489f2b6fc82b8acd9289ff191d6d4af7ce	75	{"query":{"source-table":7,"filter":["=",["field",108,null],"2086"]},"type":"query","database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x103fe9e491bf5de3905337700fad9ae72e10c9f462e1b1b35534d4c9c2a57c5e	564	{"database":2,"query":{"source-table":7},"type":"query","middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xfc8106d2ec863b1333e775e91b2b79437fa1e49d328f2f8777a17696e38ce363	98	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(coped_subject.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["microgrids"],"target":["dimension",["template-tag","label"]]}],"async?":true,"cache-ttl":null}
\\x4b66221f051e244ab44c4d5b8987b303092a4340c56a59cd580f40f25f5ec960	120	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"native":{"query":"SELECT DISTINCT name organisation_name, lat latitude, lon longitude, co.id organisation_id\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["power plants"],"target":["dimension",["template-tag","label"]]}],"async?":true,"cache-ttl":null}
\\x17425f56f2b9c4bf1f65f5c2b99a7c4f55b44e57d4f083c4690e03f42741dcb9	560	{"type":"query","query":{"source-table":7,"fields":[["field",106,null],["field",107,null],["field",109,null],["field",110,null],["field",111,{"temporal-unit":"default"}],["field",113,{"temporal-unit":"default"}],["field",114,null],["field",108,null]]},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x58f785bcce4d51ef20eaa22ab74e5b16c2504773f0d761d6d6c4d2110d23fd48	8	{"database":2,"type":"query","query":{"source-table":37,"aggregation":["count"],"filter":["=",["field",79,null],"2086"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x4fb59c47e2123fa459cbf35462100580c94b8225acb98ad9acce6da98a4ab4ae	84	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(coped_subject.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["power lines","high voltage power lines","electric power lines"],"target":["dimension",["template-tag","label"]]}],"async?":true,"cache-ttl":null}
\\xc5704cca77929c29bb1cd4209cb3b769bcd1f872b614d5b9e34f7a1556bd9d90	382	{"type":"native","native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(cpo.organisation_id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name, cpo.organisation_id\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x187418eddb3c52fe6f13ae074c65aaf42fa75bc30b7adb88ef5cd3089cb488f6	31	{"type":"native","native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(cp.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project cp ON cp.id = cpo.project_id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY cp.id, coped_subject.id\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x45c9121af0414d965a21bd75a33cae888320d118b512eca8df1873b9f6f69991	329	{"type":"native","native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(cp.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project cp ON cp.id = cpo.project_id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY cp.id, co.id, coped_subject.id\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x3eb1b2d910f1e5d921dfdda7f9e1922deaf943aedec551eace4e7738d5325bb4	312	{"type":"native","native":{"query":"SELECT co.name, count(cp.id)\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.id\\n","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x52dc1f283c4dbf053fc533b74fb0b2ff7caa8e4ce5b8f45553753a847273cf33	347	{"type":"native","native":{"query":"SELECT co.name, count(cp.id)\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, cs.label\\n","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xafce2cd7703ada38dd0294f77039e7d2459f0e51aab639114f0a4ec1267cefbe	418	{"type":"native","native":{"query":"SELECT co.name, count(cp.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, cs.label\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x9df28ce7c95b565accc11ba87c45c201eb52e883cb0245fd797af73025807d81	287	{"type":"native","native":{"query":"SELECT co.name, count(cp.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.id\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x919ed64d7d0cc66439bec5b2def2f8b8c1571f2fb65ee11d91e1ec852552b725	329	{"type":"native","native":{"query":"SELECT co.name, count(cp.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x54d6a751a83bbe3d4662ec7559f8da8ea07a0f7970037075c8975c27cae25423	107	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"native":{"query":"SELECT DISTINCT name organisation_name, lat latitude, lon longitude, co.id organisation_id\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["power lines","high voltage power lines","electric power lines"],"target":["dimension",["template-tag","label"]]}],"async?":true,"cache-ttl":null}
\\x7ee1ab1352968da1adbad58e84939629852e3f89d65de871e0b3d6abd05c5c6c	226	{"type":"native","native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(cpo.organisation_id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x73722bc22b3fd98d64b05b3c8428129ba17e9ddbe8220f75914333bdd1a89fff	344	{"type":"native","native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(cp.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project cp ON cp.id = cpo.project_id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, cp.id\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x9a53d143b134ac2972f7c267c8c0d079ab0297303a967a1020895a95294271eb	333	{"type":"native","native":{"query":"SELECT co.id organisation_id, name organisation_name, count(cp.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project cp ON cp.id = cpo.project_id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, cp.id\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xfb157e8c136ffa21133558a81f99369e7ae5ed6369dde8cad2de646a9e7f20e6	419	{"type":"native","native":{"query":"SELECT co.id organisation_id, name organisation_name, count(cp.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project cp ON cp.id = cpo.project_id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, cp.id, coped_subject.id\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x59a42eab268e4f84fb8e4957adac89ae8369533e324c02eab35ab8d15912740d	471	{"type":"native","native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(cp.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project cp ON cp.id = cpo.project_id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, cp.id, coped_subject.id\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x606107b82889442b9eb540ea0ed682cd670a86d83c7cdab80086b5597de38053	1067	{"type":"native","native":{"query":"SELECT *\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n","template-tags":{}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xa6a6d8399f14c9af6cc39772926c186c0d635dfce7a3df6e96cc886ee7dcbdda	402	{"type":"native","native":{"query":"SELECT DISTINCT co.name, count(cp.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.name, cs.label\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xba7c2fa77a86ba98e12feeface2867ab0b1ff973de7e9c95886546d0138d3226	449	{"type":"native","native":{"query":"SELECT DISTINCT co.name, count(cp.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY cs.label, co.id\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x47bcf3dcb06d2da68b415a07d4ce3dcdbd9d39d64033452fc67eca03b534c00a	445	{"type":"native","native":{"query":"SELECT co.name, count(cp.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY cs.label, co.name, co.id\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x191511173f41a8251c3f71ec2ad9644cbb82b502fe5ceb22b6c161bbe33b46d6	258	{"type":"native","native":{"query":"SELECT co.name, count(cp.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.name, co.id\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xbfc7f92f55de7d095b226a96e213f9bf82f6a7eac2d94f20f0f89732956d6606	245	{"type":"native","native":{"query":"SELECT co.name, count(cp.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.name\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x5aa344beb96b9d4ab535df90043c756bdf3704abdeccd70534fd1e974ca194fe	275	{"type":"native","native":{"query":"SELECT co.name, count(cp.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.name, cp.id\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xe9a627f9c1bc2c6ab3ca95d256b1e26993debcc3b9d9559f030c5897fa8b6b0d	24	{"type":"native","native":{"query":"SELECT co.name, cp.id\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.name, cp.id\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x7baebe5d03035b649be8041ae3bfdeea78a01b8e2dba1f061d15f90aa08adc23	327	{"type":"native","native":{"query":"SELECT co.name, cp.id\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.name, cp.id\\n","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x36c7a05853d3014306b0cd6cc5b24458390e99b9c7b92d2878c3a3aee773a213	408	{"type":"native","native":{"query":"SELECT co.name, count(cp.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name, cs.label\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xd6753ee905e1ae1cc7f0ec25387b8b337c37fdc30f979d94a0833affcec53c41	331	{"type":"native","native":{"query":"SELECT co.name, count(cp.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.name, cs.label\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xa7f404acff8ee194cdb5131c8ef65639b44e401d734f9fe98e76bb984561f556	25	{"type":"native","native":{"query":"SELECT co.id, co.name, count(cp.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.name, cs.label\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xa99c5e3468c103e2f6097a14348189a37b4fad92ef8c53ff634428400814d70c	339	{"type":"native","native":{"query":"SELECT co.id, co.name, count(cp.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name, cs.label\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x78164292e78ee57f83d97bc341fce1e747b46951d7b7a207318531f6366235f7	360	{"type":"native","native":{"query":"SELECT co.id, co.name, count(cp.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.name, co.id, cs.label\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xb68ad55c51d5823481f5ce7cddc789530c209bc49c47836082982560a7dfb037	469	{"type":"native","native":{"query":"SELECT DISTINCT co.id, co.name, count(cp.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.name, co.id, cs.label\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xc8cad119be21987b9c88308a6aa949ee6be7b8304c846ef4dc6c37fdea2aa0bd	387	{"type":"native","native":{"query":"SELECT co.name, cp.id, count(cp.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name, cp.id, cs.id\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xe92fbfcc5523060ba697eafdb6761d97899f5612947c41f2fff426cbdfa118cb	47	{"type":"native","native":{"query":"SELECT co.name, cp.id, count(cp.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name, cp.id, cs.id\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"parameters":[{"type":"category","value":["microgrids"],"target":["dimension",["template-tag","label"]]}],"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xdc1f2bc1a9ddba29384478325e1c84060a4266ff5739b83e6a3f971274ac8864	81	{"type":"native","native":{"query":"SELECT co.name, cp.id, count(cp.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject ON cps.subject_id = coped_subject.id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name, cp.id, coped_subject.id\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"parameters":[{"type":"category","value":["microgrids"],"target":["dimension",["template-tag","label"]]}],"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xd9abbf26da47cb171feaf11d145e546e0ba7cb44e3ca225985941df85efc30cc	313	{"type":"native","native":{"query":"SELECT co.name, cp.id\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name, cp.id\\n","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x4d0d9db4ffffed8a2306aa5bd2097cff3db9e944f1ca6bafc2ea8106cd35ce22	266	{"type":"native","native":{"query":"SELECT co.name, cp.id, count(cp.id)\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name, cp.id\\n","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x37be49163739427db886a5545872d8300aaa2d1342ed523d1c4fdccc0153a0de	325	{"type":"native","native":{"query":"SELECT co.name, cp.id, count(cp.id)\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject cs ON cps.subject_id = cs.id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name, cp.id, cs.id\\n","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x23eccb32b52be1cd92c713c07b1424ab56da8d8ae30db686d1033e32c1660cbe	34	{"type":"native","native":{"query":", coped_subject.id","template-tags":{}},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xe46c52df71875a4c68bd4d870012d26732c544e8a965b63ebf0abee26bbf3a6e	80	{"type":"native","native":{"query":"SELECT co.name organisation_name, cp.id project_id, count(cp.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject ON cps.subject_id = coped_subject.id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name, cp.id\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"parameters":[{"type":"category","value":["microgrids"],"target":["dimension",["template-tag","label"]]}],"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x246fd5923b029aecb71557ce1b011a98ffe07e0ce150a601c821dfef23f52534	57	{"type":"native","native":{"query":"SELECT co.name organisation_name, cp.id project_id, count(cp.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject ON cps.subject_id = coped_subject.id\\n[[WHERE {{label}}]]\\nGROUP BY cp.id, co.id, co.name\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"parameters":[{"type":"category","value":["microgrids"],"target":["dimension",["template-tag","label"]]}],"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x7e0e3b63bfda45839ff92ea7a6fbbaff89eac8100305f1c3ad26e74ef673e016	73	{"type":"native","native":{"query":"SELECT co.name organisation_name, cp.id project_id, count(co.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject ON cps.subject_id = coped_subject.id\\n[[WHERE {{label}}]]\\nGROUP BY cp.id, co.id, co.name\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"parameters":[{"type":"category","value":["microgrids"],"target":["dimension",["template-tag","label"]]}],"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xea83d312bdc60d58551390ac1d923f47b3ce544c4ab4ed6866e601afa43daaef	9	{"database":2,"type":"query","query":{"source-table":28,"aggregation":["count"],"filter":["=",["field",115,null],"2086"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x46a65b33a3634e82f7d3c92790d57045855ff82a58abb557178f6a8db756b3dd	67	{"type":"native","native":{"query":"SELECT co.name organisation_name, cp.id project_id, count(cp.id) hits\\nFROM coped_project cp\\n    JOIN coped_project_organisation cpo ON cp.id = cpo.project_id\\n    JOIN coped_organisation co ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cp.id = cps.project_id\\n    JOIN coped_subject ON cps.subject_id = coped_subject.id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name, cp.id, coped_subject.id\\nORDER BY hits DESC","template-tags":{"label":{"id":"63ef1411-64e2-6867-39b5-e16dbbb8e8c8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"widget-type":"category","default":null}}},"database":2,"parameters":[{"type":"category","value":["microgrids"],"target":["dimension",["template-tag","label"]]}],"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x516e07d52dd30488e2b477a52fcf90ec656790f446998f998761bee3db08488a	114	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(coped_subject.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["power lines","power plants"],"target":["dimension",["template-tag","label"]]}],"async?":true,"cache-ttl":null}
\\xe52d8ecf5363a3402d7969e3b21a96aed2d9ade6d3bdd00aaeb871e0338a0ab9	71	{"database":2,"type":"query","query":{"source-table":28,"filter":["=",["field",115,null],"2086"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x468b781f1e2b89bf52076630fd1ac521987bfcbe88e67dc58e0321e4f8a121f5	25	{"database":2,"type":"query","query":{"source-table":37,"aggregation":["count"],"filter":["=",["field",76,null],"2086"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xa2d009365e05084e437614b049a935b08ed99587bdaba303603a66238ed1d752	182	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":null},"native":{"query":"SELECT DISTINCT name organisation_name, lat latitude, lon longitude, co.id organisation_id\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["gas turbine plants","gas turbines","hydraulic turbines","turbines","wind turbines"],"target":["dimension",["template-tag","label"]],"name":"Subject(s)","slug":"subject(s)","id":"7d611dc4","filteringParameters":[]}],"async?":true,"cache-ttl":null}
\\x67a6a5ddd693a1e4583e520c46bd45bb31f960cb2bbbf7c28bfa75e25ed77dfa	98	{"query":{"source-table":6,"filter":["=",["field",144,null],"4711"]},"type":"query","database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x7b5eb7019fe1fd69e78f81764dd834d4cef85017680484f0de671acf342a7f1c	12	{"database":2,"type":"query","query":{"source-table":5,"aggregation":["count"],"filter":["=",["field",84,null],"4711"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xe1c0c3d9ecdcc332661a9f47bc16b6961288c7db580f97b5afe76f0b412d8b4e	28	{"database":2,"type":"query","query":{"source-table":30,"aggregation":["count"],"filter":["=",["field",101,null],"1645"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x1bae91e5d5a4e9c73dbec18b6cb7b0afdef41debc8e45d7f74fe2ec4cf91d707	17	{"database":2,"type":"query","query":{"source-table":9,"aggregation":["count"],"filter":["=",["field",120,null],"2086"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x9bb2a6ea086168bcbfee96588c731a0422be27760a43c4e1f04a7860f151f2eb	6	{"database":2,"type":"query","query":{"source-table":8,"aggregation":["count"],"filter":["=",["field",130,null],"2086"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xdae44f69b78829297add884f535a02f9dc7f1e596affe2a2b50d3cb86d77c444	85	{"database":2,"type":"query","query":{"source-table":19,"filter":["=",["field",139,null],"2086"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x285a5554c58f1bfa520e14ca4a5938070b16c76dc3400be6a457aa5cbcb24075	111	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(coped_subject.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["fishing","Fishing Act"],"target":["dimension",["template-tag","label"]]}],"async?":true,"cache-ttl":null}
\\xbfea33e7eb228dd3f31db644b046a3087f5c6e4336b605df1c07ec08de57f58b	13	{"database":2,"type":"query","query":{"source-table":11,"aggregation":["count"],"filter":["=",["field",126,null],"2086"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x22a8fd97e3c3f184118f34bfa83b60a8761a49b5ba67083f1f0da2509f53a223	200	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":null},"native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(coped_subject.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["gas turbine plants","gas turbines","hydraulic turbines","turbines","wind turbines"],"target":["dimension",["template-tag","label"]],"name":"Subject(s)","slug":"subject(s)","id":"7d611dc4","filteringParameters":[]}],"async?":true,"cache-ttl":null}
\\xa33cd1e4eca8cc6a1044d88fec257ae50f703c6a8bc6243dd2de03e6a68e7899	14	{"database":2,"type":"query","query":{"source-table":18,"aggregation":["count"],"filter":["=",["field",137,null],"1645"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x0711877b487bc0c37a2ca4a1851fa6ca562e0dcbaeef3b22a4b024a701517197	129	{"database":2,"type":"query","query":{"source-table":12,"filter":["=",["field",103,null],"1645"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x7ab3a350a8794bad9955ae17c76bed3e47f48fc5224464b00deb995e8bf7de52	27	{"query":{"source-table":5,"filter":["=",["field",83,null],"117"]},"type":"query","database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x96aa6cf5e68fa30f1ab01feb7618bb245ef113d3d6787fba7c991fd7e107b6d3	9	{"database":2,"type":"query","query":{"source-table":8,"aggregation":["count"],"filter":["=",["field",132,null],"117"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xd240afb67d0b0170d3f7833fc1cf43d6fbb7caaa64c8e89176b648f732dab42d	63	{"database":2,"type":"query","query":{"source-table":8,"filter":["=",["field",132,null],"117"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x9db94e842eb9c065c628490ac3bac5a7aae3abe74a4e9323c16a06bcb33469d8	8	{"database":2,"type":"query","query":{"source-table":18,"aggregation":["count"],"filter":["=",["field",134,null],"2086"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x6ff917cecaf7968b623c28821b469d50d8fd7dff21e536da6e163b30316172dc	127	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"native":{"query":"SELECT DISTINCT name organisation_name, lat latitude, lon longitude, co.id organisation_id\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","value":["fishing","Fishing Act"],"target":["dimension",["template-tag","label"]]}],"async?":true,"cache-ttl":null}
\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	347	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(coped_subject.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"async?":true,"cache-ttl":null}
\\xa0655e96ea90524114ca81a8e14d1854226c8fab83e17105416e1e4288cfcc23	7	{"database":2,"type":"query","query":{"source-table":19,"aggregation":["count"],"filter":["=",["field",139,null],"2086"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x81613dd5240c8a287a0a33215984f4e795c94ad298a0a9d5708145b8be0605b4	573	{"database":2,"query":{"source-table":7,"fields":[["field",108,null],["field",106,null],["field",107,null],["field",109,null],["field",110,null],["field",111,{"temporal-unit":"default"}],["field",113,{"temporal-unit":"default"}],["field",114,null]]},"type":"query","middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x0485c4bbcdffad998953aff4b625a0a0a137286872fb80d99815eba8edfa7b61	277	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":false,"process-viz-settings?":false},"native":{"query":"SELECT coped_id, title\\nFROM coped_project\\n[[WHERE title LIKE {{title}}]]","template-tags":{"title":{"id":"f75783f7-df91-e4e6-0035-2a0d8d2c8bdc","name":"title","display-name":"Title","type":"text"}}},"database":2,"async?":true,"cache-ttl":null}
\\x151cfe7ff951ca254fa3c0be6a12aedc30eea47047f8c66fd3e85ddb060de229	437	{"database":2,"query":{"source-table":7,"fields":[],"joins":[{"fields":"all","source-table":8,"condition":["=",["field",108,null],["field",130,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"all","source-table":5,"condition":["=",["field",132,{"join-alias":"Coped Project Organisation"}],["field",83,{"join-alias":"Coped Organisation - Organisation"}]],"alias":"Coped Organisation - Organisation"}]},"type":"query","middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x2a7bddafce7df525ea5f433b43df046d83dc9787b058bff87177afd2eef30ace	66	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":null},"native":{"query":"SELECT DISTINCT name organisation_name, lat latitude, lon longitude, co.id organisation_id\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","target":["dimension",["template-tag","label"]],"slug":"subject(s)","value":"algae","name":"Subject(s)","id":"7d611dc4","filteringParameters":[]}],"async?":true,"cache-ttl":null}
\\x2d9f34c32bc11c0150389d08b8887eb2f054a38a7f6d751cee8519b56d847718	254	{"database":2,"query":{"source-table":10},"type":"query","middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xa9dd8fd5655856d6188b1e0ee4fa529eb26b05a523b9cf1f0244c1f1be17bd9f	555	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"query","middleware":{"js-int-to-string?":true,"ignore-cached-results?":null},"database":2,"query":{"source-table":7,"fields":[["field",108,null],["field",106,null],["field",107,null],["field",109,null],["field",110,null],["field",111,{"temporal-unit":"default"}],["field",113,{"temporal-unit":"default"}],["field",114,null]]},"async?":true,"cache-ttl":null}
\\x9be1dc2ea449e4d03eeaf7d8d1d33a4aaabdee3a8dbd402b2cf21f5fcf7a62b9	66	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":null},"native":{"query":"SELECT coped_id, title\\nFROM coped_project\\n[[WHERE title LIKE {{title}}]]","template-tags":{"title":{"id":"f75783f7-df91-e4e6-0035-2a0d8d2c8bdc","name":"title","display-name":"Title","type":"text"}}},"database":2,"parameters":[{"type":"category","value":"power","target":["variable",["template-tag","title"]]}],"async?":true,"cache-ttl":null}
\\x8ee6c64bbde4986c46cafa5a00435e5c24747de9ef7d0cbf6a935a7151e7aca6	147	{"type":"query","query":{"source-table":7,"fields":[["field",108,null]],"joins":[{"fields":"none","source-table":8,"condition":["=",["field",108,null],["field",130,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":[["field",82,{"join-alias":"Coped Organisation - Organisation"}]],"source-table":5,"condition":["=",["field",132,{"join-alias":"Coped Project Organisation"}],["field",83,{"join-alias":"Coped Organisation - Organisation"}]],"alias":"Coped Organisation - Organisation"}]},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xd2258362753c79a0dc2107409be48cd00766037fa158c3786a679db333526eea	193	{"database":2,"query":{"source-table":7,"fields":[["field",108,null]],"joins":[{"fields":[["field",131,{"join-alias":"Coped Project Organisation"}]],"source-table":8,"condition":["=",["field",108,null],["field",130,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":[["field",82,{"join-alias":"Coped Organisation - Organisation"}]],"source-table":5,"condition":["=",["field",132,{"join-alias":"Coped Project Organisation"}],["field",83,{"join-alias":"Coped Organisation - Organisation"}]],"alias":"Coped Organisation - Organisation"}]},"type":"query","middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xd795319a95535cb43b4fd9aa217197ce2e28175d260359c3bae12947efe972bd	65	{"type":"query","query":{"source-table":7,"fields":[["field",108,null]],"joins":[{"fields":[["field",131,{"join-alias":"Coped Project Organisation"}]],"source-table":8,"condition":["=",["field",108,null],["field",130,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":[["field",82,{"join-alias":"Coped Organisation - Organisation"}]],"source-table":5,"condition":["=",["field",132,{"join-alias":"Coped Project Organisation"}],["field",83,{"join-alias":"Coped Organisation - Organisation"}]],"alias":"Coped Organisation - Organisation"}],"filter":["=",["field",108,null],80]},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xf71f161a1953ea3bad4654f814530354fe8264a3d0746013193abccfdb94819e	89	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":null},"native":{"query":"SELECT coped_id, title\\nFROM coped_project\\n[[WHERE UPPER(title) LIKE UPPER(CONCAT('%', {{title}}, '%'))]]\\n","template-tags":{"title":{"id":"f75783f7-df91-e4e6-0035-2a0d8d2c8bdc","name":"title","display-name":"Title","type":"text"}}},"database":2,"parameters":[{"type":"category","value":"microchip","target":["variable",["template-tag","title"]]}],"async?":true,"cache-ttl":null}
\\xc3449e9dfb6adffadd0f1b592e6020695e698df89e08512d493784f4d2864089	78	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":null},"native":{"query":"SELECT coped_id, title\\nFROM coped_project\\n[[WHERE UPPER(title) LIKE UPPER(CONCAT('%', {{title}}, '%'))]]\\n","template-tags":{"title":{"id":"f75783f7-df91-e4e6-0035-2a0d8d2c8bdc","name":"title","display-name":"Title","type":"text"}}},"database":2,"parameters":[{"type":"category","value":"microgrid","target":["variable",["template-tag","title"]]}],"async?":true,"cache-ttl":null}
\\xa2e662989d88513537dcafc14e7cf4ba24804ad36f03fe7c6ca9dae56077d745	79	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":null},"native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(coped_subject.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2,"parameters":[{"type":"category","target":["dimension",["template-tag","label"]],"slug":"subject(s)","value":"algae","name":"Subject(s)","id":"7d611dc4","filteringParameters":[]}],"async?":true,"cache-ttl":null}
\\x75e181649774f0850ddb62a1419ecfd7d89101813d9ab6a09844420d3ca2ca6d	77	{"type":"query","query":{"source-table":10,"filter":["contains",["field",91,null],"david",{"case-sensitive":false}]},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x4c7d40d7d7155e6de897600339da5206722ea3cbdb34bc149c495e6c2f5cbea5	16	{"database":2,"type":"query","query":{"source-table":9,"aggregation":["count"],"filter":["=",["field",125,null],"117"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xc4470fe6a68808e4e82ad6332fc2ef5c620773559541286fb849d78bc163ad59	13	{"database":2,"type":"query","query":{"source-table":7,"aggregation":["count"],"filter":["=",["field",112,null],"4711"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x35042f4612e1419d2e2dfd14d4f7f00c90d35f4082b0df9447de869a39cfa14b	82	{"query":{"source-table":10,"filter":["=",["field",94,null],"1645"]},"type":"query","database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xafc1c835bcbce90758d034b0de485289b2d3f89c4f5cfd0fc2c0a954690b4445	62	{"database":2,"type":"query","query":{"source-table":12,"aggregation":["count"],"filter":["=",["field",103,null],"1645"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x496e88a46bc77ab67f7b8dd19bfb416cc589b461252156d2023f49759d77f28c	13	{"database":2,"type":"query","query":{"source-table":21,"aggregation":["count"],"filter":["=",["field",89,null],"117"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x52769f6f24dfb47a6aa2fc0e7ca2d1e394cafa81a79eddb733b1ebc4bbceeb11	53	{"type":"native","native":{"query":"SELECT coped_id, title\\nFROM coped_project\\n[[WHERE title LIKE {{title}}]]","template-tags":{"title":{"id":"f75783f7-df91-e4e6-0035-2a0d8d2c8bdc","name":"title","display-name":"Title","type":"text"}}},"database":2,"parameters":[{"type":"category","value":"micro","target":["variable",["template-tag","title"]]}],"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x6549080b267f41c37a2df2cb14e4539056f2d48b537ada0fe621330004720b57	32	{"type":"native","native":{"query":"SELECT coped_id, title\\nFROM coped_project\\n[[WHERE title LIKE '%{{title}}%']]","template-tags":{"title":{"id":"f75783f7-df91-e4e6-0035-2a0d8d2c8bdc","name":"title","display-name":"Title","type":"text"}}},"database":2,"parameters":[{"type":"category","value":"micro","target":["variable",["template-tag","title"]]}],"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xa294ef7125e5976a86bcfafad7c83e4e1d6a0e22154e73a5a952cc5b86d9ddbb	18	{"type":"native","native":{"query":"SELECT coped_id, title\\nFROM coped_project\\nWHERE title LIKE '%{{title}}%'","template-tags":{"title":{"id":"f75783f7-df91-e4e6-0035-2a0d8d2c8bdc","name":"title","display-name":"Title","type":"text"}}},"database":2,"parameters":[{"type":"category","value":"micro","target":["variable",["template-tag","title"]]}],"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x7d7ce59de199c6740180f0d2906a4957e29b671673c039a8cf2a21f3b0a39dd9	70	{"type":"native","native":{"query":"SELECT coped_id, title\\nFROM coped_project\\n[[WHERE UPPER(title) LIKE UPPER(CONCAT('%', {{title}}, '%'))]]\\n","template-tags":{"title":{"id":"f75783f7-df91-e4e6-0035-2a0d8d2c8bdc","name":"title","display-name":"Title","type":"text"}}},"database":2,"parameters":[{"type":"category","value":"micro","target":["variable",["template-tag","title"]]}],"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xccca714e428a5813eb6438385a78e7d8bdbb2e6cca5c2f2fb3a2d52c372643cd	58	{"type":"native","native":{"query":"SELECT coped_id, title\\nFROM coped_project\\n[[WHERE UPPER(title) LIKE UPPER(CONCAT('%', {{title}}, '%'))]]\\n","template-tags":{"title":{"id":"f75783f7-df91-e4e6-0035-2a0d8d2c8bdc","name":"title","display-name":"Title","type":"text"}}},"database":2,"parameters":[{"type":"category","value":"mirco","target":["variable",["template-tag","title"]]}],"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x8a7a08dfdc4e6cd5c6f627a7ac78a4ff31c8d69dd2da804640af0cd8b2c98587	35	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":null},"native":{"query":"SELECT coped_id, title\\nFROM coped_project\\n[[WHERE title LIKE {{title}}]]","template-tags":{"title":{"id":"f75783f7-df91-e4e6-0035-2a0d8d2c8bdc","name":"title","display-name":"Title","type":"text"}}},"database":2,"parameters":[{"type":"category","value":"POWER","target":["variable",["template-tag","title"]]}],"async?":true,"cache-ttl":null}
\\x8e0f623e5770e1548846ce9be4ae755c2086e6e2c74eb12a72c582ff38699a34	61	{"type":"native","native":{"query":"SELECT coped_id, title\\nFROM coped_project\\n[[WHERE UPPER(title) LIKE UPPER(CONCAT('%', {{title}}, '%'))]]\\n","template-tags":{"title":{"id":"f75783f7-df91-e4e6-0035-2a0d8d2c8bdc","name":"title","display-name":"Title","type":"text"}}},"database":2,"parameters":[{"type":"category","value":"power","target":["variable",["template-tag","title"]]}],"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x8f73f42631e58b9fc3b507e4c866b842dbebd7cfb34a671e0d5a616fa248a9e0	108	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":null},"native":{"query":"SELECT coped_id, title\\nFROM coped_project\\n[[WHERE UPPER(title) LIKE UPPER(CONCAT('%', {{title}}, '%'))]]\\n","template-tags":{"title":{"id":"f75783f7-df91-e4e6-0035-2a0d8d2c8bdc","name":"title","display-name":"Title","type":"text"}}},"database":2,"parameters":[{"type":"category","value":"power","target":["variable",["template-tag","title"]]}],"async?":true,"cache-ttl":null}
\\x0d254b1212dba21ec0669062cab6eee06aa3c94517076680e61d6c4a508468f2	374	{"database":2,"query":{"source-table":7,"joins":[{"fields":[["field",131,{"join-alias":"Coped Project Organisation"}]],"source-table":8,"condition":["=",["field",108,null],["field",130,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":[["field",82,{"join-alias":"Coped Organisation - Organisation"}]],"source-table":5,"condition":["=",["field",132,{"join-alias":"Coped Project Organisation"}],["field",83,{"join-alias":"Coped Organisation - Organisation"}]],"alias":"Coped Organisation - Organisation"}]},"type":"query","middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x9c794d51a286105a43232d21f9290675cace2d127a80244d9cb7b5d544d27528	68	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":null},"native":{"query":"SELECT coped_id, title\\nFROM coped_project\\n[[WHERE UPPER(title) LIKE UPPER(CONCAT('%', {{title}}, '%'))]]\\n","template-tags":{"title":{"id":"f75783f7-df91-e4e6-0035-2a0d8d2c8bdc","name":"title","display-name":"Title","type":"text"}}},"database":2,"parameters":[{"type":"category","value":"microgrids","target":["variable",["template-tag","title"]]}],"async?":true,"cache-ttl":null}
\\x4054ffcdd5d7b3fa3f1921f01968e42050db816890a770354aec6f54a3503d28	66	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":null},"native":{"query":"SELECT coped_id, title\\nFROM coped_project\\n[[WHERE UPPER(title) LIKE UPPER(CONCAT('%', {{title}}, '%'))]]\\n","template-tags":{"title":{"id":"f75783f7-df91-e4e6-0035-2a0d8d2c8bdc","name":"title","display-name":"Title","type":"text"}}},"database":2,"parameters":[{"type":"category","value":"micro","target":["variable",["template-tag","title"]]}],"async?":true,"cache-ttl":null}
\\x12a466760fbcbb8a15e06b8108dffde5789d8993eb882105be96ec9df5905392	414	{"constraints":{"max-results":10000,"max-results-bare-rows":2000},"type":"native","middleware":{"js-int-to-string?":true,"ignore-cached-results?":null},"native":{"query":"SELECT coped_id, title\\nFROM coped_project\\n[[WHERE UPPER(title) LIKE UPPER(CONCAT('%', {{title}}, '%'))]]\\n","template-tags":{"title":{"id":"f75783f7-df91-e4e6-0035-2a0d8d2c8bdc","name":"title","display-name":"Title","type":"text"}}},"database":2,"async?":true,"cache-ttl":null}
\\x4f6532b5e3325f41e088e802c61eecdbe9ec078142edf9115decf7c9c1037f15	9	{"database":2,"type":"query","query":{"source-table":10,"aggregation":["count"],"filter":["=",["field",97,null],"4711"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x1b5741529e54bd4dd3e8fa6e0b83b203d167987d8d72b3f441ac8c25b65f1263	88	{"database":2,"query":{"source-table":7,"joins":[{"fields":[["field",131,{"join-alias":"Coped Project Organisation"}]],"source-table":8,"condition":["=",["field",108,null],["field",130,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":[["field",83,{"join-alias":"Coped Organisation - Organisation"}],["field",82,{"join-alias":"Coped Organisation - Organisation"}]],"source-table":5,"condition":["=",["field",132,{"join-alias":"Coped Project Organisation"}],["field",83,{"join-alias":"Coped Organisation - Organisation"}]],"alias":"Coped Organisation - Organisation"}],"filter":["=",["field",108,null],80]},"type":"query","middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\xe5c486d5b737e4a2aeec21c9390803fa2abf15096ad0fdcb45c5114cce0dbc46	77	{"type":"query","query":{"source-table":7,"joins":[{"fields":[["field",131,{"join-alias":"Coped Project Organisation"}]],"source-table":8,"condition":["=",["field",108,null],["field",130,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":[["field",82,{"join-alias":"Coped Organisation - Organisation"}]],"source-table":5,"condition":["=",["field",132,{"join-alias":"Coped Project Organisation"}],["field",83,{"join-alias":"Coped Organisation - Organisation"}]],"alias":"Coped Organisation - Organisation"}],"filter":["=",["field",108,null],80]},"database":2,"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x2852b70ea13402d95d3be22928243809f6d18c9b096209c38b469e13e92c6e44	10	{"database":2,"type":"query","query":{"source-table":9,"aggregation":["count"],"filter":["=",["field",124,null],"4711"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x8091c8e4ba87f6b8a911336f6a7d558b6deaef3ea8481215fb8bc8393d505790	17	{"database":2,"type":"query","query":{"source-table":12,"aggregation":["count"],"filter":["=",["field",104,null],"117"]},"middleware":{"js-int-to-string?":true,"add-default-userland-constraints?":true}}
\\x23345d4a9894ecf38c875088cdbac9f0eb89c3dc653520cffe95a3bcfdd5ab93	169	{"database":2,"query":{"source-table":5,"joins":[{"fields":"none","source-table":33,"condition":["=",["field",83,null],["field",86,{"join-alias":"Coped Organisation Addresses"}]],"alias":"Coped Organisation Addresses"},{"fields":"none","source-table":17,"condition":["=",["field",87,{"join-alias":"Coped Organisation Addresses"}],["field",61,{"join-alias":"Coped Address - Address"}]],"alias":"Coped Address - Address"},{"fields":[["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"source-table":35,"condition":["=",["field",58,{"join-alias":"Coped Address - Address"}],["field",72,{"join-alias":"Coped Geo Data - Geo"}]],"alias":"Coped Geo Data - Geo"},{"fields":"none","source-table":8,"condition":["=",["field",83,null],["field",132,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":"none","source-table":19,"condition":["=",["field",130,{"join-alias":"Coped Project Organisation"}],["field",139,{"join-alias":"Coped Project Subject - Project"}]],"alias":"Coped Project Subject - Project"},{"source-table":38,"condition":["=",["field",141,{"join-alias":"Coped Project Subject - Project"}],["field",148,{"join-alias":"Coped Subject - Subject"}]],"alias":"Coped Subject - Subject"}],"breakout":[["field",83,null],["field",82,null],["field",71,{"join-alias":"Coped Geo Data - Geo"}],["field",73,{"join-alias":"Coped Geo Data - Geo"}]],"filter":["inside",["field",71,null],["field",73,null],55.77657455019159,67.49999836552892,40.97989944013221,89.99999782070523]},"type":"query","async?":false}
\.


--
-- Data for Name: query_cache; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.query_cache (query_hash, updated_at, results) FROM stdin;
\.


--
-- Data for Name: query_execution; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.query_execution (id, hash, started_at, running_time, result_rows, native, context, error, executor_id, card_id, dashboard_id, pulse_id, database_id, cache_hit) FROM stdin;
1	\\xeda8a8294ae62b519a7a42329d086bf06cdf2923f995fe0e36afd0644bbdc2e9	2021-12-23 10:49:26.747101+00	568	999	t	ad-hoc	\N	1	\N	\N	\N	2	f
2	\\x5193da9d9a97c75c6d5b356bf554cb0c20ea11480e57454219d05ead2e6ad224	2021-12-23 10:49:42.456147+00	299	1000	t	ad-hoc	\N	1	\N	\N	\N	2	f
3	\\x2da9f9523b755dcc19677021956b0c46505e1291b32e85535b8ea502b48a3e39	2021-12-23 10:49:54.87165+00	444	1	f	map-tiles	\N	1	\N	\N	\N	2	f
4	\\xaf7d51af1e1e44105f7d9cf77a3eb5cffb1466e2fa471b15fe57a0c94bb7294f	2021-12-23 10:49:54.872592+00	447	208	f	map-tiles	\N	1	\N	\N	\N	2	f
5	\\x46b2679839b4d2fca6a469c1a7b840a63b4887dbf73cf950aee973f3eb17a8e9	2021-12-23 10:49:54.87165+00	466	3	f	map-tiles	\N	1	\N	\N	\N	2	f
6	\\x4bddc5e37dda79ab045bd7021da216cea0f2d5acfb87bd085660aad64bb6b669	2021-12-23 10:49:54.873603+00	474	309	f	map-tiles	\N	1	\N	\N	\N	2	f
7	\\x55a1cff7e7ec87b1eef3375cf96015b48f1592e9b6dafba27b7fed5b48345dde	2021-12-23 10:49:54.873008+00	500	895	f	map-tiles	\N	1	\N	\N	\N	2	f
8	\\x13221743ab863724383f65832795aa9da0d4da21e190c019ac61057af94a63a5	2021-12-23 10:49:54.872871+00	517	208	f	map-tiles	\N	1	\N	\N	\N	2	f
9	\\xd33ff3da05076ce75cd1de247ac1a5a01d11225f42d1b9e7c34b4b868998480a	2021-12-23 10:49:55.631345+00	238	0	f	map-tiles	\N	1	\N	\N	\N	2	f
10	\\x86f19ad3542457632eb5fa21b3d83c5a2760b08244532cb16492a95731d9c91e	2021-12-23 10:49:55.638012+00	225	0	f	map-tiles	\N	1	\N	\N	\N	2	f
11	\\x1a11ac0f8eafa38a087e13b048d225885c3d3e03cd7730b03a7065ea4874c6f7	2021-12-23 10:50:00.857649+00	281	101	f	map-tiles	\N	1	\N	\N	\N	2	f
12	\\xd9a259374dc55c4824aef4258fe0b727b4f50e1c09b31f3d95afefc511b88ece	2021-12-23 10:50:00.851979+00	430	0	f	map-tiles	\N	1	\N	\N	\N	2	f
13	\\x987975585cc7d0516eeb13a8ddc5c7b60d5af2dbe57142ebd7c214b004e86eef	2021-12-23 10:50:00.851807+00	473	0	f	map-tiles	\N	1	\N	\N	\N	2	f
14	\\x3af208d9c5f3f9a7a5951b3e843884ef57ab1c2898ec18144af4eec00983b3aa	2021-12-23 10:50:00.854274+00	496	208	f	map-tiles	\N	1	\N	\N	\N	2	f
15	\\x0ae1c258cab2ef074b1a5ae262fd818ed753858c7beab2dfe34c25d622b363cb	2021-12-23 10:50:00.851109+00	506	685	f	map-tiles	\N	1	\N	\N	\N	2	f
16	\\xd8fbfef809accf8859695c4869b982fb5dd31884f5d8fb88fdc1c09447dc7175	2021-12-23 10:50:00.851634+00	501	208	f	map-tiles	\N	1	\N	\N	\N	2	f
17	\\xc2f8c615dd5793256936713f763c975498684fe361f96e9a323d495876a13d75	2021-12-23 10:50:01.339239+00	263	0	f	map-tiles	\N	1	\N	\N	\N	2	f
18	\\x865d39687342e1e56ae32e270cbcb95fd3510c4d98fbba17ff79c5be18f1009f	2021-12-23 10:50:01.305893+00	342	2	f	map-tiles	\N	1	\N	\N	\N	2	f
19	\\x15a7d97e469fe688a1bd14e4f47acffab86f8c4945fb9006f00b8a8a6ae9cb2b	2021-12-23 10:50:01.364612+00	294	1	f	map-tiles	\N	1	\N	\N	\N	2	f
20	\\x8b5835bd4c15c8c90a1ba62d50e51d91490cb08ba4ca5d03e2316f46358894c6	2021-12-23 10:50:01.402466+00	276	0	f	map-tiles	\N	1	\N	\N	\N	2	f
21	\\x9470375fc40f3298e816f9b146d70f1cb6f058b03231ecb30cc49af02f55adc3	2021-12-23 10:50:01.465965+00	263	3	f	map-tiles	\N	1	\N	\N	\N	2	f
22	\\x925fba84ef382e55b74e728e7543364bbc8bc50451efb2f7453f5445e9eaf3a8	2021-12-23 10:50:01.404253+00	337	0	f	map-tiles	\N	1	\N	\N	\N	2	f
23	\\x733c7b9f5ea32e82626c12eb37e1491bd52a9e9df7730d2350d726210c27d943	2021-12-23 10:50:03.218609+00	268	1	f	map-tiles	\N	1	\N	\N	\N	2	f
24	\\x4bc592522851871c1f26593de72543582efdc09939f220ce278f1c6537c21938	2021-12-23 10:50:03.217559+00	269	0	f	map-tiles	\N	1	\N	\N	\N	2	f
25	\\x1fc465697c499eb9733b2f99974165dba0485f615be29ace31e84b3a2b23d929	2021-12-23 10:50:03.218014+00	314	42	f	map-tiles	\N	1	\N	\N	\N	2	f
26	\\x924c8abf8c19f8ae0817935d94412cba682eacfbb93a49e3f13df1cb29907291	2021-12-23 10:50:03.222795+00	270	0	f	map-tiles	\N	1	\N	\N	\N	2	f
27	\\xa8dbd8b30ec00b5d36ca0e07681a3ef1448f0c7706ea76f499fb5799e8407c06	2021-12-23 10:50:03.224152+00	417	100	f	map-tiles	\N	1	\N	\N	\N	2	f
28	\\x48b6f8d53092abc62e3725d3000cb5f1a789e16fbf07a8aaf1aa94b962119d59	2021-12-23 10:50:03.218846+00	513	643	f	map-tiles	\N	1	\N	\N	\N	2	f
29	\\x5655936eaf7b21a6e626f76c66bfd4d52485c089070da1238263912798cf6cee	2021-12-23 10:50:03.521641+00	264	0	f	map-tiles	\N	1	\N	\N	\N	2	f
30	\\xcb43928c81700537fffde5999a627c87ab15788eba218e3d55ba0250eefedd2b	2021-12-23 10:50:03.521811+00	323	0	f	map-tiles	\N	1	\N	\N	\N	2	f
31	\\x2ad9b9ebae64e08c847ab1f19c6c594e3bd5c50dd089ec1199795a2e7635d39d	2021-12-23 10:50:03.562253+00	345	0	f	map-tiles	\N	1	\N	\N	\N	2	f
32	\\xb105866d928b58a5fabf215a21896a2894ce8c64fa9cf943e5e8d3d96e901178	2021-12-23 10:50:03.591579+00	406	0	f	map-tiles	\N	1	\N	\N	\N	2	f
33	\\x97610bc510076979c902381f014a4c8f245ffd7d186af66617231fcf4129c8ac	2021-12-23 10:50:03.683603+00	332	0	f	map-tiles	\N	1	\N	\N	\N	2	f
34	\\x2519ff936278c9cb4f262d0c37d6d8dcb79c3a7a22e5496bfec33b21c782331c	2021-12-23 10:50:03.773571+00	344	0	f	map-tiles	\N	1	\N	\N	\N	2	f
35	\\xd923216e2a8438d421131221408964e2f6f4e6476a6c6a0ed86e48684d3d689e	2021-12-23 10:50:03.878676+00	303	0	f	map-tiles	\N	1	\N	\N	\N	2	f
36	\\xe6066acd4ef11e943f85aa1af2051111ed438d2b6bf32dd97cb4de5500a0fba1	2021-12-23 10:50:03.820446+00	398	0	f	map-tiles	\N	1	\N	\N	\N	2	f
37	\\x69136de2dee104edd39838b6b9d756e929e52813f29422180a2e3d254bc8b959	2021-12-23 10:50:03.943497+00	331	0	f	map-tiles	\N	1	\N	\N	\N	2	f
38	\\x6b39ad90b860fc040fe16aece13150de3c7e7bafefb9f340c9ddf931a9063a4d	2021-12-23 10:50:04.019765+00	305	0	f	map-tiles	\N	1	\N	\N	\N	2	f
39	\\x747ffe1c1d85520b64f7ed559c9a765b15e1e5c9a5169895a3e29dbdfece35cb	2021-12-23 10:50:04.050542+00	296	0	f	map-tiles	\N	1	\N	\N	\N	2	f
40	\\x141bff3f70fe2793060d83ba6dd88ab42a6663fe6717c0312dadadea07a61f5f	2021-12-23 10:50:04.161245+00	302	0	f	map-tiles	\N	1	\N	\N	\N	2	f
41	\\xab3b99b034298297343fd0f3c75988fb959427e00ed08519f26a50bf5a04dfe5	2021-12-23 10:50:04.256584+00	236	0	f	map-tiles	\N	1	\N	\N	\N	2	f
42	\\x428a1cb93232f93987082948dacc7733fda66dd322ebb90f917480dc74dd9330	2021-12-23 10:50:04.229326+00	283	0	f	map-tiles	\N	1	\N	\N	\N	2	f
43	\\x3b104704dd1e85cec684e37288d08f898003c98a753a138365d595ef850da731	2021-12-23 10:50:04.306963+00	222	0	f	map-tiles	\N	1	\N	\N	\N	2	f
44	\\xf125cf055044687de7b7f379394fe7060d4083b3e8eab6bcde45d3b6e8386994	2021-12-23 10:50:05.526244+00	159	0	f	map-tiles	\N	1	\N	\N	\N	2	f
45	\\x43da9244d1716c5df1c9b9d6b06e82a8c9083a6d5f66462a4e5bfb8fac9d31b9	2021-12-23 10:50:05.526244+00	159	0	f	map-tiles	\N	1	\N	\N	\N	2	f
46	\\x5dbddd1474749061b1ca75d5cb7c2f39edd11e285cd7ad74d1419025d493665a	2021-12-23 10:50:06.65228+00	212	0	f	map-tiles	\N	1	\N	\N	\N	2	f
47	\\xd8e7d7f3b92e4985d5839f5fadc5e60c856cea86586ec87616b97d32f25a3871	2021-12-23 10:50:06.664173+00	209	0	f	map-tiles	\N	1	\N	\N	\N	2	f
48	\\x99668c6a40609eb3de3eb6d4276c6f3ec3b01f8232bc4225251d757db05b9a89	2021-12-23 10:50:06.672255+00	283	42	f	map-tiles	\N	1	\N	\N	\N	2	f
49	\\x3b8ecbce6ce766576b895414b44dd88027c422757250fa795b8cb0a81bd65c08	2021-12-23 10:50:06.663349+00	331	1	f	map-tiles	\N	1	\N	\N	\N	2	f
50	\\xa382bbfe8e7b77413dbe4996ae515c05144f2ec31f98a354f3e2ed1728b8d4a0	2021-12-23 10:50:06.651066+00	382	97	f	map-tiles	\N	1	\N	\N	\N	2	f
51	\\xb82bcfac3d2dc84933b1e4197e814067bc8c9ffcd2775b57c0b34eee586a7ee6	2021-12-23 10:50:06.653154+00	378	643	f	map-tiles	\N	1	\N	\N	\N	2	f
52	\\x4b44cff3c4805cd6f61b45d3086be48924f94e419a230d87fd78d72e0d4191bd	2021-12-23 10:50:06.956427+00	224	1	f	map-tiles	\N	1	\N	\N	\N	2	f
53	\\x37558eca98d5b92fb1880b74e1064e28aee70986ce95208a4d16a497df01c164	2021-12-23 10:50:06.906723+00	311	0	f	map-tiles	\N	1	\N	\N	\N	2	f
54	\\xcc8a91fcd3b99399464a0677802dcc05a799b4198652d8d4edeeef8825b29f71	2021-12-23 10:50:07.049617+00	219	0	f	map-tiles	\N	1	\N	\N	\N	2	f
55	\\x899158e89e5fef030e48c635f3534260734fc69592dfcc9d5d4ea70d7e80a262	2021-12-23 10:50:06.997246+00	247	0	f	map-tiles	\N	1	\N	\N	\N	2	f
56	\\xcdef3df58a85e4862fd19294ebce32ff85b3f360f5e3638c7cbd9f9816f36de9	2021-12-23 10:50:07.115978+00	214	0	f	map-tiles	\N	1	\N	\N	\N	2	f
57	\\xecd2dbad0bcf401ed7c94392f5d8bc03f0e842275e20328bc72161ba6e2f630c	2021-12-23 10:50:07.067505+00	245	0	f	map-tiles	\N	1	\N	\N	\N	2	f
58	\\xce5a23258fc6738292389c0bea25ef70d1f1c966f4754601b6cf2fc0a91eff7d	2021-12-23 10:50:07.513744+00	251	1	f	map-tiles	\N	1	\N	\N	\N	2	f
59	\\x934e3bbe8883cdc7bd753d421b53d37b19624c49e0a06eb6d9db7956957324d7	2021-12-23 10:50:07.525508+00	251	0	f	map-tiles	\N	1	\N	\N	\N	2	f
60	\\xae659868f115358167a10de37a094b51d356fbd8d43f1ee2d5bd8396de0db03e	2021-12-23 10:50:07.521975+00	291	0	f	map-tiles	\N	1	\N	\N	\N	2	f
61	\\xfe5997de8b0017532371df75c68f0c5269938fdcd8b1fee4f37c9bce81379eec	2021-12-23 10:50:07.511358+00	327	1	f	map-tiles	\N	1	\N	\N	\N	2	f
62	\\xc83ddbfd9c105dbba302433629052eb13d5b1ce181d442fba3f804e270f5157e	2021-12-23 10:50:07.515375+00	434	0	f	map-tiles	\N	1	\N	\N	\N	2	f
63	\\x9cc97607be56e635a20722351afbcce09da2a2148a4096a1f3dca32ba1f6cfe8	2021-12-23 10:50:07.527593+00	448	0	f	map-tiles	\N	1	\N	\N	\N	2	f
64	\\x80f5457ebd19de72de5cec95cf1782ac8fe19d625b258494947f60a26972c2f4	2021-12-23 10:50:07.79578+00	226	0	f	map-tiles	\N	1	\N	\N	\N	2	f
65	\\x4f2876b150131a771bc026cdfcf751b10be999ebe35c4002f94d9638cb102f9f	2021-12-23 10:50:07.820895+00	241	0	f	map-tiles	\N	1	\N	\N	\N	2	f
66	\\x0c9c8e0740d8e0af0560e37d084e10be8925c39fa61dc83949a3efe5d35642c0	2021-12-23 10:50:07.854607+00	245	0	f	map-tiles	\N	1	\N	\N	\N	2	f
67	\\xfebce0b891246c768ae4d1f0e491968586bba20bff767f500388b6ac6e398732	2021-12-23 10:50:09.317546+00	224	180	f	map-tiles	\N	1	\N	\N	\N	2	f
68	\\x4ad15a5b84640eeb669da82a59f65cdcf8dc9c72d2a93f3587f71c6479184e44	2021-12-23 10:50:09.323851+00	231	0	f	map-tiles	\N	1	\N	\N	\N	2	f
69	\\xc50e375eef500082b38117e57714dc5b544053a486b9bda4671b7a83ec92f9c0	2021-12-23 10:50:09.316145+00	238	90	f	map-tiles	\N	1	\N	\N	\N	2	f
70	\\x80b59442213ee010c00087ad6ae810e814f6be2eea991945bb85ccf0701147d3	2021-12-23 10:50:09.320761+00	249	5	f	map-tiles	\N	1	\N	\N	\N	2	f
71	\\xe1b15bd16fc410faebe50de81983874aa7901398560d9b7bd72664204eb3ba5d	2021-12-23 10:50:09.316145+00	329	41	f	map-tiles	\N	1	\N	\N	\N	2	f
72	\\x158b0a706c60798b6884b0df1c83ed1650980476bfeb764be5e0e534c974127e	2021-12-23 10:50:09.31728+00	498	431	f	map-tiles	\N	1	\N	\N	\N	2	f
73	\\xcfad7386c2888f6bdf9aa3ff8e46890082f04189d698df26d7325b9cde1242a7	2021-12-23 10:50:09.594184+00	318	0	f	map-tiles	\N	1	\N	\N	\N	2	f
89	\\xd8fbfef809accf8859695c4869b982fb5dd31884f5d8fb88fdc1c09447dc7175	2021-12-23 10:50:27.950906+00	341	208	f	map-tiles	\N	1	\N	\N	\N	2	f
91	\\x8b5835bd4c15c8c90a1ba62d50e51d91490cb08ba4ca5d03e2316f46358894c6	2021-12-23 10:50:28.350291+00	268	0	f	map-tiles	\N	1	\N	\N	\N	2	f
95	\\xc2f8c615dd5793256936713f763c975498684fe361f96e9a323d495876a13d75	2021-12-23 10:50:28.315019+00	395	0	f	map-tiles	\N	1	\N	\N	\N	2	f
74	\\x996c578cc647ea3aa922fb9e8b5bcd0e37fba109d8d57bf9238ecd6878a10146	2021-12-23 10:50:09.599652+00	368	0	f	map-tiles	\N	1	\N	\N	\N	2	f
83	\\xa7b8fb02309c60bab2acee7b8fd7212661e66404068317298f8797d56235add0	2021-12-23 10:50:10.207108+00	276	1	f	map-tiles	\N	1	\N	\N	\N	2	f
87	\\xd9a259374dc55c4824aef4258fe0b727b4f50e1c09b31f3d95afefc511b88ece	2021-12-23 10:50:27.947283+00	346	0	f	map-tiles	\N	1	\N	\N	\N	2	f
75	\\x2f24ad66870225819dde1abb0b2476ceae9a614c28843b2782bcc60f3331d2db	2021-12-23 10:50:09.626476+00	392	1	f	map-tiles	\N	1	\N	\N	\N	2	f
77	\\xd596ef813b477386a5dd4658ef37cf0fa823f09d81cb260b810afc0ca890c456	2021-12-23 10:50:09.721125+00	374	28	f	map-tiles	\N	1	\N	\N	\N	2	f
80	\\x42ccd8ec457aaf10ff87dfa8628ee769bdff32be2a632051e0a46569772b05c5	2021-12-23 10:50:10.000533+00	300	0	f	map-tiles	\N	1	\N	\N	\N	2	f
84	\\xdfaa5120852d90e896604b587826cf08abfe0b978ac78b0c765a409451c8aff7	2021-12-23 10:50:10.13734+00	333	0	f	map-tiles	\N	1	\N	\N	\N	2	f
86	\\x1a11ac0f8eafa38a087e13b048d225885c3d3e03cd7730b03a7065ea4874c6f7	2021-12-23 10:50:27.958395+00	310	101	f	map-tiles	\N	1	\N	\N	\N	2	f
92	\\x865d39687342e1e56ae32e270cbcb95fd3510c4d98fbba17ff79c5be18f1009f	2021-12-23 10:50:28.296458+00	344	2	f	map-tiles	\N	1	\N	\N	\N	2	f
76	\\xf7c7d3d25ea7641400d5211c3b7ff189bd120e9855f664355cb7b02526d98cea	2021-12-23 10:50:09.584193+00	443	4	f	map-tiles	\N	1	\N	\N	\N	2	f
82	\\xa1f60147e9f3550df35a28afe5fb8dde431613a9ca2125c1e259d587e3a9f170	2021-12-23 10:50:10.074399+00	390	0	f	map-tiles	\N	1	\N	\N	\N	2	f
88	\\x0ae1c258cab2ef074b1a5ae262fd818ed753858c7beab2dfe34c25d622b363cb	2021-12-23 10:50:27.954586+00	365	685	f	map-tiles	\N	1	\N	\N	\N	2	f
90	\\x987975585cc7d0516eeb13a8ddc5c7b60d5af2dbe57142ebd7c214b004e86eef	2021-12-23 10:50:27.94728+00	407	0	f	map-tiles	\N	1	\N	\N	\N	2	f
78	\\xf3ff42f6c4509c391734672bd94b71b7fd01109e00b58bc52f2ae052bf4aba9d	2021-12-23 10:50:09.865006+00	312	2	f	map-tiles	\N	1	\N	\N	\N	2	f
79	\\xe412f094c680f8c6c07b13947a1144fcf65de38ab04863d59921636e3b930f16	2021-12-23 10:50:09.937141+00	313	0	f	map-tiles	\N	1	\N	\N	\N	2	f
81	\\x92f44430568748bfcfb66f5614a56c00c731131266e08e30acc8ea7ed06c1d76	2021-12-23 10:50:10.060441+00	293	0	f	map-tiles	\N	1	\N	\N	\N	2	f
85	\\x3af208d9c5f3f9a7a5951b3e843884ef57ab1c2898ec18144af4eec00983b3aa	2021-12-23 10:50:27.94728+00	295	208	f	map-tiles	\N	1	\N	\N	\N	2	f
96	\\x15a7d97e469fe688a1bd14e4f47acffab86f8c4945fb9006f00b8a8a6ae9cb2b	2021-12-23 10:50:28.350295+00	403	1	f	map-tiles	\N	1	\N	\N	\N	2	f
93	\\x9470375fc40f3298e816f9b146d70f1cb6f058b03231ecb30cc49af02f55adc3	2021-12-23 10:50:28.397326+00	277	3	f	map-tiles	\N	1	\N	\N	\N	2	f
94	\\x925fba84ef382e55b74e728e7543364bbc8bc50451efb2f7453f5445e9eaf3a8	2021-12-23 10:50:28.379177+00	307	0	f	map-tiles	\N	1	\N	\N	\N	2	f
97	\\x84e2a619c0782d5a5140ec015dc60d533eb9fbd3daf0ddaf59eced071bf8e939	2021-12-23 10:51:21.421644+00	180	0	f	map-tiles	\N	1	\N	\N	\N	2	f
98	\\xe6a4947e7bf41b3cdc84cee8cf665bee38cad7c2c6a2c329d551fe6a3fe0b082	2021-12-23 10:51:21.421642+00	180	0	f	map-tiles	\N	1	\N	\N	\N	2	f
99	\\x3b641b2a829e79935b414b0deccd81e5902ba79e2e478393a11790423433e187	2021-12-23 10:51:24.012527+00	152	0	f	map-tiles	\N	1	\N	\N	\N	2	f
100	\\x22856f7b62d38f8adaf1ce1b3347de27aa0cd04adf6fbd1db976533efaaae846	2021-12-23 10:51:24.012724+00	152	0	f	map-tiles	\N	1	\N	\N	\N	2	f
101	\\xb6ba3f385bf6d2a6b17a05f015ef411947082b59e1f6c28014598ec3e365e6ad	2021-12-23 10:51:24.42195+00	193	0	f	map-tiles	\N	1	\N	\N	\N	2	f
102	\\xc4d9eef8fc848246cffac7293839532e00cdbc83e26e4739e96912e57d7c72e8	2021-12-23 10:51:24.406103+00	195	0	f	map-tiles	\N	1	\N	\N	\N	2	f
103	\\x801caa26f4809005aad28c6188b8df20df5a6b837c963923a2e1c73b1d2f9b00	2021-12-23 10:51:24.415195+00	199	0	f	map-tiles	\N	1	\N	\N	\N	2	f
104	\\x0f242a4fd2c83d4d03c25de2317e06a964d6c105233b5c987eb91e22ab3e1c3e	2021-12-23 10:51:24.414095+00	276	0	f	map-tiles	\N	1	\N	\N	\N	2	f
105	\\xe60920169ce7d644d38c55b144df6c8ee333fabff7e7058941096b7fb79d40c8	2021-12-23 10:51:24.414047+00	284	0	f	map-tiles	\N	1	\N	\N	\N	2	f
106	\\xcc349628549d7363e84f77c609b2202bdc67f6b0264acae87b717993309d42b4	2021-12-23 10:51:24.420475+00	280	0	f	map-tiles	\N	1	\N	\N	\N	2	f
107	\\x1702094699eec4c1a70acb35fc88b7a1cdeb6fd34dd7cc928342701a93a88116	2021-12-23 10:51:24.636067+00	138	0	f	map-tiles	\N	1	\N	\N	\N	2	f
108	\\x4703924e65f8fd01ca356b03497f18d563eb2794db70f86b7eefdc3f174d957b	2021-12-23 10:51:30.743921+00	411	0	f	map-tiles	\N	1	\N	\N	\N	2	f
109	\\x2947dcda9b4ab2d2568f98c0e9baa4c8ffbc95cbaf36a8bb1a1645451359d659	2021-12-23 10:51:30.746655+00	424	208	f	map-tiles	\N	1	\N	\N	\N	2	f
110	\\xad3ad6b865c4f34cb73b23c0b38679948fc38bfa4297eb881bc45c375638d0f7	2021-12-23 10:51:30.742206+00	432	0	f	map-tiles	\N	1	\N	\N	\N	2	f
111	\\x88e2e98c3705884cdf0ad5744df3b1a2d43840f8ed6f53266eb3ab20cb621c07	2021-12-23 10:51:30.743153+00	494	208	f	map-tiles	\N	1	\N	\N	\N	2	f
112	\\x6ed14a822a0bb354e541bacbf727db17f683dfa48b248c3d9dbcd8ffdc9f1fd6	2021-12-23 10:51:30.742212+00	508	0	f	map-tiles	\N	1	\N	\N	\N	2	f
113	\\x222d41b8f44ce7759696ab2198f6f3f95710430a283c677c1af9d92326c380d6	2021-12-23 10:51:30.752835+00	515	0	f	map-tiles	\N	1	\N	\N	\N	2	f
114	\\xe471ff3b8eebbe453c4a64db46acdc117175e729a5d33f82f39eba3a43b750d0	2021-12-23 10:51:32.306312+00	296	1000	t	question	\N	1	1	\N	\N	2	f
115	\\x3af208d9c5f3f9a7a5951b3e843884ef57ab1c2898ec18144af4eec00983b3aa	2021-12-23 10:51:32.658452+00	254	208	f	map-tiles	\N	1	\N	\N	\N	2	f
116	\\x2947dcda9b4ab2d2568f98c0e9baa4c8ffbc95cbaf36a8bb1a1645451359d659	2021-12-23 10:51:32.66598+00	310	208	f	map-tiles	\N	1	\N	\N	\N	2	f
117	\\x88e2e98c3705884cdf0ad5744df3b1a2d43840f8ed6f53266eb3ab20cb621c07	2021-12-23 10:51:32.668073+00	307	208	f	map-tiles	\N	1	\N	\N	\N	2	f
118	\\x0ae1c258cab2ef074b1a5ae262fd818ed753858c7beab2dfe34c25d622b363cb	2021-12-23 10:51:32.661266+00	354	685	f	map-tiles	\N	1	\N	\N	\N	2	f
119	\\xd8fbfef809accf8859695c4869b982fb5dd31884f5d8fb88fdc1c09447dc7175	2021-12-23 10:51:32.658563+00	390	208	f	map-tiles	\N	1	\N	\N	\N	2	f
120	\\x1a11ac0f8eafa38a087e13b048d225885c3d3e03cd7730b03a7065ea4874c6f7	2021-12-23 10:51:32.686724+00	396	101	f	map-tiles	\N	1	\N	\N	\N	2	f
121	\\x987975585cc7d0516eeb13a8ddc5c7b60d5af2dbe57142ebd7c214b004e86eef	2021-12-23 10:51:33.002207+00	227	0	f	map-tiles	\N	1	\N	\N	\N	2	f
122	\\xad3ad6b865c4f34cb73b23c0b38679948fc38bfa4297eb881bc45c375638d0f7	2021-12-23 10:51:32.998872+00	231	0	f	map-tiles	\N	1	\N	\N	\N	2	f
123	\\xc2f8c615dd5793256936713f763c975498684fe361f96e9a323d495876a13d75	2021-12-23 10:51:32.949645+00	350	0	f	map-tiles	\N	1	\N	\N	\N	2	f
124	\\x925fba84ef382e55b74e728e7543364bbc8bc50451efb2f7453f5445e9eaf3a8	2021-12-23 10:51:33.124285+00	197	0	f	map-tiles	\N	1	\N	\N	\N	2	f
125	\\x222d41b8f44ce7759696ab2198f6f3f95710430a283c677c1af9d92326c380d6	2021-12-23 10:51:33.082487+00	313	0	f	map-tiles	\N	1	\N	\N	\N	2	f
126	\\xd9a259374dc55c4824aef4258fe0b727b4f50e1c09b31f3d95afefc511b88ece	2021-12-23 10:51:33.09352+00	309	0	f	map-tiles	\N	1	\N	\N	\N	2	f
127	\\x9470375fc40f3298e816f9b146d70f1cb6f058b03231ecb30cc49af02f55adc3	2021-12-23 10:51:33.254011+00	236	3	f	map-tiles	\N	1	\N	\N	\N	2	f
128	\\x865d39687342e1e56ae32e270cbcb95fd3510c4d98fbba17ff79c5be18f1009f	2021-12-23 10:51:33.245417+00	278	2	f	map-tiles	\N	1	\N	\N	\N	2	f
129	\\x8b5835bd4c15c8c90a1ba62d50e51d91490cb08ba4ca5d03e2316f46358894c6	2021-12-23 10:51:33.348192+00	259	0	f	map-tiles	\N	1	\N	\N	\N	2	f
130	\\x15a7d97e469fe688a1bd14e4f47acffab86f8c4945fb9006f00b8a8a6ae9cb2b	2021-12-23 10:51:33.332893+00	287	1	f	map-tiles	\N	1	\N	\N	\N	2	f
131	\\x6ed14a822a0bb354e541bacbf727db17f683dfa48b248c3d9dbcd8ffdc9f1fd6	2021-12-23 10:51:33.427352+00	240	0	f	map-tiles	\N	1	\N	\N	\N	2	f
132	\\x4703924e65f8fd01ca356b03497f18d563eb2794db70f86b7eefdc3f174d957b	2021-12-23 10:51:33.443143+00	217	0	f	map-tiles	\N	1	\N	\N	\N	2	f
133	\\x84e2a619c0782d5a5140ec015dc60d533eb9fbd3daf0ddaf59eced071bf8e939	2021-12-23 10:51:38.74255+00	197	0	f	map-tiles	\N	1	\N	\N	\N	2	f
134	\\xe6a4947e7bf41b3cdc84cee8cf665bee38cad7c2c6a2c329d551fe6a3fe0b082	2021-12-23 10:51:38.74255+00	197	0	f	map-tiles	\N	1	\N	\N	\N	2	f
135	\\xb44649533f1194150a91d05ad43a6de04930ef53305b09bb6a1cef1375a0d1a0	2021-12-23 10:51:38.74255+00	197	0	f	map-tiles	\N	1	\N	\N	\N	2	f
136	\\x22856f7b62d38f8adaf1ce1b3347de27aa0cd04adf6fbd1db976533efaaae846	2021-12-23 10:51:42.251334+00	143	0	f	map-tiles	\N	1	\N	\N	\N	2	f
137	\\x3b641b2a829e79935b414b0deccd81e5902ba79e2e478393a11790423433e187	2021-12-23 10:51:42.251334+00	143	0	f	map-tiles	\N	1	\N	\N	\N	2	f
138	\\xc89a90901d35c57ef626a5b5d6da2ff8c8b89e90f38b00f14bedfdae4f65641f	2021-12-23 10:51:44.890767+00	199	0	f	map-tiles	\N	1	\N	\N	\N	2	f
139	\\xa5d3629622db75c69e0199319c972cd6fe6469686216a91a8a004bb8eacdbf3f	2021-12-23 10:51:47.907775+00	304	999	t	ad-hoc	\N	1	\N	\N	\N	2	f
140	\\x808cf743361f6ea779b7e8aea8a84bc9cfd91919bb2caef999e550824ebae141	2021-12-23 10:54:03.384231+00	316	999	t	ad-hoc	\N	1	\N	\N	\N	2	f
141	\\x530dc3c69db39f873e426bdc5df39e77723273f13304b4114f1ae754b8c4b9f5	2021-12-23 10:54:35.961402+00	287	999	t	question	\N	1	1	\N	\N	2	f
142	\\x530dc3c69db39f873e426bdc5df39e77723273f13304b4114f1ae754b8c4b9f5	2021-12-23 10:54:43.365264+00	274	999	t	question	\N	1	1	\N	\N	2	f
143	\\x530dc3c69db39f873e426bdc5df39e77723273f13304b4114f1ae754b8c4b9f5	2021-12-23 10:56:08.884483+00	295	999	t	question	\N	1	1	1	\N	2	f
144	\\x530dc3c69db39f873e426bdc5df39e77723273f13304b4114f1ae754b8c4b9f5	2021-12-23 10:57:11.019015+00	337	999	t	question	\N	1	1	\N	\N	2	f
145	\\x77502fc5f3f2405eecccf43df8040034b1f25997931256435e70e0acdb53079b	2021-12-23 10:57:30.816167+00	328	999	t	ad-hoc	\N	1	\N	\N	\N	2	f
146	\\x4fdd5eed1e7783daeada5db86bab1283280a7bc738ca35cc1c1a1b98e19f0b3d	2021-12-23 11:05:50.977833+00	297	999	t	ad-hoc	\N	1	\N	\N	\N	2	f
147	\\x647f87c67b1686e383ec5fa2e608102b6058ea0474662b53a2de08945fca23a5	2021-12-23 11:06:00.855765+00	281	999	t	ad-hoc	\N	1	\N	\N	\N	2	f
148	\\x4652c67c65ba9529d2a8c870a3cc06613a25b3f2c27fc49cbcd6c6efcc4ed75a	2021-12-23 11:06:14.27019+00	257	999	t	question	\N	1	1	\N	\N	2	f
149	\\xd1c762900eff64000e576bd377a48ab1de6a130571b025c1c8640960a15f7e7d	2021-12-23 11:07:06.623997+00	254	999	t	ad-hoc	\N	1	\N	\N	\N	2	f
150	\\x3fbbf2fc60de4c8491d051ee70c8d075b096325689179bbf5d40ebe9d88a865a	2021-12-23 11:08:06.05844+00	249	999	t	question	\N	1	1	1	\N	2	f
151	\\x9b3e76400f990f7bcec51bc860a1fd87c208b24935e2d12cd0f9a6abba0eb355	2021-12-23 11:16:16.419226+00	141	29	t	question	\N	1	1	1	\N	2	f
152	\\x3fbbf2fc60de4c8491d051ee70c8d075b096325689179bbf5d40ebe9d88a865a	2021-12-23 11:18:06.795001+00	308	999	t	question	\N	1	1	1	\N	2	f
153	\\x3fbbf2fc60de4c8491d051ee70c8d075b096325689179bbf5d40ebe9d88a865a	2021-12-23 11:18:09.100855+00	383	999	t	question	\N	1	1	\N	\N	2	f
154	\\x395533263f41f80651ec6a595c28b207afc0cf4aa925f77ee74a4ecc799bb9ad	2021-12-23 11:18:31.623401+00	297	999	t	ad-hoc	\N	1	\N	\N	\N	2	f
155	\\xcc3ebd1f86e4c25f33ef92b7d6311d12421f4137a1b010926cda9086b6ccb781	2021-12-23 11:19:01.863758+00	318	999	t	ad-hoc	\N	1	\N	\N	\N	2	f
156	\\x6b49cf02d639fc411c819f25a74bca437a76fe410299321098757bb1a303d23a	2021-12-23 11:19:29.108381+00	338	999	t	ad-hoc	\N	1	\N	\N	\N	2	f
157	\\x6b49cf02d639fc411c819f25a74bca437a76fe410299321098757bb1a303d23a	2021-12-23 11:20:06.760705+00	265	999	t	csv-download	\N	1	\N	\N	\N	2	f
158	\\x9ed4ae9be53962b589c3bace6b41ccff5272d9558d12182573384c5be4a18375	2021-12-23 11:28:37.624541+00	302	2000	f	ad-hoc	\N	1	\N	\N	\N	2	f
159	\\x2078b60fdd0903363dd504dc0214045cdac92a8e7536226fad2aa8c87235288c	2021-12-23 11:29:06.164271+00	173	2000	f	ad-hoc	\N	1	\N	\N	\N	2	f
160	\\xb0122c462b6a64594dca7f9ad14e13a934527251c5cf01cf2b36276de6234022	2021-12-23 11:30:49.98428+00	395	2000	f	ad-hoc	\N	1	\N	\N	\N	2	f
161	\\x199853bd47d42f2f9e8fc434ab32d7b3cd118800e1e1afea4616c5affb2dcc86	2021-12-23 11:31:27.501031+00	194	2000	f	ad-hoc	\N	1	\N	\N	\N	2	f
162	\\x3cd729ba00dcdf770f56b2d64140e804c16e4c9c0bb428b437b969fbcb274456	2021-12-23 11:32:44.104069+00	257	2000	f	ad-hoc	\N	1	\N	\N	\N	2	f
163	\\xd6cddbb87759af9d0b525bbc08606e434910e68b7337aab38ec8a22def8b66e2	2021-12-23 11:32:53.096025+00	156	0	f	map-tiles	\N	1	\N	\N	\N	2	f
164	\\xf060a1845adbd2cb04d13f1eae45c50abfac8257afbf9ffb8540cdc853fa2e08	2021-12-23 11:32:53.096025+00	208	2	f	map-tiles	\N	1	\N	\N	\N	2	f
165	\\x5ffb99c4e962a21711b31eea56f695f0d2147a4a7cde2b9ec788dd0c1d590441	2021-12-23 11:32:53.10804+00	216	0	f	map-tiles	\N	1	\N	\N	\N	2	f
166	\\x22f572ca191f0e65fdf76199b95ad951e88ee2e9caeba885f678fc57333c868b	2021-12-23 11:32:53.096305+00	324	202	f	map-tiles	\N	1	\N	\N	\N	2	f
167	\\xc0a31c03b6c131abed915f9d01c16fd51260097e99989f19dfc1d3310926788d	2021-12-23 11:32:53.096025+00	312	125	f	map-tiles	\N	1	\N	\N	\N	2	f
168	\\xbdebf4183ee91651d92f348b6e35c11741f85ded17255ab360c7370dbf7f9898	2021-12-23 11:32:53.096025+00	385	1572	f	map-tiles	\N	1	\N	\N	\N	2	f
169	\\xc31893774379a04516692a2e4dfc4f79d58c003c8c31bb2a14306f91602f173c	2021-12-23 11:32:53.320642+00	210	0	f	map-tiles	\N	1	\N	\N	\N	2	f
170	\\xfa869469cddf098ebd80f5b37202fae506914d74e1ed598a2e3b41423f9288b3	2021-12-23 11:32:53.466257+00	77	702	f	map-tiles	\N	1	\N	\N	\N	2	f
171	\\xb3eeaae2ce6bfb41368b0766224b99f38ebc03c0adc32d764465ed3ee25326b7	2021-12-23 11:32:53.413031+00	131	0	f	map-tiles	\N	1	\N	\N	\N	2	f
172	\\xf5f2efba3424420c4be60664c080f2232dad83d76f404688223658305480a5b0	2021-12-23 11:32:53.445147+00	119	0	f	map-tiles	\N	1	\N	\N	\N	2	f
173	\\x02bb3a091d02bd44a4dff564200a85c33c5e739330b9e2b216b32bc76459455d	2021-12-23 11:32:53.445396+00	90	0	f	map-tiles	\N	1	\N	\N	\N	2	f
174	\\xbb0c66a9a59bbe2d192911a160cbfd03fcb9744e5582f5fb2b124d325c553b2c	2021-12-23 11:32:53.567538+00	138	0	f	map-tiles	\N	1	\N	\N	\N	2	f
175	\\x54b127416496fe733869382c1eec8fb63bd5fad1a5095f7cffb336b2c2c421cf	2021-12-23 11:32:53.519761+00	192	702	f	map-tiles	\N	1	\N	\N	\N	2	f
176	\\xfc78787126d4c451a298d7313af1202a1a27b621897b9fb7f63ee4313118a2c6	2021-12-23 11:32:53.559144+00	182	0	f	map-tiles	\N	1	\N	\N	\N	2	f
177	\\x68c2eeb93301acd5bdf051d1dda1e77736ed00f021b0bcf66c72a3b11324fcc3	2021-12-23 11:32:53.591587+00	185	0	f	map-tiles	\N	1	\N	\N	\N	2	f
178	\\x56fcaf2e9db8ee4fbbe082735a1e73ac2cc2a35287d5e4c1f7bc89cb6a70f67c	2021-12-23 11:32:53.622433+00	178	1	f	map-tiles	\N	1	\N	\N	\N	2	f
179	\\xe47de4523d89435bc9c46d78f965fda218e58d800e2dabce42638f533ed79b3f	2021-12-23 11:32:53.652101+00	155	0	f	map-tiles	\N	1	\N	\N	\N	2	f
180	\\xe44c6d3a869cf36c175cecdcf429bc63c7b7cd69e04eccc64bbb65441606e13f	2021-12-23 11:32:53.798494+00	91	0	f	map-tiles	\N	1	\N	\N	\N	2	f
181	\\x80daa4c76563e7a6057cd7871f0f4b9fa0b504c1dc063a35a5ce7cdce3bfd5ca	2021-12-23 11:32:53.817459+00	109	0	f	map-tiles	\N	1	\N	\N	\N	2	f
182	\\xd6a5c8b8ce050f6089234f81db474ea3fdaa0865c49a323817c1837387099e10	2021-12-23 11:32:53.8461+00	96	0	f	map-tiles	\N	1	\N	\N	\N	2	f
183	\\xb823f6610e7746f57cae0e33cef6c17458344430d0f1fa2bf4fe50ded8e1f5c4	2021-12-23 11:32:53.754038+00	182	0	f	map-tiles	\N	1	\N	\N	\N	2	f
184	\\x2bdd76c2b5352189c91d60232e3ff386026763b50bad6403f94b8cea7f4b6080	2021-12-23 11:32:53.790923+00	158	0	f	map-tiles	\N	1	\N	\N	\N	2	f
185	\\xd2311268b06b381fe95b25d3e0152b0ff0deb8cb052fbbcf9f8934f03bd14284	2021-12-23 11:32:53.867267+00	81	0	f	map-tiles	\N	1	\N	\N	\N	2	f
186	\\x09f418a3c55081b5ee631ba74f8507d74f0f8397f786550cbde92d74425e60f2	2021-12-23 11:32:53.912608+00	64	0	f	map-tiles	\N	1	\N	\N	\N	2	f
187	\\xc26165fa8289f779826039e06c0c6b1ec35cd682bbd38df1234bb0a1c767a98b	2021-12-23 11:32:59.511544+00	167	4	f	map-tiles	\N	1	\N	\N	\N	2	f
188	\\x3d9676ce950d9644e626d1b45b59b76c810a9261edb7cfe68de29712d18b7e0f	2021-12-23 11:32:59.513945+00	193	0	f	map-tiles	\N	1	\N	\N	\N	2	f
189	\\x23345d4a9894ecf38c875088cdbac9f0eb89c3dc653520cffe95a3bcfdd5ab93	2021-12-23 11:32:59.512631+00	169	0	f	map-tiles	\N	1	\N	\N	\N	2	f
190	\\x47086e4042e0df24e62a54157ea2eb2f9a498342d93607613349b4899ea33c0f	2021-12-23 11:32:59.511544+00	186	0	f	map-tiles	\N	1	\N	\N	\N	2	f
191	\\x7adfbfea82cfe295bb8811856818d4194f4d9f23c0fbcc4b554aca3d4f4919d2	2021-12-23 11:32:59.522584+00	224	0	f	map-tiles	\N	1	\N	\N	\N	2	f
192	\\x1ee06ef9e3313b7f6f5fd35278e1db918a1fe6b3836bdaac8688c8899b9debcc	2021-12-23 11:32:59.517611+00	237	0	f	map-tiles	\N	1	\N	\N	\N	2	f
193	\\xff3f9fc63fbeee1541de1c2e43511b275fffe40d5076f3f5bf5d8582196b0692	2021-12-23 11:32:59.747665+00	55	0	f	map-tiles	\N	1	\N	\N	\N	2	f
194	\\x8ba698af78d89001a5c7acba2814a86fa229341569f680a060664b1fe99060d1	2021-12-23 11:32:59.743731+00	59	0	f	map-tiles	\N	1	\N	\N	\N	2	f
195	\\x17dd2df67d58c680618608f148780b880b018444453a51b1a5b79acd833456c7	2021-12-23 11:33:12.251574+00	141	999	f	ad-hoc	\N	1	\N	\N	\N	2	f
196	\\x093bbe641c9df92bc13d8b371ade7506ffb3f344742716e86d49315e61433ba8	2021-12-23 11:33:45.406976+00	96	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
197	\\x3dc4bb7dcca2a19ddaedf3abefcd50380f3f4472c410e3e9cfceb613efff2947	2021-12-23 11:33:45.65943+00	95	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
198	\\x3dc4bb7dcca2a19ddaedf3abefcd50380f3f4472c410e3e9cfceb613efff2947	2021-12-23 11:33:45.769216+00	10	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
199	\\x7fedff04ea1029158fdc64e6d54d8aab894b8510dc8880985efbf819dc24b01d	2021-12-23 11:33:45.791977+00	13	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
200	\\xa98f3ef4eb52ada75427ceefbea83f1fc3bd89ac41460efb8624d6cbb18549e3	2021-12-23 11:33:45.81133+00	9	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
201	\\x8c75d66996c877432fbd78fbda49732c695c0a3620c01d3fe675fd50fb6f39d2	2021-12-23 11:33:45.833675+00	11	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
202	\\x17dd2df67d58c680618608f148780b880b018444453a51b1a5b79acd833456c7	2021-12-23 11:34:01.039407+00	190	999	f	ad-hoc	\N	1	\N	\N	\N	2	f
203	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-23 11:37:22.968326+00	313	999	t	question	\N	1	1	1	\N	2	f
204	\\x1b1948b9ee043c61eb7181d9a5bd8604a6a50f60d53d2fc079c18bef14d29a5e	2021-12-23 11:38:18.562232+00	161	234	t	question	\N	1	1	1	\N	2	f
205	\\x7b506848a55c4e731fc032bfa2a16d79ef2533bf881b4e3ee9b7f83db59d0b67	2021-12-23 11:40:06.169916+00	50	234	t	ad-hoc	\N	1	\N	\N	\N	2	f
206	\\x2380eddd44728b365c00374d118847eedcfadd74d3847ae1e7da90b6dc12d937	2021-12-23 11:44:59.17921+00	84	0	t	ad-hoc	ERROR: syntax error at or near "WHERE"\n  Position: 666	1	\N	\N	\N	2	\N
207	\\xcb82f7e9429133eea78ec94bcedb81900323c6ed3324d04169910b492b39dc8f	2021-12-23 11:45:13.429601+00	30	0	t	ad-hoc	ERROR: column reference "organisation_id" is ambiguous\n  Position: 682	1	\N	\N	\N	2	\N
208	\\xb3d335e0ae18bf7265e4ee73e5e76eca586dd727ba12e38bee0f3c134fcb595b	2021-12-23 11:45:36.186975+00	105	233	t	ad-hoc	\N	1	\N	\N	\N	2	f
209	\\xe130a237fade7b51ee9a25dc8108770aff017b986ef034275fc0df4466d7f45a	2021-12-23 11:45:50.132689+00	75	233	t	ad-hoc	\N	1	\N	\N	\N	2	f
210	\\x53bb9e762a93d5c662022ac943c6b0a29572a791e8f23fdc153cbfdfe320b3a7	2021-12-23 11:46:03.82424+00	75	233	t	ad-hoc	\N	1	\N	\N	\N	2	f
211	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-23 11:49:29.216529+00	500	999	t	question	\N	1	1	1	\N	2	f
212	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-23 11:49:29.399943+00	543	2000	t	question	\N	1	2	1	\N	2	f
213	\\x4590ee10c49cba0550f14ef9ef7752f6d5ce493e5af5750eaf86a2b709064527	2021-12-23 11:51:15.043868+00	184	234	t	question	\N	1	1	1	\N	2	f
214	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-23 11:51:15.044594+00	441	2000	t	question	\N	1	2	1	\N	2	f
215	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-23 11:52:07.970512+00	386	2000	t	question	\N	1	2	1	\N	2	f
216	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-23 11:52:07.972468+00	476	999	t	question	\N	1	1	1	\N	2	f
217	\\x4590ee10c49cba0550f14ef9ef7752f6d5ce493e5af5750eaf86a2b709064527	2021-12-23 11:52:19.630816+00	117	234	t	question	\N	1	1	1	\N	2	f
218	\\x383f830b253551a87126b3674602de760eb793096d1c58326a28c619c61a2ae1	2021-12-23 11:52:19.630822+00	138	234	t	question	\N	1	2	1	\N	2	f
219	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-23 11:52:45.775091+00	447	999	t	question	\N	1	1	1	\N	2	f
220	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-23 11:52:45.77428+00	496	2000	t	question	\N	1	2	1	\N	2	f
221	\\x09e3cd6972b75f995fcdaccdc4113b72232d26645caed5b0d0df62dafc5f215a	2021-12-23 11:53:10.678456+00	80	29	t	question	\N	1	1	1	\N	2	f
222	\\xfc8106d2ec863b1333e775e91b2b79437fa1e49d328f2f8777a17696e38ce363	2021-12-23 11:53:10.678456+00	98	29	t	question	\N	1	2	1	\N	2	f
223	\\x4fb59c47e2123fa459cbf35462100580c94b8225acb98ad9acce6da98a4ab4ae	2021-12-23 11:56:03.392445+00	88	28	t	question	\N	1	2	1	\N	2	f
224	\\x54d6a751a83bbe3d4662ec7559f8da8ea07a0f7970037075c8975c27cae25423	2021-12-23 11:56:03.392421+00	107	28	t	question	\N	1	1	1	\N	2	f
225	\\x4fb59c47e2123fa459cbf35462100580c94b8225acb98ad9acce6da98a4ab4ae	2021-12-23 11:57:47.146726+00	51	28	t	question	\N	1	2	\N	\N	2	f
226	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-23 11:57:53.203018+00	313	2000	t	question	\N	1	2	\N	\N	2	f
227	\\xc5704cca77929c29bb1cd4209cb3b769bcd1f872b614d5b9e34f7a1556bd9d90	2021-12-23 11:59:00.037029+00	382	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
228	\\x7ee1ab1352968da1adbad58e84939629852e3f89d65de871e0b3d6abd05c5c6c	2021-12-23 11:59:14.887934+00	226	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
229	\\x73722bc22b3fd98d64b05b3c8428129ba17e9ddbe8220f75914333bdd1a89fff	2021-12-23 12:00:38.724975+00	352	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
230	\\x59a42eab268e4f84fb8e4957adac89ae8369533e324c02eab35ab8d15912740d	2021-12-23 12:01:12.236901+00	484	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
234	\\x9a53d143b134ac2972f7c267c8c0d079ab0297303a967a1020895a95294271eb	2021-12-23 12:04:54.112712+00	333	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
231	\\x187418eddb3c52fe6f13ae074c65aaf42fa75bc30b7adb88ef5cd3089cb488f6	2021-12-23 12:01:45.52772+00	31	0	t	ad-hoc	ERROR: column "co.id" must appear in the GROUP BY clause or be used in an aggregate function\n  Position: 135	1	\N	\N	\N	2	\N
232	\\x45c9121af0414d965a21bd75a33cae888320d118b512eca8df1873b9f6f69991	2021-12-23 12:01:59.856918+00	329	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
233	\\x73722bc22b3fd98d64b05b3c8428129ba17e9ddbe8220f75914333bdd1a89fff	2021-12-23 12:03:44.383786+00	269	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
238	\\x3eb1b2d910f1e5d921dfdda7f9e1922deaf943aedec551eace4e7738d5325bb4	2021-12-23 12:12:07.737808+00	312	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
239	\\x52dc1f283c4dbf053fc533b74fb0b2ff7caa8e4ce5b8f45553753a847273cf33	2021-12-23 12:12:27.837727+00	347	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
240	\\xafce2cd7703ada38dd0294f77039e7d2459f0e51aab639114f0a4ec1267cefbe	2021-12-23 12:12:42.869841+00	418	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
241	\\x9df28ce7c95b565accc11ba87c45c201eb52e883cb0245fd797af73025807d81	2021-12-23 12:14:12.154601+00	287	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
242	\\x919ed64d7d0cc66439bec5b2def2f8b8c1571f2fb65ee11d91e1ec852552b725	2021-12-23 12:14:33.577942+00	329	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
243	\\x36c7a05853d3014306b0cd6cc5b24458390e99b9c7b92d2878c3a3aee773a213	2021-12-23 12:14:49.010021+00	408	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
244	\\xd6753ee905e1ae1cc7f0ec25387b8b337c37fdc30f979d94a0833affcec53c41	2021-12-23 12:15:06.621891+00	331	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
245	\\xa7f404acff8ee194cdb5131c8ef65639b44e401d734f9fe98e76bb984561f556	2021-12-23 12:15:40.415152+00	25	0	t	ad-hoc	ERROR: column "co.id" must appear in the GROUP BY clause or be used in an aggregate function\n  Position: 126	1	\N	\N	\N	2	\N
246	\\xa99c5e3468c103e2f6097a14348189a37b4fad92ef8c53ff634428400814d70c	2021-12-23 12:15:48.569511+00	339	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
247	\\x78164292e78ee57f83d97bc341fce1e747b46951d7b7a207318531f6366235f7	2021-12-23 12:16:10.275346+00	360	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
248	\\xb68ad55c51d5823481f5ce7cddc789530c209bc49c47836082982560a7dfb037	2021-12-23 12:16:23.251257+00	469	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
260	\\xc8cad119be21987b9c88308a6aa949ee6be7b8304c846ef4dc6c37fdea2aa0bd	2021-12-23 12:21:32.025467+00	387	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
261	\\xe92fbfcc5523060ba697eafdb6761d97899f5612947c41f2fff426cbdfa118cb	2021-12-23 12:22:08.853113+00	47	0	t	ad-hoc	ERROR: invalid reference to FROM-clause entry for table "coped_subject"\n  Hint: Perhaps you meant to reference the table alias "cs".\n  Position: 429	1	\N	\N	\N	2	\N
262	\\xdc1f2bc1a9ddba29384478325e1c84060a4266ff5739b83e6a3f971274ac8864	2021-12-23 12:22:31.288901+00	81	49	t	ad-hoc	\N	1	\N	\N	\N	2	f
263	\\x46a65b33a3634e82f7d3c92790d57045855ff82a58abb557178f6a8db756b3dd	2021-12-23 12:23:02.813362+00	68	49	t	ad-hoc	\N	1	\N	\N	\N	2	f
270	\\x516e07d52dd30488e2b477a52fcf90ec656790f446998f998761bee3db08488a	2021-12-23 12:26:55.057021+00	114	233	t	question	\N	1	2	1	\N	2	f
278	\\x468b781f1e2b89bf52076630fd1ac521987bfcbe88e67dc58e0321e4f8a121f5	2021-12-23 12:38:35.453116+00	25	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
283	\\x9bb2a6ea086168bcbfee96588c731a0422be27760a43c4e1f04a7860f151f2eb	2021-12-23 12:38:35.596381+00	6	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
285	\\xa0655e96ea90524114ca81a8e14d1854226c8fab83e17105416e1e4288cfcc23	2021-12-23 12:38:35.630436+00	6	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
287	\\x88d885960f3013363f1ea6e564e70a489f2b6fc82b8acd9289ff191d6d4af7ce	2021-12-23 12:39:07.539731+00	72	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
289	\\x58f785bcce4d51ef20eaa22ab74e5b16c2504773f0d761d6d6c4d2110d23fd48	2021-12-23 12:39:07.715655+00	12	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
291	\\x1bae91e5d5a4e9c73dbec18b6cb7b0afdef41debc8e45d7f74fe2ec4cf91d707	2021-12-23 12:39:07.76523+00	10	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
299	\\x58f785bcce4d51ef20eaa22ab74e5b16c2504773f0d761d6d6c4d2110d23fd48	2021-12-23 12:39:35.946772+00	9	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
303	\\x9bb2a6ea086168bcbfee96588c731a0422be27760a43c4e1f04a7860f151f2eb	2021-12-23 12:39:36.029591+00	9	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
308	\\x468b781f1e2b89bf52076630fd1ac521987bfcbe88e67dc58e0321e4f8a121f5	2021-12-23 12:39:46.800478+00	28	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
235	\\xfb157e8c136ffa21133558a81f99369e7ae5ed6369dde8cad2de646a9e7f20e6	2021-12-23 12:05:57.279157+00	419	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
236	\\x59a42eab268e4f84fb8e4957adac89ae8369533e324c02eab35ab8d15912740d	2021-12-23 12:06:09.674776+00	349	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
237	\\x606107b82889442b9eb540ea0ed682cd670a86d83c7cdab80086b5597de38053	2021-12-23 12:08:23.63372+00	1067	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
249	\\xa6a6d8399f14c9af6cc39772926c186c0d635dfce7a3df6e96cc886ee7dcbdda	2021-12-23 12:17:01.363398+00	402	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
250	\\xba7c2fa77a86ba98e12feeface2867ab0b1ff973de7e9c95886546d0138d3226	2021-12-23 12:17:37.106472+00	449	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
251	\\x47bcf3dcb06d2da68b415a07d4ce3dcdbd9d39d64033452fc67eca03b534c00a	2021-12-23 12:17:59.705171+00	445	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
252	\\x191511173f41a8251c3f71ec2ad9644cbb82b502fe5ceb22b6c161bbe33b46d6	2021-12-23 12:18:14.952836+00	258	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
253	\\xbfc7f92f55de7d095b226a96e213f9bf82f6a7eac2d94f20f0f89732956d6606	2021-12-23 12:18:25.662791+00	245	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
254	\\x5aa344beb96b9d4ab535df90043c756bdf3704abdeccd70534fd1e974ca194fe	2021-12-23 12:18:35.567793+00	275	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
255	\\xe9a627f9c1bc2c6ab3ca95d256b1e26993debcc3b9d9559f030c5897fa8b6b0d	2021-12-23 12:19:33.13897+00	24	0	t	ad-hoc	ERROR: column "hits" does not exist\n  Position: 438	1	\N	\N	\N	2	\N
256	\\x7baebe5d03035b649be8041ae3bfdeea78a01b8e2dba1f061d15f90aa08adc23	2021-12-23 12:19:47.71204+00	327	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
257	\\xd9abbf26da47cb171feaf11d145e546e0ba7cb44e3ca225985941df85efc30cc	2021-12-23 12:20:47.361557+00	313	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
258	\\x4d0d9db4ffffed8a2306aa5bd2097cff3db9e944f1ca6bafc2ea8106cd35ce22	2021-12-23 12:21:03.137578+00	266	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
259	\\x37be49163739427db886a5545872d8300aaa2d1342ed523d1c4fdccc0153a0de	2021-12-23 12:21:14.11643+00	325	2000	t	ad-hoc	\N	1	\N	\N	\N	2	f
264	\\xe46c52df71875a4c68bd4d870012d26732c544e8a965b63ebf0abee26bbf3a6e	2021-12-23 12:23:27.017638+00	81	49	t	ad-hoc	\N	1	\N	\N	\N	2	f
265	\\x23eccb32b52be1cd92c713c07b1424ab56da8d8ae30db686d1033e32c1660cbe	2021-12-23 12:23:35.191294+00	34	0	t	ad-hoc	ERROR: syntax error at or near ","\n  Position: 119	1	\N	\N	\N	2	\N
266	\\x46a65b33a3634e82f7d3c92790d57045855ff82a58abb557178f6a8db756b3dd	2021-12-23 12:23:40.575439+00	61	49	t	ad-hoc	\N	1	\N	\N	\N	2	f
267	\\xe46c52df71875a4c68bd4d870012d26732c544e8a965b63ebf0abee26bbf3a6e	2021-12-23 12:24:49.097581+00	75	49	t	ad-hoc	\N	1	\N	\N	\N	2	f
268	\\x246fd5923b029aecb71557ce1b011a98ffe07e0ce150a601c821dfef23f52534	2021-12-23 12:25:12.781578+00	57	49	t	ad-hoc	\N	1	\N	\N	\N	2	f
269	\\x7e0e3b63bfda45839ff92ea7a6fbbaff89eac8100305f1c3ad26e74ef673e016	2021-12-23 12:25:38.771936+00	73	49	t	ad-hoc	\N	1	\N	\N	\N	2	f
271	\\x1b1948b9ee043c61eb7181d9a5bd8604a6a50f60d53d2fc079c18bef14d29a5e	2021-12-23 12:26:55.057054+00	175	234	t	question	\N	1	1	1	\N	2	f
272	\\xe446109e4719cbc9db5747190ed4481c06c6eabc962c6e2c5382afad4f14f48c	2021-12-23 12:28:32.707359+00	122	212	t	question	\N	1	2	1	\N	2	f
273	\\x4b66221f051e244ab44c4d5b8987b303092a4340c56a59cd580f40f25f5ec960	2021-12-23 12:28:32.707358+00	120	213	t	question	\N	1	1	1	\N	2	f
274	\\x103fe9e491bf5de3905337700fad9ae72e10c9f462e1b1b35534d4c9c2a57c5e	2021-12-23 12:31:58.916413+00	650	2000	f	ad-hoc	\N	1	\N	\N	\N	2	f
275	\\x2c3c9426c189a16fe53bdccfa21c5cb514692d929af673d66288f870c33bd828	2021-12-23 12:32:36.231299+00	636	2000	f	ad-hoc	\N	1	\N	\N	\N	2	f
276	\\x17425f56f2b9c4bf1f65f5c2b99a7c4f55b44e57d4f083c4690e03f42741dcb9	2021-12-23 12:38:28.122153+00	560	2000	f	ad-hoc	\N	1	\N	\N	\N	2	f
277	\\x88d885960f3013363f1ea6e564e70a489f2b6fc82b8acd9289ff191d6d4af7ce	2021-12-23 12:38:35.296907+00	85	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
279	\\x58f785bcce4d51ef20eaa22ab74e5b16c2504773f0d761d6d6c4d2110d23fd48	2021-12-23 12:38:35.485214+00	8	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
280	\\xea83d312bdc60d58551390ac1d923f47b3ce544c4ab4ed6866e601afa43daaef	2021-12-23 12:38:35.506469+00	9	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
281	\\x1bae91e5d5a4e9c73dbec18b6cb7b0afdef41debc8e45d7f74fe2ec4cf91d707	2021-12-23 12:38:35.531169+00	20	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
282	\\xbfea33e7eb228dd3f31db644b046a3087f5c6e4336b605df1c07ec08de57f58b	2021-12-23 12:38:35.569833+00	14	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
284	\\x9db94e842eb9c065c628490ac3bac5a7aae3abe74a4e9323c16a06bcb33469d8	2021-12-23 12:38:35.609954+00	8	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
286	\\xdae44f69b78829297add884f535a02f9dc7f1e596affe2a2b50d3cb86d77c444	2021-12-23 12:39:01.724387+00	85	20	f	ad-hoc	\N	1	\N	\N	\N	2	f
288	\\x468b781f1e2b89bf52076630fd1ac521987bfcbe88e67dc58e0321e4f8a121f5	2021-12-23 12:39:07.65188+00	30	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
290	\\xea83d312bdc60d58551390ac1d923f47b3ce544c4ab4ed6866e601afa43daaef	2021-12-23 12:39:07.741885+00	9	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
292	\\xbfea33e7eb228dd3f31db644b046a3087f5c6e4336b605df1c07ec08de57f58b	2021-12-23 12:39:07.78283+00	6	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
293	\\x9bb2a6ea086168bcbfee96588c731a0422be27760a43c4e1f04a7860f151f2eb	2021-12-23 12:39:07.799662+00	6	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
294	\\x9db94e842eb9c065c628490ac3bac5a7aae3abe74a4e9323c16a06bcb33469d8	2021-12-23 12:39:07.812494+00	11	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
295	\\xa0655e96ea90524114ca81a8e14d1854226c8fab83e17105416e1e4288cfcc23	2021-12-23 12:39:07.843201+00	11	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
296	\\xe52d8ecf5363a3402d7969e3b21a96aed2d9ade6d3bdd00aaeb871e0338a0ab9	2021-12-23 12:39:34.045534+00	72	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
297	\\x88d885960f3013363f1ea6e564e70a489f2b6fc82b8acd9289ff191d6d4af7ce	2021-12-23 12:39:35.860845+00	32	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
298	\\x468b781f1e2b89bf52076630fd1ac521987bfcbe88e67dc58e0321e4f8a121f5	2021-12-23 12:39:35.911937+00	20	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
300	\\xea83d312bdc60d58551390ac1d923f47b3ce544c4ab4ed6866e601afa43daaef	2021-12-23 12:39:35.965681+00	9	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
301	\\x1bae91e5d5a4e9c73dbec18b6cb7b0afdef41debc8e45d7f74fe2ec4cf91d707	2021-12-23 12:39:35.984489+00	7	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
302	\\xbfea33e7eb228dd3f31db644b046a3087f5c6e4336b605df1c07ec08de57f58b	2021-12-23 12:39:36.011328+00	10	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
304	\\xa0655e96ea90524114ca81a8e14d1854226c8fab83e17105416e1e4288cfcc23	2021-12-23 12:39:36.063575+00	7	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
305	\\x9db94e842eb9c065c628490ac3bac5a7aae3abe74a4e9323c16a06bcb33469d8	2021-12-23 12:39:36.04491+00	12	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
306	\\xe52d8ecf5363a3402d7969e3b21a96aed2d9ade6d3bdd00aaeb871e0338a0ab9	2021-12-23 12:39:39.362838+00	59	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
307	\\x88d885960f3013363f1ea6e564e70a489f2b6fc82b8acd9289ff191d6d4af7ce	2021-12-23 12:39:46.7317+00	37	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
309	\\x58f785bcce4d51ef20eaa22ab74e5b16c2504773f0d761d6d6c4d2110d23fd48	2021-12-23 12:39:46.839031+00	12	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
310	\\xea83d312bdc60d58551390ac1d923f47b3ce544c4ab4ed6866e601afa43daaef	2021-12-23 12:39:46.864689+00	13	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
311	\\x1bae91e5d5a4e9c73dbec18b6cb7b0afdef41debc8e45d7f74fe2ec4cf91d707	2021-12-23 12:39:46.889062+00	12	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
312	\\xbfea33e7eb228dd3f31db644b046a3087f5c6e4336b605df1c07ec08de57f58b	2021-12-23 12:39:46.916218+00	12	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
313	\\x9bb2a6ea086168bcbfee96588c731a0422be27760a43c4e1f04a7860f151f2eb	2021-12-23 12:39:46.944361+00	10	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
314	\\xa0655e96ea90524114ca81a8e14d1854226c8fab83e17105416e1e4288cfcc23	2021-12-23 12:39:46.978757+00	7	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
315	\\x9db94e842eb9c065c628490ac3bac5a7aae3abe74a4e9323c16a06bcb33469d8	2021-12-23 12:39:46.964604+00	7	1	f	ad-hoc	\N	1	\N	\N	\N	2	f
316	\\x81613dd5240c8a287a0a33215984f4e795c94ad298a0a9d5708145b8be0605b4	2021-12-23 12:40:17.275782+00	573	2000	f	ad-hoc	\N	1	\N	\N	\N	2	f
317	\\xa9dd8fd5655856d6188b1e0ee4fa529eb26b05a523b9cf1f0244c1f1be17bd9f	2021-12-23 12:40:58.100378+00	555	2000	f	public-question	\N	\N	3	\N	\N	2	f
318	\\x0485c4bbcdffad998953aff4b625a0a0a137286872fb80d99815eba8edfa7b61	2021-12-23 12:43:55.312128+00	273	2000	t	question	\N	1	3	\N	\N	2	f
319	\\x52769f6f24dfb47a6aa2fc0e7ca2d1e394cafa81a79eddb733b1ebc4bbceeb11	2021-12-23 12:44:00.300812+00	53	0	t	ad-hoc	\N	1	\N	\N	\N	2	f
320	\\x6549080b267f41c37a2df2cb14e4539056f2d48b537ada0fe621330004720b57	2021-12-23 12:44:12.721144+00	32	0	t	ad-hoc	The column index is out of range: 1, number of columns: 0.	1	\N	\N	\N	2	\N
321	\\xa294ef7125e5976a86bcfafad7c83e4e1d6a0e22154e73a5a952cc5b86d9ddbb	2021-12-23 12:44:33.167858+00	18	0	t	ad-hoc	The column index is out of range: 1, number of columns: 0.	1	\N	\N	\N	2	\N
322	\\x7d7ce59de199c6740180f0d2906a4957e29b671673c039a8cf2a21f3b0a39dd9	2021-12-23 12:47:06.909159+00	70	75	t	ad-hoc	\N	1	\N	\N	\N	2	f
323	\\xccca714e428a5813eb6438385a78e7d8bdbb2e6cca5c2f2fb3a2d52c372643cd	2021-12-23 12:47:29.170828+00	58	0	t	ad-hoc	\N	1	\N	\N	\N	2	f
324	\\x0485c4bbcdffad998953aff4b625a0a0a137286872fb80d99815eba8edfa7b61	2021-12-23 12:49:22.114315+00	308	2000	t	public-question	\N	\N	3	\N	\N	2	f
325	\\x9be1dc2ea449e4d03eeaf7d8d1d33a4aaabdee3a8dbd402b2cf21f5fcf7a62b9	2021-12-23 12:49:29.270086+00	66	0	t	public-question	\N	\N	3	\N	\N	2	f
326	\\x8a7a08dfdc4e6cd5c6f627a7ac78a4ff31c8d69dd2da804640af0cd8b2c98587	2021-12-23 12:49:35.887657+00	35	0	t	public-question	\N	\N	3	\N	\N	2	f
327	\\x8e0f623e5770e1548846ce9be4ae755c2086e6e2c74eb12a72c582ff38699a34	2021-12-23 12:49:46.927543+00	61	186	t	ad-hoc	\N	1	\N	\N	\N	2	f
328	\\x8f73f42631e58b9fc3b507e4c866b842dbebd7cfb34a671e0d5a616fa248a9e0	2021-12-23 12:49:58.97232+00	108	186	t	public-question	\N	\N	3	\N	\N	2	f
335	\\xe5c486d5b737e4a2aeec21c9390803fa2abf15096ad0fdcb45c5114cce0dbc46	2021-12-23 12:56:29.185352+00	94	7	f	ad-hoc	\N	1	\N	\N	\N	2	f
337	\\xe5c486d5b737e4a2aeec21c9390803fa2abf15096ad0fdcb45c5114cce0dbc46	2021-12-23 13:00:22.654977+00	84	7	f	ad-hoc	\N	1	\N	\N	\N	2	f
338	\\x0d254b1212dba21ec0669062cab6eee06aa3c94517076680e61d6c4a508468f2	2021-12-23 13:02:33.671975+00	374	2000	f	ad-hoc	\N	1	\N	\N	\N	2	f
341	\\x9c794d51a286105a43232d21f9290675cace2d127a80244d9cb7b5d544d27528	2021-12-23 14:35:00.324092+00	68	5	t	public-question	\N	\N	3	\N	\N	2	f
342	\\x4054ffcdd5d7b3fa3f1921f01968e42050db816890a770354aec6f54a3503d28	2021-12-23 14:35:04.680218+00	66	75	t	public-question	\N	\N	3	\N	\N	2	f
343	\\x12a466760fbcbb8a15e06b8108dffde5789d8993eb882105be96ec9df5905392	2021-12-23 14:35:18.308459+00	414	2000	t	public-question	\N	\N	3	\N	\N	2	f
329	\\x103fe9e491bf5de3905337700fad9ae72e10c9f462e1b1b35534d4c9c2a57c5e	2021-12-23 12:52:42.337545+00	506	2000	f	ad-hoc	\N	1	\N	\N	\N	2	f
331	\\x8ee6c64bbde4986c46cafa5a00435e5c24747de9ef7d0cbf6a935a7151e7aca6	2021-12-23 12:55:01.305825+00	147	2000	f	ad-hoc	\N	1	\N	\N	\N	2	f
332	\\xd2258362753c79a0dc2107409be48cd00766037fa158c3786a679db333526eea	2021-12-23 12:55:20.806109+00	193	2000	f	ad-hoc	\N	1	\N	\N	\N	2	f
333	\\xd795319a95535cb43b4fd9aa217197ce2e28175d260359c3bae12947efe972bd	2021-12-23 12:55:52.255631+00	65	7	f	ad-hoc	\N	1	\N	\N	\N	2	f
339	\\xf71f161a1953ea3bad4654f814530354fe8264a3d0746013193abccfdb94819e	2021-12-23 14:34:44.333534+00	89	0	t	public-question	\N	\N	3	\N	\N	2	f
340	\\xc3449e9dfb6adffadd0f1b592e6020695e698df89e08512d493784f4d2864089	2021-12-23 14:34:51.696494+00	78	17	t	public-question	\N	\N	3	\N	\N	2	f
330	\\x151cfe7ff951ca254fa3c0be6a12aedc30eea47047f8c66fd3e85ddb060de229	2021-12-23 12:54:32.84295+00	437	2000	f	ad-hoc	\N	1	\N	\N	\N	2	f
334	\\xe5c486d5b737e4a2aeec21c9390803fa2abf15096ad0fdcb45c5114cce0dbc46	2021-12-23 12:56:29.185326+00	74	7	f	ad-hoc	\N	1	\N	\N	\N	2	f
336	\\x1b5741529e54bd4dd3e8fa6e0b83b203d167987d8d72b3f441ac8c25b65f1263	2021-12-23 12:59:36.991927+00	88	7	f	ad-hoc	\N	1	\N	\N	\N	2	f
345	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:00:26.880123+00	1038	999	t	question	\N	1	1	1	\N	2	f
344	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:00:26.873238+00	1042	2000	t	question	\N	1	2	1	\N	2	f
346	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:04:18.059769+00	685	999	t	question	\N	1	1	1	\N	2	f
347	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:04:18.079365+00	684	2000	t	question	\N	1	2	1	\N	2	f
348	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:04:44.514006+00	986	999	t	question	\N	1	1	1	\N	2	f
349	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:04:44.518276+00	1055	2000	t	question	\N	1	2	1	\N	2	f
350	\\x285a5554c58f1bfa520e14ca4a5938070b16c76dc3400be6a457aa5cbcb24075	2021-12-24 00:05:59.643639+00	120	12	t	question	\N	1	2	1	\N	2	f
351	\\x6ff917cecaf7968b623c28821b469d50d8fd7dff21e536da6e163b30316172dc	2021-12-24 00:05:59.643103+00	149	12	t	question	\N	1	1	1	\N	2	f
352	\\x6ff917cecaf7968b623c28821b469d50d8fd7dff21e536da6e163b30316172dc	2021-12-24 00:06:17.99062+00	98	12	t	question	\N	1	1	1	\N	2	f
353	\\x285a5554c58f1bfa520e14ca4a5938070b16c76dc3400be6a457aa5cbcb24075	2021-12-24 00:06:17.991309+00	130	12	t	question	\N	1	2	1	\N	2	f
354	\\x285a5554c58f1bfa520e14ca4a5938070b16c76dc3400be6a457aa5cbcb24075	2021-12-24 00:06:59.600004+00	61	12	t	question	\N	1	2	\N	\N	2	f
355	\\x6ff917cecaf7968b623c28821b469d50d8fd7dff21e536da6e163b30316172dc	2021-12-24 00:07:36.829878+00	84	12	t	question	\N	1	1	1	\N	2	f
356	\\x285a5554c58f1bfa520e14ca4a5938070b16c76dc3400be6a457aa5cbcb24075	2021-12-24 00:07:36.819998+00	115	12	t	question	\N	1	2	1	\N	2	f
357	\\x285a5554c58f1bfa520e14ca4a5938070b16c76dc3400be6a457aa5cbcb24075	2021-12-24 00:07:40.669237+00	75	12	t	question	\N	1	2	1	\N	2	f
358	\\x6ff917cecaf7968b623c28821b469d50d8fd7dff21e536da6e163b30316172dc	2021-12-24 00:07:40.674192+00	89	12	t	question	\N	1	1	1	\N	2	f
359	\\x6ff917cecaf7968b623c28821b469d50d8fd7dff21e536da6e163b30316172dc	2021-12-24 00:08:58.326296+00	121	12	t	question	\N	1	1	1	\N	2	f
360	\\x285a5554c58f1bfa520e14ca4a5938070b16c76dc3400be6a457aa5cbcb24075	2021-12-24 00:08:58.325352+00	143	12	t	question	\N	1	2	1	\N	2	f
361	\\x6ff917cecaf7968b623c28821b469d50d8fd7dff21e536da6e163b30316172dc	2021-12-24 00:10:36.552626+00	79	12	t	question	\N	1	1	1	\N	2	f
362	\\x285a5554c58f1bfa520e14ca4a5938070b16c76dc3400be6a457aa5cbcb24075	2021-12-24 00:10:36.55442+00	83	12	t	question	\N	1	2	1	\N	2	f
363	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:13:06.168042+00	874	999	t	public-dashboard	\N	1	1	1	\N	2	f
364	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:13:06.161871+00	967	2000	t	public-dashboard	\N	1	2	1	\N	2	f
365	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:21:29.496709+00	519	2000	t	question	\N	3	2	1	\N	2	f
366	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:21:29.501689+00	562	999	t	question	\N	3	1	1	\N	2	f
367	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:24:44.887416+00	329	2000	t	public-dashboard	\N	1	2	1	\N	2	f
368	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:24:44.887416+00	399	999	t	public-dashboard	\N	1	1	1	\N	2	f
369	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:25:47.948457+00	419	999	t	public-dashboard	\N	1	1	1	\N	2	f
370	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:25:47.949327+00	547	2000	t	public-dashboard	\N	1	2	1	\N	2	f
371	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:27:39.932748+00	297	2000	t	question	\N	1	2	1	\N	2	f
372	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:27:39.915254+00	410	999	t	question	\N	1	1	1	\N	2	f
373	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:28:28.009476+00	535	999	t	question	\N	1	1	1	\N	2	f
374	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:28:28.010699+00	552	2000	t	question	\N	1	2	1	\N	2	f
375	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:28:33.27075+00	381	999	t	public-dashboard	\N	1	1	1	\N	2	f
376	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:28:33.296454+00	373	2000	t	public-dashboard	\N	1	2	1	\N	2	f
377	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:29:01.101098+00	460	2000	t	public-dashboard	\N	1	2	1	\N	2	f
378	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:29:01.102111+00	608	999	t	public-dashboard	\N	1	1	1	\N	2	f
379	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:30:42.56702+00	674	999	t	public-dashboard	\N	1	1	1	\N	2	f
380	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:30:42.54827+00	713	2000	t	public-dashboard	\N	1	2	1	\N	2	f
381	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:32:53.293098+00	360	2000	t	question	\N	1	2	1	\N	2	f
382	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:32:53.293141+00	445	999	t	question	\N	1	1	1	\N	2	f
383	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:33:01.398981+00	281	2000	t	embedded-dashboard	\N	1	2	1	\N	2	f
384	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:33:01.398981+00	417	999	t	embedded-dashboard	\N	1	1	1	\N	2	f
385	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:33:11.520091+00	315	2000	t	embedded-dashboard	\N	1	2	1	\N	2	f
386	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:33:11.517113+00	501	999	t	embedded-dashboard	\N	1	1	1	\N	2	f
387	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:33:22.465342+00	296	2000	t	embedded-dashboard	\N	1	2	1	\N	2	f
388	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:33:22.459513+00	463	999	t	embedded-dashboard	\N	1	1	1	\N	2	f
389	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:33:27.588132+00	430	2000	t	embedded-dashboard	\N	1	2	1	\N	2	f
390	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:33:27.574841+00	510	999	t	embedded-dashboard	\N	1	1	1	\N	2	f
391	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:33:29.85288+00	317	2000	t	embedded-dashboard	\N	1	2	1	\N	2	f
392	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:33:29.857605+00	426	999	t	embedded-dashboard	\N	1	1	1	\N	2	f
393	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:33:39.368689+00	282	2000	t	embedded-dashboard	\N	1	2	1	\N	2	f
394	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:33:39.363946+00	395	999	t	embedded-dashboard	\N	1	1	1	\N	2	f
395	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:33:54.028499+00	326	2000	t	embedded-dashboard	\N	1	2	1	\N	2	f
396	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:33:54.041741+00	437	999	t	embedded-dashboard	\N	1	1	1	\N	2	f
397	\\x2a7bddafce7df525ea5f433b43df046d83dc9787b058bff87177afd2eef30ace	2021-12-24 00:34:16.25784+00	66	7	t	embedded-dashboard	\N	1	1	1	\N	2	f
398	\\xa2e662989d88513537dcafc14e7cf4ba24804ad36f03fe7c6ca9dae56077d745	2021-12-24 00:34:16.258476+00	79	7	t	embedded-dashboard	\N	1	2	1	\N	2	f
399	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:34:30.539395+00	444	2000	t	embedded-dashboard	\N	1	2	1	\N	2	f
400	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:34:30.536808+00	466	999	t	embedded-dashboard	\N	1	1	1	\N	2	f
401	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:34:49.273902+00	258	2000	t	embedded-dashboard	\N	1	2	1	\N	2	f
402	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:34:49.268138+00	363	999	t	embedded-dashboard	\N	1	1	1	\N	2	f
403	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:34:53.299485+00	287	2000	t	embedded-dashboard	\N	1	2	1	\N	2	f
404	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:34:53.299461+00	347	999	t	embedded-dashboard	\N	1	1	1	\N	2	f
405	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:48:19.214966+00	732	999	t	public-dashboard	\N	1	1	1	\N	2	f
406	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:48:19.206048+00	757	2000	t	public-dashboard	\N	1	2	1	\N	2	f
407	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:49:38.017299+00	1874	999	t	public-dashboard	\N	1	1	1	\N	2	f
408	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:49:38.017668+00	2272	2000	t	public-dashboard	\N	1	2	1	\N	2	f
409	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:58:00.343036+00	1120	999	t	public-dashboard	\N	1	1	1	\N	2	f
410	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:58:00.3429+00	1137	2000	t	public-dashboard	\N	1	2	1	\N	2	f
411	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:58:09.268387+00	702	999	t	public-dashboard	\N	1	1	1	\N	2	f
412	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:58:09.268387+00	714	2000	t	public-dashboard	\N	1	2	1	\N	2	f
413	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 00:59:14.679629+00	631	2000	t	public-dashboard	\N	1	2	1	\N	2	f
414	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 00:59:14.660435+00	710	999	t	public-dashboard	\N	1	1	1	\N	2	f
415	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 01:00:27.874984+00	740	999	t	public-dashboard	\N	1	1	1	\N	2	f
416	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 01:00:27.877458+00	805	2000	t	public-dashboard	\N	1	2	1	\N	2	f
417	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 01:21:22.489515+00	864	2000	t	public-dashboard	\N	1	2	1	\N	2	f
418	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 01:21:22.489655+00	1053	999	t	public-dashboard	\N	1	1	1	\N	2	f
419	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:21:23.98639+00	669	2000	t	question	\N	1	2	1	\N	2	f
420	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:21:23.986435+00	738	999	t	question	\N	1	1	1	\N	2	f
421	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:21:27.703643+00	559	999	t	public-dashboard	\N	1	1	1	\N	2	f
422	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:21:27.715868+00	565	2000	t	public-dashboard	\N	1	2	1	\N	2	f
423	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:22:17.20229+00	272	2000	t	public-dashboard	\N	1	2	1	\N	2	f
424	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:22:17.198308+00	385	999	t	public-dashboard	\N	1	1	1	\N	2	f
425	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:22:24.228396+00	344	2000	t	question	\N	1	2	1	\N	2	f
426	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:22:24.232365+00	416	999	t	question	\N	1	1	1	\N	2	f
427	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:22:30.538844+00	266	2000	t	question	\N	1	2	1	\N	2	f
428	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:22:30.538826+00	336	999	t	question	\N	1	1	1	\N	2	f
429	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:22:43.871221+00	270	999	t	question	\N	1	1	\N	\N	2	f
430	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:23:05.292323+00	314	2000	t	question	\N	1	2	1	\N	2	f
431	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:23:05.293321+00	424	999	t	question	\N	1	1	1	\N	2	f
432	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:23:08.961295+00	330	999	t	question	\N	1	1	1	\N	2	f
433	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:23:08.958387+00	394	2000	t	question	\N	1	2	1	\N	2	f
434	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:23:52.963043+00	281	2000	t	public-dashboard	\N	1	2	1	\N	2	f
435	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:23:52.940881+00	348	999	t	public-dashboard	\N	1	1	1	\N	2	f
436	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:24:59.079595+00	593	2000	t	public-dashboard	\N	1	2	1	\N	2	f
437	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:24:59.080635+00	666	999	t	public-dashboard	\N	1	1	1	\N	2	f
438	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:33:16.262402+00	409	2000	t	public-dashboard	\N	1	2	1	\N	2	f
439	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:33:16.238359+00	552	999	t	public-dashboard	\N	1	1	1	\N	2	f
440	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:33:31.748501+00	387	2000	t	public-dashboard	\N	1	2	1	\N	2	f
441	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:33:31.746798+00	649	999	t	public-dashboard	\N	1	1	1	\N	2	f
442	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:34:10.779641+00	254	2000	t	question	\N	1	2	1	\N	2	f
443	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:34:10.779662+00	346	999	t	question	\N	1	1	1	\N	2	f
444	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:38:31.468337+00	519	2000	t	public-dashboard	\N	1	2	1	\N	2	f
445	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:38:31.459535+00	654	999	t	public-dashboard	\N	1	1	1	\N	2	f
446	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:38:50.671803+00	1109	999	t	public-dashboard	\N	1	1	1	\N	2	f
447	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:38:50.671781+00	1208	2000	t	public-dashboard	\N	1	2	1	\N	2	f
448	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:41:23.192028+00	692	2000	t	question	\N	1	2	1	\N	2	f
449	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:41:23.167761+00	789	999	t	question	\N	1	1	1	\N	2	f
450	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:41:53.394243+00	812	2000	t	question	\N	1	2	1	\N	2	f
451	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:41:53.39474+00	975	999	t	question	\N	1	1	1	\N	2	f
452	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:42:33.724898+00	396	2000	t	question	\N	1	2	1	\N	2	f
453	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:42:33.724882+00	680	999	t	question	\N	1	1	1	\N	2	f
454	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:42:38.17805+00	323	2000	t	public-dashboard	\N	1	2	1	\N	2	f
455	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:42:38.163521+00	400	999	t	public-dashboard	\N	1	1	1	\N	2	f
456	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:44:13.141293+00	380	999	t	public-dashboard	\N	1	1	1	\N	2	f
457	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:44:13.1493+00	409	2000	t	public-dashboard	\N	1	2	1	\N	2	f
458	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:45:46.311021+00	233	2000	t	public-dashboard	\N	1	2	1	\N	2	f
459	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:45:46.292592+00	461	999	t	public-dashboard	\N	1	1	1	\N	2	f
460	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:46:40.021588+00	383	2000	t	public-dashboard	\N	1	2	1	\N	2	f
461	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:46:40.001876+00	461	999	t	public-dashboard	\N	1	1	1	\N	2	f
462	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:51:44.363036+00	392	999	t	public-dashboard	\N	1	1	1	\N	2	f
463	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:51:44.379278+00	392	2000	t	public-dashboard	\N	1	2	1	\N	2	f
464	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:51:58.867201+00	351	2000	t	public-dashboard	\N	1	2	1	\N	2	f
465	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:51:58.85041+00	504	999	t	public-dashboard	\N	1	1	1	\N	2	f
466	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:52:25.299519+00	422	2000	t	public-dashboard	\N	1	2	1	\N	2	f
467	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:52:25.278349+00	499	999	t	public-dashboard	\N	1	1	1	\N	2	f
468	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:54:26.431125+00	257	2000	t	public-dashboard	\N	1	2	1	\N	2	f
469	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:54:26.41515+00	361	999	t	public-dashboard	\N	1	1	1	\N	2	f
472	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:57:03.963078+00	442	2000	t	public-dashboard	\N	1	2	1	\N	2	f
476	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 03:00:20.050121+00	583	999	t	public-dashboard	\N	1	1	1	\N	2	f
478	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 03:00:52.210198+00	618	2000	t	public-dashboard	\N	1	2	1	\N	2	f
480	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 03:11:13.078277+00	732	999	t	question	\N	1	1	1	\N	2	f
488	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 03:11:55.452197+00	390	2000	t	public-dashboard	\N	1	2	1	\N	2	f
470	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:56:45.129664+00	402	2000	t	public-dashboard	\N	1	2	1	\N	2	f
475	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:57:08.134886+00	614	999	t	public-dashboard	\N	1	1	1	\N	2	f
482	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 03:11:22.885375+00	449	2000	t	question	\N	1	2	1	\N	2	f
483	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 03:11:22.877059+00	506	999	t	question	\N	1	1	1	\N	2	f
485	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 03:11:28.408497+00	659	999	t	public-dashboard	\N	1	1	1	\N	2	f
490	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 03:12:19.088288+00	302	2000	t	question	\N	1	2	1	\N	2	f
491	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 03:12:19.088523+00	391	999	t	question	\N	1	1	1	\N	2	f
471	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:56:45.110112+00	520	999	t	public-dashboard	\N	1	1	1	\N	2	f
473	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 02:57:03.935376+00	508	999	t	public-dashboard	\N	1	1	1	\N	2	f
474	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 02:57:08.144322+00	447	2000	t	public-dashboard	\N	1	2	1	\N	2	f
477	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 03:00:20.060443+00	603	2000	t	public-dashboard	\N	1	2	1	\N	2	f
479	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 03:00:52.192467+00	849	999	t	public-dashboard	\N	1	1	1	\N	2	f
481	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 03:11:13.078318+00	774	2000	t	question	\N	1	2	1	\N	2	f
484	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 03:11:28.415964+00	318	2000	t	public-dashboard	\N	1	2	1	\N	2	f
489	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 03:11:55.457075+00	545	999	t	public-dashboard	\N	1	1	1	\N	2	f
486	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 03:11:41.626185+00	423	2000	t	public-dashboard	\N	1	2	1	\N	2	f
487	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 03:11:41.60672+00	518	999	t	public-dashboard	\N	1	1	1	\N	2	f
493	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 03:12:54.180816+00	369	999	t	question	\N	1	1	1	\N	2	f
492	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 03:12:54.181783+00	372	2000	t	question	\N	1	2	1	\N	2	f
494	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 03:13:00.310045+00	398	2000	t	public-dashboard	\N	1	2	1	\N	2	f
495	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 03:13:00.305258+00	533	999	t	public-dashboard	\N	1	1	1	\N	2	f
496	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 03:13:14.816905+00	292	2000	t	public-dashboard	\N	1	2	1	\N	2	f
497	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 03:13:14.779425+00	594	999	t	public-dashboard	\N	1	1	1	\N	2	f
498	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 03:14:05.369663+00	245	2000	t	public-dashboard	\N	1	2	1	\N	2	f
499	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 03:14:05.362002+00	338	999	t	public-dashboard	\N	1	1	1	\N	2	f
500	\\xa2d009365e05084e437614b049a935b08ed99587bdaba303603a66238ed1d752	2021-12-24 03:14:50.94109+00	182	234	t	public-dashboard	\N	1	1	1	\N	2	f
501	\\x22a8fd97e3c3f184118f34bfa83b60a8761a49b5ba67083f1f0da2509f53a223	2021-12-24 03:14:50.941083+00	200	234	t	public-dashboard	\N	1	2	1	\N	2	f
502	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 03:18:58.059902+00	284	2000	t	public-dashboard	\N	1	2	1	\N	2	f
503	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 03:18:58.052835+00	384	999	t	public-dashboard	\N	1	1	1	\N	2	f
504	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 03:20:55.742083+00	222	2000	t	question	\N	1	2	1	\N	2	f
505	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 03:20:55.7423+00	340	999	t	question	\N	1	1	1	\N	2	f
506	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 03:21:02.609924+00	300	2000	t	embedded-dashboard	\N	1	2	1	\N	2	f
507	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 03:21:02.61001+00	399	999	t	embedded-dashboard	\N	1	1	1	\N	2	f
508	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 03:21:13.109164+00	288	2000	t	public-dashboard	\N	1	2	1	\N	2	f
509	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 03:21:13.093527+00	387	999	t	public-dashboard	\N	1	1	1	\N	2	f
510	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 03:28:52.572132+00	432	999	t	embedded-dashboard	\N	1	1	1	\N	2	f
511	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 03:28:52.589426+00	494	2000	t	embedded-dashboard	\N	1	2	1	\N	2	f
512	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 03:30:02.031971+00	292	2000	t	embedded-dashboard	\N	1	2	1	\N	2	f
513	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 03:30:02.034611+00	380	999	t	embedded-dashboard	\N	1	1	1	\N	2	f
514	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 03:30:30.309462+00	324	2000	t	embedded-dashboard	\N	1	2	1	\N	2	f
515	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 03:30:30.30941+00	496	999	t	embedded-dashboard	\N	1	1	1	\N	2	f
516	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 03:30:33.580794+00	288	2000	t	embedded-dashboard	\N	1	2	1	\N	2	f
517	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 03:30:33.567674+00	343	999	t	embedded-dashboard	\N	1	1	1	\N	2	f
518	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 04:00:20.472778+00	336	2000	t	question	\N	3	2	1	\N	2	f
519	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 04:00:20.473083+00	454	999	t	question	\N	3	1	1	\N	2	f
520	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 04:00:41.214016+00	352	2000	t	question	\N	1	2	1	\N	2	f
521	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 04:00:41.213765+00	372	999	t	question	\N	1	1	1	\N	2	f
522	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 04:02:39.821783+00	344	2000	t	embedded-dashboard	\N	\N	2	1	\N	2	f
523	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 04:02:39.824104+00	421	999	t	embedded-dashboard	\N	\N	1	1	\N	2	f
524	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 04:03:11.7327+00	257	2000	t	embedded-dashboard	\N	\N	2	1	\N	2	f
525	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 04:03:11.710215+00	408	999	t	embedded-dashboard	\N	\N	1	1	\N	2	f
526	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 04:04:56.042127+00	329	2000	t	question	\N	4	2	1	\N	2	f
527	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 04:04:56.042235+00	348	999	t	question	\N	4	1	1	\N	2	f
528	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 04:07:01.702371+00	319	2000	t	question	\N	4	2	1	\N	2	f
529	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 04:07:01.702458+00	489	999	t	question	\N	4	1	1	\N	2	f
530	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 04:11:07.365809+00	279	2000	t	question	\N	4	2	1	\N	2	f
531	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 04:11:07.369272+00	345	999	t	question	\N	4	1	1	\N	2	f
532	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 14:36:01.849181+00	576	2000	t	public-dashboard	\N	4	2	1	\N	2	f
533	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 14:36:01.83743+00	598	999	t	public-dashboard	\N	4	1	1	\N	2	f
534	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 14:37:45.417263+00	291	2000	t	question	\N	4	2	1	\N	2	f
535	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 14:37:45.408767+00	386	999	t	question	\N	4	1	1	\N	2	f
536	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 14:37:49.350304+00	418	2000	t	public-dashboard	\N	4	2	1	\N	2	f
537	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 14:37:49.339063+00	495	999	t	public-dashboard	\N	4	1	1	\N	2	f
538	\\x2d9f34c32bc11c0150389d08b8887eb2f054a38a7f6d751cee8519b56d847718	2021-12-24 14:55:14.814586+00	254	2000	f	ad-hoc	\N	4	\N	\N	\N	2	f
539	\\x75e181649774f0850ddb62a1419ecfd7d89101813d9ab6a09844420d3ca2ca6d	2021-12-24 14:55:40.600245+00	77	97	f	ad-hoc	\N	4	\N	\N	\N	2	f
540	\\x35042f4612e1419d2e2dfd14d4f7f00c90d35f4082b0df9447de869a39cfa14b	2021-12-24 14:55:48.097984+00	83	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
541	\\xafc1c835bcbce90758d034b0de485289b2d3f89c4f5cfd0fc2c0a954690b4445	2021-12-24 14:55:48.254961+00	73	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
542	\\xafc1c835bcbce90758d034b0de485289b2d3f89c4f5cfd0fc2c0a954690b4445	2021-12-24 14:55:48.33632+00	11	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
543	\\xa33cd1e4eca8cc6a1044d88fec257ae50f703c6a8bc6243dd2de03e6a68e7899	2021-12-24 14:55:48.357729+00	14	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
544	\\x67a6a5ddd693a1e4583e520c46bd45bb31f960cb2bbbf7c28bfa75e25ed77dfa	2021-12-24 14:55:54.774632+00	98	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
545	\\x7b5eb7019fe1fd69e78f81764dd834d4cef85017680484f0de671acf342a7f1c	2021-12-24 14:55:54.965534+00	12	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
546	\\x4f6532b5e3325f41e088e802c61eecdbe9ec078142edf9115decf7c9c1037f15	2021-12-24 14:55:54.993044+00	9	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
547	\\xc4470fe6a68808e4e82ad6332fc2ef5c620773559541286fb849d78bc163ad59	2021-12-24 14:55:55.018462+00	13	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
548	\\x2852b70ea13402d95d3be22928243809f6d18c9b096209c38b469e13e92c6e44	2021-12-24 14:55:55.043666+00	10	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
549	\\x35042f4612e1419d2e2dfd14d4f7f00c90d35f4082b0df9447de869a39cfa14b	2021-12-24 14:56:10.358098+00	77	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
550	\\xe1c0c3d9ecdcc332661a9f47bc16b6961288c7db580f97b5afe76f0b412d8b4e	2021-12-24 14:56:10.478322+00	28	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
551	\\xafc1c835bcbce90758d034b0de485289b2d3f89c4f5cfd0fc2c0a954690b4445	2021-12-24 14:56:10.518337+00	12	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
552	\\xa33cd1e4eca8cc6a1044d88fec257ae50f703c6a8bc6243dd2de03e6a68e7899	2021-12-24 14:56:10.542245+00	10	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
553	\\x0711877b487bc0c37a2ca4a1851fa6ca562e0dcbaeef3b22a4b024a701517197	2021-12-24 14:56:17.644239+00	129	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
554	\\x7ab3a350a8794bad9955ae17c76bed3e47f48fc5224464b00deb995e8bf7de52	2021-12-24 14:56:23.431519+00	27	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
556	\\x8091c8e4ba87f6b8a911336f6a7d558b6deaef3ea8481215fb8bc8393d505790	2021-12-24 14:56:23.551837+00	17	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
559	\\x96aa6cf5e68fa30f1ab01feb7618bb245ef113d3d6787fba7c991fd7e107b6d3	2021-12-24 14:56:23.61114+00	9	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
560	\\xd240afb67d0b0170d3f7833fc1cf43d6fbb7caaa64c8e89176b648f732dab42d	2021-12-24 14:56:42.100542+00	63	54	f	ad-hoc	\N	4	\N	\N	\N	2	f
565	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 15:00:24.274893+00	397	2000	t	question	\N	1	2	1	\N	2	f
567	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 15:48:47.09174+00	284	2000	t	question	\N	4	2	1	\N	2	f
568	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 15:48:47.090469+00	386	999	t	question	\N	4	1	1	\N	2	f
571	\\x95b204c2c64cd3dc83e11f2607f2812cfe3ff54cf01a167315da98ac74b34964	2021-12-24 15:56:02.06497+00	185	7	f	ad-hoc	\N	4	\N	\N	\N	2	f
574	\\x69cd509ec3c627bdfbdde787a829830c9e794d2cde471be492f83852c642d898	2021-12-24 15:57:14.539164+00	136	3	f	ad-hoc	\N	4	\N	\N	\N	2	f
575	\\x3e4704da1170c5967b9456ab5aee9a1a41c9c3479a66812a3e217d758c764c50	2021-12-24 15:57:32.663921+00	75	9	f	ad-hoc	\N	4	\N	\N	\N	2	f
578	\\xd184b5ab326f6701187f94f4ea3d548eccb5426d0760d2af2f62f087c45c462a	2021-12-24 16:00:56.244359+00	223	7	f	ad-hoc	\N	4	\N	\N	\N	2	f
581	\\x2f3e74479b843dfe48b2f835ff77cad5d7cc150b498723227573be7c0ab4b4fa	2021-12-24 16:01:21.979922+00	47	9	f	ad-hoc	\N	4	\N	\N	\N	2	f
583	\\x101ecbe78efeac4b0f9d0b9713c9c774eef8ca939185760cc2d74dda9335c786	2021-12-24 16:01:44.792118+00	49	0	f	ad-hoc	\N	4	\N	\N	\N	2	f
588	\\xf7161638cce0cfad0788869b96fcb6ab8d79f1d1062b72f020dd4652fe490b42	2021-12-24 16:01:54.542075+00	14	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
589	\\x59a97a72d539aa24ab72ed4dc592e17f75fac9d0336a0c521234a2f51e7954b3	2021-12-24 16:02:12.940669+00	96	121	f	ad-hoc	\N	4	\N	\N	\N	2	f
555	\\x496e88a46bc77ab67f7b8dd19bfb416cc589b461252156d2023f49759d77f28c	2021-12-24 14:56:23.5033+00	13	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
557	\\x496e88a46bc77ab67f7b8dd19bfb416cc589b461252156d2023f49759d77f28c	2021-12-24 14:56:23.529312+00	9	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
561	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 14:57:28.200698+00	432	2000	t	question	\N	4	2	1	\N	2	f
564	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 14:59:10.35041+00	320	999	t	question	\N	4	1	1	\N	2	f
569	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 15:48:56.061003+00	359	2000	t	question	\N	4	2	1	\N	2	f
582	\\xb929ff29ddaf975c341c721d7d3424e8b2dbefc95401e4eaf6a4b496061bd77a	2021-12-24 16:01:22.032707+00	12	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
584	\\xa08acb372f80c62d52451943b2ff09d434dd57df5258a3dc09294a098cee7381	2021-12-24 16:01:44.852977+00	10	0	f	ad-hoc	\N	4	\N	\N	\N	2	f
585	\\x2f3e74479b843dfe48b2f835ff77cad5d7cc150b498723227573be7c0ab4b4fa	2021-12-24 16:01:50.131337+00	36	9	f	ad-hoc	\N	4	\N	\N	\N	2	f
590	\\x9ca912290e54faa0306ac23bb83857a9a5c04317722c9709cc15014b01823f75	2021-12-24 16:10:55.09955+00	169	2000	f	ad-hoc	\N	4	\N	\N	\N	2	f
591	\\xa5673548119c698018d6a8ad4a1aadd644372c9fc6cfbd04f55c60f906ea6e12	2021-12-24 16:11:07.051128+00	60	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
592	\\x0d1ab058e666f51685780a30c5a1384efd47eb5099e36e613cb139c8ff364fd9	2021-12-24 16:11:07.181335+00	14	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
596	\\x56995c94c322377c0141fe7659b75fe3646009efc5dfb98a7fef6aec0a9c0a37	2021-12-24 16:11:07.266107+00	11	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
558	\\x4c7d40d7d7155e6de897600339da5206722ea3cbdb34bc149c495e6c2f5cbea5	2021-12-24 14:56:23.585617+00	16	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
570	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 15:48:56.061135+00	444	999	t	question	\N	4	1	1	\N	2	f
572	\\x9874682a930cd29c37fa2558429daf223e1fbe7fc43140b1073b272545a8c30e	2021-12-24 15:56:37.975789+00	426	2000	f	ad-hoc	\N	4	\N	\N	\N	2	f
573	\\x132b90d3fd407749d3211e6ded523d3442d157965d389a98bae7b3870e453803	2021-12-24 15:56:55.451568+00	74	3	f	ad-hoc	\N	4	\N	\N	\N	2	f
576	\\x621fc8c07059b989c744ca528d74ab0d137cc1d31c86dc1d3f55c0e98d13989d	2021-12-24 15:57:38.874392+00	85	1602	f	ad-hoc	\N	4	\N	\N	\N	2	f
577	\\x3e4704da1170c5967b9456ab5aee9a1a41c9c3479a66812a3e217d758c764c50	2021-12-24 15:57:52.36727+00	56	9	f	ad-hoc	\N	4	\N	\N	\N	2	f
579	\\x724448dbbfa00c7504ab3631ae64d6891202f39abccaa22e644bce5e67ffdc6c	2021-12-24 16:01:05.741593+00	42	7	f	ad-hoc	\N	4	\N	\N	\N	2	f
580	\\x20cd93e3247b9603dfbde06c32ca7da73c7b20d752b92bfb6a66731da172ecd9	2021-12-24 16:01:05.797603+00	49	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
586	\\xb929ff29ddaf975c341c721d7d3424e8b2dbefc95401e4eaf6a4b496061bd77a	2021-12-24 16:01:50.176923+00	12	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
587	\\x4602a8a37df601374ab921cb4b2a5b7cf46ad2d8093c82fdac614ed6c5191d80	2021-12-24 16:01:54.508665+00	22	94	f	ad-hoc	\N	4	\N	\N	\N	2	f
593	\\x0d1ab058e666f51685780a30c5a1384efd47eb5099e36e613cb139c8ff364fd9	2021-12-24 16:11:07.203085+00	6	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
562	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 14:57:28.200709+00	448	999	t	question	\N	4	1	1	\N	2	f
563	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 14:59:10.35017+00	278	2000	t	question	\N	4	2	1	\N	2	f
566	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 15:00:24.275933+00	481	999	t	question	\N	1	1	1	\N	2	f
594	\\xdb9c57d31134c3ff2e89ff6b0f6bd558fcf76b1fdd3dc9e755a94559af1239f0	2021-12-24 16:11:07.226115+00	14	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
595	\\x362e81a74964512f80b760d067d1796c66fd1b3515da01d307c932892bb9356c	2021-12-24 16:11:07.247694+00	8	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
597	\\x47492ce57e9b5420274b4aaff04060c0c9884b7610f1f88d11da8bd7f0ef8ab5	2021-12-24 16:12:31.423733+00	52	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
598	\\xd686fe2693d3a140a076e0cdc3fede19204157c5fda63db14842f166c4577dcd	2021-12-24 16:12:31.494746+00	23	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
599	\\x88e7ca436a9a0da7b300996f886e91c3be5f4ba8d7d1967681571495d199a9e7	2021-12-24 16:12:31.540643+00	12	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
600	\\x819d1d03e90554be4ce2c323e06a5095e37f32a8253f6c8451ad8f60430f2a8f	2021-12-24 16:12:31.560137+00	11	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
601	\\x81a631f020f63cb6874357decc7e68623ddd4619c5d7c46886d6749e00b020f2	2021-12-24 16:12:31.593331+00	15	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
602	\\x18ce3f9aa25f3dc51ad5999c65d9a243ad5b437b852e48b96b7b2dfea9c70c8c	2021-12-24 16:12:31.617408+00	159	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
603	\\xf63f061593cea5a9b7ef72226c437ef731ca86a9d67adc1892f963edc37b033c	2021-12-24 16:12:34.822318+00	52	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
604	\\x750b718b9765c0b1d78d33596f90e7e45a91f779482af894fccaf6baac6a95d0	2021-12-24 16:12:34.902536+00	21	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
605	\\x0d1ab058e666f51685780a30c5a1384efd47eb5099e36e613cb139c8ff364fd9	2021-12-24 16:12:34.935001+00	9	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
606	\\xdb9c57d31134c3ff2e89ff6b0f6bd558fcf76b1fdd3dc9e755a94559af1239f0	2021-12-24 16:12:34.953551+00	6	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
607	\\x362e81a74964512f80b760d067d1796c66fd1b3515da01d307c932892bb9356c	2021-12-24 16:12:34.974791+00	7	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
608	\\x56995c94c322377c0141fe7659b75fe3646009efc5dfb98a7fef6aec0a9c0a37	2021-12-24 16:12:35.004577+00	8	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
609	\\x1343a9aa28f52fcb839280bbde10a1523d333a076f89b1800f237ca62f940110	2021-12-24 16:12:36.998766+00	37	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
610	\\xb7a87ef9f0705bc605a0abb00150c2f182e692cce142cbe340a3e72a6a9d3803	2021-12-24 16:12:37.053227+00	13	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
611	\\x04252b71b17c25f8796cc0f1caad389468b9b20165e14d1e6717d26f92563263	2021-12-24 16:12:37.076813+00	9	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
612	\\x420fd78ba8bd6f32db80f0787f7f56129e7aa1ad5aa59223011643766490465a	2021-12-24 16:12:37.093893+00	11	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
613	\\x926cb9cb3ac592383eb0ecc5fb6eef02c2a0e18924c8015b831d4dbbd55c7832	2021-12-24 16:12:37.115927+00	14	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
614	\\xc940ece80b962b7bb3ee21c87e1be4188c14fcd93241e222fb4176b206ab46ca	2021-12-24 16:12:37.136369+00	6	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
615	\\x7d7189db0a2c4dd9ed89a07fe5672ee05cd23f827f6670a77630e157c5cf6515	2021-12-24 16:12:38.261751+00	31	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
616	\\xb1ff40cb696bb05fc7dad435dcaf66bc572f16cd16de28b4eaa0b5e3421beb8a	2021-12-24 16:12:38.327814+00	16	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
617	\\x5240e0d7368f48673177fecfa335bbbfb27d3134c949c2eef293c73a40daf140	2021-12-24 16:12:38.369815+00	8	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
618	\\xf0f1a490980ed5ff55c0d67f16966839f5e56190fb3da1bc555559f78dd2c81f	2021-12-24 16:12:38.351314+00	7	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
620	\\xe1457f3aa694fd12c68c409cbe7f32c736cb72c96b6a7791358ceef6e2c8c85e	2021-12-24 16:12:38.399985+00	7	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
619	\\xb2a2e30b071630dd8782f89876190084b98e1de7e7415adbd042c8abbbedc3df	2021-12-24 16:12:38.384355+00	9	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
621	\\xab87e6db3799e56c8ae3290eb00684fbb8fb7590d85092f4d8a193974a9ca2b5	2021-12-24 16:12:39.189919+00	34	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
622	\\xb5d9300076e7a755d0a0f425e1a3e3a1ed16657f5289974270ddda11537400d7	2021-12-24 16:12:39.246145+00	15	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
623	\\x47fa55c8f318bf389b20509d3fe487156fea302fc6460605fbdbd8ea400a9c6b	2021-12-24 16:12:39.273595+00	7	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
624	\\x98f6b7dc331cd92a90249f32ea525fd85cf177d5b9bd7e44b3b7562710e8ece1	2021-12-24 16:12:39.290245+00	5	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
625	\\xdaf21033590c9807aeb3c1acaf56ed840d563bd2f98eaa1c6ef8e91471a6589c	2021-12-24 16:12:39.313339+00	5	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
626	\\x9155ab84fc16c81aabd47a2556bdb2b1f487ffe0c3b2749cad1487506f81a585	2021-12-24 16:12:39.30148+00	6	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
627	\\x87a6e0e3a067a907992cd5469dc15de0f3833ea199550cee1bbc2f04951647e6	2021-12-24 16:12:41.143945+00	35	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
628	\\x80244f9b15812e6722e87ad491a7e920572ce32460d5e6849746808d5e409405	2021-12-24 16:12:45.676142+00	86	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
629	\\x160dbf17b4ae39219d84b5487b644809fd8b3015c9b17064dfbb25242da0715d	2021-12-24 16:12:45.804416+00	15	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
630	\\x87a6e0e3a067a907992cd5469dc15de0f3833ea199550cee1bbc2f04951647e6	2021-12-24 16:12:52.779573+00	35	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
631	\\xab87e6db3799e56c8ae3290eb00684fbb8fb7590d85092f4d8a193974a9ca2b5	2021-12-24 16:12:54.327689+00	31	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
632	\\xb5d9300076e7a755d0a0f425e1a3e3a1ed16657f5289974270ddda11537400d7	2021-12-24 16:12:54.375985+00	20	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
633	\\x47fa55c8f318bf389b20509d3fe487156fea302fc6460605fbdbd8ea400a9c6b	2021-12-24 16:12:54.406812+00	8	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
634	\\x98f6b7dc331cd92a90249f32ea525fd85cf177d5b9bd7e44b3b7562710e8ece1	2021-12-24 16:12:54.426752+00	9	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
635	\\x9155ab84fc16c81aabd47a2556bdb2b1f487ffe0c3b2749cad1487506f81a585	2021-12-24 16:12:54.441795+00	15	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
636	\\xdaf21033590c9807aeb3c1acaf56ed840d563bd2f98eaa1c6ef8e91471a6589c	2021-12-24 16:12:54.47181+00	8	1	f	ad-hoc	\N	4	\N	\N	\N	2	f
637	\\x103fe9e491bf5de3905337700fad9ae72e10c9f462e1b1b35534d4c9c2a57c5e	2021-12-24 16:13:06.980091+00	319	2000	f	ad-hoc	\N	4	\N	\N	\N	2	f
638	\\xccd8a0eb0567337853613c4b326a9b688f791c149304c8bd808ed4d03c796b61	2021-12-24 16:13:32.011829+00	111	2000	f	ad-hoc	\N	4	\N	\N	\N	2	f
639	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 16:30:34.776735+00	303	2000	t	question	\N	4	2	1	\N	2	f
640	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 16:30:34.776737+00	468	999	t	question	\N	4	1	1	\N	2	f
641	\\xa70a8263ca485ce66e8a3060c84629190136f400ef0a88091ac649e7df802d2b	2021-12-24 16:31:05.08611+00	148	483	t	question	\N	4	2	1	\N	2	f
642	\\x843be1249548c86e1aa01484fab7e0738ffb98e2211fe77e19504341fda085a0	2021-12-24 16:31:05.08611+00	161	483	t	question	\N	4	1	1	\N	2	f
643	\\xa70a8263ca485ce66e8a3060c84629190136f400ef0a88091ac649e7df802d2b	2021-12-24 16:31:15.835937+00	210	483	t	question	\N	4	2	1	\N	2	f
644	\\x843be1249548c86e1aa01484fab7e0738ffb98e2211fe77e19504341fda085a0	2021-12-24 16:31:15.836125+00	231	483	t	question	\N	4	1	1	\N	2	f
645	\\x94e2217f3e136ee51d08c309635f6d09776f4d2d38015fe8bac3699f6b816c8b	2021-12-24 16:31:38.699466+00	21	0	t	ad-hoc	You do not have permissions to run this query.	4	\N	\N	\N	2	\N
646	\\xa70a8263ca485ce66e8a3060c84629190136f400ef0a88091ac649e7df802d2b	2021-12-24 16:31:57.792211+00	121	483	t	question	\N	4	2	1	\N	2	f
647	\\x843be1249548c86e1aa01484fab7e0738ffb98e2211fe77e19504341fda085a0	2021-12-24 16:31:57.793367+00	183	483	t	question	\N	4	1	1	\N	2	f
648	\\xc188816f405b5ec24f719402801a75436de548fe92d756d0e2c88b52e6563ddd	2021-12-24 17:04:10.977835+00	28	0	t	ad-hoc	ERROR: invalid reference to FROM-clause entry for table "coped_project"\n  Hint: Perhaps you meant to reference the table alias "cp".\n  Position: 228	4	\N	\N	\N	2	\N
649	\\xeeb31de90894f938da633da15b7300d96d4fe808d947860b3b132c9a758bee6d	2021-12-24 17:04:24.145191+00	174	823	t	ad-hoc	\N	4	\N	\N	\N	2	f
650	\\x103fe9e491bf5de3905337700fad9ae72e10c9f462e1b1b35534d4c9c2a57c5e	2021-12-24 17:05:02.360913+00	204	2000	f	ad-hoc	\N	4	\N	\N	\N	2	f
651	\\x3b24f72327d8f0d4599fb56ec93156f7a8eb04f1046cac64cd9f9f6bf4d28e27	2021-12-24 17:06:01.880243+00	210	2000	f	question	\N	4	5	4	\N	2	f
652	\\x5836f3b01301ec1b70166bda95a2b7104ebefe0716f2a8e62c9ceb6d8b39ca78	2021-12-24 17:06:24.679401+00	181	7	f	question	\N	4	4	4	\N	2	f
653	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 17:06:37.927788+00	446	999	t	question	\N	4	1	4	\N	2	f
654	\\x3b24f72327d8f0d4599fb56ec93156f7a8eb04f1046cac64cd9f9f6bf4d28e27	2021-12-24 17:08:28.71471+00	186	2000	f	question	\N	4	5	4	\N	2	f
655	\\x3b24f72327d8f0d4599fb56ec93156f7a8eb04f1046cac64cd9f9f6bf4d28e27	2021-12-24 17:08:58.270999+00	295	2000	f	question	\N	4	5	\N	\N	2	f
656	\\x3b24f72327d8f0d4599fb56ec93156f7a8eb04f1046cac64cd9f9f6bf4d28e27	2021-12-24 17:10:08.446446+00	199	2000	f	question	\N	4	5	4	\N	2	f
657	\\x48b049f11b63f5a140d6de8bdaebf7dd1fe56ef7c98c0d8037edec575d875f78	2021-12-24 17:25:12.318552+00	338	2000	t	public-dashboard	\N	4	2	1	\N	2	f
658	\\x0b829e04c96a71c3d034cbee07cd1f833f5d76f410784d5ca0b81307a7f6157e	2021-12-24 17:25:12.316906+00	441	999	t	public-dashboard	\N	4	1	1	\N	2	f
659	\\x3b24f72327d8f0d4599fb56ec93156f7a8eb04f1046cac64cd9f9f6bf4d28e27	2021-12-24 18:07:59.716792+00	277	2000	f	question	\N	4	5	4	\N	2	f
661	\\x3b24f72327d8f0d4599fb56ec93156f7a8eb04f1046cac64cd9f9f6bf4d28e27	2021-12-24 18:09:33.737575+00	196	2000	f	question	\N	4	5	4	\N	2	f
660	\\x3b24f72327d8f0d4599fb56ec93156f7a8eb04f1046cac64cd9f9f6bf4d28e27	2021-12-24 18:09:06.983625+00	220	2000	f	question	\N	4	5	4	\N	2	f
\.


--
-- Data for Name: report_card; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_card (id, created_at, updated_at, name, description, display, dataset_query, visualization_settings, creator_id, database_id, table_id, query_type, archived, collection_id, public_uuid, made_public_by_id, enable_embedding, embedding_params, cache_ttl, result_metadata, collection_position) FROM stdin;
1	2021-12-23 10:51:20.358245+00	2021-12-24 17:25:12.737822+00	Organisation Map Filtered by Subject(s)	Show locations of organisations who have an association to a project with the given subject(s).	map	{"type":"native","native":{"query":"SELECT DISTINCT name organisation_name, lat latitude, lon longitude, co.id organisation_id\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2}	{"map.type":"pin","map.latitude_column":"latitude","map.longitude_column":"longitude","table.pivot_column":"lat","table.cell_column":"lon","map.center_latitude":54.18563943134077,"map.center_longitude":-8.50236767586238,"map.zoom":4.832394669298182}	1	2	\N	native	f	\N	\N	\N	f	\N	\N	[{"name":"organisation_name","display_name":"organisation_name","base_type":"type/Text","effective_type":"type/Text","field_ref":["field","organisation_name",{"base-type":"type/Text"}],"semantic_type":null,"fingerprint":{"global":{"distinct-count":986,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":22.074074074074073}}}},{"name":"latitude","display_name":"latitude","base_type":"type/Float","effective_type":"type/Float","field_ref":["field","latitude",{"base-type":"type/Float"}],"semantic_type":"type/Latitude","fingerprint":{"global":{"distinct-count":701,"nil%":0.0},"type":{"type/Number":{"min":0.0,"q1":50.8535304116578,"q3":52.440000977424816,"max":58.9636512,"sd":21.297723054979443,"avg":41.33276597718441}}}},{"name":"longitude","display_name":"longitude","base_type":"type/Float","effective_type":"type/Float","field_ref":["field","longitude",{"base-type":"type/Float"}],"semantic_type":"type/Longitude","fingerprint":{"global":{"distinct-count":702,"nil%":0.0},"type":{"type/Number":{"min":-93.6481304,"q1":-1.9235769361651829,"q3":-0.021414446540835214,"max":120.1752726,"sd":8.118014273063695,"avg":-1.0831753527528327}}}},{"name":"organisation_id","display_name":"organisation_id","base_type":"type/BigInteger","effective_type":"type/BigInteger","field_ref":["field","organisation_id",{"base-type":"type/BigInteger"}],"semantic_type":null,"fingerprint":{"global":{"distinct-count":999,"nil%":0.0},"type":{"type/Number":{"min":8.0,"q1":876.1957298490609,"q3":2429.2110576708287,"max":3160.0,"sd":909.3913435412085,"avg":1653.923923923924}}}}]	\N
3	2021-12-23 12:40:42.464981+00	2021-12-23 14:35:18.716457+00	Coped Projects	\N	table	{"type":"native","native":{"query":"SELECT coped_id, title\\nFROM coped_project\\n[[WHERE UPPER(title) LIKE UPPER(CONCAT('%', {{title}}, '%'))]]\\n","template-tags":{"title":{"id":"f75783f7-df91-e4e6-0035-2a0d8d2c8bdc","name":"title","display-name":"Title","type":"text"}}},"database":2}	{"table.columns":[{"name":"coped_id","fieldRef":["field","coped_id",{"base-type":"type/UUID"}],"enabled":true},{"name":"title","fieldRef":["field","title",{"base-type":"type/Text"}],"enabled":true}],"table.pivot_column":"end","table.cell_column":"extra_text"}	1	2	\N	native	f	\N	ebf9b4f7-7f17-4de2-ad67-c06115cc197c	1	f	\N	\N	[{"name":"coped_id","display_name":"coped_id","base_type":"type/UUID","effective_type":"type/UUID","field_ref":["field","coped_id",{"base-type":"type/UUID"}],"semantic_type":null,"fingerprint":{"global":{"distinct-count":2000,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":36.0}}}},{"name":"title","display_name":"title","base_type":"type/Text","effective_type":"type/Text","field_ref":["field","title",{"base-type":"type/Text"}],"semantic_type":"type/Title","fingerprint":{"global":{"distinct-count":1801,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":69.0845}}}}]	\N
4	2021-12-23 12:56:06.453232+00	2021-12-24 17:06:24.83789+00	Coped Project Organisations, Filtered by ID	\N	table	{"type":"query","query":{"source-table":7,"fields":[["field",108,null]],"joins":[{"fields":[["field",131,{"join-alias":"Coped Project Organisation"}]],"source-table":8,"condition":["=",["field",108,null],["field",130,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":[["field",82,{"join-alias":"Coped Organisation - Organisation"}]],"source-table":5,"condition":["=",["field",132,{"join-alias":"Coped Project Organisation"}],["field",83,{"join-alias":"Coped Organisation - Organisation"}]],"alias":"Coped Organisation - Organisation"}],"filter":["=",["field",108,null],80]},"database":2}	{"table.columns":[{"name":"id","fieldRef":["field",108,null],"enabled":false},{"name":"coped_id","fieldRef":["field",106,null],"enabled":true},{"name":"status","fieldRef":["field",110,null],"enabled":true},{"name":"title","fieldRef":["field",107,null],"enabled":true},{"name":"description","fieldRef":["field",109,null],"enabled":false},{"name":"raw_data_id","fieldRef":["field",112,null],"enabled":false},{"name":"end","fieldRef":["field",111,{"temporal-unit":"default"}],"enabled":false},{"name":"start","fieldRef":["field",113,{"temporal-unit":"default"}],"enabled":false},{"name":"extra_text","fieldRef":["field",114,null],"enabled":false},{"name":"title","field_ref":["field",107,null],"enabled":true},{"name":"description","field_ref":["field",109,null],"enabled":true},{"name":"end","field_ref":["field",111,null],"enabled":true},{"name":"start","field_ref":["field",113,null],"enabled":true},{"name":"extra_text","field_ref":["field",114,null],"enabled":true},{"name":"id_3","field_ref":["field",83,{"join-alias":"Coped Organisation - Organisation"}],"enabled":true},{"name":"coped_id_2","field_ref":["field",80,{"join-alias":"Coped Organisation - Organisation"}],"enabled":true},{"name":"raw_data_id_2","field_ref":["field",84,{"join-alias":"Coped Organisation - Organisation"}],"enabled":true},{"name":"name","field_ref":["field",82,{"join-alias":"Coped Organisation - Organisation"}],"enabled":true},{"name":"role","field_ref":["field",131,{"join-alias":"Coped Project Organisation"}],"enabled":true}],"table.pivot_column":"id","table.cell_column":"name"}	1	2	7	query	f	\N	\N	\N	f	\N	\N	[{"semantic_type":"type/PK","coercion_strategy":null,"name":"id","field_ref":["field",108,null],"effective_type":"type/BigInteger","id":108,"display_name":"ID","fingerprint":null,"base_type":"type/BigInteger"},{"semantic_type":"type/Category","coercion_strategy":null,"name":"role","field_ref":["field",131,{"join-alias":"Coped Project Organisation"}],"effective_type":"type/Text","id":131,"display_name":"Coped Project Organisation → Role","fingerprint":{"global":{"distinct-count":7,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":9.487073560767591}}},"base_type":"type/Text"},{"semantic_type":"type/Name","coercion_strategy":null,"name":"name","field_ref":["field",82,{"join-alias":"Coped Organisation - Organisation"}],"effective_type":"type/Text","id":82,"display_name":"Coped Organisation - Organisation → Name","fingerprint":{"global":{"distinct-count":3101,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":23.089698890649764}}},"base_type":"type/Text"}]	\N
5	2021-12-24 17:05:43.684592+00	2021-12-24 18:09:33.913173+00	Coped Projects by Standard User	\N	table	{"database":2,"query":{"source-table":7},"type":"query"}	{"table.pivot_column":"end","table.cell_column":"extra_text"}	4	2	7	query	f	3	\N	\N	f	\N	\N	[{"semantic_type":"type/PK","coercion_strategy":null,"name":"id","field_ref":["field",108,null],"effective_type":"type/BigInteger","id":108,"display_name":"ID","fingerprint":null,"base_type":"type/BigInteger"},{"semantic_type":null,"coercion_strategy":null,"name":"coped_id","field_ref":["field",106,null],"effective_type":"type/UUID","id":106,"display_name":"Coped ID","fingerprint":{"global":{"distinct-count":2034,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":36.0}}},"base_type":"type/UUID"},{"semantic_type":"type/Title","coercion_strategy":null,"name":"title","field_ref":["field",107,null],"effective_type":"type/Text","id":107,"display_name":"Title","fingerprint":{"global":{"distinct-count":1831,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":68.91937069813176}}},"base_type":"type/Text"},{"semantic_type":"type/Description","coercion_strategy":null,"name":"description","field_ref":["field",109,null],"effective_type":"type/Text","id":109,"display_name":"Description","fingerprint":{"global":{"distinct-count":1819,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":1152.9341199606686}}},"base_type":"type/Text"},{"semantic_type":"type/Category","coercion_strategy":null,"name":"status","field_ref":["field",110,null],"effective_type":"type/Text","id":110,"display_name":"Status","fingerprint":{"global":{"distinct-count":2,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":6.0}}},"base_type":"type/Text"},{"semantic_type":"type/FK","coercion_strategy":null,"name":"raw_data_id","field_ref":["field",112,null],"effective_type":"type/BigInteger","id":112,"display_name":"Raw Data ID","fingerprint":{"global":{"distinct-count":2034,"nil%":0.0}},"base_type":"type/BigInteger"},{"semantic_type":null,"coercion_strategy":null,"unit":"default","name":"end","field_ref":["field",111,{"temporal-unit":"default"}],"effective_type":"type/Date","id":111,"display_name":"End","fingerprint":{"global":{"distinct-count":4,"nil%":0.9985250737463127},"type":{"type/DateTime":{"earliest":"2021-04-02","latest":"2021-10-28"}}},"base_type":"type/Date"},{"semantic_type":"type/CreationDate","coercion_strategy":null,"unit":"default","name":"start","field_ref":["field",113,{"temporal-unit":"default"}],"effective_type":"type/Date","id":113,"display_name":"Start","fingerprint":{"global":{"distinct-count":4,"nil%":0.9985250737463127},"type":{"type/DateTime":{"earliest":"2017-05-01","latest":"2020-10-02"}}},"base_type":"type/Date"},{"semantic_type":null,"coercion_strategy":null,"name":"extra_text","field_ref":["field",114,null],"effective_type":"type/Text","id":114,"display_name":"Extra Text","fingerprint":{"global":{"distinct-count":581,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":375.007866273353}}},"base_type":"type/Text"}]	\N
2	2021-12-23 11:49:21.498223+00	2021-12-24 17:25:12.634863+00	Counts of Subject Hits by Organisation	Count number of projects in each organisation associated to the given subject(s).	table	{"type":"native","native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(coped_subject.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2}	{"map.type":"pin","table.pivot":false,"map.longitude_column":"longitude","click_behavior":{"type":"link","linkType":"url","linkTemplate":"http://localhost:8000/organisations/{{organisation_id}}"},"map.latitude_column":"latitude","table.columns":[{"name":"organisation_id","fieldRef":["field","organisation_id",{"base-type":"type/BigInteger"}],"enabled":false},{"name":"organisation_name","fieldRef":["field","organisation_name",{"base-type":"type/Text"}],"enabled":true},{"name":"project_hits","fieldRef":["field","project_hits",{"base-type":"type/BigInteger"}],"enabled":true}],"map.center_longitude":-4.6495943908621715,"table.cell_column":"project_hits","map.zoom":5.198660367899508,"table.pivot_column":"organisation_name","column_settings":{"[\\"name\\",\\"organisation_name\\"]":{"view_as":null}},"map.center_latitude":55.14693635319655}	1	2	\N	native	f	\N	\N	\N	f	\N	\N	[{"name":"organisation_id","display_name":"organisation_id","base_type":"type/BigInteger","effective_type":"type/BigInteger","field_ref":["field","organisation_id",{"base-type":"type/BigInteger"}],"semantic_type":null,"fingerprint":{"global":{"distinct-count":2000,"nil%":0.0},"type":{"type/Number":{"min":6.0,"q1":657.5097176863592,"q3":1938.3003723410322,"max":3160.0,"sd":805.1087260586173,"avg":1337.583}}}},{"name":"organisation_name","display_name":"organisation_name","base_type":"type/Text","effective_type":"type/Text","field_ref":["field","organisation_name",{"base-type":"type/Text"}],"semantic_type":null,"fingerprint":{"global":{"distinct-count":1974,"nil%":0.0},"type":{"type/Text":{"percent-json":0.0,"percent-url":0.0,"percent-email":0.0,"percent-state":0.0,"average-length":22.453}}}},{"name":"project_hits","display_name":"project_hits","base_type":"type/BigInteger","effective_type":"type/BigInteger","field_ref":["field","project_hits",{"base-type":"type/BigInteger"}],"semantic_type":null,"fingerprint":{"global":{"distinct-count":82,"nil%":0.0},"type":{"type/Number":{"min":20.0,"q1":20.653680061728952,"q3":48.63693357014452,"max":2931.0,"sd":155.90581665011388,"avg":61.371500000000005}}}}]	\N
\.


--
-- Data for Name: report_cardfavorite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_cardfavorite (id, created_at, updated_at, card_id, owner_id) FROM stdin;
\.


--
-- Data for Name: report_dashboard; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_dashboard (id, created_at, updated_at, name, description, creator_id, parameters, points_of_interest, caveats, show_in_getting_started, public_uuid, made_public_by_id, enable_embedding, embedding_params, archived, "position", collection_id, collection_position, cache_ttl) FROM stdin;
2	2021-12-23 12:31:42.498717+00	2021-12-23 12:52:08.804015+00	Project Connections Dashboard	Summary information on project connections in the CoPED database.	1	[]	\N	\N	f	\N	\N	f	\N	f	\N	\N	\N	\N
1	2021-12-23 10:56:01.072977+00	2021-12-24 14:57:57.706722+00	CoPED Organisation Map	View locations and details of organisations. Filter them by project subject topics.	1	[{"name":"Subject(s)","slug":"subject(s)","id":"7d611dc4","type":"category","filteringParameters":[]}]	\N	\N	f	b2fec45e-f595-4684-9cd8-d5cb9fcdb9a9	1	t	{"subject(s)":"enabled"}	f	\N	\N	\N	\N
4	2021-12-24 17:06:01.612205+00	2021-12-24 17:08:49.287495+00	Regular User Dashboard	\N	4	[]	\N	\N	f	\N	\N	f	\N	f	\N	3	\N	\N
\.


--
-- Data for Name: report_dashboardcard; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_dashboardcard (id, created_at, updated_at, "sizeX", "sizeY", "row", col, card_id, dashboard_id, parameter_mappings, visualization_settings) FROM stdin;
1	2021-12-23 10:57:08.56637+00	2021-12-24 14:37:38.316819+00	9	11	0	4	1	1	[{"parameter_id":"7d611dc4","card_id":1,"target":["dimension",["template-tag","label"]]}]	{"map.center_latitude":55.14693635319655,"map.center_longitude":-4.6495943908621715,"map.zoom":5.198660367899508,"click_behavior":{"type":"link","linkType":"url","linkTemplate":"/organisations/{{organisation_id}}"}}
2	2021-12-23 11:16:05.22107+00	2021-12-24 14:37:38.340349+00	4	11	0	0	\N	1	[]	{"virtual_card":{"name":null,"display":"text","visualization_settings":{},"dataset_query":{},"archived":false},"text":"# View Organisations by Project Subject(s)\\n\\nYou can update this dashboard by searching for project subject terms above. For example, if you enter \\"microgrids\\" the map and table will update to show you organisations with a connection to the term.\\n\\n1. The map to the right shows geographic locations of organisations that have been involved in projects with the chosen subject(s).\\n    - HINT: click on any pin to be taken to a detailed view of the organisation.\\n2. The table below shows a list of the currently displayed organisations, with additional details such as the number of projects they have been involved with that match one of the search terms."}
3	2021-12-23 11:51:00.338117+00	2021-12-24 14:37:38.360932+00	5	11	0	13	2	1	[{"parameter_id":"7d611dc4","card_id":2,"target":["dimension",["template-tag","label"]]}]	{"column_settings":{"[\\"name\\",\\"organisation_name\\"]":{"click_behavior":{"type":"link","linkType":"url","linkTemplate":"/organisations/{{organisation_id}}"}}}}
4	2021-12-24 17:08:30.625866+00	2021-12-24 17:08:49.206626+00	4	4	0	0	5	4	[]	{}
\.


--
-- Data for Name: revision; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.revision (id, model, model_id, user_id, "timestamp", object, is_reversion, is_creation, message) FROM stdin;
1	Card	1	1	2021-12-23 10:51:20.415681+00	{"description":"Show locations of organisations who have an association to a project with the given subject(s).","archived":false,"collection_position":null,"table_id":null,"database_id":2,"enable_embedding":false,"collection_id":null,"query_type":"native","name":"Organisation Map Filtered by Subject(s)","creator_id":1,"made_public_by_id":null,"embedding_params":null,"cache_ttl":null,"dataset_query":{"type":"native","native":{"query":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 1000","template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}}},"database":2},"id":1,"display":"map","visualization_settings":{"map.type":"pin","map.latitude_column":"lat","map.longitude_column":"lon"},"public_uuid":null}	f	t	\N
2	Card	1	1	2021-12-23 10:51:57.953909+00	{"description":"Show locations of organisations who have an association to a project with the given subject(s).","archived":false,"collection_position":null,"table_id":null,"database_id":2,"enable_embedding":false,"collection_id":null,"query_type":"native","name":"Organisation Map Filtered by Subject(s)","creator_id":1,"made_public_by_id":null,"embedding_params":null,"cache_ttl":null,"dataset_query":{"type":"native","native":{"query":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"7eeac02b-a0cc-c0ed-805c-431c48eb9e22","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}}},"database":2},"id":1,"display":"map","visualization_settings":{"map.type":"pin","map.latitude_column":"lat","map.longitude_column":"lon"},"public_uuid":null}	f	f	\N
3	Card	1	1	2021-12-23 10:54:30.532614+00	{"description":"Show locations of organisations who have an association to a project with the given subject(s).","archived":false,"collection_position":null,"table_id":null,"database_id":2,"enable_embedding":false,"collection_id":null,"query_type":"native","name":"Organisation Map Filtered by Subject(s)","creator_id":1,"made_public_by_id":null,"embedding_params":null,"cache_ttl":null,"dataset_query":{"type":"native","native":{"query":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"ad9abaa9-855e-ea5a-4c44-cca70c68afb8","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null]}}},"database":2},"id":1,"display":"map","visualization_settings":{"map.type":"pin","map.latitude_column":"lat","map.longitude_column":"lon"},"public_uuid":null}	f	f	\N
9	Card	1	1	2021-12-23 10:59:06.355781+00	{"description":"Show locations of organisations who have an association to a project with the given subject(s).","archived":false,"collection_position":null,"table_id":null,"database_id":2,"enable_embedding":false,"collection_id":null,"query_type":"native","name":"Organisation Map Filtered by Subject(s)","creator_id":1,"made_public_by_id":null,"embedding_params":null,"cache_ttl":null,"dataset_query":{"type":"native","native":{"query":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"23cbc2fd-0c25-255c-03c5-5419d10b3eec","name":"label","display-name":"Label","type":"dimension","dimension":["field",146,null],"required":false,"default":"microgrids"}}},"database":2},"id":1,"display":"map","visualization_settings":{"map.type":"pin","map.latitude_column":"lat","map.longitude_column":"lon"},"public_uuid":null}	f	f	\N
10	Card	1	1	2021-12-23 11:06:04.790035+00	{"description":"Show locations of organisations who have an association to a project with the given subject(s).","archived":false,"collection_position":null,"table_id":null,"database_id":2,"enable_embedding":false,"collection_id":null,"query_type":"native","name":"Organisation Map Filtered by Subject(s)","creator_id":1,"made_public_by_id":null,"embedding_params":null,"cache_ttl":null,"dataset_query":{"database":2,"native":{"template-tags":{},"query":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\nLIMIT 999"},"type":"native"},"id":1,"display":"table","visualization_settings":{"map.type":"pin","map.latitude_column":"lat","map.longitude_column":"lon","table.pivot_column":"lat","table.cell_column":"lon"},"public_uuid":null}	f	f	\N
11	Card	1	1	2021-12-23 11:06:50.11716+00	{"description":"Show locations of organisations who have an association to a project with the given subject(s).","archived":false,"collection_position":null,"table_id":null,"database_id":2,"enable_embedding":false,"collection_id":null,"query_type":"native","name":"Organisation Map Filtered by Subject(s)","creator_id":1,"made_public_by_id":null,"embedding_params":null,"cache_ttl":null,"dataset_query":{"type":"native","native":{"query":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2},"id":1,"display":"table","visualization_settings":{"map.type":"pin","map.latitude_column":"lat","map.longitude_column":"lon","table.pivot_column":"lat","table.cell_column":"lon"},"public_uuid":null}	f	f	\N
12	Card	1	1	2021-12-23 11:07:50.009705+00	{"description":"Show locations of organisations who have an association to a project with the given subject(s).","archived":false,"collection_position":null,"table_id":null,"database_id":2,"enable_embedding":false,"collection_id":null,"query_type":"native","name":"Organisation Map Filtered by Subject(s)","creator_id":1,"made_public_by_id":null,"embedding_params":null,"cache_ttl":null,"dataset_query":{"type":"native","native":{"query":"SELECT DISTINCT name, lat, lon\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2},"id":1,"display":"map","visualization_settings":{"map.type":"pin","map.latitude_column":"lat","map.longitude_column":"lon","table.pivot_column":"lat","table.cell_column":"lon","map.center_latitude":54.18563943134077,"map.center_longitude":-8.50236767586238,"map.zoom":4.832394669298182},"public_uuid":null}	f	f	\N
18	Card	1	1	2021-12-23 11:20:45.153277+00	{"description":"Show locations of organisations who have an association to a project with the given subject(s).","archived":false,"collection_position":null,"table_id":null,"database_id":2,"enable_embedding":false,"collection_id":null,"query_type":"native","name":"Organisation Map Filtered by Subject(s)","creator_id":1,"made_public_by_id":null,"embedding_params":null,"cache_ttl":null,"dataset_query":{"type":"native","native":{"query":"SELECT DISTINCT name organisation_name, lat latitude, lon longitude, co.id organisation_id\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nLIMIT 999","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2},"id":1,"display":"map","visualization_settings":{"map.type":"pin","map.latitude_column":"latitude","map.longitude_column":"longitude","table.pivot_column":"lat","table.cell_column":"lon","map.center_latitude":54.18563943134077,"map.center_longitude":-8.50236767586238,"map.zoom":4.832394669298182},"public_uuid":null}	f	f	\N
33	Dashboard	2	1	2021-12-23 12:52:08.847568+00	{"description":"Summary information on project connections in the CoPED database.","name":"Project Connections Dashboard","cache_ttl":null,"cards":[]}	f	f	\N
29	Dashboard	2	1	2021-12-23 12:31:42.544251+00	{"description":"Summary information on projects in the CoPED database.","name":"Project Detail Dashboard","cache_ttl":null,"cards":[]}	f	t	\N
21	Card	2	1	2021-12-23 11:49:21.541296+00	{"description":"Count number of projects in each organisation associated to the given subject(s).","archived":false,"collection_position":null,"table_id":null,"database_id":2,"enable_embedding":false,"collection_id":null,"query_type":"native","name":"Counts of Subject Hits by Organisation","creator_id":1,"made_public_by_id":null,"embedding_params":null,"cache_ttl":null,"dataset_query":{"type":"native","native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(coped_subject.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2},"id":2,"display":"table","visualization_settings":{"map.type":"pin","table.pivot":false,"map.longitude_column":"longitude","click_behavior":{"type":"link","linkType":"url","linkTemplate":"http://localhost:8000/organisations/{{organisation_id}}"},"map.latitude_column":"latitude","table.columns":[{"name":"organisation_id","fieldRef":["field","organisation_id",{"base-type":"type/BigInteger"}],"enabled":false},{"name":"organisation_name","fieldRef":["field","organisation_name",{"base-type":"type/Text"}],"enabled":true},{"name":"project_hits","fieldRef":["field","project_hits",{"base-type":"type/BigInteger"}],"enabled":true}],"map.center_longitude":-4.6495943908621715,"table.cell_column":"project_hits","map.zoom":5.198660367899508,"table.pivot_column":"organisation_name","map.center_latitude":55.14693635319655},"public_uuid":null}	f	t	\N
30	Card	3	1	2021-12-23 12:40:42.505497+00	{"description":null,"archived":false,"collection_position":null,"table_id":7,"database_id":2,"enable_embedding":false,"collection_id":null,"query_type":"query","name":"Coped Projects","creator_id":1,"made_public_by_id":null,"embedding_params":null,"cache_ttl":null,"dataset_query":{"database":2,"query":{"source-table":7,"fields":[["field",108,null],["field",106,null],["field",107,null],["field",109,null],["field",110,null],["field",111,{"temporal-unit":"default"}],["field",113,{"temporal-unit":"default"}],["field",114,null]]},"type":"query"},"id":3,"display":"table","visualization_settings":{"table.columns":[{"fieldRef":["field",108,null],"enabled":true},{"name":"coped_id","fieldRef":["field",106,null],"enabled":true},{"name":"title","fieldRef":["field",107,null],"enabled":true},{"name":"description","fieldRef":["field",109,null],"enabled":true},{"name":"status","fieldRef":["field",110,null],"enabled":true},{"name":"end","fieldRef":["field",111,{"temporal-unit":"default"}],"enabled":true},{"name":"start","fieldRef":["field",113,{"temporal-unit":"default"}],"enabled":true},{"name":"extra_text","fieldRef":["field",114,null],"enabled":true}],"table.pivot_column":"end","table.cell_column":"extra_text"},"public_uuid":null}	f	t	\N
31	Card	3	1	2021-12-23 12:43:52.194081+00	{"description":null,"archived":false,"collection_position":null,"table_id":null,"database_id":2,"enable_embedding":false,"collection_id":null,"query_type":"native","name":"Coped Projects","creator_id":1,"made_public_by_id":1,"embedding_params":null,"cache_ttl":null,"dataset_query":{"type":"native","native":{"query":"SELECT coped_id, title\\nFROM coped_project\\n[[WHERE title LIKE {{title}}]]","template-tags":{"title":{"id":"f75783f7-df91-e4e6-0035-2a0d8d2c8bdc","name":"title","display-name":"Title","type":"text"}}},"database":2},"id":3,"display":"table","visualization_settings":{"table.columns":[{"fieldRef":["field",108,null],"enabled":true},{"name":"coped_id","fieldRef":["field",106,null],"enabled":true},{"name":"title","fieldRef":["field",107,null],"enabled":true},{"name":"description","fieldRef":["field",109,null],"enabled":true},{"name":"status","fieldRef":["field",110,null],"enabled":true},{"name":"extra_text","fieldRef":["field",114,null],"enabled":true},{"name":"end","fieldRef":["field",111,{"temporal-unit":"default"}],"enabled":true},{"name":"start","fieldRef":["field",113,{"temporal-unit":"default"}],"enabled":true}],"table.pivot_column":"end","table.cell_column":"extra_text"},"public_uuid":"ebf9b4f7-7f17-4de2-ad67-c06115cc197c"}	f	f	\N
32	Card	3	1	2021-12-23 12:49:50.369513+00	{"description":null,"archived":false,"collection_position":null,"table_id":null,"database_id":2,"enable_embedding":false,"collection_id":null,"query_type":"native","name":"Coped Projects","creator_id":1,"made_public_by_id":1,"embedding_params":null,"cache_ttl":null,"dataset_query":{"type":"native","native":{"query":"SELECT coped_id, title\\nFROM coped_project\\n[[WHERE UPPER(title) LIKE UPPER(CONCAT('%', {{title}}, '%'))]]\\n","template-tags":{"title":{"id":"f75783f7-df91-e4e6-0035-2a0d8d2c8bdc","name":"title","display-name":"Title","type":"text"}}},"database":2},"id":3,"display":"table","visualization_settings":{"table.columns":[{"name":"coped_id","fieldRef":["field","coped_id",{"base-type":"type/UUID"}],"enabled":true},{"name":"title","fieldRef":["field","title",{"base-type":"type/Text"}],"enabled":true}],"table.pivot_column":"end","table.cell_column":"extra_text"},"public_uuid":"ebf9b4f7-7f17-4de2-ad67-c06115cc197c"}	f	f	\N
34	Card	4	1	2021-12-23 12:56:06.497614+00	{"description":null,"archived":false,"collection_position":null,"table_id":7,"database_id":2,"enable_embedding":false,"collection_id":null,"query_type":"query","name":"Coped Project Organisations, Filtered by ID","creator_id":1,"made_public_by_id":null,"embedding_params":null,"cache_ttl":null,"dataset_query":{"type":"query","query":{"source-table":7,"fields":[["field",108,null]],"joins":[{"fields":[["field",131,{"join-alias":"Coped Project Organisation"}]],"source-table":8,"condition":["=",["field",108,null],["field",130,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":[["field",82,{"join-alias":"Coped Organisation - Organisation"}]],"source-table":5,"condition":["=",["field",132,{"join-alias":"Coped Project Organisation"}],["field",83,{"join-alias":"Coped Organisation - Organisation"}]],"alias":"Coped Organisation - Organisation"}],"filter":["=",["field",108,null],80]},"database":2},"id":4,"display":"table","visualization_settings":{"table.columns":[{"name":"id","fieldRef":["field",108,null],"enabled":false},{"name":"coped_id","fieldRef":["field",106,null],"enabled":true},{"name":"status","fieldRef":["field",110,null],"enabled":true},{"name":"title","fieldRef":["field",107,null],"enabled":true},{"name":"description","fieldRef":["field",109,null],"enabled":false},{"name":"raw_data_id","fieldRef":["field",112,null],"enabled":false},{"name":"end","fieldRef":["field",111,{"temporal-unit":"default"}],"enabled":false},{"name":"start","fieldRef":["field",113,{"temporal-unit":"default"}],"enabled":false},{"name":"extra_text","fieldRef":["field",114,null],"enabled":false},{"name":"title","field_ref":["field",107,null],"enabled":true},{"name":"description","field_ref":["field",109,null],"enabled":true},{"name":"end","field_ref":["field",111,null],"enabled":true},{"name":"start","field_ref":["field",113,null],"enabled":true},{"name":"extra_text","field_ref":["field",114,null],"enabled":true},{"name":"id_3","field_ref":["field",83,{"join-alias":"Coped Organisation - Organisation"}],"enabled":true},{"name":"coped_id_2","field_ref":["field",80,{"join-alias":"Coped Organisation - Organisation"}],"enabled":true},{"name":"raw_data_id_2","field_ref":["field",84,{"join-alias":"Coped Organisation - Organisation"}],"enabled":true},{"name":"name","field_ref":["field",82,{"join-alias":"Coped Organisation - Organisation"}],"enabled":true},{"name":"role","field_ref":["field",131,{"join-alias":"Coped Project Organisation"}],"enabled":true}],"table.pivot_column":"id","table.cell_column":"name"},"public_uuid":null}	f	t	\N
39	Card	2	1	2021-12-24 00:07:29.702211+00	{"description":"Count number of projects in each organisation associated to the given subject(s).","archived":false,"collection_position":null,"table_id":null,"database_id":2,"enable_embedding":false,"collection_id":null,"query_type":"native","name":"Counts of Subject Hits by Organisation","creator_id":1,"made_public_by_id":null,"embedding_params":null,"cache_ttl":null,"dataset_query":{"type":"native","native":{"query":"SELECT DISTINCT co.id organisation_id, name organisation_name, count(coped_subject.id) project_hits\\nFROM coped_organisation co\\n    JOIN coped_organisation_addresses coa ON co.id = coa.organisation_id\\n    JOIN coped_address ca ON ca.id = coa.address_id\\n    JOIN coped_geo_data cgd ON cgd.id = ca.geo_id\\n    JOIN coped_project_organisation cpo ON cpo.organisation_id = co.id\\n    JOIN coped_project_subject cps ON cps.project_id = cpo.project_id\\n    JOIN coped_subject ON coped_subject.id = cps.subject_id\\n[[WHERE {{label}}]]\\nGROUP BY co.id, co.name\\nORDER BY project_hits DESC\\n","template-tags":{"label":{"id":"679e203d-705c-4c7f-df40-83c565a0198c","name":"label","display-name":"Subject(s)","type":"dimension","dimension":["field",146,null],"widget-type":"category"}}},"database":2},"id":2,"display":"table","visualization_settings":{"map.type":"pin","table.pivot":false,"map.longitude_column":"longitude","click_behavior":{"type":"link","linkType":"url","linkTemplate":"http://localhost:8000/organisations/{{organisation_id}}"},"map.latitude_column":"latitude","table.columns":[{"name":"organisation_id","fieldRef":["field","organisation_id",{"base-type":"type/BigInteger"}],"enabled":false},{"name":"organisation_name","fieldRef":["field","organisation_name",{"base-type":"type/Text"}],"enabled":true},{"name":"project_hits","fieldRef":["field","project_hits",{"base-type":"type/BigInteger"}],"enabled":true}],"map.center_longitude":-4.6495943908621715,"table.cell_column":"project_hits","map.zoom":5.198660367899508,"table.pivot_column":"organisation_name","column_settings":{"[\\"name\\",\\"organisation_name\\"]":{"view_as":null}},"map.center_latitude":55.14693635319655},"public_uuid":null}	f	f	\N
57	Dashboard	1	1	2021-12-24 03:12:44.434732+00	{"description":"View locations and details of organisations. Filter them by project subject topics.","name":"CoPED Organisation Map","cache_ttl":null,"cards":[{"sizeX":9,"sizeY":11,"row":0,"col":4,"id":1,"card_id":1,"series":[]},{"sizeX":4,"sizeY":11,"row":0,"col":0,"id":2,"card_id":null,"series":[]},{"sizeX":5,"sizeY":11,"row":0,"col":13,"id":3,"card_id":2,"series":[]}]}	f	f	\N
62	Dashboard	1	4	2021-12-24 04:07:14.279744+00	{"description":"View locations and details of organisations. Filter them by project subject topics.","name":"CoPED Organisation Map","cache_ttl":null,"cards":[{"sizeX":9,"sizeY":11,"row":0,"col":4,"id":1,"card_id":1,"series":[]},{"sizeX":4,"sizeY":11,"row":0,"col":0,"id":2,"card_id":null,"series":[]},{"sizeX":5,"sizeY":11,"row":0,"col":13,"id":3,"card_id":2,"series":[]}]}	f	f	\N
66	Dashboard	1	4	2021-12-24 14:37:38.398557+00	{"description":"View locations and details of organisations. Filter them by project subject topics.","name":"CoPED Organisation Map","cache_ttl":null,"cards":[{"sizeX":9,"sizeY":11,"row":0,"col":4,"id":1,"card_id":1,"series":[]},{"sizeX":4,"sizeY":11,"row":0,"col":0,"id":2,"card_id":null,"series":[]},{"sizeX":5,"sizeY":11,"row":0,"col":13,"id":3,"card_id":2,"series":[]}]}	f	f	\N
67	Dashboard	1	4	2021-12-24 14:37:38.465163+00	{"description":"View locations and details of organisations. Filter them by project subject topics.","name":"CoPED Organisation Map","cache_ttl":null,"cards":[{"sizeX":9,"sizeY":11,"row":0,"col":4,"id":1,"card_id":1,"series":[]},{"sizeX":4,"sizeY":11,"row":0,"col":0,"id":2,"card_id":null,"series":[]},{"sizeX":5,"sizeY":11,"row":0,"col":13,"id":3,"card_id":2,"series":[]}]}	f	f	\N
55	Dashboard	1	1	2021-12-24 02:45:40.978054+00	{"description":"View locations and details of organisations. Filter them by project subject topics.","name":"CoPED Organisation Map","cache_ttl":null,"cards":[{"sizeX":9,"sizeY":11,"row":0,"col":4,"id":1,"card_id":1,"series":[]},{"sizeX":4,"sizeY":11,"row":0,"col":0,"id":2,"card_id":null,"series":[]},{"sizeX":5,"sizeY":11,"row":0,"col":13,"id":3,"card_id":2,"series":[]}]}	f	f	\N
56	Dashboard	1	1	2021-12-24 03:12:44.359436+00	{"description":"View locations and details of organisations. Filter them by project subject topics.","name":"CoPED Organisation Map","cache_ttl":null,"cards":[{"sizeX":9,"sizeY":11,"row":0,"col":4,"id":1,"card_id":1,"series":[]},{"sizeX":4,"sizeY":11,"row":0,"col":0,"id":2,"card_id":null,"series":[]},{"sizeX":5,"sizeY":11,"row":0,"col":13,"id":3,"card_id":2,"series":[]}]}	f	f	\N
58	Dashboard	1	1	2021-12-24 04:00:54.493953+00	{"description":"View locations and details of organisations. Filter them by project subject topics.","name":"CoPED Organisation Map","cache_ttl":null,"cards":[{"sizeX":9,"sizeY":11,"row":0,"col":4,"id":1,"card_id":1,"series":[]},{"sizeX":4,"sizeY":11,"row":0,"col":0,"id":2,"card_id":null,"series":[]},{"sizeX":5,"sizeY":11,"row":0,"col":13,"id":3,"card_id":2,"series":[]}]}	f	f	\N
59	Dashboard	1	1	2021-12-24 04:00:54.575953+00	{"description":"View locations and details of organisations. Filter them by project subject topics.","name":"CoPED Organisation Map","cache_ttl":null,"cards":[{"sizeX":9,"sizeY":11,"row":0,"col":4,"id":1,"card_id":1,"series":[]},{"sizeX":4,"sizeY":11,"row":0,"col":0,"id":2,"card_id":null,"series":[]},{"sizeX":5,"sizeY":11,"row":0,"col":13,"id":3,"card_id":2,"series":[]}]}	f	f	\N
60	Dashboard	1	4	2021-12-24 04:05:05.507444+00	{"description":"View locations and details of organisations. Filter them by project subject topics.","name":"CoPED Organisation Map","cache_ttl":null,"cards":[{"sizeX":9,"sizeY":11,"row":0,"col":4,"id":1,"card_id":1,"series":[]},{"sizeX":4,"sizeY":11,"row":0,"col":0,"id":2,"card_id":null,"series":[]},{"sizeX":5,"sizeY":11,"row":0,"col":13,"id":3,"card_id":2,"series":[]}]}	f	f	\N
61	Dashboard	1	4	2021-12-24 04:05:05.613471+00	{"description":"View locations and details of organisations. Filter them by project subject topics.","name":"CoPED Organisation Map","cache_ttl":null,"cards":[{"sizeX":9,"sizeY":11,"row":0,"col":4,"id":1,"card_id":1,"series":[]},{"sizeX":4,"sizeY":11,"row":0,"col":0,"id":2,"card_id":null,"series":[]},{"sizeX":5,"sizeY":11,"row":0,"col":13,"id":3,"card_id":2,"series":[]}]}	f	f	\N
63	Dashboard	1	4	2021-12-24 04:07:14.356215+00	{"description":"View locations and details of organisations. Filter them by project subject topics.","name":"CoPED Organisation Map","cache_ttl":null,"cards":[{"sizeX":9,"sizeY":11,"row":0,"col":4,"id":1,"card_id":1,"series":[]},{"sizeX":4,"sizeY":11,"row":0,"col":0,"id":2,"card_id":null,"series":[]},{"sizeX":5,"sizeY":11,"row":0,"col":13,"id":3,"card_id":2,"series":[]}]}	f	f	\N
64	Dashboard	1	4	2021-12-24 04:10:59.980367+00	{"description":"View locations and details of organisations. Filter them by project subject topics.","name":"CoPED Organisation Map","cache_ttl":null,"cards":[{"sizeX":9,"sizeY":11,"row":0,"col":4,"id":1,"card_id":1,"series":[]},{"sizeX":4,"sizeY":11,"row":0,"col":0,"id":2,"card_id":null,"series":[]},{"sizeX":5,"sizeY":11,"row":0,"col":13,"id":3,"card_id":2,"series":[]}]}	f	f	\N
65	Dashboard	1	4	2021-12-24 04:11:00.057167+00	{"description":"View locations and details of organisations. Filter them by project subject topics.","name":"CoPED Organisation Map","cache_ttl":null,"cards":[{"sizeX":9,"sizeY":11,"row":0,"col":4,"id":1,"card_id":1,"series":[]},{"sizeX":4,"sizeY":11,"row":0,"col":0,"id":2,"card_id":null,"series":[]},{"sizeX":5,"sizeY":11,"row":0,"col":13,"id":3,"card_id":2,"series":[]}]}	f	f	\N
68	Card	4	4	2021-12-24 14:40:18.741294+00	{"description":null,"archived":false,"collection_position":1,"table_id":7,"database_id":2,"enable_embedding":false,"collection_id":null,"query_type":"query","name":"Coped Project Organisations, Filtered by ID","creator_id":1,"made_public_by_id":null,"embedding_params":null,"cache_ttl":null,"dataset_query":{"type":"query","query":{"source-table":7,"fields":[["field",108,null]],"joins":[{"fields":[["field",131,{"join-alias":"Coped Project Organisation"}]],"source-table":8,"condition":["=",["field",108,null],["field",130,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":[["field",82,{"join-alias":"Coped Organisation - Organisation"}]],"source-table":5,"condition":["=",["field",132,{"join-alias":"Coped Project Organisation"}],["field",83,{"join-alias":"Coped Organisation - Organisation"}]],"alias":"Coped Organisation - Organisation"}],"filter":["=",["field",108,null],80]},"database":2},"id":4,"display":"table","visualization_settings":{"table.columns":[{"name":"id","fieldRef":["field",108,null],"enabled":false},{"name":"coped_id","fieldRef":["field",106,null],"enabled":true},{"name":"status","fieldRef":["field",110,null],"enabled":true},{"name":"title","fieldRef":["field",107,null],"enabled":true},{"name":"description","fieldRef":["field",109,null],"enabled":false},{"name":"raw_data_id","fieldRef":["field",112,null],"enabled":false},{"name":"end","fieldRef":["field",111,{"temporal-unit":"default"}],"enabled":false},{"name":"start","fieldRef":["field",113,{"temporal-unit":"default"}],"enabled":false},{"name":"extra_text","fieldRef":["field",114,null],"enabled":false},{"name":"title","field_ref":["field",107,null],"enabled":true},{"name":"description","field_ref":["field",109,null],"enabled":true},{"name":"end","field_ref":["field",111,null],"enabled":true},{"name":"start","field_ref":["field",113,null],"enabled":true},{"name":"extra_text","field_ref":["field",114,null],"enabled":true},{"name":"id_3","field_ref":["field",83,{"join-alias":"Coped Organisation - Organisation"}],"enabled":true},{"name":"coped_id_2","field_ref":["field",80,{"join-alias":"Coped Organisation - Organisation"}],"enabled":true},{"name":"raw_data_id_2","field_ref":["field",84,{"join-alias":"Coped Organisation - Organisation"}],"enabled":true},{"name":"name","field_ref":["field",82,{"join-alias":"Coped Organisation - Organisation"}],"enabled":true},{"name":"role","field_ref":["field",131,{"join-alias":"Coped Project Organisation"}],"enabled":true}],"table.pivot_column":"id","table.cell_column":"name"},"public_uuid":null}	f	f	\N
69	Card	4	1	2021-12-24 14:40:48.729415+00	{"description":null,"archived":false,"collection_position":null,"table_id":7,"database_id":2,"enable_embedding":false,"collection_id":null,"query_type":"query","name":"Coped Project Organisations, Filtered by ID","creator_id":1,"made_public_by_id":null,"embedding_params":null,"cache_ttl":null,"dataset_query":{"type":"query","query":{"source-table":7,"fields":[["field",108,null]],"joins":[{"fields":[["field",131,{"join-alias":"Coped Project Organisation"}]],"source-table":8,"condition":["=",["field",108,null],["field",130,{"join-alias":"Coped Project Organisation"}]],"alias":"Coped Project Organisation"},{"fields":[["field",82,{"join-alias":"Coped Organisation - Organisation"}]],"source-table":5,"condition":["=",["field",132,{"join-alias":"Coped Project Organisation"}],["field",83,{"join-alias":"Coped Organisation - Organisation"}]],"alias":"Coped Organisation - Organisation"}],"filter":["=",["field",108,null],80]},"database":2},"id":4,"display":"table","visualization_settings":{"table.columns":[{"name":"id","fieldRef":["field",108,null],"enabled":false},{"name":"coped_id","fieldRef":["field",106,null],"enabled":true},{"name":"status","fieldRef":["field",110,null],"enabled":true},{"name":"title","fieldRef":["field",107,null],"enabled":true},{"name":"description","fieldRef":["field",109,null],"enabled":false},{"name":"raw_data_id","fieldRef":["field",112,null],"enabled":false},{"name":"end","fieldRef":["field",111,{"temporal-unit":"default"}],"enabled":false},{"name":"start","fieldRef":["field",113,{"temporal-unit":"default"}],"enabled":false},{"name":"extra_text","fieldRef":["field",114,null],"enabled":false},{"name":"title","field_ref":["field",107,null],"enabled":true},{"name":"description","field_ref":["field",109,null],"enabled":true},{"name":"end","field_ref":["field",111,null],"enabled":true},{"name":"start","field_ref":["field",113,null],"enabled":true},{"name":"extra_text","field_ref":["field",114,null],"enabled":true},{"name":"id_3","field_ref":["field",83,{"join-alias":"Coped Organisation - Organisation"}],"enabled":true},{"name":"coped_id_2","field_ref":["field",80,{"join-alias":"Coped Organisation - Organisation"}],"enabled":true},{"name":"raw_data_id_2","field_ref":["field",84,{"join-alias":"Coped Organisation - Organisation"}],"enabled":true},{"name":"name","field_ref":["field",82,{"join-alias":"Coped Organisation - Organisation"}],"enabled":true},{"name":"role","field_ref":["field",131,{"join-alias":"Coped Project Organisation"}],"enabled":true}],"table.pivot_column":"id","table.cell_column":"name"},"public_uuid":null}	f	f	\N
70	Dashboard	1	1	2021-12-24 14:41:07.657095+00	{"description":"View locations and details of organisations. Filter them by project subject topics.","name":"CoPED Organisation Map","cache_ttl":null,"cards":[{"sizeX":9,"sizeY":11,"row":0,"col":4,"id":1,"card_id":1,"series":[]},{"sizeX":4,"sizeY":11,"row":0,"col":0,"id":2,"card_id":null,"series":[]},{"sizeX":5,"sizeY":11,"row":0,"col":13,"id":3,"card_id":2,"series":[]}]}	f	f	\N
71	Dashboard	1	1	2021-12-24 14:57:57.762858+00	{"description":"View locations and details of organisations. Filter them by project subject topics.","name":"CoPED Organisation Map","cache_ttl":null,"cards":[{"sizeX":9,"sizeY":11,"row":0,"col":4,"id":1,"card_id":1,"series":[]},{"sizeX":4,"sizeY":11,"row":0,"col":0,"id":2,"card_id":null,"series":[]},{"sizeX":5,"sizeY":11,"row":0,"col":13,"id":3,"card_id":2,"series":[]}]}	f	f	\N
74	Card	5	4	2021-12-24 17:05:43.742635+00	{"description":null,"archived":false,"collection_position":null,"table_id":7,"database_id":2,"enable_embedding":false,"collection_id":3,"query_type":"query","name":"Coped Projects by Standard User","creator_id":4,"made_public_by_id":null,"embedding_params":null,"cache_ttl":null,"dataset_query":{"database":2,"query":{"source-table":7},"type":"query"},"id":5,"display":"table","visualization_settings":{"table.pivot_column":"end","table.cell_column":"extra_text"},"public_uuid":null}	f	t	\N
75	Dashboard	4	4	2021-12-24 17:06:01.67083+00	{"description":null,"name":"Regular User Dashboard","cache_ttl":null,"cards":[]}	f	t	\N
76	Dashboard	4	4	2021-12-24 17:08:30.690265+00	{"description":null,"name":"Regular User Dashboard","cache_ttl":null,"cards":[{"sizeX":2,"sizeY":2,"row":0,"col":0,"id":4,"card_id":5,"series":[]}]}	f	f	\N
77	Dashboard	4	4	2021-12-24 17:08:30.758595+00	{"description":null,"name":"Regular User Dashboard","cache_ttl":null,"cards":[{"sizeX":4,"sizeY":4,"row":0,"col":0,"id":4,"card_id":5,"series":[]}]}	f	f	\N
78	Dashboard	4	4	2021-12-24 17:08:30.799738+00	{"description":null,"name":"Regular User Dashboard","cache_ttl":null,"cards":[{"sizeX":4,"sizeY":4,"row":0,"col":0,"id":4,"card_id":5,"series":[]}]}	f	f	\N
79	Dashboard	4	4	2021-12-24 17:08:49.246821+00	{"description":null,"name":"Regular User Dashboard","cache_ttl":null,"cards":[{"sizeX":4,"sizeY":4,"row":0,"col":0,"id":4,"card_id":5,"series":[]}]}	f	f	\N
80	Dashboard	4	4	2021-12-24 17:08:49.319869+00	{"description":null,"name":"Regular User Dashboard","cache_ttl":null,"cards":[{"sizeX":4,"sizeY":4,"row":0,"col":0,"id":4,"card_id":5,"series":[]}]}	f	f	\N
\.


--
-- Data for Name: segment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.segment (id, table_id, creator_id, name, description, archived, definition, created_at, updated_at, points_of_interest, caveats, show_in_getting_started) FROM stdin;
\.


--
-- Data for Name: setting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.setting (key, value) FROM stdin;
analytics-uuid	56cd9cd9-57c9-4f30-925b-bd7ea1a50abe
instance-creation	2021-12-23T10:41:11.839257545Z
site-name	Coventry University
admin-email	metabase.local@c0l.in
site-locale	en
anon-tracking-enabled	false
enable-xrays	false
enable-public-sharing	true
redirect-all-requests-to-https	false
site-url	http://localhost/metabase
enable-embedding	true
embedding-secret-key	156812543071f0108b459434ebb9997b56865770f45fb9c19ff348772e72c0e4
version-info-last-checked	2021-12-24T18:15:00.107325012Z
settings-last-updated	2021-12-24 18:17:04.089739+00
\.


--
-- Data for Name: task_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_history (id, task, db_id, started_at, ended_at, duration, task_details) FROM stdin;
1	sync	1	2021-12-23 10:40:02.538794+00	2021-12-23 10:40:05.248946+00	2710	\N
2	sync-timezone	1	2021-12-23 10:40:02.539611+00	2021-12-23 10:40:02.910881+00	371	{"timezone-id":"UTC"}
3	sync-tables	1	2021-12-23 10:40:02.911367+00	2021-12-23 10:40:03.209569+00	298	{"updated-tables":4,"total-tables":0}
4	sync-fields	1	2021-12-23 10:40:03.209641+00	2021-12-23 10:40:04.086039+00	876	{"total-fields":36,"updated-fields":36}
5	sync-fks	1	2021-12-23 10:40:04.086103+00	2021-12-23 10:40:04.168198+00	82	{"total-fks":3,"updated-fks":3,"total-failed":0}
6	sync-metabase-metadata	1	2021-12-23 10:40:04.168275+00	2021-12-23 10:40:05.248828+00	1080	\N
7	analyze	1	2021-12-23 10:40:05.402987+00	2021-12-23 10:40:09.166772+00	3763	\N
8	fingerprint-fields	1	2021-12-23 10:40:05.403014+00	2021-12-23 10:40:08.656179+00	3253	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":32,"fingerprints-attempted":32}
9	classify-fields	1	2021-12-23 10:40:08.656318+00	2021-12-23 10:40:09.064818+00	408	{"fields-classified":32,"fields-failed":0}
10	classify-tables	1	2021-12-23 10:40:09.064878+00	2021-12-23 10:40:09.166685+00	101	{"total-tables":4,"tables-classified":4}
11	field values scanning	1	2021-12-23 10:40:09.309398+00	2021-12-23 10:40:09.931381+00	621	\N
12	update-field-values	1	2021-12-23 10:40:09.309441+00	2021-12-23 10:40:09.931319+00	621	{"errors":0,"created":5,"updated":0,"deleted":0}
13	sync	2	2021-12-23 10:42:33.086919+00	2021-12-23 10:42:38.076695+00	4989	\N
14	sync-timezone	2	2021-12-23 10:42:33.086966+00	2021-12-23 10:42:33.215687+00	128	{"timezone-id":"UTC"}
15	sync-tables	2	2021-12-23 10:42:33.215777+00	2021-12-23 10:42:34.094907+00	879	{"updated-tables":34,"total-tables":0}
16	sync-fields	2	2021-12-23 10:42:34.095026+00	2021-12-23 10:42:37.130459+00	3035	{"total-fields":128,"updated-fields":128}
17	sync-fks	2	2021-12-23 10:42:37.130658+00	2021-12-23 10:42:38.04867+00	918	{"total-fks":32,"updated-fks":30,"total-failed":0}
18	sync-metabase-metadata	2	2021-12-23 10:42:38.048858+00	2021-12-23 10:42:38.076639+00	27	\N
19	analyze	2	2021-12-23 10:42:38.210062+00	2021-12-23 10:42:45.677533+00	7467	\N
20	fingerprint-fields	2	2021-12-23 10:42:38.210094+00	2021-12-23 10:42:44.210445+00	6000	{"no-data-fingerprints":18,"failed-fingerprints":0,"updated-fingerprints":85,"fingerprints-attempted":103}
21	classify-fields	2	2021-12-23 10:42:44.210917+00	2021-12-23 10:42:45.051601+00	840	{"fields-classified":85,"fields-failed":0}
22	classify-tables	2	2021-12-23 10:42:45.051649+00	2021-12-23 10:42:45.67745+00	625	{"total-tables":26,"tables-classified":26}
23	field values scanning	2	2021-12-23 10:42:45.783141+00	2021-12-23 10:42:46.602432+00	819	\N
24	update-field-values	2	2021-12-23 10:42:45.783162+00	2021-12-23 10:42:46.602257+00	819	{"errors":0,"created":21,"updated":0,"deleted":0}
25	send-pulses	\N	2021-12-23 11:00:00.129+00	2021-12-23 11:00:00.173+00	44	\N
26	task-history-cleanup	\N	2021-12-23 11:00:00.162+00	2021-12-23 11:00:00.174+00	12	\N
27	sync	2	2021-12-23 11:04:57.770368+00	2021-12-23 11:04:58.280281+00	509	\N
28	sync-timezone	2	2021-12-23 11:04:57.773598+00	2021-12-23 11:04:57.826685+00	53	{"timezone-id":"UTC"}
29	sync-tables	2	2021-12-23 11:04:57.827613+00	2021-12-23 11:04:57.89046+00	62	{"updated-tables":0,"total-tables":34}
30	sync-fields	2	2021-12-23 11:04:57.890571+00	2021-12-23 11:04:58.123585+00	233	{"total-fields":95,"updated-fields":0}
31	sync-fks	2	2021-12-23 11:04:58.123643+00	2021-12-23 11:04:58.267086+00	143	{"total-fks":28,"updated-fks":0,"total-failed":0}
32	sync-metabase-metadata	2	2021-12-23 11:04:58.267132+00	2021-12-23 11:04:58.28026+00	13	\N
33	analyze	2	2021-12-23 11:04:58.431099+00	2021-12-23 11:04:58.506789+00	75	\N
34	fingerprint-fields	2	2021-12-23 11:04:58.431119+00	2021-12-23 11:04:58.473617+00	42	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
35	classify-fields	2	2021-12-23 11:04:58.473676+00	2021-12-23 11:04:58.485713+00	12	{"fields-classified":0,"fields-failed":0}
36	classify-tables	2	2021-12-23 11:04:58.485812+00	2021-12-23 11:04:58.506706+00	20	{"total-tables":20,"tables-classified":0}
37	sync	2	2021-12-23 11:46:00.160538+00	2021-12-23 11:46:00.444869+00	284	\N
38	sync-timezone	2	2021-12-23 11:46:00.163611+00	2021-12-23 11:46:00.179505+00	15	{"timezone-id":"UTC"}
39	sync-tables	2	2021-12-23 11:46:00.179682+00	2021-12-23 11:46:00.210181+00	30	{"updated-tables":0,"total-tables":34}
40	sync-fields	2	2021-12-23 11:46:00.210217+00	2021-12-23 11:46:00.342806+00	132	{"total-fields":95,"updated-fields":0}
41	sync-fks	2	2021-12-23 11:46:00.342841+00	2021-12-23 11:46:00.429736+00	86	{"total-fks":28,"updated-fks":0,"total-failed":0}
42	sync-metabase-metadata	2	2021-12-23 11:46:00.429769+00	2021-12-23 11:46:00.444845+00	15	\N
43	analyze	2	2021-12-23 11:46:00.551385+00	2021-12-23 11:46:00.61532+00	63	\N
44	fingerprint-fields	2	2021-12-23 11:46:00.551402+00	2021-12-23 11:46:00.582926+00	31	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
45	classify-fields	2	2021-12-23 11:46:00.583025+00	2021-12-23 11:46:00.593079+00	10	{"fields-classified":0,"fields-failed":0}
46	classify-tables	2	2021-12-23 11:46:00.593132+00	2021-12-23 11:46:00.615294+00	22	{"total-tables":20,"tables-classified":0}
47	send-pulses	\N	2021-12-23 12:00:00.228+00	2021-12-23 12:00:00.243+00	15	\N
48	task-history-cleanup	\N	2021-12-23 12:00:00.304+00	2021-12-23 12:00:00.306+00	2	\N
49	sync	2	2021-12-23 12:46:00.118386+00	2021-12-23 12:46:00.42588+00	307	\N
50	sync-timezone	2	2021-12-23 12:46:00.118532+00	2021-12-23 12:46:00.135182+00	16	{"timezone-id":"UTC"}
51	sync-tables	2	2021-12-23 12:46:00.135514+00	2021-12-23 12:46:00.186095+00	50	{"updated-tables":0,"total-tables":34}
52	sync-fields	2	2021-12-23 12:46:00.186133+00	2021-12-23 12:46:00.31372+00	127	{"total-fields":95,"updated-fields":0}
53	sync-fks	2	2021-12-23 12:46:00.313747+00	2021-12-23 12:46:00.406955+00	93	{"total-fks":28,"updated-fks":0,"total-failed":0}
54	sync-metabase-metadata	2	2021-12-23 12:46:00.407019+00	2021-12-23 12:46:00.425858+00	18	\N
55	analyze	2	2021-12-23 12:46:00.609129+00	2021-12-23 12:46:00.686261+00	77	\N
56	fingerprint-fields	2	2021-12-23 12:46:00.609151+00	2021-12-23 12:46:00.644074+00	34	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
57	classify-fields	2	2021-12-23 12:46:00.644126+00	2021-12-23 12:46:00.66156+00	17	{"fields-classified":0,"fields-failed":0}
58	classify-tables	2	2021-12-23 12:46:00.661609+00	2021-12-23 12:46:00.68622+00	24	{"total-tables":20,"tables-classified":0}
59	send-pulses	\N	2021-12-23 13:00:00.079+00	2021-12-23 13:00:00.105+00	26	\N
60	task-history-cleanup	\N	2021-12-23 13:00:00.135+00	2021-12-23 13:00:00.144+00	9	\N
61	send-pulses	\N	2021-12-23 14:50:01.074+00	2021-12-23 14:50:01.096+00	22	\N
62	task-history-cleanup	\N	2021-12-23 14:50:01.123+00	2021-12-23 14:50:01.126+00	3	\N
63	task-history-cleanup	\N	2021-12-23 15:00:35.754+00	2021-12-23 15:00:35.757+00	3	\N
64	send-pulses	\N	2021-12-23 15:00:35.733+00	2021-12-23 15:00:35.76+00	27	\N
65	task-history-cleanup	\N	2021-12-23 16:49:18.6+00	2021-12-23 16:49:18.601+00	1	\N
66	send-pulses	\N	2021-12-23 16:49:18.558+00	2021-12-23 16:49:18.598+00	40	\N
67	send-pulses	\N	2021-12-23 17:00:00.046+00	2021-12-23 17:00:00.074+00	28	\N
68	task-history-cleanup	\N	2021-12-23 17:00:00.095+00	2021-12-23 17:00:00.11+00	15	\N
69	send-pulses	\N	2021-12-23 18:13:29.623+00	2021-12-23 18:13:29.671+00	48	\N
70	task-history-cleanup	\N	2021-12-23 18:13:29.83+00	2021-12-23 18:13:29.845+00	15	\N
71	field values scanning	2	2021-12-23 18:13:30.212196+00	2021-12-23 18:13:31.171133+00	958	\N
72	update-field-values	2	2021-12-23 18:13:30.212907+00	2021-12-23 18:13:31.171011+00	958	{"errors":0,"created":0,"updated":0,"deleted":0}
73	task-history-cleanup	\N	2021-12-23 19:00:31.843+00	2021-12-23 19:00:31.845+00	2	\N
74	send-pulses	\N	2021-12-23 19:00:31.802+00	2021-12-23 19:00:31.853+00	51	\N
75	sync	2	2021-12-23 19:00:31.807141+00	2021-12-23 19:00:32.518613+00	711	\N
76	sync-timezone	2	2021-12-23 19:00:31.808543+00	2021-12-23 19:00:31.91288+00	104	{"timezone-id":"UTC"}
77	sync-tables	2	2021-12-23 19:00:31.913013+00	2021-12-23 19:00:32.086163+00	173	{"updated-tables":0,"total-tables":34}
78	sync-fields	2	2021-12-23 19:00:32.086199+00	2021-12-23 19:00:32.427766+00	341	{"total-fields":95,"updated-fields":0}
79	sync-fks	2	2021-12-23 19:00:32.427798+00	2021-12-23 19:00:32.509373+00	81	{"total-fks":28,"updated-fks":0,"total-failed":0}
80	sync-metabase-metadata	2	2021-12-23 19:00:32.509401+00	2021-12-23 19:00:32.518591+00	9	\N
81	analyze	2	2021-12-23 19:00:32.645102+00	2021-12-23 19:00:32.839629+00	194	\N
82	fingerprint-fields	2	2021-12-23 19:00:32.645114+00	2021-12-23 19:00:32.728568+00	83	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
83	classify-fields	2	2021-12-23 19:00:32.728891+00	2021-12-23 19:00:32.772754+00	43	{"fields-classified":0,"fields-failed":0}
84	classify-tables	2	2021-12-23 19:00:32.772806+00	2021-12-23 19:00:32.839586+00	66	{"total-tables":20,"tables-classified":0}
85	sync	2	2021-12-23 19:46:00.20424+00	2021-12-23 19:46:00.975871+00	771	\N
86	sync-timezone	2	2021-12-23 19:46:00.204356+00	2021-12-23 19:46:00.313769+00	109	{"timezone-id":"UTC"}
87	sync-tables	2	2021-12-23 19:46:00.316197+00	2021-12-23 19:46:00.531025+00	214	{"updated-tables":0,"total-tables":34}
88	sync-fields	2	2021-12-23 19:46:00.531752+00	2021-12-23 19:46:00.875669+00	343	{"total-fields":95,"updated-fields":0}
89	sync-fks	2	2021-12-23 19:46:00.875759+00	2021-12-23 19:46:00.959696+00	83	{"total-fks":28,"updated-fks":0,"total-failed":0}
91	analyze	2	2021-12-23 19:46:01.108395+00	2021-12-23 19:46:01.187305+00	78	\N
92	fingerprint-fields	2	2021-12-23 19:46:01.108407+00	2021-12-23 19:46:01.154011+00	45	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
93	classify-fields	2	2021-12-23 19:46:01.15405+00	2021-12-23 19:46:01.168066+00	14	{"fields-classified":0,"fields-failed":0}
94	classify-tables	2	2021-12-23 19:46:01.168101+00	2021-12-23 19:46:01.187278+00	19	{"total-tables":20,"tables-classified":0}
96	task-history-cleanup	\N	2021-12-23 20:00:00.142+00	2021-12-23 20:00:00.225+00	83	\N
97	sync	2	2021-12-23 20:46:00.546852+00	2021-12-23 20:46:01.627361+00	1080	\N
98	sync-timezone	2	2021-12-23 20:46:00.548579+00	2021-12-23 20:46:00.774271+00	225	{"timezone-id":"UTC"}
99	sync-tables	2	2021-12-23 20:46:00.777053+00	2021-12-23 20:46:00.930039+00	152	{"updated-tables":0,"total-tables":34}
100	sync-fields	2	2021-12-23 20:46:00.930077+00	2021-12-23 20:46:01.402673+00	472	{"total-fields":95,"updated-fields":0}
101	sync-fks	2	2021-12-23 20:46:01.402706+00	2021-12-23 20:46:01.550156+00	147	{"total-fks":28,"updated-fks":0,"total-failed":0}
102	sync-metabase-metadata	2	2021-12-23 20:46:01.550191+00	2021-12-23 20:46:01.627334+00	77	\N
103	analyze	2	2021-12-23 20:46:01.791788+00	2021-12-23 20:46:01.899077+00	107	\N
104	fingerprint-fields	2	2021-12-23 20:46:01.792587+00	2021-12-23 20:46:01.864934+00	72	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
105	classify-fields	2	2021-12-23 20:46:01.864963+00	2021-12-23 20:46:01.881182+00	16	{"fields-classified":0,"fields-failed":0}
106	classify-tables	2	2021-12-23 20:46:01.881225+00	2021-12-23 20:46:01.899051+00	17	{"total-tables":20,"tables-classified":0}
108	send-pulses	\N	2021-12-23 21:00:00.112+00	2021-12-23 21:00:00.212+00	100	\N
90	sync-metabase-metadata	2	2021-12-23 19:46:00.959728+00	2021-12-23 19:46:00.975851+00	16	\N
95	send-pulses	\N	2021-12-23 20:00:00.127+00	2021-12-23 20:00:00.398+00	271	\N
107	task-history-cleanup	\N	2021-12-23 21:00:00.143+00	2021-12-23 21:00:00.175+00	32	\N
117	classify-fields	2	2021-12-23 21:46:03.544843+00	2021-12-23 21:46:03.5549+00	10	{"fields-classified":0,"fields-failed":0}
118	classify-tables	2	2021-12-23 21:46:03.554977+00	2021-12-23 21:46:03.586839+00	31	{"total-tables":20,"tables-classified":0}
109	sync	2	2021-12-23 21:46:00.433908+00	2021-12-23 21:46:03.291661+00	2857	\N
110	sync-timezone	2	2021-12-23 21:46:00.435622+00	2021-12-23 21:46:00.651381+00	215	{"timezone-id":"UTC"}
111	sync-tables	2	2021-12-23 21:46:00.652211+00	2021-12-23 21:46:00.992906+00	340	{"updated-tables":0,"total-tables":34}
112	sync-fields	2	2021-12-23 21:46:00.992952+00	2021-12-23 21:46:01.88896+00	896	{"total-fields":95,"updated-fields":0}
113	sync-fks	2	2021-12-23 21:46:01.889131+00	2021-12-23 21:46:03.241235+00	1352	{"total-fks":28,"updated-fks":0,"total-failed":0}
114	sync-metabase-metadata	2	2021-12-23 21:46:03.24138+00	2021-12-23 21:46:03.29164+00	50	\N
115	analyze	2	2021-12-23 21:46:03.453085+00	2021-12-23 21:46:03.586866+00	133	\N
116	fingerprint-fields	2	2021-12-23 21:46:03.45341+00	2021-12-23 21:46:03.54481+00	91	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
119	send-pulses	\N	2021-12-23 22:00:00.093+00	2021-12-23 22:00:00.131+00	38	\N
120	task-history-cleanup	\N	2021-12-23 22:00:00.147+00	2021-12-23 22:00:00.151+00	4	\N
121	sync	2	2021-12-23 22:46:00.145298+00	2021-12-23 22:46:00.68005+00	534	\N
122	sync-timezone	2	2021-12-23 22:46:00.145844+00	2021-12-23 22:46:00.18132+00	35	{"timezone-id":"UTC"}
123	sync-tables	2	2021-12-23 22:46:00.181673+00	2021-12-23 22:46:00.223477+00	41	{"updated-tables":0,"total-tables":34}
124	sync-fields	2	2021-12-23 22:46:00.223528+00	2021-12-23 22:46:00.522186+00	298	{"total-fields":95,"updated-fields":0}
125	sync-fks	2	2021-12-23 22:46:00.522238+00	2021-12-23 22:46:00.649136+00	126	{"total-fks":28,"updated-fks":0,"total-failed":0}
126	sync-metabase-metadata	2	2021-12-23 22:46:00.64917+00	2021-12-23 22:46:00.680029+00	30	\N
127	analyze	2	2021-12-23 22:46:00.81203+00	2021-12-23 22:46:00.918085+00	106	\N
128	fingerprint-fields	2	2021-12-23 22:46:00.812051+00	2021-12-23 22:46:00.886362+00	74	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
129	classify-fields	2	2021-12-23 22:46:00.886397+00	2021-12-23 22:46:00.895462+00	9	{"fields-classified":0,"fields-failed":0}
130	classify-tables	2	2021-12-23 22:46:00.895495+00	2021-12-23 22:46:00.917734+00	22	{"total-tables":20,"tables-classified":0}
131	send-pulses	\N	2021-12-23 23:00:00.059+00	2021-12-23 23:00:00.108+00	49	\N
132	task-history-cleanup	\N	2021-12-23 23:00:00.161+00	2021-12-23 23:00:00.164+00	3	\N
133	sync	2	2021-12-23 23:57:09.36216+00	2021-12-23 23:57:10.408887+00	1046	\N
134	sync-timezone	2	2021-12-23 23:57:09.362821+00	2021-12-23 23:57:09.441859+00	79	{"timezone-id":"UTC"}
135	sync-tables	2	2021-12-23 23:57:09.442183+00	2021-12-23 23:57:09.722943+00	280	{"updated-tables":0,"total-tables":34}
136	sync-fields	2	2021-12-23 23:57:09.723046+00	2021-12-23 23:57:10.185945+00	462	{"total-fields":95,"updated-fields":0}
137	sync-fks	2	2021-12-23 23:57:10.186028+00	2021-12-23 23:57:10.389762+00	203	{"total-fks":28,"updated-fks":0,"total-failed":0}
138	sync-metabase-metadata	2	2021-12-23 23:57:10.389816+00	2021-12-23 23:57:10.408855+00	19	\N
139	analyze	2	2021-12-23 23:57:10.679486+00	2021-12-23 23:57:11.066282+00	386	\N
140	fingerprint-fields	2	2021-12-23 23:57:10.67951+00	2021-12-23 23:57:10.862348+00	182	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
141	classify-fields	2	2021-12-23 23:57:10.862507+00	2021-12-23 23:57:10.940911+00	78	{"fields-classified":0,"fields-failed":0}
142	classify-tables	2	2021-12-23 23:57:10.941009+00	2021-12-23 23:57:11.066234+00	125	{"total-tables":20,"tables-classified":0}
143	task-history-cleanup	\N	2021-12-24 00:00:00.124+00	2021-12-24 00:00:00.131+00	7	\N
144	send-pulses	\N	2021-12-24 00:00:00.084+00	2021-12-24 00:00:00.134+00	50	\N
145	sync	2	2021-12-24 00:46:00.088204+00	2021-12-24 00:46:00.449218+00	361	\N
146	sync-timezone	2	2021-12-24 00:46:00.088696+00	2021-12-24 00:46:00.103639+00	14	{"timezone-id":"UTC"}
147	sync-tables	2	2021-12-24 00:46:00.103778+00	2021-12-24 00:46:00.152846+00	49	{"updated-tables":0,"total-tables":34}
148	sync-fields	2	2021-12-24 00:46:00.152905+00	2021-12-24 00:46:00.311872+00	158	{"total-fields":95,"updated-fields":0}
149	sync-fks	2	2021-12-24 00:46:00.311909+00	2021-12-24 00:46:00.42605+00	114	{"total-fks":28,"updated-fks":0,"total-failed":0}
150	sync-metabase-metadata	2	2021-12-24 00:46:00.426097+00	2021-12-24 00:46:00.449195+00	23	\N
151	analyze	2	2021-12-24 00:46:00.611101+00	2021-12-24 00:46:00.746459+00	135	\N
152	fingerprint-fields	2	2021-12-24 00:46:00.611116+00	2021-12-24 00:46:00.643307+00	32	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
153	classify-fields	2	2021-12-24 00:46:00.643373+00	2021-12-24 00:46:00.6556+00	12	{"fields-classified":0,"fields-failed":0}
154	classify-tables	2	2021-12-24 00:46:00.655703+00	2021-12-24 00:46:00.746426+00	90	{"total-tables":20,"tables-classified":0}
155	send-pulses	\N	2021-12-24 01:00:00.105+00	2021-12-24 01:00:00.144+00	39	\N
156	task-history-cleanup	\N	2021-12-24 01:00:00.174+00	2021-12-24 01:00:00.191+00	17	\N
157	sync	2	2021-12-24 01:46:00.835687+00	2021-12-24 01:46:02.119378+00	1283	\N
158	sync-timezone	2	2021-12-24 01:46:00.845782+00	2021-12-24 01:46:01.043171+00	197	{"timezone-id":"UTC"}
159	sync-tables	2	2021-12-24 01:46:01.045322+00	2021-12-24 01:46:01.402817+00	357	{"updated-tables":0,"total-tables":34}
160	sync-fields	2	2021-12-24 01:46:01.40289+00	2021-12-24 01:46:01.997128+00	594	{"total-fields":95,"updated-fields":0}
161	sync-fks	2	2021-12-24 01:46:01.997199+00	2021-12-24 01:46:02.102891+00	105	{"total-fks":28,"updated-fks":0,"total-failed":0}
162	sync-metabase-metadata	2	2021-12-24 01:46:02.102952+00	2021-12-24 01:46:02.119339+00	16	\N
163	analyze	2	2021-12-24 01:46:02.325354+00	2021-12-24 01:46:02.42701+00	101	\N
164	fingerprint-fields	2	2021-12-24 01:46:02.325403+00	2021-12-24 01:46:02.393904+00	68	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
165	classify-fields	2	2021-12-24 01:46:02.393963+00	2021-12-24 01:46:02.403749+00	9	{"fields-classified":0,"fields-failed":0}
166	classify-tables	2	2021-12-24 01:46:02.403791+00	2021-12-24 01:46:02.426974+00	23	{"total-tables":20,"tables-classified":0}
167	send-pulses	\N	2021-12-24 02:00:00.063+00	2021-12-24 02:00:00.126+00	63	\N
168	task-history-cleanup	\N	2021-12-24 02:00:00.127+00	2021-12-24 02:00:00.135+00	8	\N
169	sync	2	2021-12-24 02:46:00.132567+00	2021-12-24 02:46:00.403309+00	270	\N
170	sync-timezone	2	2021-12-24 02:46:00.132922+00	2021-12-24 02:46:00.155036+00	22	{"timezone-id":"UTC"}
171	sync-tables	2	2021-12-24 02:46:00.155504+00	2021-12-24 02:46:00.199397+00	43	{"updated-tables":0,"total-tables":34}
172	sync-fields	2	2021-12-24 02:46:00.199431+00	2021-12-24 02:46:00.315198+00	115	{"total-fields":95,"updated-fields":0}
173	sync-fks	2	2021-12-24 02:46:00.315231+00	2021-12-24 02:46:00.392848+00	77	{"total-fks":28,"updated-fks":0,"total-failed":0}
174	sync-metabase-metadata	2	2021-12-24 02:46:00.392878+00	2021-12-24 02:46:00.403289+00	10	\N
175	analyze	2	2021-12-24 02:46:00.529958+00	2021-12-24 02:46:00.572288+00	42	\N
176	fingerprint-fields	2	2021-12-24 02:46:00.529978+00	2021-12-24 02:46:00.556981+00	27	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
177	classify-fields	2	2021-12-24 02:46:00.557026+00	2021-12-24 02:46:00.563565+00	6	{"fields-classified":0,"fields-failed":0}
178	classify-tables	2	2021-12-24 02:46:00.563599+00	2021-12-24 02:46:00.572262+00	8	{"total-tables":20,"tables-classified":0}
179	task-history-cleanup	\N	2021-12-24 03:00:00.111+00	2021-12-24 03:00:00.117+00	6	\N
180	send-pulses	\N	2021-12-24 03:00:00.066+00	2021-12-24 03:00:00.107+00	41	\N
181	sync	2	2021-12-24 03:46:00.087711+00	2021-12-24 03:46:00.453054+00	365	\N
182	sync-timezone	2	2021-12-24 03:46:00.088152+00	2021-12-24 03:46:00.115904+00	27	{"timezone-id":"UTC"}
183	sync-tables	2	2021-12-24 03:46:00.11663+00	2021-12-24 03:46:00.17787+00	61	{"updated-tables":0,"total-tables":34}
184	sync-fields	2	2021-12-24 03:46:00.17791+00	2021-12-24 03:46:00.334753+00	156	{"total-fields":95,"updated-fields":0}
185	sync-fks	2	2021-12-24 03:46:00.334782+00	2021-12-24 03:46:00.439074+00	104	{"total-fks":28,"updated-fks":0,"total-failed":0}
186	sync-metabase-metadata	2	2021-12-24 03:46:00.439105+00	2021-12-24 03:46:00.453036+00	13	\N
187	analyze	2	2021-12-24 03:46:00.593164+00	2021-12-24 03:46:00.642354+00	49	\N
188	fingerprint-fields	2	2021-12-24 03:46:00.593181+00	2021-12-24 03:46:00.624033+00	30	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
189	classify-fields	2	2021-12-24 03:46:00.624069+00	2021-12-24 03:46:00.631499+00	7	{"fields-classified":0,"fields-failed":0}
190	classify-tables	2	2021-12-24 03:46:00.631533+00	2021-12-24 03:46:00.642316+00	10	{"total-tables":20,"tables-classified":0}
191	send-pulses	\N	2021-12-24 04:00:00.078+00	2021-12-24 04:00:00.116+00	38	\N
192	task-history-cleanup	\N	2021-12-24 04:00:00.141+00	2021-12-24 04:00:00.144+00	3	\N
193	sync	2	2021-12-24 04:46:00.106068+00	2021-12-24 04:46:00.444589+00	338	\N
194	sync-timezone	2	2021-12-24 04:46:00.107253+00	2021-12-24 04:46:00.129177+00	21	{"timezone-id":"UTC"}
195	sync-tables	2	2021-12-24 04:46:00.129437+00	2021-12-24 04:46:00.175078+00	45	{"updated-tables":0,"total-tables":34}
196	sync-fields	2	2021-12-24 04:46:00.175125+00	2021-12-24 04:46:00.311839+00	136	{"total-fields":95,"updated-fields":0}
197	sync-fks	2	2021-12-24 04:46:00.311872+00	2021-12-24 04:46:00.426672+00	114	{"total-fks":28,"updated-fks":0,"total-failed":0}
198	sync-metabase-metadata	2	2021-12-24 04:46:00.426716+00	2021-12-24 04:46:00.44449+00	17	\N
199	analyze	2	2021-12-24 04:46:00.569861+00	2021-12-24 04:46:00.611211+00	41	\N
200	fingerprint-fields	2	2021-12-24 04:46:00.569875+00	2021-12-24 04:46:00.597074+00	27	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
201	classify-fields	2	2021-12-24 04:46:00.597105+00	2021-12-24 04:46:00.603997+00	6	{"fields-classified":0,"fields-failed":0}
202	classify-tables	2	2021-12-24 04:46:00.604022+00	2021-12-24 04:46:00.611193+00	7	{"total-tables":20,"tables-classified":0}
203	send-pulses	\N	2021-12-24 14:39:02.437+00	2021-12-24 14:39:02.447+00	10	\N
204	task-history-cleanup	\N	2021-12-24 14:39:02.498+00	2021-12-24 14:39:02.5+00	2	\N
205	sync	2	2021-12-24 14:46:00.106381+00	2021-12-24 14:46:00.430776+00	324	\N
206	sync-timezone	2	2021-12-24 14:46:00.106509+00	2021-12-24 14:46:00.125213+00	18	{"timezone-id":"UTC"}
207	sync-tables	2	2021-12-24 14:46:00.125537+00	2021-12-24 14:46:00.16368+00	38	{"updated-tables":0,"total-tables":34}
208	sync-fields	2	2021-12-24 14:46:00.163709+00	2021-12-24 14:46:00.335823+00	172	{"total-fields":95,"updated-fields":0}
209	sync-fks	2	2021-12-24 14:46:00.335863+00	2021-12-24 14:46:00.418485+00	82	{"total-fks":28,"updated-fks":0,"total-failed":0}
210	sync-metabase-metadata	2	2021-12-24 14:46:00.41851+00	2021-12-24 14:46:00.430757+00	12	\N
211	analyze	2	2021-12-24 14:46:00.561674+00	2021-12-24 14:46:00.60193+00	40	\N
212	fingerprint-fields	2	2021-12-24 14:46:00.56169+00	2021-12-24 14:46:00.588946+00	27	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
213	classify-fields	2	2021-12-24 14:46:00.58898+00	2021-12-24 14:46:00.594955+00	5	{"fields-classified":0,"fields-failed":0}
214	classify-tables	2	2021-12-24 14:46:00.594988+00	2021-12-24 14:46:00.601907+00	6	{"total-tables":20,"tables-classified":0}
215	send-pulses	\N	2021-12-24 15:00:00.069+00	2021-12-24 15:00:00.084+00	15	\N
216	task-history-cleanup	\N	2021-12-24 15:00:00.138+00	2021-12-24 15:00:00.141+00	3	\N
217	sync	2	2021-12-24 15:46:00.122618+00	2021-12-24 15:46:00.480696+00	358	\N
218	sync-timezone	2	2021-12-24 15:46:00.124329+00	2021-12-24 15:46:00.146606+00	22	{"timezone-id":"UTC"}
219	sync-tables	2	2021-12-24 15:46:00.146836+00	2021-12-24 15:46:00.215572+00	68	{"updated-tables":0,"total-tables":34}
220	sync-fields	2	2021-12-24 15:46:00.215639+00	2021-12-24 15:46:00.369674+00	154	{"total-fields":95,"updated-fields":0}
221	sync-fks	2	2021-12-24 15:46:00.369707+00	2021-12-24 15:46:00.46232+00	92	{"total-fks":28,"updated-fks":0,"total-failed":0}
222	sync-metabase-metadata	2	2021-12-24 15:46:00.462352+00	2021-12-24 15:46:00.480671+00	18	\N
223	analyze	2	2021-12-24 15:46:00.600012+00	2021-12-24 15:46:00.634272+00	34	\N
224	fingerprint-fields	2	2021-12-24 15:46:00.600025+00	2021-12-24 15:46:00.624274+00	24	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
225	classify-fields	2	2021-12-24 15:46:00.624302+00	2021-12-24 15:46:00.628983+00	4	{"fields-classified":0,"fields-failed":0}
226	classify-tables	2	2021-12-24 15:46:00.629004+00	2021-12-24 15:46:00.634258+00	5	{"total-tables":20,"tables-classified":0}
227	send-pulses	\N	2021-12-24 16:00:00.072+00	2021-12-24 16:00:00.104+00	32	\N
228	task-history-cleanup	\N	2021-12-24 16:00:00.121+00	2021-12-24 16:00:00.123+00	2	\N
229	sync	2	2021-12-24 16:46:00.142202+00	2021-12-24 16:46:00.830598+00	688	\N
230	sync-timezone	2	2021-12-24 16:46:00.142741+00	2021-12-24 16:46:00.183452+00	40	{"timezone-id":"UTC"}
231	sync-tables	2	2021-12-24 16:46:00.183709+00	2021-12-24 16:46:00.233719+00	50	{"updated-tables":0,"total-tables":34}
232	sync-fields	2	2021-12-24 16:46:00.23376+00	2021-12-24 16:46:00.507596+00	273	{"total-fields":95,"updated-fields":0}
233	sync-fks	2	2021-12-24 16:46:00.50764+00	2021-12-24 16:46:00.744446+00	236	{"total-fks":28,"updated-fks":0,"total-failed":0}
234	sync-metabase-metadata	2	2021-12-24 16:46:00.744483+00	2021-12-24 16:46:00.830509+00	86	\N
235	analyze	2	2021-12-24 16:46:00.983664+00	2021-12-24 16:46:01.045482+00	61	\N
236	fingerprint-fields	2	2021-12-24 16:46:00.983678+00	2021-12-24 16:46:01.024722+00	41	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
237	classify-fields	2	2021-12-24 16:46:01.024804+00	2021-12-24 16:46:01.032685+00	7	{"fields-classified":0,"fields-failed":0}
238	classify-tables	2	2021-12-24 16:46:01.032719+00	2021-12-24 16:46:01.045452+00	12	{"total-tables":20,"tables-classified":0}
239	send-pulses	\N	2021-12-24 17:00:00.045+00	2021-12-24 17:00:00.074+00	29	\N
240	task-history-cleanup	\N	2021-12-24 17:00:00.091+00	2021-12-24 17:00:00.094+00	3	\N
241	sync	2	2021-12-24 17:46:00.109646+00	2021-12-24 17:46:00.416234+00	306	\N
242	sync-timezone	2	2021-12-24 17:46:00.110144+00	2021-12-24 17:46:00.13306+00	22	{"timezone-id":"UTC"}
243	sync-tables	2	2021-12-24 17:46:00.133288+00	2021-12-24 17:46:00.182634+00	49	{"updated-tables":0,"total-tables":34}
244	sync-fields	2	2021-12-24 17:46:00.182669+00	2021-12-24 17:46:00.322995+00	140	{"total-fields":95,"updated-fields":0}
245	sync-fks	2	2021-12-24 17:46:00.323019+00	2021-12-24 17:46:00.402615+00	79	{"total-fks":28,"updated-fks":0,"total-failed":0}
246	sync-metabase-metadata	2	2021-12-24 17:46:00.402644+00	2021-12-24 17:46:00.416217+00	13	\N
247	analyze	2	2021-12-24 17:46:00.545921+00	2021-12-24 17:46:00.593236+00	47	\N
248	fingerprint-fields	2	2021-12-24 17:46:00.545935+00	2021-12-24 17:46:00.57472+00	28	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
249	classify-fields	2	2021-12-24 17:46:00.57475+00	2021-12-24 17:46:00.580156+00	5	{"fields-classified":0,"fields-failed":0}
250	classify-tables	2	2021-12-24 17:46:00.580183+00	2021-12-24 17:46:00.593206+00	13	{"total-tables":20,"tables-classified":0}
251	send-pulses	\N	2021-12-24 18:00:00.11+00	2021-12-24 18:00:00.119+00	9	\N
252	task-history-cleanup	\N	2021-12-24 18:00:00.17+00	2021-12-24 18:00:00.172+00	2	\N
253	field values scanning	2	2021-12-24 18:00:00.152694+00	2021-12-24 18:00:00.834203+00	681	\N
254	update-field-values	2	2021-12-24 18:00:00.152753+00	2021-12-24 18:00:00.834167+00	681	{"errors":0,"created":0,"updated":0,"deleted":0}
255	sync	2	2021-12-24 18:46:00.109265+00	2021-12-24 18:46:00.435517+00	326	\N
256	sync-timezone	2	2021-12-24 18:46:00.10945+00	2021-12-24 18:46:00.126751+00	17	{"timezone-id":"UTC"}
257	sync-tables	2	2021-12-24 18:46:00.127033+00	2021-12-24 18:46:00.162214+00	35	{"updated-tables":0,"total-tables":34}
258	sync-fields	2	2021-12-24 18:46:00.162277+00	2021-12-24 18:46:00.349802+00	187	{"total-fields":95,"updated-fields":0}
259	sync-fks	2	2021-12-24 18:46:00.349837+00	2021-12-24 18:46:00.426445+00	76	{"total-fks":28,"updated-fks":0,"total-failed":0}
260	sync-metabase-metadata	2	2021-12-24 18:46:00.426487+00	2021-12-24 18:46:00.435497+00	9	\N
261	analyze	2	2021-12-24 18:46:00.557573+00	2021-12-24 18:46:00.595039+00	37	\N
262	fingerprint-fields	2	2021-12-24 18:46:00.557586+00	2021-12-24 18:46:00.580159+00	22	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
263	classify-fields	2	2021-12-24 18:46:00.580198+00	2021-12-24 18:46:00.587884+00	7	{"fields-classified":0,"fields-failed":0}
264	classify-tables	2	2021-12-24 18:46:00.58792+00	2021-12-24 18:46:00.595014+00	7	{"total-tables":20,"tables-classified":0}
265	send-pulses	\N	2021-12-24 19:00:00.045+00	2021-12-24 19:00:00.082+00	37	\N
266	task-history-cleanup	\N	2021-12-24 19:00:00.111+00	2021-12-24 19:00:00.113+00	2	\N
267	sync	2	2021-12-24 19:46:00.107227+00	2021-12-24 19:46:00.412362+00	305	\N
268	sync-timezone	2	2021-12-24 19:46:00.107778+00	2021-12-24 19:46:00.125671+00	17	{"timezone-id":"UTC"}
269	sync-tables	2	2021-12-24 19:46:00.125903+00	2021-12-24 19:46:00.159712+00	33	{"updated-tables":0,"total-tables":34}
270	sync-fields	2	2021-12-24 19:46:00.159739+00	2021-12-24 19:46:00.292443+00	132	{"total-fields":95,"updated-fields":0}
271	sync-fks	2	2021-12-24 19:46:00.292481+00	2021-12-24 19:46:00.391332+00	98	{"total-fks":28,"updated-fks":0,"total-failed":0}
272	sync-metabase-metadata	2	2021-12-24 19:46:00.391357+00	2021-12-24 19:46:00.412346+00	20	\N
273	analyze	2	2021-12-24 19:46:00.540631+00	2021-12-24 19:46:00.592775+00	52	\N
274	fingerprint-fields	2	2021-12-24 19:46:00.540651+00	2021-12-24 19:46:00.573364+00	32	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
275	classify-fields	2	2021-12-24 19:46:00.573395+00	2021-12-24 19:46:00.579918+00	6	{"fields-classified":0,"fields-failed":0}
276	classify-tables	2	2021-12-24 19:46:00.579959+00	2021-12-24 19:46:00.592757+00	12	{"total-tables":20,"tables-classified":0}
277	sync	2	2021-12-24 20:49:19.803166+00	2021-12-24 20:49:20.157505+00	354	\N
278	sync-timezone	2	2021-12-24 20:49:19.80328+00	2021-12-24 20:49:19.817113+00	13	{"timezone-id":"UTC"}
279	sync-tables	2	2021-12-24 20:49:19.817276+00	2021-12-24 20:49:19.841101+00	23	{"updated-tables":0,"total-tables":34}
280	sync-fields	2	2021-12-24 20:49:19.841138+00	2021-12-24 20:49:20.021643+00	180	{"total-fields":95,"updated-fields":0}
281	sync-fks	2	2021-12-24 20:49:20.021703+00	2021-12-24 20:49:20.147199+00	125	{"total-fks":28,"updated-fks":0,"total-failed":0}
282	sync-metabase-metadata	2	2021-12-24 20:49:20.147226+00	2021-12-24 20:49:20.15749+00	10	\N
287	send-pulses	\N	2021-12-24 21:01:46.968+00	2021-12-24 21:01:46.997+00	29	\N
283	analyze	2	2021-12-24 20:49:20.334848+00	2021-12-24 20:49:20.396665+00	61	\N
284	fingerprint-fields	2	2021-12-24 20:49:20.334865+00	2021-12-24 20:49:20.377862+00	42	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
285	classify-fields	2	2021-12-24 20:49:20.377918+00	2021-12-24 20:49:20.383476+00	5	{"fields-classified":0,"fields-failed":0}
286	classify-tables	2	2021-12-24 20:49:20.383492+00	2021-12-24 20:49:20.396643+00	13	{"total-tables":20,"tables-classified":0}
288	task-history-cleanup	\N	2021-12-24 21:01:47.017+00	2021-12-24 21:01:47.019+00	2	\N
289	sync	2	2021-12-24 21:46:00.102499+00	2021-12-24 21:46:00.523328+00	420	\N
290	sync-timezone	2	2021-12-24 21:46:00.102656+00	2021-12-24 21:46:00.130454+00	27	{"timezone-id":"UTC"}
291	sync-tables	2	2021-12-24 21:46:00.130637+00	2021-12-24 21:46:00.168475+00	37	{"updated-tables":0,"total-tables":34}
292	sync-fields	2	2021-12-24 21:46:00.168509+00	2021-12-24 21:46:00.413487+00	244	{"total-fields":95,"updated-fields":0}
293	sync-fks	2	2021-12-24 21:46:00.413515+00	2021-12-24 21:46:00.50661+00	93	{"total-fks":28,"updated-fks":0,"total-failed":0}
294	sync-metabase-metadata	2	2021-12-24 21:46:00.506636+00	2021-12-24 21:46:00.523307+00	16	\N
295	analyze	2	2021-12-24 21:46:00.637324+00	2021-12-24 21:46:00.694197+00	56	\N
296	fingerprint-fields	2	2021-12-24 21:46:00.637341+00	2021-12-24 21:46:00.670762+00	33	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
297	classify-fields	2	2021-12-24 21:46:00.67079+00	2021-12-24 21:46:00.682013+00	11	{"fields-classified":0,"fields-failed":0}
298	classify-tables	2	2021-12-24 21:46:00.682056+00	2021-12-24 21:46:00.694156+00	12	{"total-tables":20,"tables-classified":0}
299	send-pulses	\N	2021-12-24 22:43:44.814+00	2021-12-24 22:43:44.858+00	44	\N
300	task-history-cleanup	\N	2021-12-24 22:43:44.872+00	2021-12-24 22:43:44.874+00	2	\N
301	sync	2	2021-12-24 22:46:00.099259+00	2021-12-24 22:46:00.446636+00	347	\N
302	sync-timezone	2	2021-12-24 22:46:00.099412+00	2021-12-24 22:46:00.112637+00	13	{"timezone-id":"UTC"}
303	sync-tables	2	2021-12-24 22:46:00.11286+00	2021-12-24 22:46:00.141945+00	29	{"updated-tables":0,"total-tables":34}
304	sync-fields	2	2021-12-24 22:46:00.141977+00	2021-12-24 22:46:00.320446+00	178	{"total-fields":95,"updated-fields":0}
305	sync-fks	2	2021-12-24 22:46:00.320484+00	2021-12-24 22:46:00.428283+00	107	{"total-fks":28,"updated-fks":0,"total-failed":0}
306	sync-metabase-metadata	2	2021-12-24 22:46:00.428316+00	2021-12-24 22:46:00.446612+00	18	\N
307	analyze	2	2021-12-24 22:46:00.540078+00	2021-12-24 22:46:00.597567+00	57	\N
308	fingerprint-fields	2	2021-12-24 22:46:00.540089+00	2021-12-24 22:46:00.569003+00	28	{"no-data-fingerprints":0,"failed-fingerprints":0,"updated-fingerprints":0,"fingerprints-attempted":0}
309	classify-fields	2	2021-12-24 22:46:00.569038+00	2021-12-24 22:46:00.586347+00	17	{"fields-classified":0,"fields-failed":0}
310	classify-tables	2	2021-12-24 22:46:00.58639+00	2021-12-24 22:46:00.59754+00	11	{"total-tables":20,"tables-classified":0}
\.


--
-- Data for Name: view_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.view_log (id, user_id, model, model_id, "timestamp", metadata) FROM stdin;
1	1	card	1	2021-12-23 10:51:20.410992+00	{"cached":null,"ignore_cache":null}
2	1	card	1	2021-12-23 10:51:32.607721+00	{"cached":null,"ignore_cache":true}
3	1	card	1	2021-12-23 10:54:36.256391+00	{"cached":null,"ignore_cache":true}
4	1	card	1	2021-12-23 10:54:43.176738+00	{"cached":null,"ignore_cache":null}
5	1	card	1	2021-12-23 10:54:43.640346+00	{"cached":null,"ignore_cache":false}
6	1	dashboard	1	2021-12-23 10:56:01.284503+00	{"cached":null,"ignore_cache":null}
7	1	card	1	2021-12-23 10:56:08.824952+00	{"cached":null,"ignore_cache":null}
8	1	card	1	2021-12-23 10:56:09.181388+00	{"cached":null,"ignore_cache":false}
9	1	dashboard	1	2021-12-23 10:57:08.836073+00	{"cached":null,"ignore_cache":null}
10	1	card	1	2021-12-23 10:57:10.850541+00	{"cached":null,"ignore_cache":null}
11	1	card	1	2021-12-23 10:57:11.358497+00	{"cached":null,"ignore_cache":false}
12	1	table	38	2021-12-23 11:02:04.198096+00	{"cached":null,"ignore_cache":null}
13	1	table	33	2021-12-23 11:02:45.409052+00	{"cached":null,"ignore_cache":null}
14	1	table	38	2021-12-23 11:02:49.673541+00	{"cached":null,"ignore_cache":null}
15	1	table	38	2021-12-23 11:04:36.395086+00	{"cached":null,"ignore_cache":null}
16	1	card	1	2021-12-23 11:06:14.156944+00	{"cached":null,"ignore_cache":null}
17	1	card	1	2021-12-23 11:06:14.528637+00	{"cached":null,"ignore_cache":false}
18	1	dashboard	1	2021-12-23 11:08:06.018335+00	{"cached":null,"ignore_cache":null}
19	1	card	1	2021-12-23 11:08:06.30811+00	{"cached":null,"ignore_cache":false}
20	1	dashboard	1	2021-12-23 11:16:05.481791+00	{"cached":null,"ignore_cache":null}
21	1	card	1	2021-12-23 11:16:16.563245+00	{"cached":null,"ignore_cache":false}
22	1	dashboard	1	2021-12-23 11:18:06.685796+00	{"cached":null,"ignore_cache":null}
23	1	card	1	2021-12-23 11:18:07.102916+00	{"cached":null,"ignore_cache":false}
24	1	card	1	2021-12-23 11:18:08.905312+00	{"cached":null,"ignore_cache":null}
25	1	card	1	2021-12-23 11:18:09.484535+00	{"cached":null,"ignore_cache":false}
26	1	table	5	2021-12-23 11:28:37.61368+00	{"cached":null,"ignore_cache":null}
27	1	table	5	2021-12-23 11:29:06.155217+00	{"cached":null,"ignore_cache":null}
28	1	table	5	2021-12-23 11:30:49.976012+00	{"cached":null,"ignore_cache":null}
29	1	table	5	2021-12-23 11:31:27.474681+00	{"cached":null,"ignore_cache":null}
30	1	table	5	2021-12-23 11:32:44.079087+00	{"cached":null,"ignore_cache":null}
31	1	table	5	2021-12-23 11:33:12.244637+00	{"cached":null,"ignore_cache":null}
32	1	table	5	2021-12-23 11:33:45.403239+00	{"cached":null,"ignore_cache":null}
33	1	table	21	2021-12-23 11:33:45.657941+00	{"cached":null,"ignore_cache":null}
34	1	table	21	2021-12-23 11:33:45.769123+00	{"cached":null,"ignore_cache":null}
35	1	table	12	2021-12-23 11:33:45.791285+00	{"cached":null,"ignore_cache":null}
36	1	table	9	2021-12-23 11:33:45.82043+00	{"cached":null,"ignore_cache":null}
37	1	table	8	2021-12-23 11:33:45.858614+00	{"cached":null,"ignore_cache":null}
38	1	table	5	2021-12-23 11:34:01.047495+00	{"cached":null,"ignore_cache":null}
39	1	dashboard	1	2021-12-23 11:37:22.943556+00	{"cached":null,"ignore_cache":null}
40	1	card	1	2021-12-23 11:37:23.283666+00	{"cached":null,"ignore_cache":false}
41	1	dashboard	1	2021-12-23 11:37:58.327779+00	{"cached":null,"ignore_cache":null}
42	1	card	1	2021-12-23 11:38:18.725876+00	{"cached":null,"ignore_cache":false}
43	1	dashboard	1	2021-12-23 11:40:02.582047+00	{"cached":null,"ignore_cache":null}
44	1	card	1	2021-12-23 11:40:06.006632+00	{"cached":null,"ignore_cache":null}
45	1	card	2	2021-12-23 11:49:21.532888+00	{"cached":null,"ignore_cache":null}
46	1	dashboard	1	2021-12-23 11:49:29.171264+00	{"cached":null,"ignore_cache":null}
47	1	card	2	2021-12-23 11:49:29.327602+00	{"cached":null,"ignore_cache":null}
48	1	card	1	2021-12-23 11:49:29.717425+00	{"cached":null,"ignore_cache":false}
49	1	card	2	2021-12-23 11:49:29.946072+00	{"cached":null,"ignore_cache":false}
50	1	dashboard	1	2021-12-23 11:51:00.570501+00	{"cached":null,"ignore_cache":null}
51	1	card	1	2021-12-23 11:51:15.228802+00	{"cached":null,"ignore_cache":false}
52	1	card	2	2021-12-23 11:51:15.486088+00	{"cached":null,"ignore_cache":false}
53	1	dashboard	1	2021-12-23 11:52:07.896334+00	{"cached":null,"ignore_cache":null}
54	1	card	2	2021-12-23 11:52:08.357544+00	{"cached":null,"ignore_cache":false}
55	1	card	1	2021-12-23 11:52:08.450115+00	{"cached":null,"ignore_cache":false}
56	1	card	1	2021-12-23 11:52:19.752403+00	{"cached":null,"ignore_cache":false}
57	1	card	2	2021-12-23 11:52:19.795913+00	{"cached":null,"ignore_cache":false}
58	1	dashboard	1	2021-12-23 11:52:45.714606+00	{"cached":null,"ignore_cache":null}
59	1	card	1	2021-12-23 11:52:46.2244+00	{"cached":null,"ignore_cache":false}
60	1	card	2	2021-12-23 11:52:46.271601+00	{"cached":null,"ignore_cache":false}
61	1	card	1	2021-12-23 11:53:10.764708+00	{"cached":null,"ignore_cache":false}
62	1	card	2	2021-12-23 11:53:10.800769+00	{"cached":null,"ignore_cache":false}
63	1	card	2	2021-12-23 11:56:03.4831+00	{"cached":null,"ignore_cache":false}
64	1	card	1	2021-12-23 11:56:03.522163+00	{"cached":null,"ignore_cache":false}
65	1	card	2	2021-12-23 11:57:47.046234+00	{"cached":null,"ignore_cache":null}
66	1	card	2	2021-12-23 11:57:47.201271+00	{"cached":null,"ignore_cache":false}
67	1	card	2	2021-12-23 11:57:53.517631+00	{"cached":null,"ignore_cache":true}
68	1	dashboard	1	2021-12-23 12:26:55.014608+00	{"cached":null,"ignore_cache":null}
69	1	card	2	2021-12-23 12:26:55.172184+00	{"cached":null,"ignore_cache":false}
70	1	card	1	2021-12-23 12:26:55.233504+00	{"cached":null,"ignore_cache":false}
71	1	card	1	2021-12-23 12:28:32.831206+00	{"cached":null,"ignore_cache":false}
72	1	card	2	2021-12-23 12:28:32.853818+00	{"cached":null,"ignore_cache":false}
73	1	dashboard	2	2021-12-23 12:31:42.66345+00	{"cached":null,"ignore_cache":null}
74	1	table	7	2021-12-23 12:31:58.907709+00	{"cached":null,"ignore_cache":null}
75	1	table	7	2021-12-23 12:32:36.225733+00	{"cached":null,"ignore_cache":null}
76	1	table	7	2021-12-23 12:33:42.365103+00	{"cached":null,"ignore_cache":null}
77	1	table	7	2021-12-23 12:34:33.619978+00	{"cached":null,"ignore_cache":null}
78	1	table	7	2021-12-23 12:38:28.119226+00	{"cached":null,"ignore_cache":null}
79	1	table	7	2021-12-23 12:38:35.291039+00	{"cached":null,"ignore_cache":null}
80	1	table	37	2021-12-23 12:38:35.448496+00	{"cached":null,"ignore_cache":null}
81	1	table	37	2021-12-23 12:38:35.485006+00	{"cached":null,"ignore_cache":null}
82	1	table	28	2021-12-23 12:38:35.520324+00	{"cached":null,"ignore_cache":null}
83	1	table	9	2021-12-23 12:38:35.553449+00	{"cached":null,"ignore_cache":null}
84	1	table	11	2021-12-23 12:38:35.590442+00	{"cached":null,"ignore_cache":null}
85	1	table	8	2021-12-23 12:38:35.610788+00	{"cached":null,"ignore_cache":null}
86	1	table	18	2021-12-23 12:38:35.656341+00	{"cached":null,"ignore_cache":null}
87	1	table	19	2021-12-23 12:38:35.68544+00	{"cached":null,"ignore_cache":null}
89	1	table	7	2021-12-23 12:39:07.532996+00	{"cached":null,"ignore_cache":null}
90	1	table	37	2021-12-23 12:39:07.647786+00	{"cached":null,"ignore_cache":null}
102	1	table	28	2021-12-23 12:39:35.97297+00	{"cached":null,"ignore_cache":null}
105	1	table	8	2021-12-23 12:39:36.127098+00	{"cached":null,"ignore_cache":null}
113	1	table	9	2021-12-23 12:39:46.915018+00	{"cached":null,"ignore_cache":null}
114	1	table	11	2021-12-23 12:39:46.953059+00	{"cached":null,"ignore_cache":null}
88	1	table	19	2021-12-23 12:39:01.718048+00	{"cached":null,"ignore_cache":null}
91	1	table	37	2021-12-23 12:39:07.71496+00	{"cached":null,"ignore_cache":null}
92	1	table	28	2021-12-23 12:39:07.75401+00	{"cached":null,"ignore_cache":null}
93	1	table	9	2021-12-23 12:39:07.798369+00	{"cached":null,"ignore_cache":null}
94	1	table	11	2021-12-23 12:39:07.835914+00	{"cached":null,"ignore_cache":null}
95	1	table	8	2021-12-23 12:39:07.874748+00	{"cached":null,"ignore_cache":null}
96	1	table	18	2021-12-23 12:39:07.901205+00	{"cached":null,"ignore_cache":null}
97	1	table	19	2021-12-23 12:39:07.938796+00	{"cached":null,"ignore_cache":null}
98	1	table	28	2021-12-23 12:39:34.036671+00	{"cached":null,"ignore_cache":null}
99	1	table	7	2021-12-23 12:39:35.86007+00	{"cached":null,"ignore_cache":null}
100	1	table	37	2021-12-23 12:39:35.911672+00	{"cached":null,"ignore_cache":null}
101	1	table	37	2021-12-23 12:39:35.946415+00	{"cached":null,"ignore_cache":null}
103	1	table	9	2021-12-23 12:39:36.013601+00	{"cached":null,"ignore_cache":null}
104	1	table	11	2021-12-23 12:39:36.055021+00	{"cached":null,"ignore_cache":null}
115	1	table	8	2021-12-23 12:39:46.991435+00	{"cached":null,"ignore_cache":null}
116	1	table	18	2021-12-23 12:39:47.035042+00	{"cached":null,"ignore_cache":null}
117	1	table	19	2021-12-23 12:39:47.066431+00	{"cached":null,"ignore_cache":null}
106	1	table	18	2021-12-23 12:39:36.164148+00	{"cached":null,"ignore_cache":null}
107	1	table	19	2021-12-23 12:39:36.186123+00	{"cached":null,"ignore_cache":null}
108	1	table	28	2021-12-23 12:39:39.359913+00	{"cached":null,"ignore_cache":null}
109	1	table	7	2021-12-23 12:39:46.730809+00	{"cached":null,"ignore_cache":null}
110	1	table	37	2021-12-23 12:39:46.800515+00	{"cached":null,"ignore_cache":null}
111	1	table	37	2021-12-23 12:39:46.840531+00	{"cached":null,"ignore_cache":null}
112	1	table	28	2021-12-23 12:39:46.876686+00	{"cached":null,"ignore_cache":null}
118	1	table	7	2021-12-23 12:40:17.271849+00	{"cached":null,"ignore_cache":null}
119	1	card	3	2021-12-23 12:40:42.501345+00	{"cached":null,"ignore_cache":null}
120	\N	card	3	2021-12-23 12:40:58.662211+00	{"cached":null,"ignore_cache":null}
121	1	card	3	2021-12-23 12:43:55.588731+00	{"cached":null,"ignore_cache":false}
122	\N	card	3	2021-12-23 12:49:22.425565+00	{"cached":null,"ignore_cache":null}
123	\N	card	3	2021-12-23 12:49:29.342276+00	{"cached":null,"ignore_cache":null}
124	\N	card	3	2021-12-23 12:49:35.923401+00	{"cached":null,"ignore_cache":null}
125	\N	card	3	2021-12-23 12:49:59.083071+00	{"cached":null,"ignore_cache":null}
126	1	dashboard	2	2021-12-23 12:51:51.656044+00	{"cached":null,"ignore_cache":null}
127	1	table	7	2021-12-23 12:52:42.330615+00	{"cached":null,"ignore_cache":null}
128	1	table	7	2021-12-23 12:54:32.840254+00	{"cached":null,"ignore_cache":null}
129	1	table	7	2021-12-23 12:55:01.299249+00	{"cached":null,"ignore_cache":null}
130	1	table	7	2021-12-23 12:55:20.797744+00	{"cached":null,"ignore_cache":null}
131	1	table	7	2021-12-23 12:55:52.253753+00	{"cached":null,"ignore_cache":null}
132	1	card	4	2021-12-23 12:56:06.484457+00	{"cached":null,"ignore_cache":null}
133	1	table	7	2021-12-23 12:56:29.181722+00	{"cached":null,"ignore_cache":null}
134	1	table	7	2021-12-23 12:56:29.197783+00	{"cached":null,"ignore_cache":null}
135	1	table	7	2021-12-23 12:59:36.986651+00	{"cached":null,"ignore_cache":null}
136	1	table	7	2021-12-23 13:00:22.650222+00	{"cached":null,"ignore_cache":null}
137	1	table	7	2021-12-23 13:02:33.668861+00	{"cached":null,"ignore_cache":null}
138	\N	card	3	2021-12-23 14:34:44.424976+00	{"cached":null,"ignore_cache":null}
139	\N	card	3	2021-12-23 14:34:51.782395+00	{"cached":null,"ignore_cache":null}
140	\N	card	3	2021-12-23 14:35:00.396971+00	{"cached":null,"ignore_cache":null}
141	\N	card	3	2021-12-23 14:35:04.752368+00	{"cached":null,"ignore_cache":null}
142	\N	card	3	2021-12-23 14:35:18.724252+00	{"cached":null,"ignore_cache":null}
143	1	dashboard	1	2021-12-24 00:00:26.7758+00	{"cached":null,"ignore_cache":null}
144	1	card	2	2021-12-24 00:00:27.915248+00	{"cached":null,"ignore_cache":false}
145	1	card	1	2021-12-24 00:00:27.968571+00	{"cached":null,"ignore_cache":false}
146	1	dashboard	1	2021-12-24 00:04:06.979783+00	{"cached":null,"ignore_cache":null}
147	1	card	1	2021-12-24 00:04:18.749395+00	{"cached":null,"ignore_cache":false}
148	1	card	2	2021-12-24 00:04:18.799143+00	{"cached":null,"ignore_cache":false}
149	1	dashboard	1	2021-12-24 00:04:35.45325+00	{"cached":null,"ignore_cache":null}
150	1	card	1	2021-12-24 00:04:45.499313+00	{"cached":null,"ignore_cache":false}
151	1	card	2	2021-12-24 00:04:45.580476+00	{"cached":null,"ignore_cache":false}
152	1	card	2	2021-12-24 00:05:59.777319+00	{"cached":null,"ignore_cache":false}
153	1	card	1	2021-12-24 00:05:59.808131+00	{"cached":null,"ignore_cache":false}
154	1	card	1	2021-12-24 00:06:18.105127+00	{"cached":null,"ignore_cache":false}
155	1	card	2	2021-12-24 00:06:18.141966+00	{"cached":null,"ignore_cache":false}
156	1	dashboard	1	2021-12-24 00:06:57.726022+00	{"cached":null,"ignore_cache":null}
157	1	card	2	2021-12-24 00:06:59.439579+00	{"cached":null,"ignore_cache":null}
158	1	card	2	2021-12-24 00:06:59.666472+00	{"cached":null,"ignore_cache":false}
159	1	dashboard	1	2021-12-24 00:07:36.715707+00	{"cached":null,"ignore_cache":null}
160	1	card	1	2021-12-24 00:07:36.916297+00	{"cached":null,"ignore_cache":false}
161	1	card	2	2021-12-24 00:07:36.958362+00	{"cached":null,"ignore_cache":false}
162	1	dashboard	1	2021-12-24 00:07:40.583599+00	{"cached":null,"ignore_cache":null}
163	1	card	2	2021-12-24 00:07:40.745254+00	{"cached":null,"ignore_cache":false}
164	1	card	1	2021-12-24 00:07:40.910319+00	{"cached":null,"ignore_cache":false}
165	1	card	1	2021-12-24 00:08:58.447389+00	{"cached":null,"ignore_cache":false}
166	1	card	2	2021-12-24 00:08:58.506084+00	{"cached":null,"ignore_cache":false}
167	1	dashboard	1	2021-12-24 00:10:36.438255+00	{"cached":null,"ignore_cache":null}
168	1	card	1	2021-12-24 00:10:36.632294+00	{"cached":null,"ignore_cache":false}
169	1	card	2	2021-12-24 00:10:36.660483+00	{"cached":null,"ignore_cache":false}
170	1	card	1	2021-12-24 00:13:07.044001+00	{"cached":null,"ignore_cache":null}
171	1	card	2	2021-12-24 00:13:07.128159+00	{"cached":null,"ignore_cache":null}
172	3	dashboard	1	2021-12-24 00:21:29.450603+00	{"cached":null,"ignore_cache":null}
173	3	card	2	2021-12-24 00:21:30.016957+00	{"cached":null,"ignore_cache":false}
174	3	card	1	2021-12-24 00:21:30.06479+00	{"cached":null,"ignore_cache":false}
175	3	dashboard	1	2021-12-24 00:23:44.206942+00	{"cached":null,"ignore_cache":null}
176	1	card	2	2021-12-24 00:24:45.221836+00	{"cached":null,"ignore_cache":null}
177	1	card	1	2021-12-24 00:24:45.287391+00	{"cached":null,"ignore_cache":null}
178	3	dashboard	1	2021-12-24 00:25:23.633509+00	{"cached":null,"ignore_cache":null}
179	1	card	1	2021-12-24 00:25:48.370248+00	{"cached":null,"ignore_cache":null}
180	1	card	2	2021-12-24 00:25:48.499178+00	{"cached":null,"ignore_cache":null}
181	1	dashboard	1	2021-12-24 00:27:39.821509+00	{"cached":null,"ignore_cache":null}
182	1	card	2	2021-12-24 00:27:40.229425+00	{"cached":null,"ignore_cache":false}
183	1	card	1	2021-12-24 00:27:40.327097+00	{"cached":null,"ignore_cache":false}
184	1	dashboard	1	2021-12-24 00:28:20.425301+00	{"cached":null,"ignore_cache":null}
185	1	card	1	2021-12-24 00:28:28.549967+00	{"cached":null,"ignore_cache":false}
186	1	card	2	2021-12-24 00:28:28.585317+00	{"cached":null,"ignore_cache":false}
187	1	card	1	2021-12-24 00:28:33.658436+00	{"cached":null,"ignore_cache":null}
188	1	card	2	2021-12-24 00:28:33.696707+00	{"cached":null,"ignore_cache":null}
189	1	card	2	2021-12-24 00:29:01.575399+00	{"cached":null,"ignore_cache":null}
190	1	card	1	2021-12-24 00:29:01.713302+00	{"cached":null,"ignore_cache":null}
191	1	card	1	2021-12-24 00:30:43.244163+00	{"cached":null,"ignore_cache":null}
192	1	card	2	2021-12-24 00:30:43.289822+00	{"cached":null,"ignore_cache":null}
193	1	dashboard	1	2021-12-24 00:32:53.224148+00	{"cached":null,"ignore_cache":null}
194	1	card	2	2021-12-24 00:32:53.658636+00	{"cached":null,"ignore_cache":false}
195	1	card	1	2021-12-24 00:32:53.739534+00	{"cached":null,"ignore_cache":false}
197	1	card	1	2021-12-24 00:33:01.817631+00	{"cached":null,"ignore_cache":null}
199	1	card	1	2021-12-24 00:33:12.01819+00	{"cached":null,"ignore_cache":null}
200	1	card	2	2021-12-24 00:33:22.767557+00	{"cached":null,"ignore_cache":null}
201	1	card	1	2021-12-24 00:33:22.924149+00	{"cached":null,"ignore_cache":null}
207	1	card	1	2021-12-24 00:33:39.762436+00	{"cached":null,"ignore_cache":null}
214	1	card	2	2021-12-24 00:34:49.532875+00	{"cached":null,"ignore_cache":null}
216	1	card	2	2021-12-24 00:34:53.588212+00	{"cached":null,"ignore_cache":null}
217	1	card	1	2021-12-24 00:34:53.647855+00	{"cached":null,"ignore_cache":null}
218	1	card	1	2021-12-24 00:48:19.947748+00	{"cached":null,"ignore_cache":null}
196	1	card	2	2021-12-24 00:33:01.682846+00	{"cached":null,"ignore_cache":null}
198	1	card	2	2021-12-24 00:33:11.843113+00	{"cached":null,"ignore_cache":null}
211	1	card	2	2021-12-24 00:34:16.359558+00	{"cached":null,"ignore_cache":null}
212	1	card	2	2021-12-24 00:34:30.985241+00	{"cached":null,"ignore_cache":null}
202	1	card	2	2021-12-24 00:33:28.015198+00	{"cached":null,"ignore_cache":null}
206	1	card	2	2021-12-24 00:33:39.659871+00	{"cached":null,"ignore_cache":null}
209	1	card	1	2021-12-24 00:33:54.48055+00	{"cached":null,"ignore_cache":null}
219	1	card	2	2021-12-24 00:48:20.019651+00	{"cached":null,"ignore_cache":null}
203	1	card	1	2021-12-24 00:33:28.086259+00	{"cached":null,"ignore_cache":null}
204	1	card	2	2021-12-24 00:33:30.172059+00	{"cached":null,"ignore_cache":null}
205	1	card	1	2021-12-24 00:33:30.285514+00	{"cached":null,"ignore_cache":null}
208	1	card	2	2021-12-24 00:33:54.36063+00	{"cached":null,"ignore_cache":null}
210	1	card	1	2021-12-24 00:34:16.325949+00	{"cached":null,"ignore_cache":null}
213	1	card	1	2021-12-24 00:34:31.033493+00	{"cached":null,"ignore_cache":null}
215	1	card	1	2021-12-24 00:34:49.632665+00	{"cached":null,"ignore_cache":null}
220	1	card	1	2021-12-24 00:49:39.967032+00	{"cached":null,"ignore_cache":null}
221	1	card	2	2021-12-24 00:49:40.291263+00	{"cached":null,"ignore_cache":null}
222	1	card	1	2021-12-24 00:58:01.461598+00	{"cached":null,"ignore_cache":null}
223	1	card	2	2021-12-24 00:58:01.546433+00	{"cached":null,"ignore_cache":null}
224	1	card	1	2021-12-24 00:58:09.973618+00	{"cached":null,"ignore_cache":null}
225	1	card	2	2021-12-24 00:58:10.014821+00	{"cached":null,"ignore_cache":null}
226	1	card	2	2021-12-24 00:59:15.315252+00	{"cached":null,"ignore_cache":null}
227	1	card	1	2021-12-24 00:59:15.372794+00	{"cached":null,"ignore_cache":null}
228	1	card	1	2021-12-24 01:00:28.617527+00	{"cached":null,"ignore_cache":null}
229	1	card	2	2021-12-24 01:00:28.684515+00	{"cached":null,"ignore_cache":null}
230	1	card	2	2021-12-24 01:21:23.356824+00	{"cached":null,"ignore_cache":null}
231	1	card	1	2021-12-24 01:21:23.543458+00	{"cached":null,"ignore_cache":null}
232	1	dashboard	1	2021-12-24 02:21:18.450563+00	{"cached":null,"ignore_cache":null}
233	1	card	2	2021-12-24 02:21:24.6524+00	{"cached":null,"ignore_cache":false}
234	1	card	1	2021-12-24 02:21:24.725713+00	{"cached":null,"ignore_cache":false}
235	1	card	1	2021-12-24 02:21:28.26379+00	{"cached":null,"ignore_cache":null}
236	1	card	2	2021-12-24 02:21:28.301919+00	{"cached":null,"ignore_cache":null}
237	1	card	2	2021-12-24 02:22:17.476707+00	{"cached":null,"ignore_cache":null}
238	1	card	1	2021-12-24 02:22:17.587264+00	{"cached":null,"ignore_cache":null}
239	1	dashboard	1	2021-12-24 02:22:24.161075+00	{"cached":null,"ignore_cache":null}
240	1	card	2	2021-12-24 02:22:24.576631+00	{"cached":null,"ignore_cache":false}
241	1	card	1	2021-12-24 02:22:24.649401+00	{"cached":null,"ignore_cache":false}
242	1	card	2	2021-12-24 02:22:30.806218+00	{"cached":null,"ignore_cache":false}
243	1	card	1	2021-12-24 02:22:30.87547+00	{"cached":null,"ignore_cache":false}
244	1	card	1	2021-12-24 02:22:43.70916+00	{"cached":null,"ignore_cache":null}
245	1	card	1	2021-12-24 02:22:44.144747+00	{"cached":null,"ignore_cache":false}
246	1	dashboard	1	2021-12-24 02:23:05.239966+00	{"cached":null,"ignore_cache":null}
247	1	card	2	2021-12-24 02:23:05.6086+00	{"cached":null,"ignore_cache":false}
248	1	card	1	2021-12-24 02:23:05.717968+00	{"cached":null,"ignore_cache":false}
249	1	dashboard	1	2021-12-24 02:23:08.839605+00	{"cached":null,"ignore_cache":null}
250	1	card	1	2021-12-24 02:23:09.292678+00	{"cached":null,"ignore_cache":false}
251	1	card	2	2021-12-24 02:23:09.353648+00	{"cached":null,"ignore_cache":false}
252	1	dashboard	1	2021-12-24 02:23:44.859442+00	{"cached":null,"ignore_cache":null}
253	1	card	2	2021-12-24 02:23:53.2482+00	{"cached":null,"ignore_cache":null}
254	1	card	1	2021-12-24 02:23:53.28899+00	{"cached":null,"ignore_cache":null}
255	1	card	2	2021-12-24 02:24:59.675909+00	{"cached":null,"ignore_cache":null}
256	1	card	1	2021-12-24 02:24:59.747115+00	{"cached":null,"ignore_cache":null}
257	1	card	2	2021-12-24 02:33:16.677187+00	{"cached":null,"ignore_cache":null}
258	1	card	1	2021-12-24 02:33:16.793117+00	{"cached":null,"ignore_cache":null}
259	1	card	2	2021-12-24 02:33:32.137274+00	{"cached":null,"ignore_cache":null}
260	1	card	1	2021-12-24 02:33:32.396836+00	{"cached":null,"ignore_cache":null}
261	1	dashboard	1	2021-12-24 02:33:54.234914+00	{"cached":null,"ignore_cache":null}
262	1	card	2	2021-12-24 02:34:11.036927+00	{"cached":null,"ignore_cache":false}
263	1	card	1	2021-12-24 02:34:11.126376+00	{"cached":null,"ignore_cache":false}
264	1	card	2	2021-12-24 02:38:31.999812+00	{"cached":null,"ignore_cache":null}
265	1	card	1	2021-12-24 02:38:32.114269+00	{"cached":null,"ignore_cache":null}
266	1	card	1	2021-12-24 02:38:51.796295+00	{"cached":null,"ignore_cache":null}
267	1	card	2	2021-12-24 02:38:51.880831+00	{"cached":null,"ignore_cache":null}
268	1	dashboard	1	2021-12-24 02:41:23.1256+00	{"cached":null,"ignore_cache":null}
269	1	card	2	2021-12-24 02:41:23.886759+00	{"cached":null,"ignore_cache":false}
270	1	card	1	2021-12-24 02:41:23.960127+00	{"cached":null,"ignore_cache":false}
271	1	dashboard	1	2021-12-24 02:41:53.301875+00	{"cached":null,"ignore_cache":null}
272	1	card	2	2021-12-24 02:41:54.215455+00	{"cached":null,"ignore_cache":false}
273	1	card	1	2021-12-24 02:41:54.371586+00	{"cached":null,"ignore_cache":false}
274	1	card	2	2021-12-24 02:42:34.122429+00	{"cached":null,"ignore_cache":false}
275	1	card	1	2021-12-24 02:42:34.422417+00	{"cached":null,"ignore_cache":false}
276	1	card	2	2021-12-24 02:42:38.501071+00	{"cached":null,"ignore_cache":null}
277	1	card	1	2021-12-24 02:42:38.563823+00	{"cached":null,"ignore_cache":null}
278	1	dashboard	1	2021-12-24 02:44:04.432566+00	{"cached":null,"ignore_cache":null}
279	1	card	1	2021-12-24 02:44:13.520408+00	{"cached":null,"ignore_cache":null}
280	1	card	2	2021-12-24 02:44:13.558657+00	{"cached":null,"ignore_cache":null}
281	1	dashboard	1	2021-12-24 02:45:41.015356+00	{"cached":null,"ignore_cache":null}
282	1	card	2	2021-12-24 02:45:46.550607+00	{"cached":null,"ignore_cache":null}
283	1	card	1	2021-12-24 02:45:46.754752+00	{"cached":null,"ignore_cache":null}
284	1	card	2	2021-12-24 02:46:40.404305+00	{"cached":null,"ignore_cache":null}
285	1	card	1	2021-12-24 02:46:40.463543+00	{"cached":null,"ignore_cache":null}
286	1	card	1	2021-12-24 02:51:44.757071+00	{"cached":null,"ignore_cache":null}
287	1	card	2	2021-12-24 02:51:44.797547+00	{"cached":null,"ignore_cache":null}
288	1	card	2	2021-12-24 02:51:59.222998+00	{"cached":null,"ignore_cache":null}
289	1	card	1	2021-12-24 02:51:59.356986+00	{"cached":null,"ignore_cache":null}
290	1	card	2	2021-12-24 02:52:25.725439+00	{"cached":null,"ignore_cache":null}
291	1	card	1	2021-12-24 02:52:25.778347+00	{"cached":null,"ignore_cache":null}
292	1	card	2	2021-12-24 02:54:26.69288+00	{"cached":null,"ignore_cache":null}
293	1	card	1	2021-12-24 02:54:26.777601+00	{"cached":null,"ignore_cache":null}
294	1	card	2	2021-12-24 02:56:45.528645+00	{"cached":null,"ignore_cache":null}
304	1	dashboard	1	2021-12-24 03:11:13.000913+00	{"cached":null,"ignore_cache":null}
305	1	card	1	2021-12-24 03:11:13.83115+00	{"cached":null,"ignore_cache":false}
306	1	card	2	2021-12-24 03:11:13.876006+00	{"cached":null,"ignore_cache":false}
307	1	dashboard	1	2021-12-24 03:11:22.80069+00	{"cached":null,"ignore_cache":null}
309	1	card	1	2021-12-24 03:11:23.387131+00	{"cached":null,"ignore_cache":false}
313	1	card	1	2021-12-24 03:11:42.125608+00	{"cached":null,"ignore_cache":null}
314	1	card	2	2021-12-24 03:11:55.847155+00	{"cached":null,"ignore_cache":null}
315	1	card	1	2021-12-24 03:11:56.005171+00	{"cached":null,"ignore_cache":null}
322	1	card	2	2021-12-24 03:13:00.718245+00	{"cached":null,"ignore_cache":null}
295	1	card	1	2021-12-24 02:56:45.631362+00	{"cached":null,"ignore_cache":null}
296	1	card	2	2021-12-24 02:57:04.408349+00	{"cached":null,"ignore_cache":null}
297	1	card	1	2021-12-24 02:57:04.453619+00	{"cached":null,"ignore_cache":null}
298	1	card	2	2021-12-24 02:57:08.600848+00	{"cached":null,"ignore_cache":null}
300	1	card	1	2021-12-24 03:00:20.650846+00	{"cached":null,"ignore_cache":null}
301	1	card	2	2021-12-24 03:00:20.709317+00	{"cached":null,"ignore_cache":null}
320	1	card	2	2021-12-24 03:12:54.553165+00	{"cached":null,"ignore_cache":false}
321	1	card	1	2021-12-24 03:12:54.634689+00	{"cached":null,"ignore_cache":false}
299	1	card	1	2021-12-24 02:57:08.750194+00	{"cached":null,"ignore_cache":null}
302	1	card	2	2021-12-24 03:00:52.828511+00	{"cached":null,"ignore_cache":null}
311	1	card	1	2021-12-24 03:11:29.069232+00	{"cached":null,"ignore_cache":null}
312	1	card	2	2021-12-24 03:11:42.052418+00	{"cached":null,"ignore_cache":null}
319	1	dashboard	1	2021-12-24 03:12:44.466835+00	{"cached":null,"ignore_cache":null}
323	1	card	1	2021-12-24 03:13:00.845553+00	{"cached":null,"ignore_cache":null}
324	1	card	2	2021-12-24 03:13:15.114376+00	{"cached":null,"ignore_cache":null}
325	1	card	1	2021-12-24 03:13:15.374853+00	{"cached":null,"ignore_cache":null}
326	1	card	2	2021-12-24 03:14:05.616254+00	{"cached":null,"ignore_cache":null}
303	1	card	1	2021-12-24 03:00:53.043434+00	{"cached":null,"ignore_cache":null}
308	1	card	2	2021-12-24 03:11:23.338147+00	{"cached":null,"ignore_cache":false}
316	1	dashboard	1	2021-12-24 03:12:19.025276+00	{"cached":null,"ignore_cache":null}
317	1	card	2	2021-12-24 03:12:19.391096+00	{"cached":null,"ignore_cache":false}
318	1	card	1	2021-12-24 03:12:19.479824+00	{"cached":null,"ignore_cache":false}
327	1	card	1	2021-12-24 03:14:05.700156+00	{"cached":null,"ignore_cache":null}
310	1	card	2	2021-12-24 03:11:28.743202+00	{"cached":null,"ignore_cache":null}
328	1	card	1	2021-12-24 03:14:51.127207+00	{"cached":null,"ignore_cache":null}
329	1	card	2	2021-12-24 03:14:51.161709+00	{"cached":null,"ignore_cache":null}
330	1	card	2	2021-12-24 03:18:58.34382+00	{"cached":null,"ignore_cache":null}
331	1	card	1	2021-12-24 03:18:58.437321+00	{"cached":null,"ignore_cache":null}
332	1	dashboard	1	2021-12-24 03:20:55.698349+00	{"cached":null,"ignore_cache":null}
333	1	card	2	2021-12-24 03:20:55.965169+00	{"cached":null,"ignore_cache":false}
334	1	card	1	2021-12-24 03:20:56.083651+00	{"cached":null,"ignore_cache":false}
335	1	card	2	2021-12-24 03:21:02.912416+00	{"cached":null,"ignore_cache":null}
336	1	card	1	2021-12-24 03:21:03.009585+00	{"cached":null,"ignore_cache":null}
337	1	card	2	2021-12-24 03:21:13.399251+00	{"cached":null,"ignore_cache":null}
338	1	card	1	2021-12-24 03:21:13.481573+00	{"cached":null,"ignore_cache":null}
339	1	card	1	2021-12-24 03:28:53.019788+00	{"cached":null,"ignore_cache":null}
340	1	card	2	2021-12-24 03:28:53.085849+00	{"cached":null,"ignore_cache":null}
341	1	card	2	2021-12-24 03:30:02.334861+00	{"cached":null,"ignore_cache":null}
342	1	card	1	2021-12-24 03:30:02.415233+00	{"cached":null,"ignore_cache":null}
343	1	card	2	2021-12-24 03:30:30.641412+00	{"cached":null,"ignore_cache":null}
344	1	card	1	2021-12-24 03:30:30.808936+00	{"cached":null,"ignore_cache":null}
345	1	card	2	2021-12-24 03:30:33.870447+00	{"cached":null,"ignore_cache":null}
346	1	card	1	2021-12-24 03:30:33.914741+00	{"cached":null,"ignore_cache":null}
347	3	dashboard	1	2021-12-24 04:00:20.409334+00	{"cached":null,"ignore_cache":null}
348	3	card	2	2021-12-24 04:00:20.80985+00	{"cached":null,"ignore_cache":false}
349	3	card	1	2021-12-24 04:00:20.929934+00	{"cached":null,"ignore_cache":false}
350	1	dashboard	1	2021-12-24 04:00:41.174562+00	{"cached":null,"ignore_cache":null}
351	1	card	2	2021-12-24 04:00:41.568332+00	{"cached":null,"ignore_cache":false}
352	1	card	1	2021-12-24 04:00:41.606452+00	{"cached":null,"ignore_cache":false}
353	1	dashboard	1	2021-12-24 04:00:54.615107+00	{"cached":null,"ignore_cache":null}
354	\N	card	2	2021-12-24 04:02:40.167301+00	{"cached":null,"ignore_cache":null}
355	\N	card	1	2021-12-24 04:02:40.2469+00	{"cached":null,"ignore_cache":null}
356	\N	card	2	2021-12-24 04:03:11.992981+00	{"cached":null,"ignore_cache":null}
357	\N	card	1	2021-12-24 04:03:12.120215+00	{"cached":null,"ignore_cache":null}
358	4	dashboard	1	2021-12-24 04:04:55.986759+00	{"cached":null,"ignore_cache":null}
359	4	card	2	2021-12-24 04:04:56.373156+00	{"cached":null,"ignore_cache":false}
360	4	card	1	2021-12-24 04:04:56.411827+00	{"cached":null,"ignore_cache":false}
361	4	dashboard	1	2021-12-24 04:05:05.642454+00	{"cached":null,"ignore_cache":null}
362	4	dashboard	1	2021-12-24 04:07:01.639664+00	{"cached":null,"ignore_cache":null}
363	4	card	2	2021-12-24 04:07:02.022527+00	{"cached":null,"ignore_cache":false}
364	4	card	1	2021-12-24 04:07:02.192816+00	{"cached":null,"ignore_cache":false}
365	4	dashboard	1	2021-12-24 04:07:14.393719+00	{"cached":null,"ignore_cache":null}
366	4	dashboard	1	2021-12-24 04:11:00.088502+00	{"cached":null,"ignore_cache":null}
367	4	card	2	2021-12-24 04:11:07.63992+00	{"cached":null,"ignore_cache":false}
368	4	card	1	2021-12-24 04:11:07.718726+00	{"cached":null,"ignore_cache":false}
369	4	card	2	2021-12-24 14:36:02.428757+00	{"cached":null,"ignore_cache":null}
370	4	card	1	2021-12-24 14:36:02.470888+00	{"cached":null,"ignore_cache":null}
371	4	dashboard	1	2021-12-24 14:37:38.497174+00	{"cached":null,"ignore_cache":null}
372	4	card	2	2021-12-24 14:37:45.710361+00	{"cached":null,"ignore_cache":false}
373	4	card	1	2021-12-24 14:37:45.795558+00	{"cached":null,"ignore_cache":false}
374	4	card	2	2021-12-24 14:37:49.769629+00	{"cached":null,"ignore_cache":null}
375	4	card	1	2021-12-24 14:37:49.83573+00	{"cached":null,"ignore_cache":null}
376	4	table	10	2021-12-24 14:55:14.805657+00	{"cached":null,"ignore_cache":null}
377	4	table	10	2021-12-24 14:55:40.595086+00	{"cached":null,"ignore_cache":null}
378	4	table	10	2021-12-24 14:55:48.090702+00	{"cached":null,"ignore_cache":null}
379	4	table	12	2021-12-24 14:55:48.253792+00	{"cached":null,"ignore_cache":null}
380	4	table	12	2021-12-24 14:55:48.33445+00	{"cached":null,"ignore_cache":null}
381	4	table	18	2021-12-24 14:55:48.370227+00	{"cached":null,"ignore_cache":null}
382	4	table	6	2021-12-24 14:55:54.769931+00	{"cached":null,"ignore_cache":null}
383	4	table	5	2021-12-24 14:55:54.963238+00	{"cached":null,"ignore_cache":null}
384	4	table	10	2021-12-24 14:55:54.989758+00	{"cached":null,"ignore_cache":null}
385	4	table	7	2021-12-24 14:55:55.020579+00	{"cached":null,"ignore_cache":null}
386	4	table	9	2021-12-24 14:55:55.060795+00	{"cached":null,"ignore_cache":null}
387	4	table	10	2021-12-24 14:56:10.350284+00	{"cached":null,"ignore_cache":null}
388	4	table	30	2021-12-24 14:56:10.472706+00	{"cached":null,"ignore_cache":null}
389	4	table	12	2021-12-24 14:56:10.528178+00	{"cached":null,"ignore_cache":null}
390	4	table	18	2021-12-24 14:56:10.558502+00	{"cached":null,"ignore_cache":null}
391	4	table	12	2021-12-24 14:56:17.611142+00	{"cached":null,"ignore_cache":null}
392	4	table	5	2021-12-24 14:56:23.425658+00	{"cached":null,"ignore_cache":null}
393	4	table	21	2021-12-24 14:56:23.500784+00	{"cached":null,"ignore_cache":null}
394	4	table	21	2021-12-24 14:56:23.543229+00	{"cached":null,"ignore_cache":null}
395	4	table	12	2021-12-24 14:56:23.601393+00	{"cached":null,"ignore_cache":null}
396	4	table	9	2021-12-24 14:56:23.642788+00	{"cached":null,"ignore_cache":null}
397	4	table	8	2021-12-24 14:56:23.680785+00	{"cached":null,"ignore_cache":null}
398	4	table	8	2021-12-24 14:56:42.091921+00	{"cached":null,"ignore_cache":null}
399	4	dashboard	1	2021-12-24 14:57:28.144323+00	{"cached":null,"ignore_cache":null}
400	4	card	2	2021-12-24 14:57:28.633479+00	{"cached":null,"ignore_cache":false}
401	4	card	1	2021-12-24 14:57:28.668669+00	{"cached":null,"ignore_cache":false}
402	4	dashboard	1	2021-12-24 14:59:10.31244+00	{"cached":null,"ignore_cache":null}
403	4	card	2	2021-12-24 14:59:10.631648+00	{"cached":null,"ignore_cache":false}
404	4	card	1	2021-12-24 14:59:10.676997+00	{"cached":null,"ignore_cache":false}
405	1	dashboard	1	2021-12-24 15:00:24.228714+00	{"cached":null,"ignore_cache":null}
406	1	card	2	2021-12-24 15:00:24.673275+00	{"cached":null,"ignore_cache":false}
407	1	card	1	2021-12-24 15:00:24.757154+00	{"cached":null,"ignore_cache":false}
408	4	dashboard	1	2021-12-24 15:48:47.056846+00	{"cached":null,"ignore_cache":null}
409	4	card	2	2021-12-24 15:48:47.377039+00	{"cached":null,"ignore_cache":false}
410	4	card	1	2021-12-24 15:48:47.4779+00	{"cached":null,"ignore_cache":false}
411	4	dashboard	1	2021-12-24 15:48:56.012716+00	{"cached":null,"ignore_cache":null}
412	4	card	2	2021-12-24 15:48:56.422519+00	{"cached":null,"ignore_cache":false}
413	4	card	1	2021-12-24 15:48:56.506246+00	{"cached":null,"ignore_cache":false}
414	4	table	9	2021-12-24 15:56:02.061022+00	{"cached":null,"ignore_cache":null}
415	4	table	9	2021-12-24 15:56:37.973761+00	{"cached":null,"ignore_cache":null}
416	4	table	9	2021-12-24 15:56:55.435909+00	{"cached":null,"ignore_cache":null}
417	4	table	9	2021-12-24 15:57:14.537534+00	{"cached":null,"ignore_cache":null}
418	4	table	9	2021-12-24 15:57:32.661423+00	{"cached":null,"ignore_cache":null}
419	4	table	9	2021-12-24 15:57:38.871698+00	{"cached":null,"ignore_cache":null}
420	4	table	9	2021-12-24 15:57:52.363+00	{"cached":null,"ignore_cache":null}
421	4	table	9	2021-12-24 16:00:56.237013+00	{"cached":null,"ignore_cache":null}
422	4	table	9	2021-12-24 16:02:12.934721+00	{"cached":null,"ignore_cache":null}
423	4	table	5	2021-12-24 16:10:55.096097+00	{"cached":null,"ignore_cache":null}
424	4	table	5	2021-12-24 16:11:07.046386+00	{"cached":null,"ignore_cache":null}
425	4	table	21	2021-12-24 16:11:07.180563+00	{"cached":null,"ignore_cache":null}
426	4	table	21	2021-12-24 16:11:07.20243+00	{"cached":null,"ignore_cache":null}
427	4	table	12	2021-12-24 16:11:07.23933+00	{"cached":null,"ignore_cache":null}
428	4	table	9	2021-12-24 16:11:07.282347+00	{"cached":null,"ignore_cache":null}
429	4	table	8	2021-12-24 16:11:07.319469+00	{"cached":null,"ignore_cache":null}
430	4	table	5	2021-12-24 16:12:31.415891+00	{"cached":null,"ignore_cache":null}
431	4	table	33	2021-12-24 16:12:31.493477+00	{"cached":null,"ignore_cache":null}
432	4	table	21	2021-12-24 16:12:31.540499+00	{"cached":null,"ignore_cache":null}
433	4	table	12	2021-12-24 16:12:31.562713+00	{"cached":null,"ignore_cache":null}
434	4	table	9	2021-12-24 16:12:31.600723+00	{"cached":null,"ignore_cache":null}
435	4	table	8	2021-12-24 16:12:31.770406+00	{"cached":null,"ignore_cache":null}
436	4	table	5	2021-12-24 16:12:34.812205+00	{"cached":null,"ignore_cache":null}
437	4	table	33	2021-12-24 16:12:34.900177+00	{"cached":null,"ignore_cache":null}
438	4	table	21	2021-12-24 16:12:34.932955+00	{"cached":null,"ignore_cache":null}
439	4	table	12	2021-12-24 16:12:34.958248+00	{"cached":null,"ignore_cache":null}
440	4	table	9	2021-12-24 16:12:34.991966+00	{"cached":null,"ignore_cache":null}
441	4	table	8	2021-12-24 16:12:35.028332+00	{"cached":null,"ignore_cache":null}
442	4	table	5	2021-12-24 16:12:36.997565+00	{"cached":null,"ignore_cache":null}
443	4	table	33	2021-12-24 16:12:37.051517+00	{"cached":null,"ignore_cache":null}
444	4	table	21	2021-12-24 16:12:37.078138+00	{"cached":null,"ignore_cache":null}
445	4	table	12	2021-12-24 16:12:37.117387+00	{"cached":null,"ignore_cache":null}
446	4	table	9	2021-12-24 16:12:37.15574+00	{"cached":null,"ignore_cache":null}
447	4	table	8	2021-12-24 16:12:37.190675+00	{"cached":null,"ignore_cache":null}
448	4	table	5	2021-12-24 16:12:38.260586+00	{"cached":null,"ignore_cache":null}
449	4	table	33	2021-12-24 16:12:38.327216+00	{"cached":null,"ignore_cache":null}
450	4	table	21	2021-12-24 16:12:38.361467+00	{"cached":null,"ignore_cache":null}
451	4	table	12	2021-12-24 16:12:38.417093+00	{"cached":null,"ignore_cache":null}
452	4	table	9	2021-12-24 16:12:38.452305+00	{"cached":null,"ignore_cache":null}
453	4	table	8	2021-12-24 16:12:38.48901+00	{"cached":null,"ignore_cache":null}
454	4	table	5	2021-12-24 16:12:39.189245+00	{"cached":null,"ignore_cache":null}
455	4	table	33	2021-12-24 16:12:39.245816+00	{"cached":null,"ignore_cache":null}
456	4	table	21	2021-12-24 16:12:39.273378+00	{"cached":null,"ignore_cache":null}
457	4	table	12	2021-12-24 16:12:39.310021+00	{"cached":null,"ignore_cache":null}
458	4	table	9	2021-12-24 16:12:39.342026+00	{"cached":null,"ignore_cache":null}
459	4	table	8	2021-12-24 16:12:39.379974+00	{"cached":null,"ignore_cache":null}
460	4	table	33	2021-12-24 16:12:41.145049+00	{"cached":null,"ignore_cache":null}
461	4	table	17	2021-12-24 16:12:45.669407+00	{"cached":null,"ignore_cache":null}
462	4	table	33	2021-12-24 16:12:45.803701+00	{"cached":null,"ignore_cache":null}
463	4	table	33	2021-12-24 16:12:52.778884+00	{"cached":null,"ignore_cache":null}
464	4	table	5	2021-12-24 16:12:54.327775+00	{"cached":null,"ignore_cache":null}
465	4	table	33	2021-12-24 16:12:54.375655+00	{"cached":null,"ignore_cache":null}
466	4	table	21	2021-12-24 16:12:54.406981+00	{"cached":null,"ignore_cache":null}
467	4	table	12	2021-12-24 16:12:54.446522+00	{"cached":null,"ignore_cache":null}
468	4	table	9	2021-12-24 16:12:54.484471+00	{"cached":null,"ignore_cache":null}
469	4	table	8	2021-12-24 16:12:54.522118+00	{"cached":null,"ignore_cache":null}
470	4	table	7	2021-12-24 16:13:06.979915+00	{"cached":null,"ignore_cache":null}
471	4	table	7	2021-12-24 16:13:32.008673+00	{"cached":null,"ignore_cache":null}
472	1	dashboard	3	2021-12-24 16:18:10.011796+00	{"cached":null,"ignore_cache":null}
473	1	dashboard	3	2021-12-24 16:18:24.392704+00	{"cached":null,"ignore_cache":null}
474	4	dashboard	1	2021-12-24 16:30:34.723449+00	{"cached":null,"ignore_cache":null}
475	4	card	2	2021-12-24 16:30:35.080351+00	{"cached":null,"ignore_cache":false}
476	4	card	1	2021-12-24 16:30:35.246008+00	{"cached":null,"ignore_cache":false}
477	4	card	2	2021-12-24 16:31:05.246452+00	{"cached":null,"ignore_cache":false}
478	4	card	1	2021-12-24 16:31:05.287973+00	{"cached":null,"ignore_cache":false}
479	4	card	2	2021-12-24 16:31:16.047499+00	{"cached":null,"ignore_cache":false}
480	4	card	1	2021-12-24 16:31:16.09675+00	{"cached":null,"ignore_cache":false}
481	4	card	2	2021-12-24 16:31:38.515195+00	{"cached":null,"ignore_cache":null}
482	4	dashboard	1	2021-12-24 16:31:57.72737+00	{"cached":null,"ignore_cache":null}
483	4	card	2	2021-12-24 16:31:57.914307+00	{"cached":null,"ignore_cache":false}
484	4	card	1	2021-12-24 16:31:57.977623+00	{"cached":null,"ignore_cache":false}
485	4	table	7	2021-12-24 17:05:02.358765+00	{"cached":null,"ignore_cache":null}
486	4	card	5	2021-12-24 17:05:43.735732+00	{"cached":null,"ignore_cache":null}
487	4	dashboard	4	2021-12-24 17:06:01.770302+00	{"cached":null,"ignore_cache":null}
488	4	card	5	2021-12-24 17:06:01.815703+00	{"cached":null,"ignore_cache":null}
489	4	card	5	2021-12-24 17:06:02.091919+00	{"cached":null,"ignore_cache":false}
490	4	card	4	2021-12-24 17:06:24.575129+00	{"cached":null,"ignore_cache":null}
491	4	card	4	2021-12-24 17:06:24.861523+00	{"cached":null,"ignore_cache":false}
492	4	card	1	2021-12-24 17:06:37.793247+00	{"cached":null,"ignore_cache":null}
493	4	card	1	2021-12-24 17:06:38.374682+00	{"cached":null,"ignore_cache":false}
494	4	dashboard	4	2021-12-24 17:08:13.438601+00	{"cached":null,"ignore_cache":null}
495	4	card	5	2021-12-24 17:08:28.640197+00	{"cached":null,"ignore_cache":null}
496	4	card	5	2021-12-24 17:08:28.901667+00	{"cached":null,"ignore_cache":false}
498	4	dashboard	4	2021-12-24 17:08:49.343906+00	{"cached":null,"ignore_cache":null}
499	4	card	5	2021-12-24 17:08:58.163716+00	{"cached":null,"ignore_cache":null}
500	4	card	5	2021-12-24 17:08:58.565865+00	{"cached":null,"ignore_cache":false}
503	4	card	2	2021-12-24 17:25:12.661927+00	{"cached":null,"ignore_cache":null}
504	4	card	1	2021-12-24 17:25:12.757967+00	{"cached":null,"ignore_cache":null}
507	4	dashboard	4	2021-12-24 18:08:33.538583+00	{"cached":null,"ignore_cache":null}
497	4	dashboard	4	2021-12-24 17:08:30.818835+00	{"cached":null,"ignore_cache":null}
502	4	card	5	2021-12-24 17:10:08.646229+00	{"cached":null,"ignore_cache":false}
505	4	dashboard	4	2021-12-24 18:07:59.678208+00	{"cached":null,"ignore_cache":null}
506	4	card	5	2021-12-24 18:07:59.994761+00	{"cached":null,"ignore_cache":false}
501	4	dashboard	4	2021-12-24 17:10:08.378684+00	{"cached":null,"ignore_cache":null}
508	4	dashboard	4	2021-12-24 18:09:06.899669+00	{"cached":null,"ignore_cache":null}
509	4	card	5	2021-12-24 18:09:07.20437+00	{"cached":null,"ignore_cache":false}
510	4	dashboard	4	2021-12-24 18:09:33.692571+00	{"cached":null,"ignore_cache":null}
511	4	card	5	2021-12-24 18:09:33.934639+00	{"cached":null,"ignore_cache":false}
\.


--
-- Name: activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.activity_id_seq', 29, true);


--
-- Name: card_label_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.card_label_id_seq', 1, false);


--
-- Name: collection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.collection_id_seq', 3, true);


--
-- Name: collection_permission_graph_revision_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.collection_permission_graph_revision_id_seq', 1, false);


--
-- Name: computation_job_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.computation_job_id_seq', 1, false);


--
-- Name: computation_job_result_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.computation_job_result_id_seq', 1, false);


--
-- Name: core_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.core_user_id_seq', 4, true);


--
-- Name: dashboard_favorite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dashboard_favorite_id_seq', 1, false);


--
-- Name: dashboardcard_series_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dashboardcard_series_id_seq', 1, false);


--
-- Name: dependency_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dependency_id_seq', 1, false);


--
-- Name: dimension_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dimension_id_seq', 1, false);


--
-- Name: group_table_access_policy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.group_table_access_policy_id_seq', 1, false);


--
-- Name: label_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.label_id_seq', 1, false);


--
-- Name: login_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.login_history_id_seq', 13, true);


--
-- Name: metabase_database_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.metabase_database_id_seq', 2, true);


--
-- Name: metabase_field_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.metabase_field_id_seq', 164, true);


--
-- Name: metabase_fieldvalues_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.metabase_fieldvalues_id_seq', 26, true);


--
-- Name: metabase_table_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.metabase_table_id_seq', 38, true);


--
-- Name: metric_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.metric_id_seq', 1, false);


--
-- Name: metric_important_field_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.metric_important_field_id_seq', 1, false);


--
-- Name: moderation_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.moderation_review_id_seq', 1, false);


--
-- Name: native_query_snippet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.native_query_snippet_id_seq', 1, false);


--
-- Name: permissions_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_group_id_seq', 3, true);


--
-- Name: permissions_group_membership_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_group_membership_id_seq', 4, true);


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 8, true);


--
-- Name: permissions_revision_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_revision_id_seq', 1, false);


--
-- Name: pulse_card_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pulse_card_id_seq', 1, false);


--
-- Name: pulse_channel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pulse_channel_id_seq', 1, false);


--
-- Name: pulse_channel_recipient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pulse_channel_recipient_id_seq', 1, false);


--
-- Name: pulse_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pulse_id_seq', 1, false);


--
-- Name: query_execution_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.query_execution_id_seq', 661, true);


--
-- Name: report_card_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_card_id_seq', 5, true);


--
-- Name: report_cardfavorite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_cardfavorite_id_seq', 1, false);


--
-- Name: report_dashboard_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_dashboard_id_seq', 4, true);


--
-- Name: report_dashboardcard_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_dashboardcard_id_seq', 4, true);


--
-- Name: revision_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.revision_id_seq', 80, true);


--
-- Name: segment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.segment_id_seq', 1, false);


--
-- Name: task_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.task_history_id_seq', 310, true);


--
-- Name: view_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.view_log_id_seq', 511, true);


--
-- Name: activity activity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity
    ADD CONSTRAINT activity_pkey PRIMARY KEY (id);


--
-- Name: card_label card_label_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_label
    ADD CONSTRAINT card_label_pkey PRIMARY KEY (id);


--
-- Name: collection collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_pkey PRIMARY KEY (id);


--
-- Name: collection_permission_graph_revision collection_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection_permission_graph_revision
    ADD CONSTRAINT collection_revision_pkey PRIMARY KEY (id);


--
-- Name: computation_job computation_job_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computation_job
    ADD CONSTRAINT computation_job_pkey PRIMARY KEY (id);


--
-- Name: computation_job_result computation_job_result_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computation_job_result
    ADD CONSTRAINT computation_job_result_pkey PRIMARY KEY (id);


--
-- Name: core_session core_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_session
    ADD CONSTRAINT core_session_pkey PRIMARY KEY (id);


--
-- Name: core_user core_user_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_user
    ADD CONSTRAINT core_user_email_key UNIQUE (email);


--
-- Name: core_user core_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_user
    ADD CONSTRAINT core_user_pkey PRIMARY KEY (id);


--
-- Name: dashboard_favorite dashboard_favorite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_favorite
    ADD CONSTRAINT dashboard_favorite_pkey PRIMARY KEY (id);


--
-- Name: dashboardcard_series dashboardcard_series_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboardcard_series
    ADD CONSTRAINT dashboardcard_series_pkey PRIMARY KEY (id);


--
-- Name: data_migrations data_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_migrations
    ADD CONSTRAINT data_migrations_pkey PRIMARY KEY (id);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: dependency dependency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dependency
    ADD CONSTRAINT dependency_pkey PRIMARY KEY (id);


--
-- Name: dimension dimension_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dimension
    ADD CONSTRAINT dimension_pkey PRIMARY KEY (id);


--
-- Name: group_table_access_policy group_table_access_policy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_table_access_policy
    ADD CONSTRAINT group_table_access_policy_pkey PRIMARY KEY (id);


--
-- Name: databasechangelog idx_databasechangelog_id_author_filename; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.databasechangelog
    ADD CONSTRAINT idx_databasechangelog_id_author_filename UNIQUE (id, author, filename);


--
-- Name: metabase_field idx_uniq_field_table_id_parent_id_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_field
    ADD CONSTRAINT idx_uniq_field_table_id_parent_id_name UNIQUE (table_id, parent_id, name);


--
-- Name: metabase_table idx_uniq_table_db_id_schema_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_table
    ADD CONSTRAINT idx_uniq_table_db_id_schema_name UNIQUE (db_id, schema, name);


--
-- Name: report_cardfavorite idx_unique_cardfavorite_card_id_owner_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_cardfavorite
    ADD CONSTRAINT idx_unique_cardfavorite_card_id_owner_id UNIQUE (card_id, owner_id);


--
-- Name: label label_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.label
    ADD CONSTRAINT label_pkey PRIMARY KEY (id);


--
-- Name: label label_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.label
    ADD CONSTRAINT label_slug_key UNIQUE (slug);


--
-- Name: login_history login_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT login_history_pkey PRIMARY KEY (id);


--
-- Name: metabase_database metabase_database_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_database
    ADD CONSTRAINT metabase_database_pkey PRIMARY KEY (id);


--
-- Name: metabase_field metabase_field_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_field
    ADD CONSTRAINT metabase_field_pkey PRIMARY KEY (id);


--
-- Name: metabase_fieldvalues metabase_fieldvalues_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_fieldvalues
    ADD CONSTRAINT metabase_fieldvalues_pkey PRIMARY KEY (id);


--
-- Name: metabase_table metabase_table_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_table
    ADD CONSTRAINT metabase_table_pkey PRIMARY KEY (id);


--
-- Name: metric_important_field metric_important_field_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metric_important_field
    ADD CONSTRAINT metric_important_field_pkey PRIMARY KEY (id);


--
-- Name: metric metric_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metric
    ADD CONSTRAINT metric_pkey PRIMARY KEY (id);


--
-- Name: moderation_review moderation_review_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moderation_review
    ADD CONSTRAINT moderation_review_pkey PRIMARY KEY (id);


--
-- Name: native_query_snippet native_query_snippet_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.native_query_snippet
    ADD CONSTRAINT native_query_snippet_name_key UNIQUE (name);


--
-- Name: native_query_snippet native_query_snippet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.native_query_snippet
    ADD CONSTRAINT native_query_snippet_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_group_id_object_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_group_id_object_key UNIQUE (group_id, object);


--
-- Name: permissions_group_membership permissions_group_membership_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_group_membership
    ADD CONSTRAINT permissions_group_membership_pkey PRIMARY KEY (id);


--
-- Name: permissions_group permissions_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_group
    ADD CONSTRAINT permissions_group_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: permissions_revision permissions_revision_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_revision
    ADD CONSTRAINT permissions_revision_pkey PRIMARY KEY (id);


--
-- Name: qrtz_blob_triggers pk_qrtz_blob_triggers; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_blob_triggers
    ADD CONSTRAINT pk_qrtz_blob_triggers PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_calendars pk_qrtz_calendars; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_calendars
    ADD CONSTRAINT pk_qrtz_calendars PRIMARY KEY (sched_name, calendar_name);


--
-- Name: qrtz_cron_triggers pk_qrtz_cron_triggers; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_cron_triggers
    ADD CONSTRAINT pk_qrtz_cron_triggers PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_fired_triggers pk_qrtz_fired_triggers; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_fired_triggers
    ADD CONSTRAINT pk_qrtz_fired_triggers PRIMARY KEY (sched_name, entry_id);


--
-- Name: qrtz_job_details pk_qrtz_job_details; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_job_details
    ADD CONSTRAINT pk_qrtz_job_details PRIMARY KEY (sched_name, job_name, job_group);


--
-- Name: qrtz_locks pk_qrtz_locks; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_locks
    ADD CONSTRAINT pk_qrtz_locks PRIMARY KEY (sched_name, lock_name);


--
-- Name: qrtz_scheduler_state pk_qrtz_scheduler_state; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_scheduler_state
    ADD CONSTRAINT pk_qrtz_scheduler_state PRIMARY KEY (sched_name, instance_name);


--
-- Name: qrtz_simple_triggers pk_qrtz_simple_triggers; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_simple_triggers
    ADD CONSTRAINT pk_qrtz_simple_triggers PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_simprop_triggers pk_qrtz_simprop_triggers; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_simprop_triggers
    ADD CONSTRAINT pk_qrtz_simprop_triggers PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_triggers pk_qrtz_triggers; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_triggers
    ADD CONSTRAINT pk_qrtz_triggers PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_paused_trigger_grps pk_sched_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_paused_trigger_grps
    ADD CONSTRAINT pk_sched_name PRIMARY KEY (sched_name, trigger_group);


--
-- Name: pulse_card pulse_card_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_card
    ADD CONSTRAINT pulse_card_pkey PRIMARY KEY (id);


--
-- Name: pulse_channel pulse_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_channel
    ADD CONSTRAINT pulse_channel_pkey PRIMARY KEY (id);


--
-- Name: pulse_channel_recipient pulse_channel_recipient_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_channel_recipient
    ADD CONSTRAINT pulse_channel_recipient_pkey PRIMARY KEY (id);


--
-- Name: pulse pulse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse
    ADD CONSTRAINT pulse_pkey PRIMARY KEY (id);


--
-- Name: query_cache query_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.query_cache
    ADD CONSTRAINT query_cache_pkey PRIMARY KEY (query_hash);


--
-- Name: query_execution query_execution_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.query_execution
    ADD CONSTRAINT query_execution_pkey PRIMARY KEY (id);


--
-- Name: query query_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.query
    ADD CONSTRAINT query_pkey PRIMARY KEY (query_hash);


--
-- Name: report_card report_card_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT report_card_pkey PRIMARY KEY (id);


--
-- Name: report_card report_card_public_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT report_card_public_uuid_key UNIQUE (public_uuid);


--
-- Name: report_cardfavorite report_cardfavorite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_cardfavorite
    ADD CONSTRAINT report_cardfavorite_pkey PRIMARY KEY (id);


--
-- Name: report_dashboard report_dashboard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_dashboard
    ADD CONSTRAINT report_dashboard_pkey PRIMARY KEY (id);


--
-- Name: report_dashboard report_dashboard_public_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_dashboard
    ADD CONSTRAINT report_dashboard_public_uuid_key UNIQUE (public_uuid);


--
-- Name: report_dashboardcard report_dashboardcard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_dashboardcard
    ADD CONSTRAINT report_dashboardcard_pkey PRIMARY KEY (id);


--
-- Name: revision revision_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revision
    ADD CONSTRAINT revision_pkey PRIMARY KEY (id);


--
-- Name: segment segment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.segment
    ADD CONSTRAINT segment_pkey PRIMARY KEY (id);


--
-- Name: setting setting_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.setting
    ADD CONSTRAINT setting_pkey PRIMARY KEY (key);


--
-- Name: task_history task_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_history
    ADD CONSTRAINT task_history_pkey PRIMARY KEY (id);


--
-- Name: card_label unique_card_label_card_id_label_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_label
    ADD CONSTRAINT unique_card_label_card_id_label_id UNIQUE (card_id, label_id);


--
-- Name: collection unique_collection_personal_owner_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT unique_collection_personal_owner_id UNIQUE (personal_owner_id);


--
-- Name: dashboard_favorite unique_dashboard_favorite_user_id_dashboard_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_favorite
    ADD CONSTRAINT unique_dashboard_favorite_user_id_dashboard_id UNIQUE (user_id, dashboard_id);


--
-- Name: dimension unique_dimension_field_id_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dimension
    ADD CONSTRAINT unique_dimension_field_id_name UNIQUE (field_id, name);


--
-- Name: group_table_access_policy unique_gtap_table_id_group_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_table_access_policy
    ADD CONSTRAINT unique_gtap_table_id_group_id UNIQUE (table_id, group_id);


--
-- Name: metric_important_field unique_metric_important_field_metric_id_field_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metric_important_field
    ADD CONSTRAINT unique_metric_important_field_metric_id_field_id UNIQUE (metric_id, field_id);


--
-- Name: permissions_group_membership unique_permissions_group_membership_user_id_group_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_group_membership
    ADD CONSTRAINT unique_permissions_group_membership_user_id_group_id UNIQUE (user_id, group_id);


--
-- Name: permissions_group unique_permissions_group_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_group
    ADD CONSTRAINT unique_permissions_group_name UNIQUE (name);


--
-- Name: view_log view_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_log
    ADD CONSTRAINT view_log_pkey PRIMARY KEY (id);


--
-- Name: idx_activity_custom_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_activity_custom_id ON public.activity USING btree (custom_id);


--
-- Name: idx_activity_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_activity_timestamp ON public.activity USING btree ("timestamp");


--
-- Name: idx_activity_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_activity_user_id ON public.activity USING btree (user_id);


--
-- Name: idx_card_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_card_collection_id ON public.report_card USING btree (collection_id);


--
-- Name: idx_card_creator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_card_creator_id ON public.report_card USING btree (creator_id);


--
-- Name: idx_card_label_card_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_card_label_card_id ON public.card_label USING btree (card_id);


--
-- Name: idx_card_label_label_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_card_label_label_id ON public.card_label USING btree (label_id);


--
-- Name: idx_card_public_uuid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_card_public_uuid ON public.report_card USING btree (public_uuid);


--
-- Name: idx_cardfavorite_card_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cardfavorite_card_id ON public.report_cardfavorite USING btree (card_id);


--
-- Name: idx_cardfavorite_owner_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cardfavorite_owner_id ON public.report_cardfavorite USING btree (owner_id);


--
-- Name: idx_collection_location; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_collection_location ON public.collection USING btree (location);


--
-- Name: idx_collection_personal_owner_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_collection_personal_owner_id ON public.collection USING btree (personal_owner_id);


--
-- Name: idx_dashboard_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dashboard_collection_id ON public.report_dashboard USING btree (collection_id);


--
-- Name: idx_dashboard_creator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dashboard_creator_id ON public.report_dashboard USING btree (creator_id);


--
-- Name: idx_dashboard_favorite_dashboard_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dashboard_favorite_dashboard_id ON public.dashboard_favorite USING btree (dashboard_id);


--
-- Name: idx_dashboard_favorite_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dashboard_favorite_user_id ON public.dashboard_favorite USING btree (user_id);


--
-- Name: idx_dashboard_public_uuid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dashboard_public_uuid ON public.report_dashboard USING btree (public_uuid);


--
-- Name: idx_dashboardcard_card_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dashboardcard_card_id ON public.report_dashboardcard USING btree (card_id);


--
-- Name: idx_dashboardcard_dashboard_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dashboardcard_dashboard_id ON public.report_dashboardcard USING btree (dashboard_id);


--
-- Name: idx_dashboardcard_series_card_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dashboardcard_series_card_id ON public.dashboardcard_series USING btree (card_id);


--
-- Name: idx_dashboardcard_series_dashboardcard_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dashboardcard_series_dashboardcard_id ON public.dashboardcard_series USING btree (dashboardcard_id);


--
-- Name: idx_data_migrations_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_data_migrations_id ON public.data_migrations USING btree (id);


--
-- Name: idx_dependency_dependent_on_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dependency_dependent_on_id ON public.dependency USING btree (dependent_on_id);


--
-- Name: idx_dependency_dependent_on_model; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dependency_dependent_on_model ON public.dependency USING btree (dependent_on_model);


--
-- Name: idx_dependency_model; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dependency_model ON public.dependency USING btree (model);


--
-- Name: idx_dependency_model_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dependency_model_id ON public.dependency USING btree (model_id);


--
-- Name: idx_dimension_field_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dimension_field_id ON public.dimension USING btree (field_id);


--
-- Name: idx_field_parent_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_field_parent_id ON public.metabase_field USING btree (parent_id);


--
-- Name: idx_field_table_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_field_table_id ON public.metabase_field USING btree (table_id);


--
-- Name: idx_fieldvalues_field_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fieldvalues_field_id ON public.metabase_fieldvalues USING btree (field_id);


--
-- Name: idx_gtap_table_id_group_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_gtap_table_id_group_id ON public.group_table_access_policy USING btree (table_id, group_id);


--
-- Name: idx_label_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_label_slug ON public.label USING btree (slug);


--
-- Name: idx_lower_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lower_email ON public.core_user USING btree (lower((email)::text));


--
-- Name: idx_metabase_table_db_id_schema; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_metabase_table_db_id_schema ON public.metabase_table USING btree (db_id, schema);


--
-- Name: idx_metabase_table_show_in_getting_started; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_metabase_table_show_in_getting_started ON public.metabase_table USING btree (show_in_getting_started);


--
-- Name: idx_metric_creator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_metric_creator_id ON public.metric USING btree (creator_id);


--
-- Name: idx_metric_important_field_field_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_metric_important_field_field_id ON public.metric_important_field USING btree (field_id);


--
-- Name: idx_metric_important_field_metric_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_metric_important_field_metric_id ON public.metric_important_field USING btree (metric_id);


--
-- Name: idx_metric_show_in_getting_started; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_metric_show_in_getting_started ON public.metric USING btree (show_in_getting_started);


--
-- Name: idx_metric_table_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_metric_table_id ON public.metric USING btree (table_id);


--
-- Name: idx_moderation_review_item_type_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_moderation_review_item_type_item_id ON public.moderation_review USING btree (moderated_item_type, moderated_item_id);


--
-- Name: idx_permissions_group_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_permissions_group_id ON public.permissions USING btree (group_id);


--
-- Name: idx_permissions_group_id_object; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_permissions_group_id_object ON public.permissions USING btree (group_id, object);


--
-- Name: idx_permissions_group_membership_group_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_permissions_group_membership_group_id ON public.permissions_group_membership USING btree (group_id);


--
-- Name: idx_permissions_group_membership_group_id_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_permissions_group_membership_group_id_user_id ON public.permissions_group_membership USING btree (group_id, user_id);


--
-- Name: idx_permissions_group_membership_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_permissions_group_membership_user_id ON public.permissions_group_membership USING btree (user_id);


--
-- Name: idx_permissions_group_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_permissions_group_name ON public.permissions_group USING btree (name);


--
-- Name: idx_permissions_object; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_permissions_object ON public.permissions USING btree (object);


--
-- Name: idx_pulse_card_card_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pulse_card_card_id ON public.pulse_card USING btree (card_id);


--
-- Name: idx_pulse_card_pulse_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pulse_card_pulse_id ON public.pulse_card USING btree (pulse_id);


--
-- Name: idx_pulse_channel_pulse_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pulse_channel_pulse_id ON public.pulse_channel USING btree (pulse_id);


--
-- Name: idx_pulse_channel_schedule_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pulse_channel_schedule_type ON public.pulse_channel USING btree (schedule_type);


--
-- Name: idx_pulse_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pulse_collection_id ON public.pulse USING btree (collection_id);


--
-- Name: idx_pulse_creator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pulse_creator_id ON public.pulse USING btree (creator_id);


--
-- Name: idx_qrtz_ft_inst_job_req_rcvry; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_ft_inst_job_req_rcvry ON public.qrtz_fired_triggers USING btree (sched_name, instance_name, requests_recovery);


--
-- Name: idx_qrtz_ft_j_g; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_ft_j_g ON public.qrtz_fired_triggers USING btree (sched_name, job_name, job_group);


--
-- Name: idx_qrtz_ft_jg; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_ft_jg ON public.qrtz_fired_triggers USING btree (sched_name, job_group);


--
-- Name: idx_qrtz_ft_t_g; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_ft_t_g ON public.qrtz_fired_triggers USING btree (sched_name, trigger_name, trigger_group);


--
-- Name: idx_qrtz_ft_tg; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_ft_tg ON public.qrtz_fired_triggers USING btree (sched_name, trigger_group);


--
-- Name: idx_qrtz_ft_trig_inst_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_ft_trig_inst_name ON public.qrtz_fired_triggers USING btree (sched_name, instance_name);


--
-- Name: idx_qrtz_j_grp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_j_grp ON public.qrtz_job_details USING btree (sched_name, job_group);


--
-- Name: idx_qrtz_j_req_recovery; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_j_req_recovery ON public.qrtz_job_details USING btree (sched_name, requests_recovery);


--
-- Name: idx_qrtz_t_c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_c ON public.qrtz_triggers USING btree (sched_name, calendar_name);


--
-- Name: idx_qrtz_t_g; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_g ON public.qrtz_triggers USING btree (sched_name, trigger_group);


--
-- Name: idx_qrtz_t_j; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_j ON public.qrtz_triggers USING btree (sched_name, job_name, job_group);


--
-- Name: idx_qrtz_t_jg; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_jg ON public.qrtz_triggers USING btree (sched_name, job_group);


--
-- Name: idx_qrtz_t_n_g_state; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_n_g_state ON public.qrtz_triggers USING btree (sched_name, trigger_group, trigger_state);


--
-- Name: idx_qrtz_t_n_state; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_n_state ON public.qrtz_triggers USING btree (sched_name, trigger_name, trigger_group, trigger_state);


--
-- Name: idx_qrtz_t_next_fire_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_next_fire_time ON public.qrtz_triggers USING btree (sched_name, next_fire_time);


--
-- Name: idx_qrtz_t_nft_misfire; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_nft_misfire ON public.qrtz_triggers USING btree (sched_name, misfire_instr, next_fire_time);


--
-- Name: idx_qrtz_t_nft_st; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_nft_st ON public.qrtz_triggers USING btree (sched_name, trigger_state, next_fire_time);


--
-- Name: idx_qrtz_t_nft_st_misfire; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_nft_st_misfire ON public.qrtz_triggers USING btree (sched_name, misfire_instr, next_fire_time, trigger_state);


--
-- Name: idx_qrtz_t_nft_st_misfire_grp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_nft_st_misfire_grp ON public.qrtz_triggers USING btree (sched_name, misfire_instr, next_fire_time, trigger_group, trigger_state);


--
-- Name: idx_qrtz_t_state; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_qrtz_t_state ON public.qrtz_triggers USING btree (sched_name, trigger_state);


--
-- Name: idx_query_cache_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_query_cache_updated_at ON public.query_cache USING btree (updated_at);


--
-- Name: idx_query_execution_card_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_query_execution_card_id ON public.query_execution USING btree (card_id);


--
-- Name: idx_query_execution_card_id_started_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_query_execution_card_id_started_at ON public.query_execution USING btree (card_id, started_at);


--
-- Name: idx_query_execution_query_hash_started_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_query_execution_query_hash_started_at ON public.query_execution USING btree (hash, started_at);


--
-- Name: idx_query_execution_started_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_query_execution_started_at ON public.query_execution USING btree (started_at);


--
-- Name: idx_report_dashboard_show_in_getting_started; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_report_dashboard_show_in_getting_started ON public.report_dashboard USING btree (show_in_getting_started);


--
-- Name: idx_revision_model_model_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_revision_model_model_id ON public.revision USING btree (model, model_id);


--
-- Name: idx_segment_creator_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_segment_creator_id ON public.segment USING btree (creator_id);


--
-- Name: idx_segment_show_in_getting_started; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_segment_show_in_getting_started ON public.segment USING btree (show_in_getting_started);


--
-- Name: idx_segment_table_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_segment_table_id ON public.segment USING btree (table_id);


--
-- Name: idx_session_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_session_id ON public.login_history USING btree (session_id);


--
-- Name: idx_snippet_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_snippet_collection_id ON public.native_query_snippet USING btree (collection_id);


--
-- Name: idx_snippet_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_snippet_name ON public.native_query_snippet USING btree (name);


--
-- Name: idx_table_db_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_table_db_id ON public.metabase_table USING btree (db_id);


--
-- Name: idx_task_history_db_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_history_db_id ON public.task_history USING btree (db_id);


--
-- Name: idx_task_history_end_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_history_end_time ON public.task_history USING btree (ended_at);


--
-- Name: idx_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_timestamp ON public.login_history USING btree ("timestamp");


--
-- Name: idx_uniq_field_table_id_parent_id_name_2col; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_uniq_field_table_id_parent_id_name_2col ON public.metabase_field USING btree (table_id, name) WHERE (parent_id IS NULL);


--
-- Name: idx_uniq_table_db_id_schema_name_2col; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_uniq_table_db_id_schema_name_2col ON public.metabase_table USING btree (db_id, name) WHERE (schema IS NULL);


--
-- Name: idx_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_id ON public.login_history USING btree (user_id);


--
-- Name: idx_user_id_device_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_id_device_id ON public.login_history USING btree (session_id, device_id);


--
-- Name: idx_user_id_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_id_timestamp ON public.login_history USING btree (user_id, "timestamp");


--
-- Name: idx_view_log_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_view_log_timestamp ON public.view_log USING btree (model_id);


--
-- Name: idx_view_log_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_view_log_user_id ON public.view_log USING btree (user_id);


--
-- Name: activity fk_activity_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity
    ADD CONSTRAINT fk_activity_ref_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: report_card fk_card_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT fk_card_collection_id FOREIGN KEY (collection_id) REFERENCES public.collection(id) ON DELETE SET NULL;


--
-- Name: card_label fk_card_label_ref_card_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_label
    ADD CONSTRAINT fk_card_label_ref_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id) ON DELETE CASCADE;


--
-- Name: card_label fk_card_label_ref_label_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_label
    ADD CONSTRAINT fk_card_label_ref_label_id FOREIGN KEY (label_id) REFERENCES public.label(id) ON DELETE CASCADE;


--
-- Name: report_card fk_card_made_public_by_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT fk_card_made_public_by_id FOREIGN KEY (made_public_by_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: report_card fk_card_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT fk_card_ref_user_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: report_cardfavorite fk_cardfavorite_ref_card_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_cardfavorite
    ADD CONSTRAINT fk_cardfavorite_ref_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id) ON DELETE CASCADE;


--
-- Name: report_cardfavorite fk_cardfavorite_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_cardfavorite
    ADD CONSTRAINT fk_cardfavorite_ref_user_id FOREIGN KEY (owner_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: collection fk_collection_personal_owner_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT fk_collection_personal_owner_id FOREIGN KEY (personal_owner_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: collection_permission_graph_revision fk_collection_revision_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection_permission_graph_revision
    ADD CONSTRAINT fk_collection_revision_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: computation_job fk_computation_job_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computation_job
    ADD CONSTRAINT fk_computation_job_ref_user_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: computation_job_result fk_computation_result_ref_job_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computation_job_result
    ADD CONSTRAINT fk_computation_result_ref_job_id FOREIGN KEY (job_id) REFERENCES public.computation_job(id) ON DELETE CASCADE;


--
-- Name: report_dashboard fk_dashboard_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_dashboard
    ADD CONSTRAINT fk_dashboard_collection_id FOREIGN KEY (collection_id) REFERENCES public.collection(id) ON DELETE SET NULL;


--
-- Name: dashboard_favorite fk_dashboard_favorite_dashboard_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_favorite
    ADD CONSTRAINT fk_dashboard_favorite_dashboard_id FOREIGN KEY (dashboard_id) REFERENCES public.report_dashboard(id) ON DELETE CASCADE;


--
-- Name: dashboard_favorite fk_dashboard_favorite_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_favorite
    ADD CONSTRAINT fk_dashboard_favorite_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: report_dashboard fk_dashboard_made_public_by_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_dashboard
    ADD CONSTRAINT fk_dashboard_made_public_by_id FOREIGN KEY (made_public_by_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: report_dashboard fk_dashboard_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_dashboard
    ADD CONSTRAINT fk_dashboard_ref_user_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: report_dashboardcard fk_dashboardcard_ref_card_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_dashboardcard
    ADD CONSTRAINT fk_dashboardcard_ref_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id) ON DELETE CASCADE;


--
-- Name: report_dashboardcard fk_dashboardcard_ref_dashboard_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_dashboardcard
    ADD CONSTRAINT fk_dashboardcard_ref_dashboard_id FOREIGN KEY (dashboard_id) REFERENCES public.report_dashboard(id) ON DELETE CASCADE;


--
-- Name: dashboardcard_series fk_dashboardcard_series_ref_card_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboardcard_series
    ADD CONSTRAINT fk_dashboardcard_series_ref_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id) ON DELETE CASCADE;


--
-- Name: dashboardcard_series fk_dashboardcard_series_ref_dashboardcard_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboardcard_series
    ADD CONSTRAINT fk_dashboardcard_series_ref_dashboardcard_id FOREIGN KEY (dashboardcard_id) REFERENCES public.report_dashboardcard(id) ON DELETE CASCADE;


--
-- Name: dimension fk_dimension_displayfk_ref_field_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dimension
    ADD CONSTRAINT fk_dimension_displayfk_ref_field_id FOREIGN KEY (human_readable_field_id) REFERENCES public.metabase_field(id) ON DELETE CASCADE;


--
-- Name: dimension fk_dimension_ref_field_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dimension
    ADD CONSTRAINT fk_dimension_ref_field_id FOREIGN KEY (field_id) REFERENCES public.metabase_field(id) ON DELETE CASCADE;


--
-- Name: metabase_field fk_field_parent_ref_field_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_field
    ADD CONSTRAINT fk_field_parent_ref_field_id FOREIGN KEY (parent_id) REFERENCES public.metabase_field(id) ON DELETE CASCADE;


--
-- Name: metabase_field fk_field_ref_table_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_field
    ADD CONSTRAINT fk_field_ref_table_id FOREIGN KEY (table_id) REFERENCES public.metabase_table(id) ON DELETE CASCADE;


--
-- Name: metabase_fieldvalues fk_fieldvalues_ref_field_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_fieldvalues
    ADD CONSTRAINT fk_fieldvalues_ref_field_id FOREIGN KEY (field_id) REFERENCES public.metabase_field(id) ON DELETE CASCADE;


--
-- Name: group_table_access_policy fk_gtap_card_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_table_access_policy
    ADD CONSTRAINT fk_gtap_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id) ON DELETE CASCADE;


--
-- Name: group_table_access_policy fk_gtap_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_table_access_policy
    ADD CONSTRAINT fk_gtap_group_id FOREIGN KEY (group_id) REFERENCES public.permissions_group(id) ON DELETE CASCADE;


--
-- Name: group_table_access_policy fk_gtap_table_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_table_access_policy
    ADD CONSTRAINT fk_gtap_table_id FOREIGN KEY (table_id) REFERENCES public.metabase_table(id) ON DELETE CASCADE;


--
-- Name: login_history fk_login_history_session_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT fk_login_history_session_id FOREIGN KEY (session_id) REFERENCES public.core_session(id) ON DELETE SET NULL;


--
-- Name: login_history fk_login_history_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_history
    ADD CONSTRAINT fk_login_history_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: metric_important_field fk_metric_important_field_metabase_field_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metric_important_field
    ADD CONSTRAINT fk_metric_important_field_metabase_field_id FOREIGN KEY (field_id) REFERENCES public.metabase_field(id) ON DELETE CASCADE;


--
-- Name: metric_important_field fk_metric_important_field_metric_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metric_important_field
    ADD CONSTRAINT fk_metric_important_field_metric_id FOREIGN KEY (metric_id) REFERENCES public.metric(id) ON DELETE CASCADE;


--
-- Name: metric fk_metric_ref_creator_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metric
    ADD CONSTRAINT fk_metric_ref_creator_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: metric fk_metric_ref_table_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metric
    ADD CONSTRAINT fk_metric_ref_table_id FOREIGN KEY (table_id) REFERENCES public.metabase_table(id) ON DELETE CASCADE;


--
-- Name: permissions_group_membership fk_permissions_group_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_group_membership
    ADD CONSTRAINT fk_permissions_group_group_id FOREIGN KEY (group_id) REFERENCES public.permissions_group(id) ON DELETE CASCADE;


--
-- Name: permissions fk_permissions_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT fk_permissions_group_id FOREIGN KEY (group_id) REFERENCES public.permissions_group(id) ON DELETE CASCADE;


--
-- Name: permissions_group_membership fk_permissions_group_membership_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_group_membership
    ADD CONSTRAINT fk_permissions_group_membership_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: permissions_revision fk_permissions_revision_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions_revision
    ADD CONSTRAINT fk_permissions_revision_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: pulse_card fk_pulse_card_ref_card_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_card
    ADD CONSTRAINT fk_pulse_card_ref_card_id FOREIGN KEY (card_id) REFERENCES public.report_card(id) ON DELETE CASCADE;


--
-- Name: pulse_card fk_pulse_card_ref_pulse_card_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_card
    ADD CONSTRAINT fk_pulse_card_ref_pulse_card_id FOREIGN KEY (dashboard_card_id) REFERENCES public.report_dashboardcard(id) ON DELETE CASCADE;


--
-- Name: pulse_card fk_pulse_card_ref_pulse_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_card
    ADD CONSTRAINT fk_pulse_card_ref_pulse_id FOREIGN KEY (pulse_id) REFERENCES public.pulse(id) ON DELETE CASCADE;


--
-- Name: pulse_channel_recipient fk_pulse_channel_recipient_ref_pulse_channel_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_channel_recipient
    ADD CONSTRAINT fk_pulse_channel_recipient_ref_pulse_channel_id FOREIGN KEY (pulse_channel_id) REFERENCES public.pulse_channel(id) ON DELETE CASCADE;


--
-- Name: pulse_channel_recipient fk_pulse_channel_recipient_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_channel_recipient
    ADD CONSTRAINT fk_pulse_channel_recipient_ref_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: pulse_channel fk_pulse_channel_ref_pulse_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse_channel
    ADD CONSTRAINT fk_pulse_channel_ref_pulse_id FOREIGN KEY (pulse_id) REFERENCES public.pulse(id) ON DELETE CASCADE;


--
-- Name: pulse fk_pulse_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse
    ADD CONSTRAINT fk_pulse_collection_id FOREIGN KEY (collection_id) REFERENCES public.collection(id) ON DELETE SET NULL;


--
-- Name: pulse fk_pulse_ref_creator_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse
    ADD CONSTRAINT fk_pulse_ref_creator_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: pulse fk_pulse_ref_dashboard_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pulse
    ADD CONSTRAINT fk_pulse_ref_dashboard_id FOREIGN KEY (dashboard_id) REFERENCES public.report_dashboard(id) ON DELETE CASCADE;


--
-- Name: qrtz_blob_triggers fk_qrtz_blob_triggers_triggers; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_blob_triggers
    ADD CONSTRAINT fk_qrtz_blob_triggers_triggers FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES public.qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_cron_triggers fk_qrtz_cron_triggers_triggers; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_cron_triggers
    ADD CONSTRAINT fk_qrtz_cron_triggers_triggers FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES public.qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_simple_triggers fk_qrtz_simple_triggers_triggers; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_simple_triggers
    ADD CONSTRAINT fk_qrtz_simple_triggers_triggers FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES public.qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_simprop_triggers fk_qrtz_simprop_triggers_triggers; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_simprop_triggers
    ADD CONSTRAINT fk_qrtz_simprop_triggers_triggers FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES public.qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_triggers fk_qrtz_triggers_job_details; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qrtz_triggers
    ADD CONSTRAINT fk_qrtz_triggers_job_details FOREIGN KEY (sched_name, job_name, job_group) REFERENCES public.qrtz_job_details(sched_name, job_name, job_group);


--
-- Name: report_card fk_report_card_ref_database_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT fk_report_card_ref_database_id FOREIGN KEY (database_id) REFERENCES public.metabase_database(id) ON DELETE CASCADE;


--
-- Name: report_card fk_report_card_ref_table_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_card
    ADD CONSTRAINT fk_report_card_ref_table_id FOREIGN KEY (table_id) REFERENCES public.metabase_table(id) ON DELETE CASCADE;


--
-- Name: revision fk_revision_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revision
    ADD CONSTRAINT fk_revision_ref_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: segment fk_segment_ref_creator_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.segment
    ADD CONSTRAINT fk_segment_ref_creator_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: segment fk_segment_ref_table_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.segment
    ADD CONSTRAINT fk_segment_ref_table_id FOREIGN KEY (table_id) REFERENCES public.metabase_table(id) ON DELETE CASCADE;


--
-- Name: core_session fk_session_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.core_session
    ADD CONSTRAINT fk_session_ref_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: native_query_snippet fk_snippet_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.native_query_snippet
    ADD CONSTRAINT fk_snippet_collection_id FOREIGN KEY (collection_id) REFERENCES public.collection(id) ON DELETE SET NULL;


--
-- Name: native_query_snippet fk_snippet_creator_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.native_query_snippet
    ADD CONSTRAINT fk_snippet_creator_id FOREIGN KEY (creator_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- Name: metabase_table fk_table_ref_database_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metabase_table
    ADD CONSTRAINT fk_table_ref_database_id FOREIGN KEY (db_id) REFERENCES public.metabase_database(id) ON DELETE CASCADE;


--
-- Name: view_log fk_view_log_ref_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_log
    ADD CONSTRAINT fk_view_log_ref_user_id FOREIGN KEY (user_id) REFERENCES public.core_user(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

