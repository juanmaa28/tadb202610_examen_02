-- Scripts Examen #2
-- Curso de Tópicos Avanzados de base de datos - UPB 202610
-- Juan Manuel Arias - 000511985
-- Juan Andrés Ciro - 000511559

-- Proyecto: Spotify Charts
-- Motor de Base de datos: PostgreSQL 17.x

-- ****************************************
-- Creación de base de datos y usuarios
-- ****************************************

-- ============================================
-- ESQUEMA INICIAL: Tabla temporal con datos crudos
-- ============================================

create schema if not exists initial;

create table initial.spotify_raw (
    rank                int,
    title               varchar(200),
    artists             varchar(500),
    date                date,
    danceability        numeric,
    energy              numeric,
    loudness            numeric,
    speechiness         numeric,
    acousticness        numeric,
    instrumentalness    numeric,
    valence             numeric,
    num_artists         int,
    artist_ind          varchar(200),
    num_nationality     int,
    nationality         varchar(100),
    continent           varchar(100),
    points_total        int,
    points_ind          numeric,
    spotify_id          varchar(100),
    song_url            text
);

-- Creamos un esquema para almacenar todo el modelo de datos del dominio
create schema core;

-- crear el usuario con el que se implementará la creación del modelo
create user spotify_app with encrypted password 'Jm_000511986';

-- asignación de privilegios para el usuario
grant connect on database neondb to spotify_app;
grant create on database neondb to spotify_app;
grant create, usage on schema core to spotify_app;
alter user spotify_app set search_path to core;

-- crear el usuario con el que se conectará la aplicación
create user spotify_usr with encrypted password 'Jm_000511559';

-- asignación de privilegios para el usuario
grant connect on database neondb to spotify_usr;
grant usage on schema core to spotify_usr;

-- Privilegios sobre tablas existentes
grant select, insert, update, delete, trigger on all tables in schema core to spotify_usr;

-- privilegios sobre secuencias existentes
grant usage, select on all sequences in schema core to spotify_usr;

-- privilegios sobre funciones existentes
grant execute on all functions in schema core to spotify_usr;

-- privilegios sobre procedimientos existentes
grant execute on all procedures in schema core to spotify_usr;

-- privilegios sobre objetos futuros
alter default privileges in schema core grant select, insert, update, delete on tables TO spotify_usr;
alter default privileges in schema core grant execute on routines to spotify_usr;

alter user spotify_usr set search_path to core;

-- Activar la extensión que permite el uso de UUID
create extension if not exists "uuid-ossp";