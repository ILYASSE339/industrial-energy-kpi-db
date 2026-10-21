DROP VIEW  IF EXISTS measurement_enriched;
DROP TABLE IF EXISTS emission_factor;

-- 1. Périodes tarifaires (hypothèse : grille horaire coréenne)
ALTER TABLE measurement DROP COLUMN IF EXISTS period_id;
DROP TABLE IF EXISTS tariff_period;

CREATE TABLE tariff_period (
    period_id  smallint PRIMARY KEY,
    code       text NOT NULL UNIQUE,     -- 'Light_Load', ...
    label      text NOT NULL             -- 'Heures creuses', ...
);
INSERT INTO tariff_period VALUES
    (1, 'Light_Load',   'Heures creuses'),
    (2, 'Medium_Load',  'Heures pleines'),
    (3, 'Maximum_Load', 'Heures de pointe');

ALTER TABLE measurement ADD COLUMN period_id smallint REFERENCES tariff_period (period_id);

UPDATE measurement m
SET    period_id = tp.period_id
FROM   raw_steel r
JOIN   tariff_period tp ON tp.code = r.load_type
WHERE  m.ts = r.ts AT TIME ZONE 'Asia/Seoul';

-- 2. Facteur d'émission : un paramètre daté, pas un résultat stocké
CREATE TABLE emission_factor (
    site_id         integer NOT NULL REFERENCES site (site_id),
    valid_from      date    NOT NULL,
    valid_to        date    NOT NULL,
    kg_co2_per_kwh  numeric NOT NULL CHECK (kg_co2_per_kwh >= 0),
    source          text    NOT NULL,
    PRIMARY KEY (site_id, valid_from)
);

INSERT INTO emission_factor VALUES
    (1, '2018-01-01', '2018-12-31', 0.46,
     'Estimé sur les intervalles >= 100 kWh du dataset UCI (CO2 source arrondi à 0,01 t ; résidu ±0,04 kg/kWh non expliqué)');


CREATE VIEW measurement_enriched AS
SELECT m.ts,
       m.usage_kwh,
       m.lagging_reactive_kvarh,
       m.leading_reactive_kvarh,
       m.usage_kwh * 4                                                  AS power_kw,
       (m.usage_kwh * 4) / NULLIF(SQRT(POWER(m.usage_kwh * 4, 2) + POWER(m.lagging_reactive_kvarh * 4, 2)), 0) AS pf_lagging,
       EXTRACT(HOUR   FROM m.ts AT TIME ZONE 'Asia/Seoul')              AS local_hour,
       EXTRACT(ISODOW FROM m.ts AT TIME ZONE 'Asia/Seoul')              AS iso_dow,
       (EXTRACT(ISODOW FROM m.ts AT TIME ZONE 'Asia/Seoul') = 7)        AS is_sunday,
       tp.label                                                         AS period,
       m.usage_kwh * ef.kg_co2_per_kwh / 1000                           AS co2_t
FROM measurement m
JOIN tariff_period   tp ON m.period_id = tp.period_id
JOIN meter           mt ON mt.meter_id = m.meter_id
JOIN emission_factor ef ON ef.site_id = mt.site_id
                       AND (m.ts AT TIME ZONE 'Asia/Seoul')::date BETWEEN ef.valid_from AND ef.valid_to;