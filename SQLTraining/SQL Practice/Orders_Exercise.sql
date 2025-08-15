/*
Interview Exercise: SQL Practice - Orders
Created 2025-08-15 by PiotrUr
*/

/* ============================================================
   Optional indexes that typically help these patterns
   (review with the actual execution plan before deploying)
------------------------------------------------------------ */
-- CREATE INDEX IX_Orders_CustomerId ON Orders(customer_id);
-- CREATE INDEX IX_Payments_OrderId  ON Payments(order_id);
-- Optionally covering for aggregations on Payments:
-- CREATE INDEX IX_Payments_OrderId_Amount ON Payments(order_id) INCLUDE (amount);
GO

/* ============================================================
   Z1 — All customers with the number of their orders
   Rationale:
   - Pre-aggregate orders per customer, then LEFT JOIN to Customers.
   - This keeps customers with zero orders (order_count = 0).
------------------------------------------------------------ */
WITH orders_per_customer AS (
    SELECT o.customer_id, COUNT(*) AS order_count
    FROM Orders AS o
    GROUP BY o.customer_id
)
SELECT
    c.customer_id,
    c.name,
    ISNULL(opc.order_count, 0) AS order_count  -- COALESCE(opc.order_count, 0) for ANSI portability
FROM Customers AS c
LEFT JOIN orders_per_customer AS opc
    ON opc.customer_id = c.customer_id;
GO

/* ============================================================
   Z2 — Orders with customer name and amount paid
   Rationale:
   - Sum payments per order once (pre-aggregation).
   - LEFT JOIN to include orders with no payments (NULL amount_paid).
------------------------------------------------------------ */
WITH payment_sum AS (
    SELECT p.order_id, SUM(p.amount) AS amount_paid
    FROM Payments AS p
    GROUP BY p.order_id
)
SELECT
    o.order_id,
    c.name,
    ps.amount_paid
FROM Orders AS o
JOIN Customers AS c
    ON c.customer_id = o.customer_id
LEFT JOIN payment_sum AS ps
    ON ps.order_id = o.order_id
ORDER BY o.order_id ASC;
GO

/* ============================================================
   Z3 — Customers who spent > 400 PLN in total
   Rationale:
   - Pre-aggregate total per customer from Orders+Payments,
     then filter on the small result set.
------------------------------------------------------------ */
WITH customer_total AS (
    SELECT o.customer_id, SUM(p.amount) AS total_spent
    FROM Orders AS o
    JOIN Payments AS p
        ON p.order_id = o.order_id
    GROUP BY o.customer_id
)
SELECT
    c.customer_id,
    c.name,
    ct.total_spent
FROM customer_total AS ct
JOIN Customers AS c
    ON c.customer_id = ct.customer_id
WHERE ct.total_spent > 400;
GO

/* ============================================================
   Z4 — Orders where sum of payments < total_amount
   Rationale:
   - Pre-aggregate payments per order, then compare against order total.
   - Treat NULL payments as 0 (unpaid orders).
------------------------------------------------------------ */
WITH payment_sum AS (
    SELECT p.order_id, SUM(p.amount) AS total_paid
    FROM Payments AS p
    GROUP BY p.order_id
)
SELECT
    o.order_id,
    ISNULL(ps.total_paid, 0) AS total_paid,   -- COALESCE(ps.total_paid, 0)
    o.total_amount
FROM Orders AS o
LEFT JOIN payment_sum AS ps
    ON ps.order_id = o.order_id
WHERE ISNULL(ps.total_paid, 0) < o.total_amount   -- COALESCE for ANSI
ORDER BY o.order_id ASC;
GO

/* ============================================================
   Z5 — Customers with their total spent amount, descending
   Rationale:
   - Include all customers; those without payments show 0.
   - Aggregate once over Orders+Payments, then join to Customers.
------------------------------------------------------------ */
WITH customer_total AS (
    SELECT o.customer_id, SUM(p.amount) AS total_spent
    FROM Orders AS o
    LEFT JOIN Payments AS p
        ON p.order_id = o.order_id
    GROUP BY o.customer_id
)
SELECT
    c.customer_id,
    c.name,
    ISNULL(ct.total_spent, 0) AS total_spent   -- COALESCE(ct.total_spent, 0)
FROM Customers AS c
LEFT JOIN customer_total AS ct
    ON ct.customer_id = c.customer_id
ORDER BY total_spent DESC;
GO

/* ============================================================
   (Optional) How to preview the estimated plan for any query
   without executing it (SQL Server):
------------------------------------------------------------ */
-- SET SHOWPLAN_XML ON;
-- -- paste a query here, e.g., the Z4 SELECT
-- SET SHOWPLAN_XML OFF;