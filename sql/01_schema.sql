-- Schéma relationnel : mesures énergétiques de l'aciérie
-- Relançable : supprime puis recrée les tables

DROP TABLE IF EXISTS measurement, meter, site;

CREATE TABLE site (
    site_id   integer PRIMARY KEY,
    name      text NOT NULL,
    country   text NOT NULL,
    timezone  text NOT NULL          -- fuseau horaire des données source
);

CREATE TABLE meter (
    meter_id    integer PRIMARY KEY,
    site_id     integer NOT NULL REFERENCES site(site_id),
    description text
);

CREATE TABLE measurement (
    meter_id                integer NOT NULL REFERENCES meter(meter_id),
    ts                      timestamptz NOT NULL,            -- début de l'intervalle de 15 min
    usage_kwh               double precision NOT NULL CHECK (usage_kwh >= 0),
    lagging_reactive_kvarh  double precision NOT NULL CHECK (lagging_reactive_kvarh >= 0),
    leading_reactive_kvarh  double precision NOT NULL CHECK (leading_reactive_kvarh >= 0),
    PRIMARY KEY (meter_id, ts)
);
