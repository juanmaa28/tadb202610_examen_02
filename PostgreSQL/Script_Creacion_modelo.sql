-- Scripts Examen #2
-- Curso de Tópicos Avanzados de base de datos - UPB 202610
-- Juan Manuel Arias - 000511985
-- Juan Andrés Ciro - 000511559


-- Permisos sobre el esquema initial para spotify_app
GRANT CREATE, USAGE ON SCHEMA initial TO spotify_app;

-- Permisos sobre el esquema initial para spotify_usr
GRANT USAGE ON SCHEMA initial TO spotify_usr;

-- Privilegios sobre tablas existentes
GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER ON ALL TABLES IN SCHEMA initial TO spotify_usr;

-- Privilegios sobre secuencias existentes
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA initial TO spotify_usr;

-- Privilegios sobre funciones existentes
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA initial TO spotify_usr;

-- Privilegios sobre procedimientos existentes
GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA initial TO spotify_usr;

-- Privilegios sobre objetos futuros
ALTER DEFAULT PRIVILEGES IN SCHEMA initial 
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO spotify_usr;

ALTER DEFAULT PRIVILEGES IN SCHEMA initial 
    GRANT EXECUTE ON ROUTINES TO spotify_usr;


-- Trabajamos sobre el esquema core
set search_path to core;

-- ============================================
-- TABLA: CONTINENT
-- ============================================
create table core.continent (
    continent_id serial primary key,
    continent_name varchar(100) not null unique
);

-- ============================================
-- TABLA: NATIONALITY
-- ============================================
create table core.nationality (
    nationality_id serial primary key,
    nationality_name varchar(100) not null unique,
    continent_id int not null,
    constraint nationality_continent_fk
        foreign key (continent_id)
        references core.continent (continent_id)
);

-- ============================================
-- TABLA: ARTIST
-- ============================================
create table core.artist (
    artist_id serial primary key,
    artist_name varchar(150) not null unique,
    nationality_id int not null,
    constraint artist_nationality_fk
        foreign key (nationality_id)
        references core.nationality (nationality_id)
);

-- ============================================
-- TABLA: SONG
-- ============================================
create table core.song (
    song_id serial primary key,
    spotify_id varchar(100) not null unique,
    title varchar(200) not null,
    danceability numeric,
    energy numeric,
    loudness numeric,
    speechiness numeric,
    acousticness numeric,
    instrumentalness numeric,
    valence numeric,
    song_url text not null unique
);

-- ============================================
-- TABLA: SONG_ARTIST 
-- ============================================
create table core.song_artist (
    song_id int not null,
    artist_id int not null,
    points_ind numeric,
    artist_order smallint,

    constraint song_artist_pk
        primary key (song_id, artist_id),

    constraint song_artist_song_fk
        foreign key (song_id)
        references core.song (song_id)
        on delete cascade,

    constraint song_artist_artist_fk
        foreign key (artist_id)
        references core.artist (artist_id)
        on delete cascade
);

-- ============================================
-- TABLA: CHART
-- ============================================
create table core.chart (
    chart_id serial primary key,
    song_id int not null,
    rank int not null,
    chart_date date not null,
    points_total int not null,

    constraint chart_song_fk
        foreign key (song_id)
        references core.song (song_id)
        on delete cascade,

    constraint chart_unique_song_date
        unique (song_id, chart_date),

    constraint chart_rank_check
        check (rank > 0),

    constraint chart_points_check
        check (points_total >= 0)
);

-- ============================================
-- ÍNDICES
-- ============================================

create index idx_song_spotify_id
    on core.song (spotify_id);

create index idx_chart_date
    on core.chart (chart_date);

create index idx_chart_song
    on core.chart (song_id);

create index idx_artist_name
    on core.artist (artist_name);

create index idx_chart_date_rank
    on core.chart (chart_date, rank);
