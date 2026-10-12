-- Q3: Do customers come back to buy again?
-- Note: Olist creates a new customer_id for every order,
-- so people are identified with customer_unique_id.
WITH orders_per_customer AS (
  SELECT c.customer_unique_id,
         COUNT(DISTINCT o.order_id) AS n_orders
  FROM orders o
  JOIN customers c ON c.customer_id = o.customer_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_unique_id
)
SELECT CASE WHEN n_orders = 1 THEN '1 order' ELSE '2+ orders' END AS segment,
       COUNT(*) AS customers,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM orders_per_customer
GROUP BY 1
ORDER BY 1;
