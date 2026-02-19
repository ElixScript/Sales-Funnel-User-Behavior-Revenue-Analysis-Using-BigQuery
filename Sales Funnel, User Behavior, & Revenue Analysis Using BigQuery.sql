SELECT *
FROM `sales-funnel-analysis-487709.sales_funnel.transactions`
LIMIT 10;

-- membuat CTE FUNCTION untuk menghitung jumlah user di setiap stage funnel 
WITH funnel_stages AS (

  SELECT
    COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS stage_1_views,
    COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS stage_2_cart,
    COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS stage_3_checkout,
    COUNT(DISTINCT CASE WHEN event_type = 'payment_info' THEN user_id END) AS stage_4_payment,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS stage_5_purchase

  FROM `sales-funnel-analysis-487709.sales_funnel.transactions`
  -- ini untuk mengambil 30 hari ke belakang 
  WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY))
)

-- menemukan conversion rate pada funnel 
SELECT
  stage_1_views,
  stage_2_cart,
  ROUND(stage_2_cart * 100.0 / stage_1_views, 2) AS view_to_cart_rate,

  stage_3_checkout,
  ROUND(stage_3_checkout * 100.0 / stage_2_cart, 2) AS cart_to_checkout_rate,

  stage_4_payment,
  ROUND(stage_4_payment * 100.0 / stage_3_checkout, 2) AS checkout_to_payment_rate,

  stage_5_purchase,
  ROUND(stage_5_purchase * 100.0 / stage_4_payment, 2) AS payment_to_purchase_rate,
  ROUND(stage_5_purchase * 100.0 / stage_1_views, 2) AS overall_conversion_rate

FROM funnel_stages;


-- Funnel berdasarkan traffic source 
WITH source_funnel AS (
  SELECT
    traffic_source,
    COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS views,

    COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS carts,

    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchases
  FROM `sales-funnel-analysis-487709.sales_funnel.transactions`
  WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY))
  GROUP BY traffic_source
)

-- SELECT *
-- FROM source_funnel
-- ORDER BY views DESC;

SELECT
  traffic_source,
  views,
  carts,
  purchases,

  ROUND(carts * 100.0 / NULLIF(views, 0), 2) AS cart_conversion_rate,
  ROUND(purchases * 100.0 / NULLIF(views, 0), 2) AS purchase_conversion_rate,
  ROUND(purchases * 100.0 / NULLIF(carts, 0), 2) AS cart_to_purchase_conversion_rate

FROM source_funnel
ORDER BY purchases DESC;

-- time to conversion analysis 
WITH user_journey AS (
  SELECT
    user_id,
    MIN(CASE WHEN event_type = 'page_view'  THEN event_date END) AS view_time,
    MIN(CASE WHEN event_type = 'add_to_cart' THEN event_date END) AS cart_time,
    MIN(CASE WHEN event_type = 'purchase'   THEN event_date END) AS purchase_time
  FROM `sales-funnel-analysis-487709.sales_funnel.transactions`
  WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY))
  GROUP BY user_id
  HAVING MIN(CASE WHEN event_type = 'purchase' THEN event_date END) IS NOT NULL
)

-- rata-rata durasi perjalanan user (dalam menit)
SELECT
  COUNT(*) AS converted_users,
  ROUND(AVG(TIMESTAMP_DIFF(cart_time, view_time, MINUTE)), 2) AS avg_view_to_cart_minutes,
  ROUND(AVG(TIMESTAMP_DIFF(purchase_time, cart_time, MINUTE)), 2) AS avg_cart_to_purchase_minutes,
  ROUND(AVG(TIMESTAMP_DIFF(purchase_time, view_time, MINUTE)), 2) AS avg_total_journey_minutes
FROM user_journey;

-- funnel + revenue dari 30 hari terakhir 
WITH funnel_revenue AS (
  SELECT
    COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS total_visitors,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS total_buyers,
    SUM(CASE WHEN event_type = 'purchase' THEN amount END) AS total_revenue,
    COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS total_orders
  FROM `sales-funnel-analysis-487709.sales_funnel.transactions`
  WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY))
)

-- KPI revenue funnel 
SELECT
  total_visitors,
  total_buyers,
  total_orders,
  total_revenue,
  total_revenue / NULLIF(total_orders, 0) AS avg_order_value,
  total_revenue / NULLIF(total_buyers, 0) AS revenue_per_buyer,
  total_revenue / NULLIF(total_visitors, 0) AS revenue_per_visitor
FROM funnel_revenue;







