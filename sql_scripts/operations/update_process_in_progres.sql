DECLARE
    v_process_id processes.process_id%TYPE := 8; -- v_process_id jest dana wejsciowa programu
    v_process processes%ROWTYPE;
	v_tools_in_use BOOLEAN := FALSE;
	
	e_tools_in_use EXCEPTION;
    e_no_such_process EXCEPTION;
    e_invalid_process_state EXCEPTION;
    	
    CURSOR c_tools(p_recipe_id NUMBER) IS
        SELECT tool_id AS id
        FROM tools_for_recipe
        WHERE recipe_id = p_recipe_id;
    CURSOR c_tools_info(p_tool_id NUMBER) IS
        SELECT tiu.tool_id, tiu.process_id, p.status
        FROM tools_in_use tiu
        INNER JOIN processes p ON tiu.process_id = p.process_id
        WHERE tiu.tool_id = p_tool_id;
		    
BEGIN
    dbms_output.put_line('Process state update is about to start...' || CHR(10));
    
    BEGIN
        SELECT * INTO v_process
        FROM processes
        WHERE process_id = v_process_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('There is no process with provided ID!' || CHR(10));
            RAISE e_no_such_process;
    END;
       
    IF v_process.status <> 'planned' THEN
        dbms_output.put_line('Only planned process can be set to be in progress!' || CHR(10));
        RAISE e_invalid_process_state;
    END IF;
    
    FOR recipe_tool IN c_tools(v_process.recipe_id)
    LOOP
        FOR process_tool IN c_tools_info(recipe_tool.id)
        LOOP
            IF process_tool.status = 'in_progress' THEN
                v_tools_in_use := TRUE;
                dbms_output.put_line('Tool with ID = ' || to_char(recipe_tool.id) || ' is currently used by process with ID = ' ||
                                        to_char(process_tool.process_id));
            END IF;
        END LOOP;
    END LOOP;
    
    IF v_tools_in_use THEN
        dbms_output.put_line('Some tools required by process are unavailable.' || CHR(10));
        RAISE e_tools_in_use;
    END IF;
    
    UPDATE Processes
    SET status = 'in_progress', start_date = CURRENT_TIMESTAMP(0)
    WHERE process_id = v_process_id;
    dbms_output.put_line('Process status successfuly set to in_progress!' || CHR(10));
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Process status cannot be updated to in_progrss.' || CHR(10));
END;