-- Q5: How do customers pay, and how much do they spend?
-- Note: payment_value includes freight, so totals differ from fact_sales revenue.
-- "payments" counts payment records, not orders (one order can have several payments).
SELECT p.payment_type,
       COUNT(*) AS payments,
       ROUND(SUM(p.payment_value), 2) AS total_value,
       ROUND(100.0 * SUM(p.payment_value) / SUM(SUM(p.payment_value)) OVER (), 2) AS pct_value,
       ROUND(AVG(p.payment_value), 2) AS avg_payment,
       ROUND(AVG(p.payment_installments), 1) AS avg_installments
FROM order_payments p
JOIN orders o ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY p.payment_type
ORDER BY total_value DESC;
