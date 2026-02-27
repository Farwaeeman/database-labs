-- Lab 3 Queries
-- Name: Farwa Eeman
-- Date: February 27, 2026

-- Query 1 - Overall Business Summary
SELECT COUNT(*) AS total_orders,
SUM(total_amount) AS total_revenue,
ROUND(AVG(total_amount), 2) AS avg_order_value,
MAX(total_amount) AS largest_order
FROM orders
WHERE status = 'delivered';

-- Query 2 - Revenue by Product Category
SELECT category,
COUNT(*) AS total_products,
ROUND(AVG(price), 2) AS avg_price
FROM products
GROUP BY category
HAVING AVG(price) > 3000
ORDER BY avg_price DESC;

-- Query 3 - Customer Totals CTE
WITH customer_totals AS (
    SELECT customer_id,
    SUM(total_amount) AS total_spent,
    COUNT(*) AS num_orders
    FROM orders
    WHERE status = 'delivered'
    GROUP BY customer_id
)
SELECT customer_id, total_spent, num_orders
FROM customer_totals
WHERE total_spent > 10000
ORDER BY total_spent DESC;

-- Query 4 - Customer Tiers
WITH customer_spend AS (
    SELECT customer_id,
    SUM(total_amount) AS total_spent,
    COUNT(*) AS num_orders
    FROM orders
    WHERE status = 'delivered'
    GROUP BY customer_id
),
customer_tiers AS (
    SELECT customer_id,
    total_spent,
    num_orders,
    CASE
        WHEN total_spent > 30000 THEN 'VIP'
        WHEN total_spent > 10000 THEN 'Regular'
        ELSE 'Occasional'
    END AS tier
    FROM customer_spend
)
SELECT tier,
COUNT(*) AS num_customers,
SUM(total_spent) AS total_revenue
FROM customer_tiers
GROUP BY tier
ORDER BY total_revenue DESC;

-- Query 5 - Session Summary Combined
WITH session_summary AS (
    SELECT customer_id,
    COUNT(*) AS total_sessions,
    SUM(pages_viewed) AS total_pages,
    ROUND(AVG(duration_mins), 2) AS avg_duration,
    SUM(CASE WHEN converted THEN 1 ELSE 0 END) AS converted_sessions
    FROM user_sessions
    GROUP BY customer_id
),
order_summary AS (
    SELECT customer_id,
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_spent
    FROM orders
    WHERE status = 'delivered'
    GROUP BY customer_id
),
combined AS (
    SELECT c.name,
    c.city,
    s.total_sessions,
    s.total_pages,
    s.avg_duration,
    s.converted_sessions,
    COALESCE(o.total_orders, 0) AS total_orders,
    COALESCE(o.total_spent, 0) AS total_spent
    FROM session_summary s
    JOIN customers c ON s.customer_id = c.customer_id
    LEFT JOIN order_summary o ON s.customer_id = o.customer_id
)
SELECT name,
city,
total_sessions,
total_pages,
avg_duration,
total_orders,
total_spent,
ROUND(
    CASE WHEN total_sessions > 0
    THEN 100.0 * total_orders / total_sessions
    ELSE 0
    END, 1
) AS orders_per_100_sessions
FROM combined
ORDER BY total_sessions DESC, orders_per_100_sessions ASC;
