# Card Transaction Trends – SQL Project

## 📌 Overview

This project focuses on analyzing corporate card transactions using SQL. It demonstrates the use of key SQL concepts such as `JOINs`, `CTEs`, `aggregations`, `window functions`, and `date functions` to extract meaningful insights from transactional data. The analysis identifies spending patterns, detects anomalies, and monitors card usage across departments and time periods.

## 📂 Dataset Structure

The project uses a relational schema with the following CSV-based tables:

- `employees` – Contains employee ID, name, department, and location.
- `merchants` – Includes merchant ID, category, and vendor details.
- `transactions` – Corporate card transactions with timestamps, amounts, employee IDs, and merchant IDs.

> All datasets have been cleaned and contain over 200 rows for meaningful analysis.

## 🧠 Key Concepts Demonstrated

- ✅ SQL Joins (INNER, LEFT, SELF)
- ✅ Common Table Expressions (CTEs)
- ✅ Aggregations & Grouping (`SUM`, `AVG`, `COUNT`)
- ✅ Window Functions (`ROW_NUMBER`, `RANK`, `OVER`)
- ✅ Filtering (`WHERE`, `HAVING`)
- ✅ Subqueries & Derived Tables
- ✅ Date-Time Analysis (monthly, quarterly trends)

## 📊 Business Questions Answered

- What are the monthly transaction trends across departments?
- Who are the top spenders?
- Which merchants receive the highest volume of transactions?
- Are there any suspicious or unusually large transactions?
- What is the average transaction size by department and category?

## 🛠 Tools Used

- **PostgreSQL (pgAdmin 4)** – for SQL querying
- **Tableau (Optional)** – for visualization and dashboard building

## 🧾 Example SQL Snippets

```sql
-- Monthly spend by department
WITH monthly_spend AS (
  SELECT 
    e.department,
    DATE_TRUNC('month', t.transaction_date) AS month,
    SUM(t.amount) AS total_spent
  FROM transactions t
  JOIN employees e ON t.employee_id = e.employee_id
  GROUP BY e.department, month
)
SELECT * FROM monthly_spend
ORDER BY month;
