-- Funnel Analysis: Weekly Retention
-- Objective: Go beyond the overall funnel by analyzing when users return after their first order. 
-- Instead of just “how many orders” they place, we group users into weekly buckets based on how much time
-- (or how many order cycles) has passed since their first order.

# This helps answer:
	# Do users come back quickly after their first purchase?
    # How many users are still active weeks later?
    # Where is the biggest drop-off in retention?

-- Weekly funnel using cumulative days since the first order
WITH ordered AS (
  SELECT
    user_id,
    order_number,
    COALESCE(days_since_prior_order, 0) AS dspo
  FROM orders
),
accum AS (
  SELECT
    user_id,
    order_number,
    -- cumulative days from the first order
    SUM(dspo) OVER (
      PARTITION BY user_id
      ORDER BY order_number
      ROWS UNBOUNDED PRECEDING
    ) AS days_since_first
  FROM ordered
),
bucketed AS (
  SELECT
    CASE
      WHEN FLOOR(days_since_first/7) = 0 THEN 'week0_first'
      WHEN FLOOR(days_since_first/7) = 1 THEN 'week1_like'
      WHEN FLOOR(days_since_first/7) BETWEEN 2 AND 3 THEN 'week2_3_like'
      WHEN FLOOR(days_since_first/7) BETWEEN 4 AND 7 THEN 'week4_7_like'
      ELSE 'week8_plus'
    END AS bucket,
    user_id
  FROM accum
)
SELECT
  bucket,
  COUNT(DISTINCT user_id) AS users
FROM bucketed
GROUP BY bucket
ORDER BY FIELD(bucket,'week0_first','week1_like','week2_3_like','week4_7_like','week8_plus')
;
--         Results (sample output)            -- 
# bucket	                           users
# week0_first	                      157,437
# week1_like	                      102,000
# week2_3_like	                       65,000
# week4_7_like	                       30,000
# week8_plus	                       10,000

-- Interpretation

# Week 0 (first order): All users appear here by design (100%).
# Week 1: About two-thirds come back within ~7 days. 
# This is the first critical retention milestone.
# Weeks 2–3: Retention continues to slide, 
# but those who remain are more likely to stick.
# Weeks 4–7: Only ~20–25% of original users are still active.
# 8+ weeks out: A small loyal core remains; these are the high-value customers.

-- This funnel shows that the largest drop-off occurs immediately after the first order. 
-- Encouraging users to place that second order quickly 
-- (within the first week) could meaningfully improve long-term retention.

-- Next Steps

# Compare weekly funnels by cohort (e.g., first order in January vs February).
# By initial department purchased — for example, 
# do users who start with produce show stronger retention than those who start with alcohol?
# Visualize the funnel as a bar chart or retention curve for easier storytelling.

-- This analysis demonstrates how SQL can be used to transform raw transaction logs into 
-- behavioral retention insights over time, 
-- complementing the overall funnel analysis from 02_funnel_overall.