# Instacart Customer Behavior Analysis
Production scale behavioral analytics demonstrating workforce adjacent capabilities: retention forecasting, segmentation, causal inference, and SQL-based operational reporting across 3M+ transactions.


## Why This Matters for Workforce Management
This project demonstrates analytical capabilities directly applicable to workforce planning and operational analytics:

 ### 1. Retention & Attrition Forecasting
 
   **Workforce Parallel:**  Just as customers churn, employees attrit forecasting methods apply to both domains.
 
   **What I Did:**
   * Built retention funnels tracking user progression through order milestones (1→2→3→6+ orders)
     
   * Identified Week 1 as critical retention window (35% drop off after first order)
     
   * Applied Prophet & ARIMA to forecast weekly demand patterns with proper evaluation metrics


 **WFM Application:** 
 
   * Predict employee attrition 3-6 months ahead to support proactive hiring

   * Forecast service volume to inform staffing capacity models

   * Identify critical retention milestones (90-day, 6-month, 1-year)

 ### 2. Behavioral Segmentation for Targeted Interventions
 
 **Workforce Parallel:** Segment employees by engagement/risk level to allocate retention resources efficiently.
 
 **What I Did:**
 * Clustered customers into actionable groups (heavy re-orderers, at risk, one time buyers)

 * Analyzed engagement patterns by tenure and product interaction

 * Identified high-value segments for targeted marketing

**WFM Application:**

* Risk-score employees based on tenure, engagement, and performance metrics

* Target retention interventions to high risk segments

* Optimize retention budget by focusing on employees most likely to respond

 ### 3. Causal Impact Measurement (A/B Testing + Uplift Modeling)
 
 **Workforce Parallel:** Measure whether retention programs (bonuses, training, flexibility) actually reduce attrition.
 
 **What I Did:**
 * Used Propensity Score Matching (PSM) to isolate true treatment effects
   
 * Measured uplift by customer segment (~0.7% improvement in reorders)

 * Applied rigorous causal inference: Inverse Probability Weighting (IPW), matching, bootstrap CIs

**WFM Application:**

* Test whether retention bonuses reduce attrition using same causal framework

* Measure ROI of training programs or schedule flexibility initiatives
  
* Segment-level analysis shows which employee groups benefit most from interventions

4. SQL-Based Operational Analytics at Scale
**Workforce Parallel:** Monitor workforce KPIs in real time for operational decision-making.

**What I Did:**

* Queried 3M+ records with complex joins and window functions

* Built reusable SQL patterns for funnel conversion and cohort retention
  
* Created scalable infrastructure for ongoing monitoring

**WFM Application:**

* Track workforce KPIs (attrition rates, tenure cohorts, schedule adherence) at scale

* Build SQL-based dashboards for daily/weekly operational reporting
  
* Enable self-service analytics for cross functional teams

## Project Components

### 01_EDA_Shopping_Patterns.ipynb
Focus: Temporal patterns, engagement metrics, and product loyalty

**Key Findings:**

* **Peak order times:** 10am-3pm on Sundays

* **Reorder cadences:** 7 day and 30 day peaks suggest natural reminder windows
  
* **Top products:** Bananas, organic strawberries, organic avocados (high reorder rates)

**Methods:**

* Time-of-day and day-of-week analysis
  
* Reorder frequency distributions
  
* Product level loyalty metrics

**Business Value:**

* Inform CRM timing (send reminders at 7-day, 30-day marks)

* Identify high loyalty products for cross-sell/upsell
  
* Establish baseline metrics for segmentation

**WFM Connection:** Same temporal analysis identifies optimal times for employee check-ins, training sessions, or performance reviews based on workload patterns.


### 02_Funnel_Overall.sql & 03_Funnel_Weekly.sql
Focus: User retention through order progression (SQL-based behavioral analytics)

    **Overall Funnel:**  100% users → 65% place 2+ orders → 42% place 3+ orders → 14% place 6+ orders
    **Weekly Retention:**
       * Week 0: 100% (baseline)
   
       * Week 1: 67% return (first critical milestone)
   
       * Weeks 2-3: 41% remain (loyalty forming)
   
       * Weeks 4-7: 19% active (long-term customers emerging)
   
       * 8+ weeks: 6% (high-value core)
       
**Key Insight:** Largest drop-off occurs immediately after first order. Users who return within Week 1 are significantly more likely to become long-term customers.


**SQL Techniques:**
 * Window functions for cumulative days since first order
   
 * CTEs for multi-stage funnel construction

 * Conditional aggregation for conversion rates

 * Bucketing strategy for time-based cohorts

**Business Value:**

 * Prioritize Week 1 engagement (35% retention gain opportunity)
   
 * Set realistic long-term retention benchmarks (only 14% reach 6+ orders)
   
 * Inform acquisition cost targets based on retention curves

**WFM Connection:** Same funnel logic tracks employee retention milestones:

 * 90 day survival rate (early attrition)
   
 * 6 month milestone (probationary period completion)
   
 * 1 year+ tenure (established employees)

**Critical finding:** Early engagement predicts long term retention—same pattern in both customer and employee lifecycles.

## 04_Forecasting_Prophet_ARIMA.ipynb
Focus: Predict weekly demand to support capacity planning and inventory management

**Models Evaluated:**
  * *Baselines:** Naive, Seasonal-Naive, Moving Average (4-week)
  
  * *Advanced:** Prophet (Facebook's forecasting library), SARIMA (Seasonal ARIMA)

**Methodology:**

  * *Proper temporal splits:** Train (70%) / Validation (15%) / Test (15%)

  * *Multiple metrics:** MAE, RMSE, MAPE, sMAPE, MASE

  * Rolling backtest for stability assessment
   
  * Hyperparameter tuning with grid search

**Results:**

 * Prophet captured weekly seasonality and holiday effects
  
 * SARIMA modeled autocorrelation patterns
  
 * 4-8 week ahead forecasts supported planning decisions

**Technical Details:**

 * Handled gaps in weekly series (interpolation for missing weeks)
   
 * Decomposed trend, seasonality, and residuals
   
 * Implemented custom evaluation framework
   
 * Generated forecast confidence intervals

**Business Value:**

 * Anticipate volume spikes 4-8 weeks ahead
   
 * Optimize inventory levels to meet predicted demand
   
 * Inform staffing decisions for peak periods

**WFM Connection:** Identical forecasting methods predict:

 * *Call volume forecasting:** ARIMA for weekly call patterns
   
 * *Attrition forecasting:** Prophet for seasonal turnover trends
   
 * *Capacity planning:** Staffing models based on predicted service volume

**Key transferable skill:** Time series decomposition and forecasting with proper train/test discipline.


### 05_AB_Testing_PSM_Uplift.ipynb
Focus: Measure causal impact of interventions using advanced statistical methods

**Methods:**

 * **Propensity Score Matching (PSM):** Balance treatment/control groups on observables

 * **Inverse Probability Weighting (IPW):** Adjust for selection bias
   
 * **Nearest-Neighbor Matching:** 1:1 matching with caliper for robustnes
   
 * **Uplift Modeling:** Estimate treatment effect heterogeneity across segments

**Experimental Design:**

 * Treatment: Promotional discount for at-risk customers
   
 * Outcome: Any reorder in post-period (binary)
   
 * Covariates: Pre-period engagement (reorder rate, total orders, basket size, days between orders)

**Diagnostics:**

 * Propensity score overlap checks (common support)
   
 * Standardized Mean Differences (SMDs) before/after weighting
   
 * Balance testing on all covariates
   
 * Bootstrap confidence intervals (1000 iterations)

**Results:**

 * **Overall ATE:** +0.7% improvement in reorder probability (p < 0.05)
   
 * **By-segment uplift:** High engagement customers showed 1.2% lift; low engagement 0.3%
   
 * **IPW vs Matching agreement:** Both methods yielded consistent estimates (validates robustness)

**Business Value:**

 * Validated promotional strategy with statistical rigor
   
 * Identified which customer segments benefit most from intervention
   
 * Provided ROI calculation for marketing spend

**WFM Connection:** Same causal inference framework tests workforce interventions:

 * **Retention bonuses:** Do they reduce attrition? For which employee segments?
 * **Training programs:** Measure impact on productivity or retention
 * **Schedule flexibility:** Test whether flexible schedules improve retention/performance
 * **Onboarding enhancements:** A/B test different onboarding approaches

**Critical skill:** Rigorous causal inference prevents false conclusions from observational data. Essential for measuring ROI of workforce programs.

## Technical Skills Demonstrated

### Programming & Analysis

* **Python:** pandas, numpy, scikit-learn, statsmodels, matplotlib, seaborn
* **SQL:** Complex joins, window functions, CTEs, aggregation patterns

### Statistical Methods

* **Time Series:** Prophet, ARIMA, seasonal decomposition, autocorrelation analysis
  
* **Causal Inference:** Propensity scores, IPW, matching, uplift modeling
  
* **Machine Learning:** Clustering, classification, cross-validation, hyperparameter tuning
  
* **Experimentation:** A/B testing, bootstrap CIs, multiple comparison corrections

### Data Engineering

* **Scale:** 3M+ transactions, 200K+ users, 50K+ products
  
* **SQL Optimization:** Efficient joins, indexing strategies, query performance
  
* **Pipeline Design:** Reproducible workflows, modular code, artifact management

### Business Communication

* **Documentation:** Clear project structure, markdown explanations, reproducible code
  
* **Storytelling:**  Business context for every analysis, actionable insights
  
* **Visualization:** Matplotlib, Seaborn for exploratory and presentation graphics


## Key Insights for Workforce Management

### 1. Early Engagement is Disproportionately Important

* **Finding:** 35% of customers don't return after first order; those who return in Week 1 have 3x higher lifetime value.
  
* **Workforce Implication:** First 90 days are highest attrition risk. Targeted onboarding and early check-ins at critical milestones (30-day, 60-day, 90-day) significantly improve retention.
  
* **Action:**  Build structured onboarding with milestone checkpoints; allocate manager time to early-tenure employees.


### 2. Segmentation Enables Precision

* **Finding:** Heavy re-orderers vs. one-time buyers require fundamentally different strategies.
  
* **Workforce Implication:** High engagement vs. low engagement employees need tailored retention approaches. Risk-scoring enables efficient resource allocation.
  
* **Action:** Segment employees by engagement/performance; target retention budget to high-risk, high-value segments.

### 3. Forecasting Informs Capacity Planning

* **Finding:** Weekly demand patterns enable 4-8 week ahead planning.
  
* **Workforce Implication:** Predicting attrition 3-6 months ahead maintains service levels through proactive hiring.
  
* **Action:** Build attrition forecasts into headcount models; hire ahead of predicted gaps.

### 4. Causal Methods Validate Interventions

* **Finding:** Propensity scoring isolates true promotional impact (+0.7% reorder uplift).
  
* **Workforce Implication:** Rigorous testing determines whether retention programs actually work (not just correlation).
  
* **Action:** Run A/B tests on retention bonuses, training programs, schedule flexibility; measure ROI scientifically.


## Tools & Technologies

* **Languages:** Python, SQL
  
* **Libraries:** pandas, numpy, scikit-learn, statsmodels, Prophet, causalml, matplotlib, seaborn
  
* **Methods:** Time series forecasting, causal inference, cohort analysis, funnel analytics, machine learning
  
* **Scale:** 3M+ transaction records, 200K+ users, 50K+ products
  
* **Environment:** Jupyter Notebooks, Git version control


## Business Value Summary

 * **Retention:** Identified critical engagement windows (Week 1 = 35% opportunity)
   
 * **Forecasting:** Enabled 4-8 week ahead demand planning with statistical confidence
   
 * **Experimentation:** Validated 0.7% uplift with rigorous causal inference
   
 * **Scalability:** SQL-based infrastructure supports ongoing operational monitoring
   
 * **Segmentation:** Actionable customer groups enable targeted interventions


## Future Enhancements

 * **Dashboard:** Tableau/Power BI for real-time segment tracking and KPI monitoring
   
 * **Deep Learning:** LSTM networks for demand forecasting (capture complex patterns)
   
 * **Bayesian A/B Testing:** Continuous experimentation framework with Bayesian inference
   
 * **Survival Analysis:** Time-to-churn modeling with Cox proportional hazards
   
 * **Recommendation Engine:** Collaborative filtering for product cross-sell


## Project Context

 * **Type:** Personal project demonstrating production-level analytical capabilities
   
 * **Scope:** End-to-end analysis from raw data to actionable insights
   
 * **Audience:** Workforce Management teams, Operations Planning, Data Science stakeholders
   
 * **Goal:** Showcase transferable skills for operational analytics and workforce planning roles

## About This Work
This project demonstrates that strong analytical fundamentals transfer across business domains. The methods used here—retention analysis, forecasting, causal inference—are the same ones workforce management teams use to:

 * Predict and prevent employee attrition
   
 * Forecast staffing needs based on service volume
   
 * Measure ROI of retention and training programs
   
 * Optimize operational capacity and costs

**The key insight:** whether analyzing customers or employees, the underlying analytical framework is the same. What changes is the business context and domain-specific KPIs, not the core statistical and computational methods.
