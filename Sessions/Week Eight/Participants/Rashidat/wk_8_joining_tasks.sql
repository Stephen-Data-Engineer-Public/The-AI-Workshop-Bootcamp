-- =============================================================
-- Week 8: SQL Joins  -  EXERCISES
-- The AI Workshop Bootcamp  |  9 May 2026
-- =============================================================
-- Try each exercise yourself first. Use AI as a partner, not as a
-- shortcut. Compare your answer to 03-solutions.sql at the end.
--
-- Tables (recap):
--   Patients     (PatientID, NHSNumber, FirstName, LastName, ...)
--   Wards        (WardID, WardName, WardType, Capacity, Site)
--   Admissions   (AdmissionID, PatientID, WardID, AdmissionDate,
--                 DischargeDate, AdmissionType, Diagnosis, ...)
--   Observations (ObservationID, AdmissionID, ObsDateTime,
--                 ObsType, ObsValue, RecordedBy)
-- =============================================================

USE BootcampDB;
GO


SELECT * FROM Patients;


-- -------------------------------------------------------------
-- EXERCISE 1   (warm-up, INNER JOIN)
-- -------------------------------------------------------------
-- Return one row per admission with these columns:
--   PatientFullName, AdmissionDate, Diagnosis, AdmissionType
-- Order by AdmissionDate ascending.

-- Your query here:

SELECT 
    p.FirstName + ' ' + p.LastName AS PatientFullName, 
    a.AdmissionDate, 
    a.Diagnosis, 
    a.AdmissionType
FROM Admissions a
INNER JOIN Patients p ON a.PatientID = p.PatientID
ORDER BY a.AdmissionDate ASC;



-- -------------------------------------------------------------
-- EXERCISE 2   (LEFT JOIN, finding the gaps)
-- -------------------------------------------------------------
-- List EVERY ward and the number of admissions it has had.
-- Wards with zero admissions must still appear (with count = 0).
-- Order by AdmissionCount descending.

-- Your query here:

SELECT w.WardName, COUNT(a.AdmissionID) AS AdmissionCount
FROM Wards w
LEFT JOIN Admissions a
ON w.WardID = a.WardID
WHERE a.AdmissionID > 0
GROUP BY w.WardName
HAVING COUNT(a.AdmissionID) > 1
ORDER BY AdmissionCount DESC;


-- -------------------------------------------------------------
-- EXERCISE 3   (anti-join pattern)
-- -------------------------------------------------------------
-- Find patients who have NEVER been admitted.
-- Return: PatientID, FirstName, LastName, RegisteredGP.

-- Your query here:

SELECT 
    p.PatientID, 
    p.FirstName, 
    p.LastName, 
    p.RegisteredGP
FROM Patients AS p
LEFT JOIN Admissions AS a
ON p.PatientID = a.PatientID
WHERE a.AdmissionID IS NULL;


-- -------------------------------------------------------------
-- EXERCISE 4   (multi-table, 3 joins)
-- -------------------------------------------------------------
-- For every observation, return:
--   PatientFullName, WardName, ObsDateTime, ObsType, ObsValue
-- Order by ObsDateTime ascending.

-- Your query here:


SELECT 
    p.FirstName + ' ' + p.LastName AS PatientFullName, 
    w.WardName, 
    o.ObsDateTime, 
    o.ObsType, 
    o.ObsValue
FROM Patients AS p
INNER JOIN Admissions AS a
    ON p.PatientID = a.PatientID
INNER JOIN Wards AS w
    ON a.WardID = w.WardID
INNER JOIN Observations AS o
    ON  a.AdmissionID = o.AdmissionID
ORDER BY ObsDateTime ASC;


-- -------------------------------------------------------------
-- EXERCISE 5   (mixed INNER + LEFT)
-- -------------------------------------------------------------
-- Return one row per admission with:
--   PatientFullName, WardName, AdmissionDate,
--   FirstObsType, FirstObsValue
-- "First observation" = the earliest ObsDateTime for that admission.
-- Admissions with NO observations should still appear (NULLs allowed).
-- Hint: a subquery or APPLY may help, but it is solvable with joins
-- and a GROUP BY trick. AI-assisted attempts welcome.

-- Your query here:
-- Quick check
-- Quick peek at each table:

SELECT TOP 3 * FROM Patients;
SELECT TOP 3 * FROM Wards;
SELECT TOP 3 * FROM Admissions;
SELECT TOP 3 * FROM Observations;

-- Using OUTER APPLY

SELECT  
    p.FirstName + ' ' + p.LastName AS PatientFullName, 
    w.WardName, 
    a.AdmissionDate, 
    fo.ObsType AS FirstObsType,
    fo.ObsValue AS FirstObsValue
FROM Admissions AS a
INNER JOIN Patients AS p
    ON a.PatientID = p.PatientID
LEFT JOIN Wards AS w
    ON a.WardID = w.WardID
OUTER APPLY (
    SELECT TOP 1
    o.ObsType,
    o.ObsValue
    FROM Observations AS o
    WHERE o.AdmissionID = a.AdmissionID
    ORDER BY o.ObsDateTime ASC
) AS fo
ORDER BY a.AdmissionDate;



-- -------------------------------------------------------------
-- EXERCISE 6   (BONUS - self join)
-- -------------------------------------------------------------
-- Find pairs of patients who share the same RegisteredGP and
-- the same Postcode prefix (first 3 characters, e.g. 'LS1').
-- Return: PatientA, PatientB, GP, PostcodePrefix.
-- Avoid duplicate pairs (A-B and B-A) and self-pairs (A-A).

-- Your query here:

SELECT p1.FirstName + '' + p1.LastName AS PatientA, 
       P2.FirstName + '' + p2.LastName  AS PatientB,
       P1.RegisteredGP  AS GP,
       Left(p1.Postcode, 3) AS PostcodePrefix
FROM Patients as p1
INNER JOIN Patients AS p2 
ON p1.RegisteredGP = p2.RegisteredGP
    AND Left(p1.Postcode, 3) = Left(p2.Postcode, 3)
    AND p1.PatientID < p2.PatientID
WHERE p1.Postcode IS NOT NULL
    AND p2.Postcode IS NOT NULL
ORDER BY
    GP ASC,
    PostcodePrefix ASC;


-- -------------------------------------------------------------
-- EXERCISE 7   (BONUS - AI prompting practice)
-- -------------------------------------------------------------
-- Without writing the SQL yourself, write the BEST PROMPT you can
-- to get an AI to produce a correct query for this question:
--
-- "Show me each patient who is currently still admitted (no
--  discharge date), the ward they are on, the most recent vital
--  signs observation taken, and how many days they have been in."
--
-- Paste your prompt as a comment below. Discuss in the chat what
-- makes the prompt good or bad. Then test it with Claude or Copilot.

-- Your prompt:


-- 1. Write T-SQL for SQL Server.
-- 2. Schema: 
   -- Patients(PatientID PK, FirstName, LastName)
   -- Ward(WardID PK, WardName)
   -- Admissions(AdmissionID PK, PatientID FK, WardID FK, AdmissionDate, DischargeDate)
   -- Observation(ObservationID PK, AdmissionID FK, ObsDateTime, ObsType, ObsValue)

-- 3. Goal: 
    -- For each patient who’s currently still admitted (DischargeDate IS NULL), 
    -- return the - PatientFullName, WardName, the most recent vital Observations(ObsType and ObsValue), and number of days they have been on admission.

-- 4. Quality bar:    
   -- Use aliases. Use LEFT JOIN and INNER JOIN where appropriate.
   -- Handle NULLs. Order by DaysAdmitted."

-- 5. Verification:  Explain the join strategy. List any assumptions.


-- =============================================================
-- END OF EXERCISES
-- =============================================================
