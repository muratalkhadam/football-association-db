USE football_association;

DROP TABLE IF EXISTS index_test;
CREATE TABLE index_test AS
SELECT p.id, p.first_name, p. last_name, p.player_number, c.team, c.start_date, c.end_date, c.salary
FROM players p
         CROSS JOIN contracts c;

SELECT COUNT(*)
FROM index_test;

EXPLAIN ANALYZE
SELECT DISTINCT id, last_name, last_name, team
FROM index_test
WHERE salary = 729631.00;

CREATE INDEX index_view_test
ON index_test(salary);

EXPLAIN ANALYZE
SELECT DISTINCT id, last_name, last_name, team
FROM index_test
WHERE salary = 729631.00;

DROP TABLE index_test;