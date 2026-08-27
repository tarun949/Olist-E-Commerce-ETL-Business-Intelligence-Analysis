# Olist-E-Commerce-ETL-Business-Intelligence-Analysis



## Project Overview

This project is an end-to-end **E-Commerce Data Analytics and ETL pipeline** built using **Python, PostgreSQL, SQL, and Power BI**.

The objective is to transform raw Olist e-commerce data into a reliable analytical dataset, identify important business trends and operational issues, and present the findings through an interactive Power BI dashboard.

The project focuses on answering a practical business question:

> **How can an e-commerce business improve revenue, customer retention, customer satisfaction, and delivery performance using data-driven insights?**

---

##  Business Objectives

The analysis focuses on five major areas:

* Understand overall sales and revenue performance.
* Identify high-performing products, categories, and sellers.
* Analyze customer purchasing behavior and repeat customers.
* Evaluate delivery performance and late deliveries.

---

##  ETL Pipeline

```text
Raw Olist Dataset
       ↓
Python / Pandas
       ↓
Data Cleaning & Validation
       ↓
Feature Engineering
       ↓
PostgreSQL
       ↓
SQL Analysis & Views
       ↓
Power BI
       ↓
Interactive Business Dashboard
```

### Extract

Raw Olist CSV files were imported into Python using Pandas.

### Transform

Data preparation included:

* Handling missing values
* Identifying and removing exact duplicates
* Converting columns to appropriate data types
* Cleaning date fields
* Validating relationships between tables
* Handling duplicate geographic records
* Creating business-ready features

### Feature Engineering

The following features were created:

* `delivery_days`
* `delivery_delay`
* `delivery_status`
* `order_value`

### Load

Cleaned datasets were loaded into **PostgreSQL** as separate relational tables.

### SQL Transformation & Analysis

PostgreSQL was used to:

* Join related tables
* Aggregate one-to-many relationships safely
* Create reusable analytical views
* Calculate business KPIs
* Perform sales, customer, product, delivery, and satisfaction analysis

---

##  PostgreSQL Tables

The main tables used in the project include:

```text
orders
order_items
customers
products
sellers
order_payments
order_reviews
geolocation
```

To avoid double-counting, one-to-many tables such as `order_items` and `order_reviews` were aggregated at the appropriate grain before calculating business metrics.

---

## 📊 SQL Analytical Views

Six main SQL views were created:

### `vw_executive_kpis`

Contains overall business KPIs such as:

* Total Revenue
* Total Orders
* Total Customers
* Average Order Value
* Average Delivery Days
* Late Delivery %

### `vw_sales_analysis`

Used for:

* Monthly revenue trends
* Revenue by category
* Revenue by product
* Seller performance
* Freight analysis

### `vw_customer_analysis`

Used for:

* Customer-level order analysis
* Total customer spending
* Average Order Value
* First and last purchase
* Repeat customer identification

### `vw_delivery_analysis`

Used for:

* Delivery time analysis
* Late delivery analysis
* State-wise delivery performance
* Delivery trends

### `vw_product_analysis`

Used for:

* Product revenue
* Orders by product
* Category performance
* Freight cost
* Seller count

### `vw_customer_satisfaction`

Used for:

* Review score analysis
* Delivery status vs review score
* Customer satisfaction by region
* Delivery and satisfaction analysis

---

## 📈 Key Business Questions

The SQL and Power BI analysis were designed to answer:

1. What is the monthly revenue trend?
2. Which product categories generate the most revenue?
3. Which products and sellers perform best?
4. What is the Average Order Value?
5. What percentage of customers are repeat customers?
6. Which states generate the most revenue?
7. What is the average delivery time?
8. What percentage of orders are delivered late?
9. Does delivery status affect customer review scores?

---

##  Key KPIs

The dashboard tracks:

| KPI                   | Description                                             |
| --------------------- | ------------------------------------------------------- |
| Total Revenue         | Total value generated from delivered orders             |
| Total Orders          | Number of delivered orders                              |
| Total Customers       | Unique customers                                        |
| Average Order Value   | Average revenue per order                               |
| Repeat Customer %     | Percentage of customers making more than one purchase   |
| Average Review Score  | Overall customer satisfaction                           |
| Average Delivery Days | Average time from purchase to delivery                  |
| Late Delivery %       | Percentage of orders delivered after the estimated date |

---

## 📊 Power BI Dashboard

The project dashboard is divided into four major pages.

### 1. Executive Overview

Provides a high-level view of business performance.

**KPIs:**

* Total Revenue
* Total Orders
* Total Customers
* Average Order Value
* Repeat Customer %
* Average Review Score

**Visuals:**

* Monthly Revenue Trend
* Revenue by Product Category
* Revenue by State
* Top 10 Products

**Slicers:**

* Date 
* Product Category
* Customer State

---

### 2. Sales & Product Performance

Focuses on revenue and product performance.

**Visuals:**

* Top 10 Products Category
* Top 10 Sellers
* Monthly Revenue Trend
* Product Value vs Freight Value

This page helps identify which products and categories contribute most to business revenue.

---

### 3. Customer & Satisfaction

Analyzes customer behavior and satisfaction.

**Visuals:**

* Repeat vs One-Time Customers
* Customers by State
* Order by State
* Review by Delivery Status

This page helps identify customer retention and satisfaction issues.

---

### 4. Delivery & Operations

Focuses on logistics and operational performance.

**KPIs:**

* Total Orders
* Average Delivery Days
* Delivery Delay %
* Avg Review Score

**Visuals:**

* Monthly Delivery Performance
* Late vs On-Time Orders
* Delivery Performance by State

---

## 🔎 Business Insights

The project is designed to identify insights such as:

* Which categories generate the largest share of revenue.
* Which states have strong or weak sales performance.
* The proportion of customers returning for additional purchases.
* Whether late deliveries are associated with lower review scores.
* High-revenue categories that may require customer-experience improvements.
* The impact of freight costs relative to product value.

The final insights should be interpreted together with the dashboard filters and supporting SQL analysis rather than relying on a single metric.

---

## 🛠️ Technology Stack

| Technology           | Purpose                                            |
| -------------------- | -------------------------------------------------- |
| **Python**           | Data cleaning, transformation, feature engineering |
| **Pandas**           | Data manipulation                                  |
| **NumPy**            | Numerical operations                               |
| **Matplotlib**       | Visualization                                      |
| **Seaborn**          | Exploratory data analysis                          |
| **PostgreSQL**       | Data storage and SQL analysis                      |
| **SQL**              | Joins, aggregations, KPIs and analytical views     |
| **Power BI**         | Interactive dashboard and business reporting       |
| **Jupyter Notebook** | Development and analysis                           |


## 🚀 Project Workflow

```text
1. Import raw CSV files into Python
2. Explore the structure and quality of the data
3. Clean missing values and duplicates
4. Convert data types and date fields
5. Validate table relationships
6. Create delivery and order-related features
7. Load cleaned tables into PostgreSQL
8. Create SQL analytical views
9. Calculate business KPIs
10. Connect Power BI to the analytical layer
11. Build interactive dashboards
12. Identify business insights and recommendations
```

---

## 💡 Business Recommendations Framework

Based on the final results, recommendations can focus on:

### Customer Retention

Improve repeat purchases through targeted customer engagement and personalized offers.

### Delivery Performance

Investigate sellers, regions, and categories with consistently high delivery delays.

### Customer Satisfaction

Prioritize high-revenue categories with relatively low review scores.

### Revenue Growth

Focus on high-performing categories, products, and regions while identifying underperforming segments.

### Logistics Cost

Investigate categories where freight cost represents a large proportion of product value.

---

## 📌 Project Outcome

This project demonstrates an end-to-end analytics workflow rather than only a dashboard.

It showcases the ability to:

* Clean and transform real-world data using Python
* Work with relational datasets
* Load and manage data in PostgreSQL
* Write business-focused SQL queries
* Build reusable SQL views
* Develop Power BI dashboards
* Translate data into actionable business insights

---

## 👨‍💻 Skills Demonstrated

**Python | Pandas | NumPy | EDA | Data Cleaning | Feature Engineering | SQL | PostgreSQL | ETL | Data Modeling | Power BI | Data Visualization | Business Analysis**

---

## 📚 Dataset

**Olist Brazilian E-Commerce Public Dataset**

Source: Kaggle — <a href="https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce?utm_source=chatgpt.com">Dataset</a>

The dataset contains anonymized Brazilian e-commerce information covering orders, customers, products, sellers, payments, reviews, and geographic data.

---

