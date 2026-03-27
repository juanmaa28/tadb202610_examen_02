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
-- ========================================
-- PASO 1: Crear las bases de datos

CREATE DATABASE IF NOT EXISTS initial;
CREATE DATABASE IF NOT EXISTS core;

-- ========================================
-- PASO 2: Usuario spotify_app
-- ========================================
CREATE USER IF NOT EXISTS 'spotify_app'@'%' IDENTIFIED BY 'Jm_000511986';

-- En PostgreSQL:
-- GRANT CONNECT, CREATE ON DATABASE
-- GRANT CREATE, USAGE ON SCHEMA

-- Permitir acceso y creación de objetos dentro de core
GRANT CREATE ON core.* TO 'spotify_app'@'%';

-- Permitir acceso a initial (solo uso del schema)
GRANT USAGE ON initial.* TO 'spotify_app'@'%';

-- ========================================
-- PASO 3: Usuario spotify_usr
-- ========================================
CREATE USER IF NOT EXISTS 'spotify_usr'@'%' IDENTIFIED BY 'Jm_000511559';

GRANT USAGE ON core.* TO 'spotify_usr'@'%';

-- Privilegios sobre tablas (core)
GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER ON core.* TO 'spotify_usr'@'%';

-- Privilegios sobre rutinas (funciones y procedimientos)
GRANT EXECUTE ON core.* TO 'spotify_usr'@'%';

-- ========================================
-- Privilegios sobre initial
-- ========================================

-- Acceso básico
GRANT USAGE ON initial.* TO 'spotify_usr'@'%';

-- Tablas
GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER ON initial.* TO 'spotify_usr'@'%';

-- Rutinas
GRANT EXECUTE ON initial.* TO 'spotify_usr'@'%';

FLUSH PRIVILEGES;