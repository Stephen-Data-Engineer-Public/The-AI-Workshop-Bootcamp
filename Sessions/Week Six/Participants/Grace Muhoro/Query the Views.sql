---Find all orders for 'Latte' or 'Cappuccino' where the quantity is greater than 1

SELECT customer, product, qty
FROM vw_orders
WHERE product IN ('Latte','Cappuccino')
AND qty > 1

--Find all orders placed between '2024-02-01' and '2024-04-30' where a promo code was used

SELECT customer, product, order_date, promo_code
FROM vw_orders
WHERE order_date BETWEEN '2024-02-01' AND '2024-04-30'
AND promo_code IS NOT NULL

--Find all customers whose name starts with the letters A, E, or I

SELECT customer
FROM vw_orders
WHERE customer LIKE 'A%' OR customer LIKE 'E%' OR customer LIKE 'I%'

--Find all orders where the promo code is NULL or the quantity is exactly 1

SELECT customer, order_id, qty, promo_code
FROM vw_orders
WHERE promo_code IS NULL
OR qty = 1

--Using vw_sales_summary, show only the products whose total revenue across all months is greater than £200.

SELECT product, month, revenue
FROM vw_sales_summary
GROUP BY product, month, revenue
HAVING revenue > 200

