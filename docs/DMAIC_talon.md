
# DMAIC project charter — Base-load reduction
 
Steel plant, electricity, data year 2018. Worked example built on the KPI database results.
 
## D — Define
 
- **Problem:** the plant draws a permanent base load of **13.0 kW** even when idle (nights, Sundays). It represents
  **114 MWh/year, 11.8 % of annual electricity and about 52 tCO₂**. In addition, consumption decreases slowly after
  the end of production each evening.
- **SMART objective:** reduce the base load **from 13 kW to 10 kW within 6 months**, measured as the median power
  between 00:00 and 06:00 and on Sundays, i.e. **26 MWh and 12 tCO₂ avoided per year**; and halve the evening
  shutdown tail.
- **Scope:** included — electricity consumption outside production hours (nights, Sundays, end-of-day shutdown).
  Excluded — production-hour consumption, peak demand and reactive power (separate projects).
- **Sponsor / user:** the plant energy manager.
## M — Measure
 
| Indicator | Value | Source |
|---|---|---|
| Base load (median, 00:00–06:00 and Sundays) | **13.0 kW** | Q1 |
| Working-day nights (02:00–07:00 average) | 17.4–18.9 kW | Q7 |
| Sunday nights (00:00–07:00 average) | 12.6–19.2 kW | Q7 |
| Shutdown tail, working days (21:00 → 01:00) | 62 → 38 → 35 → 34 → 26 kW | Q7 |
| Sunday daytime (08:00–16:00 average) | 45–64 kW | Q7 |
 
**Data reliability:** 35,040 / 35,040 intervals, no gaps or duplicates; power derived from 15-minute energy
(kW = kWh × 4). **Limits:** one meter for the whole plant — the base load cannot be split by equipment; the timestamp
convention (start of interval) is an assumption.
 
## A — Analyze
 
| Possible cause | Data that would confirm it |
|---|---|
| 1. Permanent auxiliaries (compressed air leaks, cooling, ventilation, lighting) | Sub-metering of auxiliaries; compressed-air pressure decay test on a Sunday |
| 2. Equipment kept in standby or warm between shifts — working-day nights are ~3 kW above Sunday nights | Night profile by equipment; compare nights before working days vs before Sundays |
| 3. Slow end-of-day shutdown — about 80 kWh above base load each working night between 22:00 and 02:00 | Timestamped shutdown sequence; consumption of each line after its stop signal |
| 4. Unplanned Sunday activity — 45–64 kW on Sunday daytime | Maintenance log; list of Sundays with consumption well above base load |
 
**5 whys (cause 3):** why does consumption stay high after 21:00? → some lines keep running after production
ends → why? → no defined shutdown sequence, each operator stops their own equipment → why? → no standard
operating procedure for shutdown. *Root cause to verify on site: absence of a shutdown standard.*
 
## I — Improve
 
| Action | Estimated gain | Effort |
|---|---|---|
| Night and Sunday audit of permanent consumers (leaks, lighting, idle equipment) | 3 kW → **26 MWh/year, 12 tCO₂** | Low |
| Standard end-of-day shutdown sequence with a checklist | Tail roughly halved → **~12 MWh/year** (estimate: 80 kWh/night × 303 working days ÷ 2) | Low |
| Review Sunday activities and group maintenance consumption | To quantify after the Sunday list | Medium |
 
Gains are verified by comparing the 3 months after the actions to the same months before (IPMVP-style
before/after comparison on the base-load indicator).
 
## C — Control
 
- **Monthly indicator:** median power 00:00–06:00 and Sundays (target ≤ 10 kW); average power 22:00–01:00 on working days.
- **Alert:** median night power above 11 kW for two consecutive weeks → investigation.
- **Next step:** a CUSUM chart of base-load energy against the target, so that a drift is visible within days
  rather than at the end of the month.
- **Standard:** the shutdown checklist becomes part of the operating procedures; it is reviewed at each monthly
  energy meeting (PDCA cycle of ISO 50001).
