-- To be run within chem_lab schema

--1)
CREATE TABLE Suppliers (
supplier_id NUMBER(4) PRIMARY KEY,
supplier_name varchar2(50) NOT NULL,
phone_number varchar2(14) NOT NULL UNIQUE CHECK(regexp_like(phone_number, '^\+?\d{9,}$')),
address varchar2(50)
);

--2)
CREATE TABLE Ingredients (
ingredient_id NUMBER(5) PRIMARY KEY,
ingredient_name varchar2(100) NOT NULL,
quantity NUMBER(7) DEFAULT 0 NOT NULL CHECK (quantity >= 0),
notes varchar2(100),
supplier_id NUMBER(4),
CONSTRAINT supplier_id_fk FOREIGN KEY (supplier_id)
REFERENCES Suppliers(supplier_id) 
);

--3)
CREATE TABLE Tools (
tool_id NUMBER(5) PRIMARY KEY,
type varchar2(50) NOT NULL,
model varchar2(50),
manufacturer_name varchar2(50)
);

--4)
CREATE TABLE Employees (
employee_id NUMBER(5) PRIMARY KEY,
first_name varchar2(50) NOT NULL,
last_name varchar2(50) NOT NULL,
salary NUMBER(5) CHECK (salary >= 0)
);

--5)
CREATE TABLE Data_types (
data_type varchar2(30) PRIMARY KEY,
unit varchar2(15)
);

--6)
CREATE TABLE Recipes (
recipe_id NUMBER(5) PRIMARY KEY,
recipe_name varchar2(100) NOT NULL,
description varchar2(1000) NOT NULL
);

--7)
/* Wykaz składników potrzebnych do wykonania receptury */
CREATE TABLE Ingredients_for_recipe (
recipe_id NUMBER(5),
ingredient_id NUMBER(5), 
ingredient_quantity NUMBER(7) NOT NULL CHECK (ingredient_quantity > 0),
CONSTRAINT recipe_id_fk FOREIGN KEY (recipe_id)
REFERENCES Recipes(recipe_id),
CONSTRAINT ingredient_id_fk FOREIGN KEY (ingredient_id)
REFERENCES Ingredients(ingredient_id),
CONSTRAINT ingredients_for_recipe_pk PRIMARY KEY (recipe_id, ingredient_id)
);

--8)
/* Wykaz narzędzi potrzebnych do wykonania receptury */
CREATE TABLE Tools_for_recipe (
recipe_id NUMBER(5),
tool_id NUMBER(5), 
CONSTRAINT tool_id_fk FOREIGN KEY (tool_id) 
REFERENCES Tools(tool_id),
CONSTRAINT recipe_id_fk2 FOREIGN KEY (recipe_id) 
REFERENCES Recipes(recipe_id),
CONSTRAINT tools_for_recipe_pk PRIMARY KEY (recipe_id, tool_id)
);

--9)
CREATE TABLE Projects (
project_id NUMBER(5) PRIMARY KEY,
project_name varchar2(30) UNIQUE,
manager_id NUMBER(5) NOT NULL,
description varchar2(1000),
CONSTRAINT manager_id_fk FOREIGN KEY (manager_id) 
REFERENCES Employees(employee_id)
);

--10)
/* Wykaz pracowników uprawnionych do wglądu w projekt */
CREATE TABLE Authorized_employees (
project_id NUMBER(5), 
employee_id NUMBER(5),
CONSTRAINT employee_id_fk FOREIGN KEY (employee_id) 
REFERENCES Employees(employee_id),
CONSTRAINT project_id_fk FOREIGN KEY (project_id)
REFERENCES Projects(project_id),
CONSTRAINT authorized_employees_pk PRIMARY KEY (project_id, employee_id)
);

--11)
CREATE TABLE Processes (
process_id NUMBER(5) PRIMARY KEY,
project_id NUMBER(5) NOT NULL,
recipe_id NUMBER(5) NOT NULL,
employee_id NUMBER(5) NOT NULL,
status varchar2(11) DEFAULT 'planned' NOT NULL CHECK (status IN ('in_progress', 'planned', 'success', 'fail')),
start_date timestamp,
end_date timestamp,
notes varchar2(1000),
CONSTRAINT project_id_fk2 FOREIGN KEY (project_id) 
REFERENCES Projects(project_id),
CONSTRAINT recipe_id_fk3 FOREIGN KEY (recipe_id) 
REFERENCES Recipes(recipe_id),
CONSTRAINT employee_id_fk2 FOREIGN KEY (employee_id)
REFERENCES Employees(employee_id)
);

--12)
/*Wykaz danych procesu*/
CREATE TABLE Process_data (
process_id NUMBER(5), 
data_type varchar2(30),
data_value NUMBER(20, 5) DEFAULT 0 NOT NULL,
CONSTRAINT process_id_fk FOREIGN KEY (process_id)
REFERENCES Processes(process_id),
CONSTRAINT data_type_fk FOREIGN KEY (data_type) 
REFERENCES Data_types(data_type),
CONSTRAINT process_data_pk PRIMARY KEY (process_id, data_type)
);

--13)
/*Wykaz aktualnie używanych narzędzi*/
CREATE TABLE Tools_in_use (
process_id NUMBER(5),
tool_id NUMBER(5), 
CONSTRAINT tool_id_fk2 FOREIGN KEY (tool_id)
REFERENCES Tools(tool_id),
CONSTRAINT process_id_fk2 FOREIGN KEY (process_id)
REFERENCES Processes(process_id),
CONSTRAINT tools_in_use_pk PRIMARY KEY (process_id, tool_id)
);
