CREATE TABLE employees (
    employee_id VARCHAR PRIMARY KEY,
    employee_name TEXT,
    department TEXT,
    company_name TEXT
);

CREATE TABLE merchants (
    merchant_name TEXT PRIMARY KEY,
    merchant_category TEXT,
    risk_level TEXT CHECK (risk_level IN ('Low', 'Medium', 'High'))
);

CREATE TABLE transactions (
    transaction_id VARCHAR PRIMARY KEY,
    employee_id VARCHAR REFERENCES employees(employee_id),
    date DATE,
    amount NUMERIC(12, 2),
    category TEXT,
    merchant TEXT REFERENCES merchants(merchant_name),
    location TEXT,
    card_type TEXT CHECK (card_type IN ('Corporate', 'Virtual'))
);


-- joining transactions with merchants and employees table

SELECT 
    t.transaction_id,
    t.date,
    t.amount,
    t.category AS transaction_category,
    m.merchant_category,
    m.risk_level,
    e.employee_name,
    e.department,
    e.company_name
FROM transactions t
JOIN employees e ON t.employee_id = e.employee_id
LEFT JOIN merchants m ON t.merchant = m.merchant_name;

-- High-Spending Departments

WITH dept_spend AS (
    SELECT 
        e.department,
        SUM(t.amount) AS total_spend
    FROM transactions t
    JOIN employees e ON t.employee_id = e.employee_id
    GROUP BY e.department
)
SELECT *
FROM dept_spend
WHERE total_spend > 10000
ORDER BY total_spend DESC;

-- Risky or High-Value Flags

SELECT 
    t.transaction_id,
    t.amount,
    m.risk_level,
    CASE 
        WHEN t.amount > 10000 THEN 'High-Value'
        WHEN m.risk_level = 'High' THEN 'High-Risk Merchant'
        ELSE 'Normal'
    END AS transaction_flag
FROM transactions t
LEFT JOIN merchants m ON t.merchant = m.merchant_name;

-- Rank Employees Within Departments

SELECT 
    e.department,
    e.employee_id,
    e.employee_name,
    SUM(t.amount) AS total_spend,
    RANK() OVER (
        PARTITION BY e.department 
        ORDER BY SUM(t.amount) DESC
    ) AS spend_rank
FROM transactions t
JOIN employees e ON t.employee_id = e.employee_id
GROUP BY e.department, e.employee_id, e.employee_name;

-- Merchants Used by >5 Unique Employees

SELECT merchant
FROM transactions
WHERE merchant IN (
    SELECT merchant
    FROM transactions
    GROUP BY merchant
    HAVING COUNT(DISTINCT employee_id) > 5
)
GROUP BY merchant;

-- Monthly Spend Trend by Company

SELECT 
    DATE_TRUNC('month', t.date) AS month,
    e.company_name,
    SUM(t.amount) AS total_spend
FROM transactions t
JOIN employees e ON t.employee_id = e.employee_id
GROUP BY month, e.company_name
ORDER BY month;

-- Monthly Spend Trends by Department

WITH monthly_trends AS (
    SELECT
        department,
        DATE_TRUNC('month', date) AS month,
        SUM(amount) AS total_monthly_spend
    FROM transactions t
    JOIN employees e ON t.employee_id = e.employee_id
    GROUP BY department, month
    ORDER BY month
)
SELECT * FROM monthly_trends;

-- Potential Fraud Detection Logic

WITH risky_transactions AS (
    SELECT
        t.transaction_id,
        e.employee_name,
        t.amount,
        t.date,
        m.merchant_name,
        m.risk_level
    FROM transactions t
    JOIN employees e ON t.employee_id = e.employee_id
    JOIN merchants m ON t.merchant = m.merchant_name
    WHERE m.risk_level = 'High' AND t.amount > 10000
)
SELECT * FROM risky_transactions;

-- Card Usage Behavior

SELECT
    card_type,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_spend,
    ROUND(AVG(amount), 2) AS avg_transaction_amount
FROM transactions
GROUP BY card_type;



