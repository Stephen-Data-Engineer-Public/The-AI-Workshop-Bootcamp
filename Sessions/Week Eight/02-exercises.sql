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

-- -------------------------------------------------------------
-- EXERCISE 1   (warm-up, INNER JOIN)
-- -------------------------------------------------------------
-- Return one row per admission with these columns:
--   PatientFullName, AdmissionDate, Diagnosis, AdmissionType
-- Order by AdmissionDate ascending.

-- Your query here:
SELECT p.Firstname + ' ' + p.LastName AS PatientFullName
    , a.AdmissionDate
    , a.Diagnosis
    , a.AdmissionType
    FROM Patients p
    INNER JOIN Admissions a
    ON p.PatientID = a.PatientID
ORDER BY a.AdmissionDate ASC;

-- -------------------------------------------------------------
-- EXERCISE 2   (LEFT JOIN, finding the gaps)
-- -------------------------------------------------------------
-- List EVERY ward and the number of admissions it has had.
-- Wards with zero admissions must still appear (with count = 0).
-- Order by AdmissionCount descending.

-- Your query here:

SELECT w.WardName
    , COUNT(a.AdmissionID) AS AdmissionCount
FROM Wards w
LEFT JOIN Admissions a
ON a.WardID = w.WardID
GROUP BY w.WardName
ORDER BY AdmissionCount DESC

-- -------------------------------------------------------------
-- EXERCISE 3   (anti-join pattern)
-- -------------------------------------------------------------
-- Find patients who have NEVER been admitted.
-- Return: PatientID, FirstName, LastName, RegisteredGP.

-- Your query here:

SELECT p.PatientID, p.FirstName, p.LastName, p.RegisteredGP
FROM Patients p
LEFT JOIN Admissions a
ON p.PatientID = a.PatientID
WHERE a.AdmissionID IS NULL

-- -------------------------------------------------------------
-- EXERCISE 4   (multi-table, 3 joins)
-- -------------------------------------------------------------
-- For every observation, return:
--   PatientFullName, WardName, ObsDateTime, ObsType, ObsValue
-- Order by ObsDateTime ascending.

-- Your query here:

SELECT p.Firstname + '' + p.LastName AS PatientFullName
    , w.WardName
    , o.ObsDateTime
    , o.ObsType
    , o.ObsValue
FROM Observations o 
JOIN Admissions a ON o.AdmissionID = a.AdmissionID
JOIN Patients p ON p.PatientID = a.PatientID
JOIN Wards w ON w.WardID = a.WardID
ORDER BY ObsDateTime ASC


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

SELECT p.FirstName + ' ' + p.LastName AS PatientFullName
    ,w.WardName
    ,a.AdmissionDate
    ,obs.ObsType   AS FirstObsType
    ,obs.ObsValue  AS FirstObsValue
    ,obs.ObsDateTime AS FirstObservation
FROM Admissions a
INNER JOIN Patients p ON p.PatientID = a.PatientID
INNER JOIN Wards w ON w.WardID    = a.WardID
OUTER APPLY (
    SELECT TOP 1 o.ObsType
    ,o.ObsValue
    ,o.ObsDateTime
    FROM Observations o
    WHERE o.AdmissionID = a.AdmissionID
    ORDER BY o.ObsDateTime ASC
) obs;



-- -------------------------------------------------------------
-- EXERCISE 6   (BONUS - self join)
-- -------------------------------------------------------------
-- Find pairs of patients who share the same RegisteredGP and
-- the same Postcode prefix (first 3 characters, e.g. 'LS1').
-- Return: PatientA, PatientB, GP, PostcodePrefix.
-- Avoid duplicate pairs (A-B and B-A) and self-pairs (A-A).

-- Your query here:

SELECT p1.FirstName + ' ' + p1.LastName AS PatientA
    , p2.FirstName + ' ' + p2.LastName AS PatientB
    , p1.RegisteredGP AS GP
    , LEFT(p1.Postcode, 3) AS PostcodePrefix
FROM Patients p1
INNER JOIN Patients p2
    ON p1.RegisteredGP = p2.RegisteredGP
    AND LEFT(p1.Postcode, 3) = LEFT(p2.Postcode, 3)
    AND p1.PatientID < p2.PatientID


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
-- I'm interested in finding all patients that are still admitted. Identified by no discharge date
-- For each of these paitients I want to know the ward name, all observations and the number of days they 
-- have been admitted. Can you provide a SQL statement that can do this?

SELECT p.FirstName + ' ' + p.LastName     AS PatientName,
       w.WardName,
       a.AdmissionDate,
       DATEDIFF(DAY, a.AdmissionDate, GETDATE()) AS DaysAdmitted,
       o.ObsDateTime,
       o.ObsType,
       o.ObsValue
FROM Admissions a
INNER JOIN Patients p ON p.PatientID = a.PatientID
INNER JOIN Wards    w ON w.WardID    = a.WardID
LEFT JOIN Observations o ON o.AdmissionID = a.AdmissionID
WHERE a.DischargeDate IS NULL
ORDER BY PatientName, o.ObsDateTime;

SELECT p.FirstName + ' ' + p.LastName     AS PatientName,
       w.WardName,
       a.AdmissionDate,
       DATEDIFF(DAY, a.AdmissionDate, GETDATE()) AS DaysAdmitted,
       STRING_AGG(
           CONVERT(VARCHAR, o.ObsDateTime, 120) + ' - ' +
           o.ObsType + ': ' + CAST(o.ObsValue AS VARCHAR(50)),
           CHAR(13) + CHAR(10)
       ) WITHIN GROUP (ORDER BY o.ObsDateTime) AS Observations
FROM Admissions a
INNER JOIN Patients p ON p.PatientID = a.PatientID
INNER JOIN Wards    w ON w.WardID    = a.WardID
LEFT JOIN Observations o ON o.AdmissionID = a.AdmissionID
WHERE a.DischargeDate IS NULL
GROUP BY p.FirstName, p.LastName, w.WardName, a.AdmissionDate
ORDER BY PatientName;



-- =============================================================
-- END OF EXERCISES
-- Solutions are in 03-solutions.sql  (no peeking until you've tried!)
-- =============================================================
