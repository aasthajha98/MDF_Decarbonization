# Tracking State-Level Decarbonization Trends Using PUDL

This project analyzes decarbonization trends in the United States using data from the **Public Utility Data Liberation Project (PUDL)**. It focuses on tracking electricity generation and associated carbon emissions by state over time, enabling data-driven insights into how different states are progressing toward cleaner energy portfolios.

As global energy demand continues to rise alongside increasing carbon dioxide emissions, most Americans believe that the United States should focus on advancing renewable energy sources like wind and solar. They also support efforts to move the country toward achieving carbon neutrality by 2050.

The United Nations Intergovernmental Panel on Climate Change highlights that limiting global warming to 1.5°C will necessitate a reduction in carbon dioxide emissions by approximately 45% from 2010 levels by 2030, and achieving net-zero emissions by 2050.

Project Website is available at: https://aasthajha98.github.io/MDF_Decarbonization/
---

## 📁 Project Files and Descriptions

### `Loading PUDL Data.py`
This notebook shows how to load selected PUDL data tables from AWS S3 and store them into a local database for analysis.

**Tables Loaded:**
- `out_eia__monthly_generators` → `monthly_generators`
- `core_epacems__hourly_emissions` → `hourly_emissions`
- `out_eia__yearly_plants` → `yearly_plants`
- `out_eia923__fuel_receipts_costs` → `fuel_receipts_costs`

All tables are stored in a database called `my_pudl_data`.

---

### `decarbonization_trends.sql`
This SQL script creates a materialized view or derived table called `decarbonization_trends`, which aggregates and joins the loaded datasets to track:
- Electricity generation by fuel type
- CO₂ emissions by state and year
- Changes in fuel mix and carbon intensity over time

---

### `Visualizing Decarbonization.ipynb`
This notebook uses the `decarbonization_trends` table to create visualizations that show:
- State-level changes in electricity generation mix
- CO₂ emissions trends over time
- Comparisons between states in terms of decarbonization progress

---

### `co2_animation.html`
An interactive animation (rendered in HTML) showing the change in state-level CO₂ emissions from electricity generation over time. This helps visualize decarbonization dynamics across the country.

---

### `Decarbonization Monitoring Dashboard.lvdash.json`
A JSON configuration file for a **Databricks dashboard**. The dashboard includes:
- Time series charts of CO₂ emissions
- Fuel mix breakdowns by state
- Emissions intensity (tons CO₂ per MWh)
- Interactive filtering by year and state

---

## 🔍 Goals of the Project
- Understand how U.S. states have shifted their electricity generation fuel mix.
- Track associated changes in CO₂ emissions over the past 10–15 years.
- Visualize decarbonization progress and identify leaders and laggards.
- Build reusable components (SQL, notebooks, dashboards) to support ongoing monitoring.

---

## 📚 Data Sources
Data is pulled from the **Public Utility Data Liberation Project (PUDL)**, which cleans and standardizes:
- U.S. Energy Information Administration (EIA) Form 923 & 860
- EPA Continuous Emissions Monitoring System (CEMS)
- Federal Energy Regulatory Commission (FERC) Form 1 (not used in this project)

---

## 🛠️ Requirements
- Databricks or a local Spark/SQL environment
- Python 3.x
- Pandas, SQLAlchemy, Plotly/Matplotlib for visualizations
- Access to PUDL data on AWS S3 (via [PUDL documentation](https://catalystcoop-pudl.readthedocs.io/en/latest/))

---

## 📈 Example Questions Answered
- How much has each state reduced its CO₂ emissions since 2010?
- Which states have transitioned most away from coal?
- What is the carbon intensity of electricity generation in each state?

---

## 💬 Contact
For questions, feel free to reach out or open an issue on this repository.

---

