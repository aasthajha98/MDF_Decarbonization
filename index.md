# Tracking State-Level Decarbonization

Welcome to our PPOL 5206 final project! We use open-source utility data from the [Public Utility Data Liberation Project (PUDL)](https://catalyst.coop/pudl/) to track how U.S. states are progressing in decarbonizing their electricity generation over time.

## 🔍 What You’ll Find

- 💾 **[Loading PUDL Data.py](./Loading%20PUDL%20Data.py)** — Loads raw PUDL tables and builds a database for analysis.
- 🧮 **[decarbonization_trends.sql](./sql/decarbonization_trends.sql)** — SQL logic to calculate state-level CO₂ and generation trends.
- 📊 **[Visualizing Decarbonization.ipynb](./notebooks/Visualizing%20Decarbonization.ipynb)** — Charts showing emissions and fuel mix.
- 🌍 **[CO₂ Animation](./docs/co2_animation.html)** — Animated map of changing CO₂ emissions by state.
- 📈 **Dashboard Code** — [Databricks dashboard config](./dashboard/Decarbonization%20Monitoring%20Dashboard.lvdash.json)

## 📌 Why This Matters
States are making uneven progress toward decarbonization. With federal incentives and climate targets in place, this dashboard helps track which states are leading and which may need policy support.

## 🌍 CO₂ Emissions Animation

<iframe src="./co2_animation.html" width="100%" height="600px" frameborder="0"></iframe>


## 📬 Contact
Project by students in PPOL 5206. For inquiries, reach out via [GitHub issues](https://github.com/your-username/your-repo/issues).
