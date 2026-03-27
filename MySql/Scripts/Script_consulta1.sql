-- ============================================
-- ETAPA 2: Diagnóstico de tendencia de artistas en el tiempo
-- Scripts Examen #2
-- Curso de Tópicos Avanzados de base de datos - UPB 202610
-- Juan Manuel Arias - 000511985
-- Juan Andrés Ciro - 000511559
-- ============================================
CREATE TEMPORARY TABLE temp_continent_points (
    continent_id INT,
    continent_name VARCHAR(100),
    chart_date DATE,
    continent_points DOUBLE,
    PRIMARY KEY (continent_id, chart_date)
)
AS
SELECT
    co.continent_id,
    co.continent_name,
    c.chart_date,
    SUM(sa.points_ind) AS continent_points
FROM continent co
JOIN nationality n ON n.continent_id = co.continent_id
JOIN artist a ON a.nationality_id = n.nationality_id
JOIN song_artist sa ON sa.artist_id = a.artist_id
JOIN chart c ON c.song_id = sa.song_id
GROUP BY co.continent_id, co.continent_name, c.chart_date;

CREATE TEMPORARY TABLE temp_global (
    chart_date DATE,
    global_points DOUBLE,
    PRIMARY KEY (chart_date)
)
AS
SELECT
    chart_date,
    SUM(continent_points) AS global_points
FROM temp_continent_points
GROUP BY chart_date;

SELECT
    tcp.continent_name,
    tcp.chart_date,
    tcp.continent_points,
    tg.global_points,
    ROUND((tcp.continent_points / tg.global_points) * 100, 2) AS participation_pct,
    RANK() OVER (
        PARTITION BY tcp.chart_date
        ORDER BY tcp.continent_points DESC
    ) AS weekly_rank
FROM temp_continent_points tcp
JOIN temp_global tg ON tg.chart_date = tcp.chart_date
ORDER BY tcp.chart_date ASC, weekly_rank ASC;
-- se usa este metodo ya que la nube utilizada no soportaba procesos muy pesados simultaneamente ya que es el plan gratuito