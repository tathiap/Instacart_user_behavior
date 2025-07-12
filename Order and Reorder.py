# instacart_analysis.py

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import ttest_ind
from prophet import Prophet
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, roc_auc_score
import warnings

warnings.filterwarnings("ignore")
sns.set(style="whitegrid")

# ---------------------- Load and Clean Data ----------------------

orders = pd.read_csv("datasets/instacart_orders.csv", delimiter=';')
products = pd.read_csv("datasets/products.csv", delimiter=';')
aisles = pd.read_csv("datasets/aisles.csv", delimiter=';')
departments = pd.read_csv("datasets/departments.csv", delimiter=';')
order_products = pd.read_csv("datasets/order_products.csv", delimiter=';')

# Clean and convert datatypes
def clean_data():
    orders[['order_id', 'user_id']] = orders[['order_id', 'user_id']].apply(pd.to_numeric, errors='coerce').fillna(0).astype(int)
    products['product_id'] = pd.to_numeric(products['product_id'], errors='coerce').fillna(0).astype(int)
    aisles['aisle_id'] = pd.to_numeric(aisles['aisle_id'], errors='coerce').fillna(0).astype(int)
    departments['department_id'] = pd.to_numeric(departments['department_id'], errors='coerce').fillna(0).astype(int)
    order_products['add_to_cart_order'] = pd.to_numeric(order_products['add_to_cart_order'], errors='coerce').fillna(0).astype(int)
    products['product_name'] = products['product_name'].fillna('Unknown')

    # Drop duplicates
    for df in [orders, products, aisles, departments, order_products]:
        df.drop_duplicates(inplace=True)

clean_data()

# ---------------------- Helper Plot Functions ----------------------

def plot_bar(data, title, xlabel, ylabel, color='skyblue', figsize=(10,6), rotation=0):
    plt.figure(figsize=figsize)
    data.plot(kind='bar', color=color)
    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.xticks(rotation=rotation)
    plt.grid(axis='y')
    plt.tight_layout()
    plt.show()

def plot_hist(data, title, xlabel, ylabel, bins=24, color='salmon'):
    plt.figure(figsize=(10,6))
    plt.hist(data, bins=bins, color=color, edgecolor='black')
    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.grid(axis='y')
    plt.tight_layout()
    plt.show()

# ---------------------- Exploratory Data Analysis ----------------------

# A. Hourly orders
hourly_orders = orders['order_hour_of_day'].value_counts().sort_index()
plot_bar(hourly_orders, 'Order Distribution by Hour', 'Hour (0-23)', 'Order Count', color='teal')

# B. Daily orders
daily_orders = orders['order_dow'].value_counts().sort_index()
plot_bar(daily_orders, 'Order Distribution by Day of Week', 'Day (0=Sun, ..., 6=Sat)', 'Order Count', color='coral')

# C. Days since prior order
days_since_order = orders['days_since_prior_order'].dropna()
plot_bar(days_since_order.value_counts().sort_index(), 'Frequency of Days Since Prior Order',
         'Days Since Prior Order', 'Frequency', color='slateblue', rotation=45)

# D. Wednesday vs Saturday shopping habits
for day, label in zip([3, 6], ['Wednesday', 'Saturday']):
    subset = orders[orders['order_dow'] == day]['order_hour_of_day']
    plot_hist(subset, f'Shopping Hours - {label}', 'Hour of Day', 'Order Count')

# E. Orders per customer
orders_per_user = orders.groupby('user_id')['order_id'].nunique()
plot_hist(orders_per_user, 'Orders per Customer', 'Number of Orders', 'Frequency', bins=50)

# F. Product popularity
top_products = order_products.merge(products, on='product_id')['product_name'].value_counts().head(20)
plot_bar(top_products, 'Top 20 Most Ordered Products', 'Product Name', 'Order Count', color='mediumseagreen', rotation=90)

# G. Top 20 by reorder rate
reorder_stats = order_products.groupby('product_id')['reordered'].agg(['sum', 'count']).reset_index()
reorder_stats['reorder_rate'] = reorder_stats['sum'] / reorder_stats['count']
reorder_stats = reorder_stats.merge(products[['product_id', 'product_name']], on='product_id')
top_reordered = reorder_stats.sort_values(by='reorder_rate', ascending=False).head(20)
print("Top 20 Products by Reorder Rate:\n", top_reordered[['product_name', 'reorder_rate']])

# ---------------------- A/B Test Simulation ----------------------
np.random.seed(42)
users = orders['user_id'].unique()
treatment = np.random.choice(users, size=len(users)//2, replace=False)
orders['treatment'] = orders['user_id'].isin(treatment).astype(int)

ab_result = orders.merge(order_products, on='order_id')
means = ab_result.groupby('treatment')['reordered'].mean()
t_stat, p_value = ttest_ind(
    ab_result[ab_result['treatment'] == 1]['reordered'],
    ab_result[ab_result['treatment'] == 0]['reordered'],
    equal_var=False
)
print("\nA/B Test - Mean Reorder Rate by Group:\n", means)
print(f"\nT-Test Result: t-statistic = {t_stat:.4f}, p-value = {p_value:.4f}")

# ---------------------- Forecasting with Prophet ----------------------
daily_volume = orders.groupby('order_number').size().reset_index(name='y')
daily_volume['ds'] = pd.to_datetime(daily_volume['order_number'], unit='D', origin='2020-01-01')

prophet_model = Prophet()
prophet_model.fit(daily_volume[['ds', 'y']])
future = prophet_model.make_future_dataframe(periods=30)
forecast = prophet_model.predict(future)
prophet_model.plot(forecast)
plt.title("Forecast of Daily Orders")
plt.show()

# ---------------------- Logistic Regression Model ----------------------
features = order_products[['add_to_cart_order']]
labels = order_products['reordered']

model = LogisticRegression()
model.fit(features, labels)
predictions = model.predict(features)

print("\nClassification Report:\n")
print(classification_report(labels, predictions))
print("ROC-AUC Score:", roc_auc_score(labels, model.predict_proba(features)[:,1]))


