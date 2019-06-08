--A i B--
SET TRANSACTION NAME 'process_finish'
UPDATE Processes
SET status = 'in_progress', end_date = CURRENT_TIMESTAMP()
WHERE process_id = __id__;
INSERT INTO process_data (process_id, data_type, data_value)
VALUES (__process_id__, __data_type__, __value__);
COMMIT;

--A--
INSERT INTO process_data (process_id, data_type, data_value)
VALUES (__process_id__, __data_type__, __value__);
