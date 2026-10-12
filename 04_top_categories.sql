-- Q2: Which product categories generate the most revenue?
SELECT p.category_en,
       ROUND(SUM(f.price), 2) AS revenue,
       COUNT(*) AS units,
       ROUND(SUM(f.price) / COUNT(*), 2) AS avg_price,
       RANK() OVER (ORDER BY SUM(f.price) DESC) AS ranking
FROM fact_sales f
JOIN dim_product p ON p.product_id = f.product_id
WHERE f.order_status = 'delivered'
GROUP BY p.category_en
ORDER BY revenue DESC
LIMIT 10;
