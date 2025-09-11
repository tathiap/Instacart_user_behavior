# Instacart Customer Behavior Analysis
Customer purchase behavior analysis using the Instacart Online Grocery Dataset (public dataset from Kaggle).
This project explores segmentation, re-ordering behavior, and the impact of targeted interventions through A/B testing and uplift modeling. Forecasting methods are also applied to project customer demand and reorder activity.


## Project Overview
Instacart provides a large dataset of grocery orders. This analysis addresses:

  * Customer Segmentation – clustering users into actionable groups based on order habits.
  * A/B Testing & Causal Inference – measuring the impact of interventions using propensity score matching (PSM) and uplift modeling.
  * Forecasting & Time Series – predicting reorder volumes using ARIMA/Prophet.
  * SQL Analysis – querying the dataset (via notebooks).
  * Feature Engineering & Modeling – building features such as reorder ratio, aisle/department preferences, and time-based purchase patterns.

## Tools & Tech

* Languages: Python, SQL
* Libraries: pandas, numpy, matplotlib, seaborn, scikit-learn, statsmodels, causalml, Prophet
* Environment: Jupyter Notebooks (Local Jupyter)
* Visualization: Matplotlib & Seaborn

## Dataset Access
The dataset is stored on Google Drive: https://drive.google.com/drive/folders/1hWo1zIMyihISacroshPO1KplkK3quxP9?usp=drive_link

*Note: Data is too large to be stored in this repository. Please download directly from the link above to reproduce results.*

## Key Insight 

  * Segmentation – Customers cluster into groups (e.g., heavy re-orderers, new shoppers, aisle specialists), enabling targeted marketing.
  * A/B Testing (PSM + Uplift) – Treatment groups showed a ~0.7% uplift in reorders, validating targeted promotional strategies.
  * Forecasting – Prophet & ARIMA models captured weekly reorder seasonality, useful for staffing and inventory planning.
  * SQL Analysis – streamlined large scale joins across millions of records for aisles, departments, and user behavior features.

## Future Improvements

  * Build a dashboard (Tableau/Power BI) for real time segment tracking.
  * Expand causal inference with Bayesian A/B testing.
  * Incorporate deep learning models (LSTM) for demand forecasting.
