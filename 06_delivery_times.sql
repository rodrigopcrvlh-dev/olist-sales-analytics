-- Q4: In which states do deliveries take longest?
SELECT c.customer_state,
       COUNT(*) AS orders,
       ROUND(AVG(o.order_delivered_customer_date::date - o.order_purchase_timestamp::date), 1) AS avg_days,
       ROUND(100.0 * AVG(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END), 1) AS pct_late
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_days DESC;
