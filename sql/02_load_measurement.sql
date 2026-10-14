
INSERT INTO site  VALUES (1, 'Steel plant (UCI dataset)', 'KR', 'Asia/Seoul');
INSERT INTO meter VALUES (1, 1, 'Main meter (assumed)');

INSERT INTO measurement (meter_id, ts, usage_kwh, lagging_reactive_kvarh, leading_reactive_kvarh)
SELECT 1,
       ts AT TIME ZONE 'Asia/Seoul',
       usage_kwh, lagging_reactive_kvarh, leading_reactive_kvarh
FROM raw_steel;