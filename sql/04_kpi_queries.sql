-- Q1 : puissance de talon (médiane 0 h–6 h et dimanche) et part de l'énergie 2018
WITH talon AS (
    SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY power_kw) AS talon_kw
    FROM measurement_enriched
    WHERE local_hour < 6 OR is_sunday
)
SELECT ROUND(talon_kw::numeric, 1)                               AS talon_kw,
       ROUND((100 * talon_kw * 8760 / (SELECT SUM(usage_kwh) FROM measurement_enriched))::numeric, 1) AS part_pct
FROM talon;


-- Q8 : énergie par période tarifaire (MWh et %)
SELECT period,
       ROUND((SUM(usage_kwh) / 1000)::numeric, 1)                              AS energy_mwh,
       ROUND((100 * SUM(usage_kwh) / SUM(SUM(usage_kwh)) OVER ())::numeric, 1) AS share_pct,
       ROUND((100 * COUNT(*) / SUM(COUNT(*)) OVER ()), 1)                AS time_pct 
FROM measurement_enriched
GROUP BY period
ORDER BY energy_mwh DESC;

-- Q4 : pointe mensuelle (kW) avec date et heure locales
WITH ranked AS (
    SELECT DATE_TRUNC('month', ts AT TIME ZONE 'Asia/Seoul') AS month,
           ts AT TIME ZONE 'Asia/Seoul'                      AS local_ts,
           power_kw,
           ROW_NUMBER() OVER (PARTITION BY DATE_TRUNC('month', ts AT TIME ZONE 'Asia/Seoul')
                              ORDER BY power_kw DESC)         AS rank
    FROM measurement_enriched
)
SELECT month::date, local_ts, ROUND(power_kw::numeric, 1) AS peak_kw
FROM ranked
WHERE rank = 1
ORDER BY month;