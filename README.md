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
* 
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


