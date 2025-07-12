# Instacart User Behavior & Reorder Prediction Analysis
This repository includes two complementary projects based on the Instacart Online Grocery Shopping Dataset 2017. These projects aim to explore user behavior and predict product reordering patterns to support data-driven decision-making for e-commerce platforms.

## Project 1: Exploratory Data Analysis (EDA)

### Goal: 
This project focuses on analyzing key behavioral trends in Instacart’s user base through exploratory data analysis (EDA). By investigating when customers shop, how frequently they reorder, and which products they favor, we aim to uncover actionable insights that can inform future modeling efforts such as A/B testing, forecasting, and user segmentation.

### Key Insights:

* Time-Based Ordering: Most users order between 9AM and 6PM, especially mid-week and on weekends.
* Customer Frequency: Majority of users place only 1–2 orders; fewer users show consistent shopping behavior.
* Product Trends: Staples like bananas, avocados, and organic produce dominate both first-time and repeat purchases.
* Reorder Patterns: Certain niche products have perfect reorder rates, suggesting strong product loyalty.

### Output: 
instacart_eda.ipynb — an interactive notebook with charts, histograms, and summary commentary.

## Project 2: Predictive Modeling & Forecasting

### Goal: 
Building on the EDA findings, this project adds statistical testing, machine learning, and time-series modeling to simulate real-world decision-making strategies. This includes testing hypotheses, forecasting demand, and predicting whether a product will be reordered.

### Modules:
* A/B Testing: Simulates two user groups to test impact on reorder behavior. Results show no significant difference (p > 0.05).
* Forecasting: Uses Facebook Prophet to predict daily order volume, identifying temporal trends to support operations.
* Classification Model: Implements logistic regression to predict reorder likelihood with a ROC-AUC score of 0.58.

### Output:
* instacart_analysis.py — a Python script version for data pipelines
* instacart_modeling.ipynb (optional) — notebook version with visual explanations

## Dataset Overview
The Instacart dataset includes:

* orders.csv: Order-level details (user ID, order timing, etc.)
* products.csv, departments.csv, aisles.csv: Product catalog
* order_products.csv: Product-level data per order

## Tech Stack
* Data Analysis: pandas, numpy, matplotlib, seaborn
* Statistical Testing: scipy
* Forecasting: prophet
* Modeling: scikit-learn, statsmodels
