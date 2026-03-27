-- Scripts Examen #2
-- Curso de Tópicos Avanzados de base de datos - UPB 202610
-- Juan Manuel Arias - 000511985
-- Juan Andrés Ciro - 000511559
============================================
-- TABLA: DATOS CRUDOS
-- ============================================

USE initial;

CREATE TABLE spotify_raw (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rank_position INT,
    title VARCHAR(200),
    artists VARCHAR(500),
    chart_date DATE,
    danceability DECIMAL(10,5),
    energy DECIMAL(10,5),
    loudness DECIMAL(10,5),
    speechiness DECIMAL(10,5),
    acousticness DECIMAL(10,5),
    instrumentalness DECIMAL(10,5),
    valence DECIMAL(10,5),
    num_artists INT,
    artist_ind VARCHAR(200),
    num_nationality INT,
    nationality VARCHAR(100),
    continent VARCHAR(100),
    points_total INT,
    points_ind DECIMAL(10,5),
    spotify_id VARCHAR(100),
    song_url TEXT
);


USE core;

-- ============================================
-- TABLA: CONTINENT
-- ============================================

CREATE TABLE continent (
    continent_id INT AUTO_INCREMENT PRIMARY KEY,
    continent_name VARCHAR(100) NOT NULL UNIQUE
);

-- ============================================
-- TABLA: NATIONALITY
-- ============================================

CREATE TABLE nationality (
    nationality_id INT AUTO_INCREMENT PRIMARY KEY,
    nationality_name VARCHAR(100) NOT NULL UNIQUE,
    continent_id INT NOT NULL,
    CONSTRAINT nationality_continent_fk
        FOREIGN KEY (continent_id)
        REFERENCES continent (continent_id)
);

-- ============================================
-- TABLA: ARTIST
-- ============================================

CREATE TABLE artist (
    artist_id INT AUTO_INCREMENT PRIMARY KEY,
    artist_name VARCHAR(150) NOT NULL UNIQUE,
    nationality_id INT NOT NULL,
    CONSTRAINT artist_nationality_fk
        FOREIGN KEY (nationality_id)
        REFERENCES nationality (nationality_id)
);

-- ============================================
-- TABLA: SONG
-- ============================================

CREATE TABLE song (
    song_id INT AUTO_INCREMENT PRIMARY KEY,
    spotify_id VARCHAR(100) NOT NULL UNIQUE,
    title VARCHAR(200) NOT NULL,
    danceability DECIMAL(10,5),
    energy DECIMAL(10,5),
    loudness DECIMAL(10,5),
    speechiness DECIMAL(10,5),
    acousticness DECIMAL(10,5),
    instrumentalness DECIMAL(10,5),
    valence DECIMAL(10,5),
    song_url VARCHAR(500) NOT NULL UNIQUE
);

-- ============================================
-- TABLA: SONG_ARTIST
-- ============================================

CREATE TABLE song_artist (
    song_id INT NOT NULL,
    artist_id INT NOT NULL,
    points_ind DECIMAL(10,5),
    artist_order SMALLINT,

    PRIMARY KEY (song_id, artist_id),

    CONSTRAINT song_artist_song_fk
        FOREIGN KEY (song_id)
        REFERENCES song (song_id)
        ON DELETE CASCADE,

    CONSTRAINT song_artist_artist_fk
        FOREIGN KEY (artist_id)
        REFERENCES artist (artist_id)
        ON DELETE CASCADE
);

-- ============================================
-- TABLA: CHART
-- ============================================

CREATE TABLE chart (
    chart_id INT AUTO_INCREMENT PRIMARY KEY,
    song_id INT NOT NULL,
    rank_position INT NOT NULL,
    chart_date DATE NOT NULL,
    points_total INT NOT NULL,

    CONSTRAINT chart_song_fk
        FOREIGN KEY (song_id)
        REFERENCES song (song_id)
        ON DELETE CASCADE,

    UNIQUE (song_id, chart_date),

    CHECK (rank_position > 0),
    CHECK (points_total >= 0)
);

-- ============================================
-- ÍNDICES
-- ============================================

CREATE INDEX idx_song_spotify_id
    ON song (spotify_id);

CREATE INDEX idx_chart_date
    ON chart (chart_date);

CREATE INDEX idx_chart_song
    ON chart (song_id);

CREATE INDEX idx_artist_name
    ON artist (artist_name);

CREATE INDEX idx_chart_date_rank
    ON chart (chart_date, rank_position);