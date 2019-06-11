SELECT COUNT(employee_id) AS HAS_PERMITION
FROM authorized_employees
WHERE (project_id = 1 AND employee_id = 1);
