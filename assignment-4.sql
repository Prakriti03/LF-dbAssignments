SET datestyle = 'MDY';

SET Search_Path to salary_management

COPY employee
FROM '/var/lib/postgresql/Salary-Prediction-of-Data-Professions.csv'
DELIMITER ','
CSV HEADER;

select * from employee;

-- Calculate the average salary by department for all Analysts.
WITH analyst_employee AS(
	SELECT * FROM Employee WHERE designation = 'Analyst'
)SELECT unit, AVG(salary) FROM analyst_employee
GROUP BY unit;

-- List all employees who have used more than 10 leaves.
WITH employees_leave AS(
	SELECT * FROM Employee WHERE leaves_used>10
)SELECT first_name, last_name FROM employees_leave;

-- Create a view to show the details of all Senior Analysts.
CREATE VIEW Senior_Analysts AS
SELECT * FROM Employee
WHERE designation = 'Senior Analyst';

-- Create a materialized view to store the count of employees by department.
-- Add a column called "emp_id" as primary key to count the number of employees.
ALTER TABLE employee
ADD emp_id SERIAL PRIMARY KEY;

CREATE MATERIALIZED VIEW Employee_Count AS
SELECT unit, COUNT(emp_id) FROM Employee
GROUP BY unit;

SELECT * FROM Employee_Count

-- Create a procedure to update an employee's salary by their first name and last name.
CREATE OR REPLACE PROCEDURE update_salary(
	name_first VARCHAR(50), 
	name_last VARCHAR(50)
)
LANGUAGE plpgsql   
AS $$
BEGIN
	UPDATE employee
	SET salary = salary + 10000
	WHERE first_name = name_first AND last_name = name_last;
END;$$;

SELECT * FROM employee WHERE first_name = 'ALONZO' AND last_name = 'ADSIDE';

-- call the procedure
CALL update_salary('ALONZO','ADSIDE');


-- Create a procedure to calculate the total number of leaves used across all departments.
CREATE OR REPLACE PROCEDURE leaves_departments_used()
LANGUAGE plpgsql
AS $$
BEGIN
    CREATE OR REPLACE VIEW leaves_used AS 
    SELECT unit AS department, SUM(leaves_used) AS total_leaves 
    FROM employee
    GROUP BY unit;
END;
$$;

CALL leaves_departments_used();

SELECT * FROM leaves_used;








