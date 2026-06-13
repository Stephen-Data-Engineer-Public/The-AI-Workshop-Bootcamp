# 🪟 SQL Window Functions — The AI Workshop SQL & AI Bootcamp

> **Session: Window Functions** · The AI Workshop CIC · *SQL & AI Bootcamp*
> Materials adapted from the RESGAD Tech write-up (Written by Stephen Nwoye · Reviewed by Alex Adjahossou)

---

## 🏁 The Big Idea (in one picture)

Imagine you're judging a community **marathon**. Runners of every age cross the line — children, teens, adults. You wouldn't rank a 10-year-old against a 25-year-old, would you? So you do the fair thing: you **group runners by age**, then measure each person against *their own peers*.

That is exactly what **window functions** do.

Picture your data as a long **train**. Each coach holds one group — just like the age brackets in the race. A window function applies a calculation (a total, an average, a ranking) *inside each coach, separately*. It's still **one train** — but every part is handled individually, with care. And it takes only a few lines of SQL.

**Window functions = clear logic + fair comparisons + smarter results.**

---

## 🎯 Learning Outcomes

By the end of this session you will be able to:

- Explain what a window (`OVER (...)`) is and how `PARTITION BY` and `ORDER BY` shape it.
- Apply the three **ranking** functions — `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()` — and explain how they treat ties.
- Bucket rows with `NTILE(n)`.
- Look forward and backward in a result set with `LEAD()` and `LAG()`.
- Run **aggregate window functions** (`SUM`, `AVG`, `MIN`, `MAX`) without collapsing your rows with `GROUP BY`.
- Recognise where window functions appear in the real world (e.g. converting prices to returns in finance).

---

## 🗂️ The Dataset

We work with a single `Runners` table. To keep everyone's environment identical, the sample data is wrapped inside a **view** — run the setup below once and you're ready.

```sql
-- ============================================================
--  SETUP — Runners sample data wrapped in a VIEW
--  Run this once on your SQL engine before the exercises.
-- ============================================================

CREATE VIEW Runners AS
SELECT * FROM (
    VALUES
        (1,  'Collins', 10, 55, 'Child'),
        (2,  'Alice',   12, 56, 'Child'),
        (3,  'Ben',     25, 40, 'Adult'),
        (4,  'Clara',   12, 51, 'Child'),
        (5,  'David',   10, 60, 'Child'),
        (6,  'Ella',    25, 42, 'Adult'),
        (7,  'Frank',   47, 44, 'Adult'),
        (8,  'Grace',   50, 50, 'Adult'),
        (9,  'Hannah',  29, 42, 'Adult'),
        (10, 'Ivan',    35, 39, 'Adult')
) AS r (RunnerID, Name, Age, FinishTime, Category);
```

> 💡 The `(VALUES ...) AS r (cols)` table-value constructor works in SQL Server, PostgreSQL and most modern engines. On SQL Server you can `SELECT * FROM Runners;` to confirm the view returns all 10 rows.

| RunnerID | Name | Age | FinishTime | Category |
|---:|---|---:|---:|---|
| 1 | Collins | 10 | 55 | Child |
| 2 | Alice | 12 | 56 | Child |
| 3 | Ben | 25 | 40 | Adult |
| 4 | Clara | 12 | 51 | Child |
| 5 | David | 10 | 60 | Child |
| 6 | Ella | 25 | 42 | Adult |
| 7 | Frank | 47 | 44 | Adult |
| 8 | Grace | 50 | 50 | Adult |
| 9 | Hannah | 29 | 42 | Adult |
| 10 | Ivan | 35 | 39 | Adult |

---

## 🧰 The Toolkit

### 1. Ranking functions

| Function | What it does | Ties | Gaps after a tie? |
|---|---|---|---|
| `ROW_NUMBER()` | Numbers every row uniquely | Broken arbitrarily | n/a — no ties |
| `RANK()` | Position by value | Tied rows share a rank | **Yes** — it skips ahead |
| `DENSE_RANK()` | Position by value | Tied rows share a rank | **No** — neat, tight lineup |
| `NTILE(n)` | Splits rows into `n` equal buckets | — | — |

**ROW_NUMBER()** — *no ties allowed.* Clean 1, 2, 3… for everyone, even when two times match.
**RANK()** — *fair but skips.* Two tied at 1st → next runner is 3rd.
**DENSE_RANK()** — *fair, no gaps.* Two tied at 1st → next runner is 2nd.
**NTILE(4)** — *buckets.* Splits all runners into four equal-sized groups (great for medals or snacks 🍫).

### 2. Offset functions — perspective

- **`LEAD()`** — peek at the **next** runner. Is someone closing the gap?
- **`LAG()`** — glance at the **previous** runner. Was the person before faster or slower?

### 3. Aggregate window functions — the whole group, without losing rows

- **`SUM()`** — add it all up (e.g. cumulative finishers).
- **`AVG()`** — the middle ground; what "normal" looks like.
- **`MIN()` / `MAX()`** — the fastest and the slowest.

The trick: an aggregate **with** an `OVER (...)` clause keeps every individual row, unlike `GROUP BY` which collapses them.

---

## 🔍 Worked Example — all four ranking functions side by side

```sql
SELECT
    RunnerID,
    Name,
    Age,
    FinishTime,
    Category,
    ROW_NUMBER() OVER (ORDER BY FinishTime) AS Row_Num,
    RANK()       OVER (ORDER BY FinishTime) AS Rnk,
    DENSE_RANK() OVER (ORDER BY FinishTime) AS Dense_Rnk,
    NTILE(4)     OVER (ORDER BY FinishTime) AS Ntile
FROM Runners;
```

Reading the output, notice how `Hannah` and `Ella` (both 42s) share a `RANK` of 3, the next runner jumps to 5, but `DENSE_RANK` keeps moving 3 → 4 with no gap. That contrast is the heart of the lesson.

---

## 🏋️ Exercises

Work through these in order. Each builds on the last. Solutions are at the bottom — try first, peek later.

### Exercise 1 — Fair ranking *within* each category 🥇

Rank the runners **inside their own category** by finish time (fastest = 1). A child shouldn't be ranked against an adult.

> **Hint:** this is where `PARTITION BY` earns its keep.


---

### Exercise 2 — How far off the pace? ⏱️

For **each runner**, show the difference between their finish time and the **fastest** time in their category. The category leader should show `0`.

> **Hint:** an aggregate window function (`MIN`) with `PARTITION BY` keeps every row — no `GROUP BY` needed.


---

### Exercise 3 — Fastest and slowest in each category 🐇🐢

Return **one row per extreme**: the fastest and the slowest runner in each category, labelled `'Fastest'` or `'Slowest'`.

> **Hint:** two `RANK()`s in a CTE — one ordered `ASC`, one `DESC` — then filter to rank `= 1`.


---

## 💹 Where this shows up in the real world — Finance

Window functions are everywhere in financial time-series work:

- **Prices → returns:** `LAG()` compares each price to the prior one to compute simple or log returns.
- **Imputing missing data:** `LAST_VALUE()` / `FIRST_VALUE()` / `LAG()` carry forward the last known value to fill gaps.
- **Aggregating trades:** `SUM() OVER (...)` and `ROW_NUMBER()` track cumulative positions and rolling averages — without losing row-level detail.

Same handful of functions, very different stakes.

---



**Expected result:**

| Category | Name | FinishTime | Position |
|---|---|---:|---|
| Adult | Ivan | 39 | Fastest |
| Adult | Grace | 50 | Slowest |
| Child | Clara | 51 | Fastest |
| Child | David | 60 | Slowest |

> 💡 The same answer can be written with `CROSS APPLY` — a neat alternative worth exploring once you're comfortable with the CTE form.
</details>

---

## 🧹 Cleanup

```sql
DROP VIEW Runners;
```

---

## 📎 Session Materials

- `README.md` — this guide
- `Window_Functions_Slides.pptx` — the session slide deck

*Built for The AI Workshop SQL & AI Bootcamp. Happy querying! 🚀*
