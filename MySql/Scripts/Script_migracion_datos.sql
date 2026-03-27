-- Scripts Examen #2
-- Curso de Tópicos Avanzados de base de datos - UPB 202610
-- Juan Manuel Arias - 000511985
-- Juan Andrés Ciro - 000511559
-- ============================================
-- MIGRACIÓN DE DATOS: initial -> core
-- ============================================

USE core;

-- ============================================
-- 1. CONTINENT
-- ============================================

INSERT INTO continent (continent_name)
SELECT DISTINCT continent
FROM initial.spotify_raw
WHERE continent IS NOT NULL;

-- ============================================
-- 2. NATIONALITY
-- ============================================

INSERT INTO nationality (nationality_name, continent_id)
SELECT DISTINCT sr.nationality, c.continent_id
FROM initial.spotify_raw sr
JOIN continent c ON c.continent_name = sr.continent
WHERE sr.nationality IS NOT NULL;

-- ============================================
-- 3. ARTIST
-- ============================================

INSERT INTO artist (artist_name, nationality_id)
SELECT
    sr.artist_ind,
    MIN(n.nationality_id)
FROM initial.spotify_raw sr
JOIN nationality n ON n.nationality_name = sr.nationality
WHERE sr.artist_ind IS NOT NULL
GROUP BY sr.artist_ind;

-- ============================================
-- 4. SONG
-- ============================================

INSERT INTO song (
    spotify_id, title, danceability, energy, loudness,
    speechiness, acousticness, instrumentalness, valence, song_url
)
SELECT
    sr.spotify_id,
    MAX(sr.title),
    MAX(sr.danceability),
    MAX(sr.energy),
    MAX(sr.loudness),
    MAX(sr.speechiness),
    MAX(sr.acousticness),
    MAX(sr.instrumentalness),
    MAX(sr.valence),
    MAX(sr.song_url)
FROM initial.spotify_raw sr
WHERE sr.spotify_id IS NOT NULL
GROUP BY sr.spotify_id;

-- ============================================
-- 5. CHART
-- ============================================

INSERT INTO chart (song_id, rank_position, chart_date, points_total)
SELECT
    s.song_id,
    MIN(sr.rank_position),
    STR_TO_DATE(NULLIF(sr.chart_date,''), '%d/%m/%Y'),
    MAX(sr.points_total)
FROM initial.spotify_raw sr
JOIN song s ON s.spotify_id = sr.spotify_id
GROUP BY
    s.song_id,
    STR_TO_DATE(NULLIF(sr.chart_date,''), '%d/%m/%Y');

-- ============================================
-- 6. SONG_ARTIST
-- ============================================
INSERT INTO song_artist (song_id, artist_id, points_ind, artist_order)
SELECT
    s.song_id,
    a.artist_id,
    MAX(sr.points_ind),
    1
FROM initial.spotify_raw sr
JOIN song s ON s.spotify_id = sr.spotify_id
JOIN artist a ON a.artist_name = sr.artist_ind
GROUP BY s.song_id, a.artist_id;


WITH artist_weekly_rank AS (
    SELECT
        a.artist_id,
        a.artist_name,
        c.chart_date,
        MIN(c.rank_position) AS best_rank,
        SUM(sa.points_ind) AS weekly_points
    FROM artist a
    JOIN song_artist sa ON sa.artist_id = a.artist_id
    JOIN chart c ON c.song_id = sa.song_id
    GROUP BY a.artist_id, a.artist_name, c.chart_date
),

artist_rank_evolution AS (
    SELECT
        artist_id,
        artist_name,
        chart_date,
        best_rank,
        weekly_points,
        LAG(best_rank) OVER (
            PARTITION BY artist_id
            ORDER BY chart_date
        ) AS prev_rank
    FROM artist_weekly_rank
),

artist_streaks AS (
    SELECT
        artist_id,
        artist_name,
        chart_date,
        best_rank,
        weekly_points,
        prev_rank,
        CASE
            WHEN prev_rank IS NOT NULL AND best_rank < prev_rank THEN 1
            ELSE 0
        END AS improved,
        SUM(
            CASE
                WHEN prev_rank IS NOT NULL AND best_rank < prev_rank THEN 0
                ELSE 1
            END
        ) OVER (
            PARTITION BY artist_id
            ORDER BY chart_date
        ) AS streak_group
    FROM artist_rank_evolution
),

streak_summary AS (
    SELECT
        artist_id,
        artist_name,
        streak_group,
        COUNT(*) AS weeks_improving,
        SUM(weekly_points) AS total_points_in_streak,
        MIN(chart_date) AS streak_start,
        MAX(chart_date) AS streak_end,
        MIN(best_rank) AS best_rank_in_streak
    FROM artist_streaks
    WHERE improved = 1
    GROUP BY artist_id, artist_name, streak_group
    HAVING COUNT(*) >= 2
)

SELECT
    artist_name,
    weeks_improving,
    total_points_in_streak,
    streak_start,
    streak_end,
    best_rank_in_streak
FROM streak_summary
ORDER BY weeks_improving DESC, total_points_in_streak DESC;