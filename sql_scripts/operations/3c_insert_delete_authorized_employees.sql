-- dane poprzedzone znakiem "_" są danymi wejściowymi

INSERT INTO authorized_employees
VALUES(_project_id, _employee_id);

DELETE FROM authorized_employees
WHERE project_id = _project_id AND employee_id = _employee_id;