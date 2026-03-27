-- ============================================
-- ETAPA 2: Diagnóstico de tendencia de artistas en el tiempo
-- Scripts Examen #2
-- Curso de Tópicos Avanzados de base de datos - UPB 202610
-- Juan Manuel Arias - 000511985
-- Juan Andrés Ciro - 000511559
-- ============================================

WITH artist_weekly_rank AS (
    -- Obtenemos el rank y puntos de cada artista por semana
    SELECT
        a.artist_id,
        a.artist_name,
        c.chart_date,
        MIN(c.rank) AS best_rank,
        SUM(sa.points_ind) AS weekly_points
    FROM core.artist a
    JOIN core.song_artist sa ON sa.artist_id = a.artist_id
    JOIN core.chart c ON c.song_id = sa.song_id
    GROUP BY a.artist_id, a.artist_name, c.chart_date
),

artist_rank_evolution AS (
    -- Comparamos el rank de cada semana con la semana anterior
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
    -- Identificamos si hubo mejora (rank menor = mejor posición)
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
        -- Agrupamos rachas consecutivas de mejora
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
    -- Calculamos duración y puntos acumulados por racha
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
    HAVING COUNT(*) >= 2  -- Al menos 2 semanas consecutivas mejorando
)

-- Resultado final: artistas con su mejor racha de mejora
SELECT
    artist_name,
    weeks_improving,
    total_points_in_streak,
    streak_start,
    streak_end,
    best_rank_in_streak
FROM streak_summary
ORDER BY weeks_improving DESC, total_points_in_streak DESC;