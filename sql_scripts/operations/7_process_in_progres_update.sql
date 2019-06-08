
UPDATE Processes
SET status = 'in_progress', start_date = CURRENT_TIMESTAMP()
WHERE process_id = __id__;
