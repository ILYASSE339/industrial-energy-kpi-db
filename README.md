# Industrial Energy KPI Database

Turning raw 15-minute meter data from a steel plant into reliable energy
performance indicators that support energy-efficiency decisions.

**Status:** v1.0 — complete. Next step: the same approach applied to a steam-power utilities optimizer.

## Key findings

| | Finding | Why it matters |
|---|---|---|
| 1 | **Base load of 13 kW = 11.8 % of annual energy** (114 MWh, 52 tCO₂) | Consumed even when the plant is idle; each permanent kW costs 8.76 MWh/year |
| 2 | **Peak hours carry 44.9 % of energy for 20.8 % of the time** | Production sits in the most expensive tariff hours |
| 3 | **Monthly peaks come from the morning ramp-up**, 4 of 12 on Mondays | The billed peak can be lowered by staggering start-ups, without investment |
| 4 | **Reactive power is above the French billing threshold**: energy-weighted tan φ = 0.48 (> 0.4), 53–77 % of operating time above 0.4 depending on the month | A compensation study is justified |
| 5 | **The source CO₂ column underestimates emissions by about 9 %** | Rounding to 0.01 t sets base-load intervals to zero; recomputed with 0.46 kg/kWh |

The project follows a DMAIC structure: **Define** (section 1), **Measure** (data quality, section 3),
**Analyze** (sections 4–5), **Improve** (section 6), **Control** (section 6 and limitations, section 7).

## 1. Problem

Managing & monitoring energy consumption in an industrial plant requires a robust analysis and verification
of metering data in order to propose intelligent management strategies and spot any drift in the plant's
energy behaviour. This project replicates the standard process a robust energy monitoring would look like.

The user is the plant's **energy manager**. The 15 business questions the database must answer, each tied to a
decision (base load, peak demand, load shifting, reactive power, carbon), are listed in
[`sql/questions.md`](sql/questions.md).

## 2. System

A steel plant whose electricity consumption is metered every 15 minutes.
Measured quantities: active energy (kWh), lagging and leading reactive energy (kVarh),
lagging and leading power factor (%), CO₂ emissions (tCO₂), and a load-type label.

## 3. Data

- **Source:** UCI Machine Learning Repository — *Steel Industry Energy Consumption*. Raw data is not versioned
  in this repository; download it from the source and place the CSV in `data/raw/`.
- **Coverage:** year 2018, 15-minute resolution, 35,040 records.

### Data quality checks

| Check | Result |
|---|---|
| Completeness against the theoretical 15-min grid | 35,040 / 35,040 — no gaps |
| Duplicate timestamps | 0 |
| Missing values | 0 in all columns |
| Date parsing cross-check (computed weekday vs. `Day_of_week`) | 0 mismatches |
| Physical plausibility (energies ≥ 0) | 35,040 rows accepted by the database `CHECK` constraints |
| Power-factor recomputation from P and Q | mean absolute deviation 0.002 percentage points (max 0.005) — the source PF is computed from P and Q |
| Zero-energy intervals | 1 (P = Q = 0, power factor undefined) |
| Staging → model transfer | 35,040 rows, identical energy total (959.6 MWh) |

### Findings about the source data

- **The load type is a time-of-use grid, not an observed load.** Every interval between 00:00 and 09:00 is
  "Light"; about 62 days (Sundays and holidays) are "Light" all day; the remaining 303 days follow two seasonal
  schedules. It is stored as a tariff-period reference (`tariff_period`), labelled as an assumption.
- **The CO₂ column is rounded to 0.01 t.** Low-energy intervals (base load ≈ 4 kWh) show 0 t. The CO₂/kWh ratio
  stabilises at **0.46 kg/kWh** on intervals ≥ 100 kWh, and its dispersion decreases with interval energy — the
  signature of rounding, not of a variable emission factor. A residual of about ±0.04 kg/kWh remains unexplained.
- **The power factor columns are derived, not measured:** recomputing PF = P / √(P² + Q²) reproduces the source
  values to within their 0.01 % rounding. They are therefore not stored in the model and are recomputed in the view.
- **Consequence:** summing the source CO₂ column gives 403.8 t for 2018; recomputing with 0.46 kg/kWh gives
  441.4 t. **The source underestimates annual emissions by about 9 %.**

### Assumptions

- Timestamps mark the **start** of each 15-minute interval (series runs from 2018-01-01 00:00 to 2018-12-31 23:45).
  Not confirmed by the source documentation; impact limited to intervals at day boundaries.
- Source timestamps are local time in Korea (`Asia/Seoul`, UTC+9, no daylight saving time). They are stored in
  UTC (`timestamptz`) and converted back to local time for hourly and daily analysis.

## 4. Method

```text
raw CSV → quality checks (notebooks) → staging table raw_steel → relational model → enriched view → KPI queries
```

**Relational model** (`sql/01_schema.sql`, `sql/03_reference_tables.sql`):

```text
site (site_id PK, name, country, timezone)
  └── meter (meter_id PK, site_id FK)
        └── measurement (meter_id FK, ts timestamptz, usage_kwh, lagging_reactive_kvarh,
                         leading_reactive_kvarh, period_id FK)        PK = (meter_id, ts)
tariff_period   (period_id PK, code, label)
emission_factor (site_id FK, valid_from, valid_to, kg_co2_per_kwh, source)   PK = (site_id, valid_from)
```

Design rules:
- **Constraints enforce quality permanently:** the primary key rejects duplicates, `CHECK` rejects negative
  energies, foreign keys reject unknown meters or periods.
- **Derived values are never stored.** Power (kW = kWh × 4), power factor, local hour, weekday, Sunday flag and CO₂
  are computed in the view `measurement_enriched`.
- **Parameters are stored with their validity period** (emission factor), so updating a factor updates every
  calculation that depends on it.
- Energy is aggregated by **sum**; peak demand by **max**; power factors are recomputed from summed P and Q,
  never averaged.

## 5. Results

### Monthly energy and peak demand (exploration, pandas)

| Month | Energy (MWh) | Peak (kW) | Form factor (peak / mean power) |
|---|---:|---:|---:|
| Jan | 126.2 | 612.6 | 3.6 |
| Feb | 91.5 | 582.0 | 4.3 |
| Mar | 80.2 | 605.2 | 5.6 |
| Apr | 78.8 | 556.1 | 5.1 |
| May | 79.1 | 560.2 | 5.3 |
| Jun | 65.4 | 535.4 | 5.9 |
| Jul | 81.7 | 486.7 | 4.4 |
| Aug | 68.6 | 534.8 | 5.8 |
| Sep | 57.9 | 510.5 | 6.3 |
| Oct | 84.7 | 557.7 | 4.9 |
| Nov | 86.2 | **628.7** | 5.3 |
| Dec | 59.4 | 596.7 | **7.5** |
| **2018** | **959.6** | **628.7** | |

**Reading for the energy manager:**
- **Energy varies by a factor of 2.2 between months** (January 126 MWh, September 58 MWh), but **peak demand stays
  between 487 and 629 kW all year.** Peaks do not follow activity.
- **The form factor rises when activity drops** (December: 7.5). In low-activity months, the plant still calls
  near-full power for short periods: peak-related costs weigh relatively more. Peak management (load shifting,
  scheduling of large consumers) deserves analysis, starting with the months with the highest form factor.
- **The plant runs in two regimes:** median power 18.3 kW versus mean 109.5 kW. Three quarters of the intervals are
  below 205 kW; the annual peak is **628.7 kW on Thursday 22 November 2018 at 09:45** (local time), a working-day
  morning, consistent with production.

### KPI queries (SQL, `sql/04_kpi_queries.sql`)

| Question | Result | Interpretation |
|---|---|---|
| Q1 — Base load | **13.0 kW**, i.e. 114 MWh/year, **11.8 %** of annual energy | Even when idle (nights, Sundays), the plant draws 13 kW. Each permanent kW costs 8.76 MWh/year: worth an audit of permanent consumers. |
| Q4 — Monthly peak with date and time | 487–629 kW; **all on working days, 8 of 12 between 09:00 and 11:15, 4 on Mondays** | The billed peak is set by the morning ramp-up, probably the simultaneous start of large consumers after the Sunday stop. Staggering start-ups is a no-investment lever. Three peaks fall exactly at 09:00, the last off-peak quarter-hour before the tariff switch — to investigate. |
| Q7 — Hourly profile (working days vs Sundays) | Working days: ~17.5 kW at night, **ramp-up 08:00–09:00** (19 → 168 → 263 kW), **lunch dip at 12:00** (82 kW), second plateau 14:00–16:00 (~250 kW), reduced evening 18:00–20:00 (~150–175 kW), **slow shutdown 21:00–01:00** (62 → 26 kW). Sundays: 13–16 kW at night but **45–64 kW between 08:00 and 16:00** | Two daily ramp-ups (08:00 and 13:00) explain the peak timestamps of Q4: 9 in the morning (09:00–12:00), 3 in the early afternoon (13:45–14:30). The shutdown tail costs about 24 MWh/year above base load. Sunday daytime consumption is well above base load: something runs on Sundays — to investigate. |
| Q8 — Energy by tariff period | Peak hours: **44.9 %** of energy for **20.8 %** of time (×2.2); shoulder 38.8 % / 27.7 %; off-peak 16.2 % / 51.6 % | Production is concentrated in the most expensive hours. Shifting part of it to shoulder or off-peak hours is a significant cost lever, to quantify with the actual tariff. |
| Q10 — Share of operating time with tan φ > 0.4, by month | **53–77 %** depending on the month (max October 77.0 %, min February 53.4 %); energy-weighted tan φ over 2018 = **0.48** | The plant is structurally above the 0.4 threshold, not only at low load. The split by tariff period (billing applies to daytime winter periods in France) is the next check before sizing compensation. |

## 6. Recommendations (Improve) and follow-up (Control)

| Lever | Action | Expected effect | Follow-up indicator |
|---|---|---|---|
| Base load | Audit of permanent consumers at night and on Sundays (compressors, cooling, lighting, idle equipment) | Each kW removed saves 8.76 MWh and about 4 tCO₂ per year | Monthly median power at night and on Sundays |
| Peak demand | Stagger the morning start-up of large consumers, especially on Mondays | Lower billed monthly peak, no investment | Monthly peak with date and time (Q4) |
| Load shifting | Assess which production steps can move from peak to shoulder or off-peak hours | Lower energy cost, to quantify with the actual tariff | Share of energy in peak hours (Q8) |
| Reactive power | Compensation study: automatic stepped capacitor bank (load varies from 13 to 630 kW), after a harmonics check | Avoided reactive charges, lower losses, freed transformer capacity | Monthly energy-weighted tan φ and share of time above 0.4 (Q10) |
| Shutdown tail | Review the end-of-day shutdown sequence (21:00–01:00) | About 24 MWh/year above base load | Average power 22:00–01:00 on working days (Q7) |

A worked DMAIC project charter for base-load reduction is available in [`docs/dmaic_talon.md`](docs/dmaic_talon.md).

## 7. Limitations

- Single site, single year: no inter-annual comparison is possible.
- **No production data:** specific energy consumption (kWh per tonne), the key efficiency indicator, cannot be computed.
- Tariff periods are inferred from the load-type label; the exact rule (holidays, season dates) is unknown.
- CO₂ is recomputed with a single emission factor estimated from the data (0.46 kg/kWh, residual ±0.04).
- The timestamp convention (start of interval) is an assumption.

## 8. How to run

Requirements: [uv](https://docs.astral.sh/uv/) and PostgreSQL.

```bash
git clone https://github.com/ILYASSE339/industrial-energy-kpi-db.git
cd industrial-energy-kpi-db
uv sync                                   # recreates the exact Python environment from uv.lock
# download the CSV from UCI and place it in data/raw/
createdb energy_kpi
uv run jupyter lab                        # run notebooks/02_load_staging.ipynb to load raw_steel
psql energy_kpi -f sql/01_schema.sql
psql energy_kpi -f sql/02_load_measurement.sql
psql energy_kpi -f sql/03_reference_tables.sql
psql energy_kpi -f sql/04_kpi_queries.sql
```

## Project structure

```text
sql/               questions, schema, loading, reference tables, KPI queries
notebooks/         exploration and staging load (not a final deliverable)
docs/              system sheets (energy domain notes) and DMAIC project charter
data/raw/          original data, never modified (not versioned)
data/processed/    regenerated outputs (not versioned)
src/, tests/       reusable code and automated tests (to come)
```
