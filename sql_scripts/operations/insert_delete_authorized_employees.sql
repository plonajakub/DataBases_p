-- Dodanie nowego uprawnienia
INSERT INTO authorized_employees(project_id, employee_id)
VALUES(1, 2);

-- Usuniecie istniejacego uprawnienia
DELETE FROM authorized_employees
WHERE project_id = 1 AND employee_id = 2;