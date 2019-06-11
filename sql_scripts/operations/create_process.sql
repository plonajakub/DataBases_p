DECLARE
    v_process_id processes.process_id%TYPE;
    v_project_id projects.project_id%TYPE := 3; -- v_project_id jest dana wejsciowa
    v_recipe_id recipes.recipe_id%TYPE := 6; -- v_recipe_id jest dana wejsciowa
    v_employee_id employees.employee_id%TYPE := 3; -- v_emloyee_id jest dana wejsciowa
    
    
    v_temp_quantity ingredients.quantity%TYPE;
    v_missing_ingredients BOOLEAN := FALSE;
    v_temp_supplier suppliers%ROWTYPE;
    
    e_missing_ingredients EXCEPTION;
    
    CURSOR c_ingredients IS
        SELECT i.ingredient_id AS id, i.ingredient_name AS name, i.quantity AS available_quantity, ifr.ingredient_quantity AS needed_quantity, i.supplier_id
        FROM ingredients_for_recipe ifr
        INNER JOIN ingredients i ON ifr.ingredient_id = i.ingredient_id
        WHERE ifr.recipe_id = v_recipe_id;     
    CURSOR c_tools IS
        SELECT tool_id AS id
        FROM tools_for_recipe
        WHERE recipe_id = v_recipe_id;
BEGIN
    SAVEPOINT before_process_creation;
    dbms_output.put_line('New process is being created...' || CHR(10));
    
    SELECT MAX(process_id) + 1 INTO v_process_id
    FROM processes;
    
    IF v_process_id IS NULL THEN
        v_process_id := 1;
    END IF;
    
    BEGIN
        INSERT INTO authorized_employees
        VALUES (v_project_id, v_employee_id);
        dbms_output.put_line('Privileges granted for project with ID = ' || to_char(v_project_id) || ' to employee with ID = ' || to_char(v_employee_id) || CHR(10));
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            NULL; -- no operation in case of employee already authorized
    END;
    
    FOR ingredient IN c_ingredients
    LOOP
        IF ingredient.needed_quantity <= ingredient.available_quantity THEN
            UPDATE ingredients
            SET quantity = quantity - ingredient.needed_quantity
            WHERE ingredient_id = ingredient.id;
            SELECT quantity INTO v_temp_quantity
            FROM ingredients
            WHERE ingredient_id = ingredient.id;
            dbms_output.put_line('Ingredient with ID = ' || to_char(ingredient.id) || ' reserved' || CHR(10) ||
                                    'Old quantity = ' || to_char(ingredient.available_quantity) || CHR(10) ||
                                    'Current quantity = ' || to_char(v_temp_quantity) || CHR(10));
        ELSE
            SELECT * INTO v_temp_supplier
            FROM suppliers
            WHERE supplier_id = ingredient.supplier_id;
            dbms_output.put_line('############################################################################################' || chr(10) ||
                                    'There is not enought of ingredient ' || ingredient.name || ' in stock' || chr(10) ||
                                    'Contact ' || v_temp_supplier.supplier_name || ' with phone number ' || to_char(v_temp_supplier.phone_number) ||
                                    ' to order missing ingredient' || chr(10) ||
                                    '############################################################################################');
            v_missing_ingredients := TRUE;
        END IF;
        IF v_missing_ingredients THEN
            ROLLBACK TO before_process_creation;
            RAISE e_missing_ingredients;
        END IF;
    END LOOP;
    
    INSERT INTO processes
    VALUES (v_process_id, v_project_id, v_recipe_id, v_employee_id, 'planned', NULL, NULL, NULL);
    dbms_output.put_line('The process will have an ID = ' || to_char(v_process_id));
    
    FOR tool IN c_tools
    LOOP
        INSERT INTO tools_in_use
        VALUES (v_process_id, tool.id);
        dbms_output.put_line('Tool with ID = ' || to_char(tool.id) || ' added to TOOLS_IN_USE for current process');
    END LOOP;
    dbms_output.put_line(CHR(10) || 'New process created!' || CHR(10));
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line(CHR(10) || 'Process not created!' || CHR(10) || 'No changes were made to the database.' || CHR(10));
END;
