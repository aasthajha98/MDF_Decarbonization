# Databricks notebook source
# MAGIC %md
# MAGIC
# MAGIC ## Data Ingestion
# MAGIC
# MAGIC This notebook shows you how to load in data from the The Public Utility Data Liberation Project (PUDL) from AWS S3. 
# MAGIC
# MAGIC We are only loading in the following tables: 
# MAGIC
# MAGIC - out_eia__monthly_generators
# MAGIC - core_epacems__hourly_emissions
# MAGIC - out_eia__yearly_plants
# MAGIC - out_eia923__fuel_receipts_costs
# MAGIC
# MAGIC And then storing them in a database called my_pudl_data. 
# MAGIC The table names are as follows: 
# MAGIC - monthly_generators
# MAGIC - hourly_emissions
# MAGIC - yearly_plants
# MAGIC - fuel_receipts_costs

# COMMAND ----------

dbutils.fs.ls("s3a://pudl.catalyst.coop/")


# COMMAND ----------

dbutils.fs.ls("s3a://pudl.catalyst.coop/v2025.2.0/")


# COMMAND ----------

# Monthly generator data from EIA
monthly_generators = spark.read.parquet("s3a://pudl.catalyst.coop/v2025.2.0/out_eia__monthly_generators.parquet")

# Hourly emissions data from EPA CEMS
hourly_emissions = spark.read.parquet("s3a://pudl.catalyst.coop/v2025.2.0/core_epacems__hourly_emissions.parquet")

# Yearly plant data from EIA
yearly_plants = spark.read.parquet("s3a://pudl.catalyst.coop/v2025.2.0/out_eia__yearly_plants.parquet")

# Fuel receipts and cost data from EIA-923
fuel_receipts_costs = spark.read.parquet("s3a://pudl.catalyst.coop/v2025.2.0/out_eia923__fuel_receipts_costs.parquet")


# COMMAND ----------

monthly_generators.show(5)
hourly_emissions.show(5)
yearly_plants.show(5)
fuel_receipts_costs.show(5)


# COMMAND ----------

spark.sql("CREATE DATABASE IF NOT EXISTS my_pudl_data")


# COMMAND ----------

# Register DataFrame as a temporary SQL table (view)
monthly_generators.createOrReplaceTempView("monthly_generators_temp")


# COMMAND ----------

hourly_emissions.createOrReplaceTempView("hourly_emissions_temp")
yearly_plants.createOrReplaceTempView("yearly_plants_temp")
fuel_receipts_costs.createOrReplaceTempView("fuel_receipts_costs_temp")


# COMMAND ----------

spark.catalog.listTables()


# COMMAND ----------

# MAGIC %sql
# MAGIC -- Create a permanent SQL table for monthly generators
# MAGIC CREATE TABLE my_pudl_data.monthly_generators AS
# MAGIC SELECT * FROM monthly_generators_temp;
# MAGIC
# MAGIC -- Create a permanent SQL table for hourly emissions
# MAGIC CREATE TABLE my_pudl_data.hourly_emissions AS
# MAGIC SELECT * FROM hourly_emissions_temp;
# MAGIC
# MAGIC -- Create a permanent SQL table for yearly plants
# MAGIC CREATE TABLE my_pudl_data.yearly_plants AS
# MAGIC SELECT * FROM yearly_plants_temp;
# MAGIC
# MAGIC -- Create a permanent SQL table for fuel receipts & costs
# MAGIC CREATE TABLE my_pudl_data.fuel_receipts_costs AS
# MAGIC SELECT * FROM fuel_receipts_costs_temp;
# MAGIC

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT * FROM my_pudl_data.monthly_generators LIMIT 10;
# MAGIC

# COMMAND ----------

# Print schemas for each DataFrame
print("Schema for monthly_generators:")
monthly_generators.printSchema()

print("\nSchema for hourly_emissions:")
hourly_emissions.printSchema()

print("\nSchema for yearly_plants:")
yearly_plants.printSchema()

print("\nSchema for fuel_receipts_costs:")
fuel_receipts_costs.printSchema()


# COMMAND ----------


