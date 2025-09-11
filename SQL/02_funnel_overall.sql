-- 02 — Funnel Analysis: Overall User Retention
-- Objective: Measure how many Instacart users place multiple orders over time and calculate conversion rates between funnel stages (1+, 2+, 3+, 6+ orders). 
-- This helps highlight customer retention and drop-off points in the order journey.

-- Overall user funnel: users with 1+, 2+, 3+, 6+ orders
WITH u AS (
  SELECT user_id, COUNT(*) AS total_orders
  FROM orders
  GROUP BY user_id
),
levels AS (
  SELECT
    COUNT(*)                               AS users_total,
    SUM(total_orders >= 1)                 AS placed_1,
    SUM(total_orders >= 2)                 AS placed_2,
    SUM(total_orders >= 3)                 AS placed_3,
    SUM(total_orders >= 6)                 AS placed_6
  FROM u
)
SELECT
  users_total, placed_1, placed_2, placed_3, placed_6,
  ROUND(100.0 * placed_1 / users_total, 1)        AS pct_1_of_all,
  ROUND(100.0 * placed_2 / NULLIF(placed_1,0), 1) AS pct_2_of_1,
  ROUND(100.0 * placed_3 / NULLIF(placed_2,0), 1) AS pct_3_of_2,
  ROUND(100.0 * placed_6 / NULLIF(placed_3,0), 1) AS pct_6_of_3
FROM levels;

-- Interpretation

# Everyone orders at least once (by dataset design → 157k users).
# Only 65% return for a 2nd order → the biggest drop happens here.
# From 2 to 3 orders, retention holds steady (64%) → suggests loyal users are forming.
# By 6 orders, only 1 in 3 remain → long-term retention is a challenge.

-- This funnel shows early repeat purchase is the key bottleneck. If users can be nudged to make it past order #2, 
-- their likelihood of continuing rises significantly.

-- Next Steps

# Add more funnel stages (10+, 20+ orders) to measure long-term engagement.
# Segment funnels by:
	# First order day-of-week → are weekend vs weekday starters different?
    #Department of first product → do certain product types encourage loyalty?
# Export results to CSV and visualize as a funnel/bar chart for clearer storytelling.

-- This analysis demonstrates how SQL can be used not just for querying data, 
-- but for behavioral analytics and retention insights at scale (~90M rows).