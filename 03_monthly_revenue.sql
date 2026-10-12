-- Q1: How much does the company sell each month?
-- Revenue = item price of delivered orders (BRL), excluding freight.
SELECT d.year_month,
       ROUND(SUM(f.price), 2) AS revenue,
       COUNT(DISTINCT f.order_id) AS orders
FROM fact_sales f
JOIN dim_date d ON d.date_id = f.order_date
WHERE f.order_status = 'delivered'
GROUP BY d.year_month
ORDER BY d.year_month;
