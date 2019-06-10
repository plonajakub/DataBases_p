SELECT p.project_id, p.project_name, p.manager_id, p.description
FROM projects p 
INNER JOIN authorized_employees ae ON p.project_id = ae.project_id
WHERE ae.employee_id = 23 -- employee_id jest argumentem wejściowym
ORDER BY p.project_name;