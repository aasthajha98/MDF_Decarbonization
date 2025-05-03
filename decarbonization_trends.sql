CREATE TABLE decarbonization_trends AS

WITH annual_emissions AS (
  -- Aggregate emissions data by state and year
  SELECT
    year,
    state,
    SUM(co2_mass_tons) AS total_co2_tons,
    SUM(so2_mass_lbs) AS total_so2_lbs,
    SUM(nox_mass_lbs) AS total_nox_lbs,
    COUNT(DISTINCT plant_id_eia) AS num_emitting_plants
  FROM my_pudl_data.hourly_emissions
  WHERE co2_mass_tons IS NOT NULL
  GROUP BY year, state
),

annual_generation AS (
  -- Aggregate generation data by state, year, and fuel type
  SELECT
    YEAR(report_date) AS year,
    state,
    fuel_type_code_pudl,
    SUM(net_generation_mwh) AS total_generation_mwh,
    SUM(capacity_mw) AS total_capacity_mw,
    COUNT(DISTINCT generator_id) AS num_generators
  FROM my_pudl_data.monthly_generators
  WHERE net_generation_mwh IS NOT NULL
  GROUP BY YEAR(report_date), state, fuel_type_code_pudl
),

renewable_capacity AS (
  -- Calculate renewable capacity by state and year
  SELECT
    YEAR(report_date) AS year,
    state,
    SUM(CASE 
      WHEN technology_description LIKE '%Solar%' OR 
           technology_description LIKE '%Wind%' OR 
           technology_description LIKE '%Hydro%' OR 
           technology_description LIKE '%Biomass%' OR 
           technology_description LIKE '%Geothermal%' 
      THEN capacity_mw ELSE 0 END) AS renewable_capacity_mw,
    SUM(capacity_mw) AS total_capacity_mw
  FROM monthly_generators
  WHERE capacity_mw IS NOT NULL
  GROUP BY YEAR(report_date), state
),

fuel_mix AS (
  -- Calculate fuel mix percentages by state and year
  SELECT
    YEAR(report_date) AS year,
    state,
    fuel_type_code_pudl,
    SUM(fuel_consumed_mmbtu) AS fuel_consumed_mmbtu
  FROM fuel_receipts_costs
  WHERE fuel_consumed_mmbtu IS NOT NULL
  GROUP BY YEAR(report_date), state, fuel_type_code_pudl
)

-- Final combined query 
SELECT
  ae.year,
  ae.state,
  ae.total_co2_tons,
  ae.total_so2_lbs,
  ae.total_nox_lbs,
  ae.num_emitting_plants,
  -- Calculate emissions intensity (CO2 tons per MWh)
  ae.total_co2_tons / NULLIF(SUM(ag.total_generation_mwh), 0) AS co2_intensity_tons_per_mwh,
  -- Renewable metrics
  rc.renewable_capacity_mw,
  rc.renewable_capacity_mw / NULLIF(rc.total_capacity_mw, 0) AS renewable_capacity_fraction,
  -- Generation mix
  SUM(CASE WHEN ag.fuel_type_code_pudl = 'coal' THEN ag.total_generation_mwh ELSE 0 END) AS coal_generation_mwh,
  SUM(CASE WHEN ag.fuel_type_code_pudl = 'gas' THEN ag.total_generation_mwh ELSE 0 END) AS gas_generation_mwh,
  SUM(CASE WHEN ag.fuel_type_code_pudl = 'nuclear' THEN ag.total_generation_mwh ELSE 0 END) AS nuclear_generation_mwh,
  SUM(CASE WHEN ag.fuel_type_code_pudl IN ('solar', 'wind', 'hydro', 'biomass', 'geothermal') 
      THEN ag.total_generation_mwh ELSE 0 END) AS renewable_generation_mwh,
  -- Fuel consumption mix
  SUM(CASE WHEN fm.fuel_type_code_pudl = 'coal' THEN fm.fuel_consumed_mmbtu ELSE 0 END) AS coal_consumed_mmbtu,
  SUM(CASE WHEN fm.fuel_type_code_pudl = 'gas' THEN fm.fuel_consumed_mmbtu ELSE 0 END) AS gas_consumed_mmbtu,
  SUM(CASE WHEN fm.fuel_type_code_pudl IN ('solar', 'wind', 'hydro', 'biomass', 'geothermal') 
      THEN fm.fuel_consumed_mmbtu ELSE 0 END) AS renewable_consumed_mmbtu,
  -- Year-over-year changes (can be calculated with window functions)
  LAG(ae.total_co2_tons) OVER (PARTITION BY ae.state ORDER BY ae.year) AS prev_year_co2_tons,
  ae.total_co2_tons - LAG(ae.total_co2_tons) OVER (PARTITION BY ae.state ORDER BY ae.year) AS yoy_co2_change_tons,
  (ae.total_co2_tons - LAG(ae.total_co2_tons) OVER (PARTITION BY ae.state ORDER BY ae.year)) / 
      NULLIF(LAG(ae.total_co2_tons) OVER (PARTITION BY ae.state ORDER BY ae.year), 0) AS yoy_co2_change_pct
FROM annual_emissions ae
LEFT JOIN annual_generation ag ON ae.year = ag.year AND ae.state = ag.state
LEFT JOIN renewable_capacity rc ON ae.year = rc.year AND ae.state = rc.state
LEFT JOIN fuel_mix fm ON ae.year = fm.year AND ae.state = fm.state
GROUP BY 
  ae.year, 
  ae.state, 
  ae.total_co2_tons, 
  ae.total_so2_lbs, 
  ae.total_nox_lbs, 
  ae.num_emitting_plants,
  rc.renewable_capacity_mw,
  rc.total_capacity_mw
ORDER BY ae.state, ae.year;