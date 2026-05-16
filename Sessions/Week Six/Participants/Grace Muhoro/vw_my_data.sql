--Create a view called vw_my_data from scratch — no tables, just VALUES
--It should have at least 5 columns with at least one number column, one text column, and one nullable column, and at least 8 rows
-- Mix your values so filters produce interesting results

CREATE VIEW vw_my_data AS
SELECT *
FROM (VALUES
--customer_id  first_name 		surname      gender  	department  	quantity_sold   amount_sold     date_sold 	discount_code
	(100, 		'Albert',   	'Peterson',  'Male',   	'Babies',               55, 		150000,    '09/11/2003',	'SAVE5%'),
	(101, 		'Prince',   	'Jaden',     'Male',   	'Fruits & Veggies',     47, 		70000,     '15/03/2003',	'SAVE5%'),
	(102, 		'Green',    	'Nathan',    'Male',   	'Pasteries',            38, 		23000,     '12/10/2002',	 NULL	),
	(103, 		'Philo',    	'White',     'Female', 	'Fashion',              47, 		100000,    '12/10/2002',	'SAVE5%'),
	(104, 		'John',     	'Brown',     'Male',   	'Pasteries',            28, 		90000,     '06/01/2005',	 NULL	),
	(105, 		'Josphine', 	'Trunk',     'Female', 	'Babies',               60, 		45000,     '15/12/2004',	'SAVE10%'),
	(106, 		'Carol',    	'Jordan',    'Female', 	'Babies',               53, 		28000,     '10/08/2005', 	'SAVE5%'),
	(107, 		'Stephnie', 	'Johnson',   'Female', 	'Fruits & Veggies',     40, 		65000,     '06/01/2005', 	'SAVE5%'),
	(108, 		'Craig',    	'Lambert',   'Male',   	'Shoes',                39, 		30000,     '09/11/2003', 	 NULL   ),
	(109, 		'Ginika',   	'Nzleu',     'Female', 	'Fashion',              30, 		20000000,  '12/22/2024', 	 NULL   ),
	(110, 		'Chidinma', 	'Nzelu',     'Female', 	'Pasteries',            20, 		450000,    '12/01/2024', 	 NULL   ),
	(111, 		'Joseph',   	'Obi',       'Male',   	'Food Stuff',           45, 		100000,    '21/05/2024', 	'SAVE5%'),
	(112, 		'Chike',    	'John',      'Male',   	'Shoes',                25, 		50000,     '23/04/2024',  	 NULL   ),
	(113, 		'Joshua',   	'Peter',     'Male',   	'Fashion',              15, 		10000,     '22/12/2024',  	 NULL   ),
	(114, 		'Mary',     	'Chukwudi',  'Female', 	'Shoes',                10, 		35000,     '29/03/2024',  	 NULL   ),
	(115, 		'Mathew',   	'Phillip',   'Male',   	'Pasteries',            18, 		15000,     '15/05/2024',  	 NULL   ),
	(116, 		'Mayjane',  	'Kamen',     'Female', 	'Babies',               28, 		65000,     '10/07/2024',  	 NULL   ),
	(117, 		'Chijioke', 	'John',      'Male',   	'Food Stuff',           40, 		55000,     '02/02/2024', 	'SAVE5%'),
	(118, 		'Oluebube', 	'Phillip',   'Female', 	'Fruits & Veggies',     20, 		35000,     '03/03/2024', 	 NULL   ),
	(119, 		'Solomon',  	'Chukwuma',  'Male',   	'Fruits & Veggies',     12, 		5000,      '20/01/2024', 	 NULL   ),
	(120, 		'Chioma',   	'Chukwuka',  'Female', 	'Food Stuff',           45, 		60000,     '25/12/2024', 	'SAVE5%'),
	(121, 		'Chika',    	'Mark',      'Male',   	'Pasteries',            28, 		35000,     '15/07/2024', 	 NULL   ),
	(122, 		'Ujunwa',   	'Obidike',   'Female', 	'Fashion',              35, 		70000,     '18/12/2024', 	 NULL   ),
	(123, 		'Kamsi',    	'Emeka',     'Male',   	'Fashion',              45, 		105000,    '06/01/2024', 	'SAVE5%'),
	(124, 		'Nafisat',  	'Joseph',    'Female', 	'Shoes',                10, 		1000000,   '11/11/2024', 	 NULL	),
	(125, 		'Tochukwu', 	'Emenike',   'Male',   	'Shoes',                20, 		500000,    '10/10/2024', 	 NULL	),
	(126, 		'Chinaza',  	'Chima',     'Female', 	'Fashion',              30, 		25000,     '05/08/2024', 	 NULL	),
	(127, 		'Emeka',    	'Frank',     'Female', 	'Shoes',                40, 		800000,    '15/09/2024', 	'SAVE5%')
) AS t(customer_id, first_name, surname, gender, department, quantity_sold, amount_sold, date_sold, discount_code);

