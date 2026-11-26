DROP INDEX IF EXISTS ix_orders_customer;
DROP INDEX IF EXISTS ix_orders_ordered_on;
DROP INDEX IF EXISTS ix_orderline_order;
DROP INDEX IF EXISTS ix_orderline_product;
.timer on

.print '=== ORIGINAL (GROUP BY) ==='
EXPLAIN QUERY PLAN
SELECT c.customer_id, c.name, COUNT(*) AS late_orders
FROM orders o JOIN customer c ON c.customer_id = o.customer_id
WHERE o.status = 'late'
GROUP BY c.customer_id, c.name
ORDER BY late_orders DESC;

.print '=== CORRELATED SUBQUERY ==='
EXPLAIN QUERY PLAN
SELECT customer_id, name, late_orders FROM (
  SELECT c.customer_id, c.name,
         (SELECT COUNT(*) FROM orders o
          WHERE o.customer_id = c.customer_id AND o.status = 'late') AS late_orders
  FROM customer c)
WHERE late_orders > 0
ORDER BY late_orders DESC;

.print '=== WINDOW FUNCTION ==='
EXPLAIN QUERY PLAN
SELECT DISTINCT c.customer_id, c.name,
       COUNT(*) OVER (PARTITION BY c.customer_id) AS late_orders
FROM orders o JOIN customer c ON c.customer_id = o.customer_id
WHERE o.status = 'late'
ORDER BY late_orders DESC;

.print '=== TIMINGS (output hidden, timer shows cost) ==='
.output nul
SELECT c.customer_id, c.name, COUNT(*) AS late_orders FROM orders o JOIN customer c ON c.customer_id = o.customer_id WHERE o.status = 'late' GROUP BY c.customer_id, c.name ORDER BY late_orders DESC;
SELECT customer_id, name, late_orders FROM (SELECT c.customer_id, c.name, (SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.customer_id AND o.status = 'late') AS late_orders FROM customer c) WHERE late_orders > 0 ORDER BY late_orders DESC;
SELECT DISTINCT c.customer_id, c.name, COUNT(*) OVER (PARTITION BY c.customer_id) AS late_orders FROM orders o JOIN customer c ON c.customer_id = o.customer_id WHERE o.status = 'late' ORDER BY late_orders DESC;
.output stdout

.print '=== CORRELATED + INDEX ==='
CREATE INDEX ix_orders_customer ON orders(customer_id, status);
EXPLAIN QUERY PLAN
SELECT customer_id, name, late_orders FROM (
  SELECT c.customer_id, c.name,
         (SELECT COUNT(*) FROM orders o
          WHERE o.customer_id = c.customer_id AND o.status = 'late') AS late_orders
  FROM customer c)
WHERE late_orders > 0
ORDER BY late_orders DESC;