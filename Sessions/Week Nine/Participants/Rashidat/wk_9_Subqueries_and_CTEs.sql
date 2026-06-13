-- Week 9 tasks

-- Views

-- Drop and recreate — run both blocks together
DROP VIEW IF EXISTS vw_patients;
GO

-- Patients
CREATE VIEW vw_patients AS
SELECT * FROM (VALUES
    (1, 'Amara Osei',      'Cardiology',    3),
    (2, 'David Mensah',    'Orthopaedics',  1),
    (3, 'Fatima Al-Rashid','Cardiology',    5),
    (4, 'James Okafor',    'Neurology',     2),
    (5, 'Priya Patel',     'Orthopaedics',  0)
) AS p(patient_id, patient_name, ward, spell_count);
GO

SELECT * FROM vw_patients;


DROP VIEW IF EXISTS vw_ward_avg;
GO

-- Ward averages (pre-computed for illustration)
CREATE VIEW vw_ward_avg AS
SELECT * FROM (VALUES
    ('Cardiology',    4.0),
    ('Orthopaedics',  0.5),
    ('Neurology',     2.0)
) AS w(ward, avg_spells);
GO

SELECT * FROM vw_ward_avg;


DROP VIEW IF EXISTS vw_discharges;
GO

-- Discharges
CREATE VIEW vw_discharges AS
SELECT * FROM (VALUES
    (1, 'Amara Osei',    '2026-04-10'),
    (3, 'Fatima Al-Rashid','2026-04-22'),
    (4, 'James Okafor',  '2026-05-01')
) AS d(patient_id, patient_name, discharge_date);
GO

SELECT * FROM vw_discharges;

-- Exercise 1
-- Find patients whose spell count is above the ward average Scalar subquery in WHERE
-- Returns: Fatima Al-Rashid and David Mensah as they are above their ward average

SELECT patient_name, ward, spell_count
FROM vw_patients p
WHERE spell_count  > (
    SELECT avg_spells
    FROM vw_ward_avg w
    WHERE w.ward = p.ward
);


-- Exercise 2
-- List wards that have never had a discharge - NOT EXISTS subquery
-- Returns: David Mensah, Priya Patel as neither names in the vw_discharges view

SELECT patient_id, patient_name, ward
FROM vw_patients p
WHERE NOT EXISTS (
	SELECT 1
	FROM vw_discharges d
WHERE d.patient_id = p.patient_id
);


-- Ordering do really matter
-- Returns nothing
SELECT patient_id, patient_name
FROM vw_discharges d
WHERE NOT EXISTS (
	SELECT 1
	FROM vw_patients p
	WHERE p.patient_id = d.patient_id
);


-- Exercise 3: Rewrite a nested subquery as a CTE - CTE refactoring
-- Exercise 1 refactored: Find patients whose spell count is above the ward average Scalar subquery in WHERE
-- Returns: Fatima Al-Rashid and David Mensah as they are above their ward average, but also include the avg_spells

WITH curr_patients AS (
    SELECT ward, avg_spells
    FROM vw_ward_avg 
)
SELECT p.patient_name, p.ward, p.spell_count, cp.avg_spells
FROM vw_patients p
JOIN curr_patients cp 
    ON cp.ward = p.ward
WHERE p.spell_count > cp.avg_spells;



-- Exercise 4: Produce a patient journey summary using chained CTEs - Multi-CTE pipeline

-- Step 1: Patients with at least a spell

WITH 
spells AS (
    SELECT patient_id, patient_name, ward, spell_count
    FROM vw_patients
    WHERE spell_count > 0
),

-- Step 2: Return the total and highest spells per ward
total_avg_w_summary AS (
        SELECT
        ward,
        COUNT(*) AS patient_count,
        SUM(spell_count) AS total_spells,
        MAX(spell_count) AS max_spells
FROM spells s
GROUP BY ward
),

-- Step 3: Check if patients were discharged
flag_discharged_patient AS (
	SELECT  s.patient_id,
            s.patient_name,
            s.ward,
            s.spell_count,
            ts.patient_count  AS ward_patient_count,
            ts.total_spells   AS ward_total_spells,
            ts.max_spells     AS ward_max_spells,
            d.discharge_date,
	        CASE 
                WHEN d.patient_id IS NOT NULL THEN 'Yes' 
                ELSE 'No'
            END AS discharged
	FROM spells s
    LEFT JOIN total_avg_w_summary ts 
        ON s.ward = ts.ward
	LEFT JOIN vw_discharges d 
        ON s.patient_id = d.patient_id
)


-- Step 4: Check the most recent discharge
SELECT 
    TOP 4
    patient_id,
    patient_name,
    ward,
    spell_count,
    ward_patient_count,
    ward_total_spells,
    ward_max_spells,
    discharged,
    discharge_date
FROM flag_discharged_patient 
ORDER BY discharge_date DESC;



--5	(Stretch) Build a recursive CTE over a referral hierarchy	Recursive CTE