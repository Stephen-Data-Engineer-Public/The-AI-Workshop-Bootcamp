--A simple coffee shop order log.

CREATE VIEW vw_orders AS
SELECT *
FROM (VALUES
--  order_id  customer   product       order_date     qty  unit_price  promo_code
        (1,  'Alice',   'Latte',       '2024-01-05',   2,   3.50,  'SAVE10'),
        (2,  'Bob',     'Espresso',    '2024-01-12',   1,   2.00,   NULL   ),
        (3,  'Clara',   'Cappuccino',  '2024-02-03',   3,   3.20,  'SAVE10'),
        (4,  'David',   'Latte',       '2024-02-18',   1,   3.50,   NULL   ),
        (5,  'Eve',     'Tea',         '2024-03-07',   4,   1.80,   NULL   ),
        (6,  'Frank',   'Espresso',    '2024-03-22',   2,   2.00,  'VIP20' ),
        (7,  'Grace',   'Cappuccino',  '2024-04-10',   1,   3.20,   NULL   ),
        (8,  'Henry',   'Latte',       '2024-04-25',   5,   3.50,  'VIP20' ),
        (9,  'Isla',    'Tea',         '2024-05-01',   2,   1.80,   NULL   ),
        (10, 'James',   'Espresso',    '2024-05-14',   3,   2.00,  'SAVE10')
) AS t(order_id, customer, product, order_date, qty, unit_price, promo_code);

--Monthly sales totals per product.

CREATE VIEW vw_sales_summary AS
SELECT *
FROM (VALUES
--  sale_id   product        month        units_sold  revenue
        (1,  'Latte',       'January',    45,   157.50),
        (2,  'Espresso',    'January',    30,    60.00),
        (3,  'Cappuccino',  'January',    20,    64.00),
        (4,  'Tea',         'January',    10,    18.00),
        (5,  'Latte',       'February',   50,   175.00),
        (6,  'Espresso',    'February',   25,    50.00),
        (7,  'Cappuccino',  'February',   15,    48.00),
        (8,  'Tea',         'February',    5,     9.00),
        (9,  'Latte',       'March',      60,   210.00),
        (10, 'Espresso',    'March',      40,    80.00),
        (11, 'Cappuccino',  'March',      30,    96.00),
        (12, 'Tea',         'March',       8,    14.40)
) AS t(sale_id, product, month, units_sold, revenue);
