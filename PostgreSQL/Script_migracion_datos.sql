-- ============================================
-- MIGRACIÓN DE DATOS: initial -> core
-- Scripts Examen #2
-- Curso de Tópicos Avanzados de base de datos - UPB 202610
-- Juan Manuel Arias - 000511985
-- Juan Andrés Ciro - 000511559
-- ============================================

SET search_path TO core, initial;

-- ============================================
-- 1. CONTINENT
-- ============================================
INSERT INTO core.continent (continent_name)
SELECT DISTINCT continent
FROM initial.spotify_raw
WHERE continent IS NOT NULL;

-- ============================================
-- 2. NATIONALITY
-- ============================================
INSERT INTO core.nationality (nationality_name, continent_id)
SELECT DISTINCT sr.nationality, c.continent_id
FROM initial.spotify_raw sr
JOIN core.continent c ON c.continent_name = sr.continent
WHERE sr.nationality IS NOT NULL;

-- ============================================
-- 3. ARTIST
-- ============================================
INSERT INTO core.artist (artist_name, nationality_id)
SELECT DISTINCT ON (sr.artist_ind)
    sr.artist_ind,
    n.nationality_id
FROM initial.spotify_raw sr
JOIN core.nationality n ON n.nationality_name = sr.nationality
WHERE sr.artist_ind IS NOT NULL
ORDER BY sr.artist_ind;

-- ============================================
-- 4. SONG
-- ============================================
INSERT INTO core.song (spotify_id, title, danceability, energy, loudness,
                        speechiness, acousticness, instrumentalness, valence, song_url)
SELECT DISTINCT ON (sr.spotify_id)
    sr.spotify_id,
    sr.title,
    sr.danceability,
    sr.energy,
    sr.loudness,
    sr.speechiness,
    sr.acousticness,
    sr.instrumentalness,
    sr.valence,
    sr.song_url
FROM initial.spotify_raw sr
WHERE sr.spotify_id IS NOT NULL
ORDER BY sr.spotify_id;

-- ============================================
-- 5. CHART
-- ============================================
INSERT INTO core.chart (song_id, rank, chart_date, points_total)
SELECT DISTINCT ON (s.song_id, TO_DATE(sr.date, 'DD/MM/YYYY'))
    s.song_id,
    sr.rank,
    TO_DATE(sr.date, 'DD/MM/YYYY'),
    sr.points_total
FROM initial.spotify_raw sr
JOIN core.song s ON s.spotify_id = sr.spotify_id
ORDER BY s.song_id, TO_DATE(sr.date, 'DD/MM/YYYY');

-- ============================================
-- 6. SONG_ARTIST
-- ============================================
INSERT INTO core.song_artist (song_id, artist_id, points_ind, artist_order)
SELECT DISTINCT ON (s.song_id, a.artist_id)
    s.song_id,
    a.artist_id,
    sr.points_ind,
    ROW_NUMBER() OVER (PARTITION BY sr.spotify_id ORDER BY sr.artist_ind) AS artist_order
FROM initial.spotify_raw sr
JOIN core.song s ON s.spotify_id = sr.spotify_id
JOIN core.artist a ON a.artist_name = sr.artist_ind
ORDER BY s.song_id, a.artist_id;