--Write 3 queries against the VIEW that each use at least one of: WHERE clause with AND / OR and parentheses, BETWEEN or IN, IS NULL or IS NOT NULL

SELECT customer_id, first_name, surname, quantity_sold, amount_sold
FROM vw_my_data
WHERE amount_sold >= 500000
AND discount_code IS NOT NULL

SELECT customer_id, first_name, surname, quantity_sold, amount_sold
FROM vw_my_data
WHERE (discount_code = 'SAVE5%' OR discount_code IS NULL)
AND quantity_sold > 50

SELECT department, SUM(quantity_sold) AS total_quantity, SUM(amount_sold) AS total_sales
FROM vw_my_data
WHERE(date_sold BETWEEN '01/01/2024' AND '31/12/2024'
AND discount_code IN ('SAVE5%'))
GROUP BY department, discount_code
ORDER BY SUM(amount_sold) DESC

