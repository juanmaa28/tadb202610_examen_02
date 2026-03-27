-- ============================================
-- ETAPA 2: Diagnóstico de tendencia de artistas en el tiempo
-- Scripts Examen #2
-- Curso de Tópicos Avanzados de base de datos - UPB 202610
-- Juan Manuel Arias - 000511985
-- Juan Andrés Ciro - 000511559
-- ============================================

WITH continent_weekly_points AS (
    -- Puntos aportados por cada continente cada semana
    SELECT
        co.continent_id,
        co.continent_name,
        c.chart_date,
        SUM(sa.points_ind) AS continent_points
    FROM core.continent co
    JOIN core.nationality n ON n.continent_id = co.continent_id
    JOIN core.artist a ON a.nationality_id = n.nationality_id
    JOIN core.song_artist sa ON sa.artist_id = a.artist_id
    JOIN core.chart c ON c.song_id = sa.song_id
    GROUP BY co.continent_id, co.continent_name, c.chart_date
),

global_weekly_points AS (
    -- Total global de puntos por semana
    SELECT
        chart_date,
        SUM(continent_points) AS global_points
    FROM continent_weekly_points
    GROUP BY chart_date
),

continent_participation AS (
    -- Participación porcentual de cada continente por semana
    SELECT
        cwp.continent_name,
        cwp.chart_date,
        cwp.continent_points,
        gwp.global_points,
        ROUND(
            (CAST(cwp.continent_points AS DECIMAL(18,2)) / gwp.global_points) * 100,
            2
        ) AS participation_pct,
        RANK() OVER (
            PARTITION BY cwp.chart_date
            ORDER BY cwp.continent_points DESC
        ) AS weekly_rank
    FROM continent_weekly_points cwp
    JOIN global_weekly_points gwp 
        ON gwp.chart_date = cwp.chart_date
)

-- Resultado final
SELECT
    continent_name,
    chart_date,
    continent_points,
    global_points,
    participation_pct,
    weekly_rank
FROM continent_participation
ORDER BY chart_date ASC, weekly_rank ASC;