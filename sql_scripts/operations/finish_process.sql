-- Zakonczenie procesu z wpisaniem danych
SET TRANSACTION NAME 'process_finish';
UPDATE Processes
SET status = 'success', end_date = CURRENT_TIMESTAMP(0)
WHERE process_id = 3;
INSERT INTO process_data (process_id, data_type, data_value)
VALUES (3, 'temperature', '30');
COMMIT;

-- Wpisanie danych (bez zakonczenia procesu)
INSERT INTO process_data (process_id, data_type, data_value)
VALUES (3, 'temperature', '30');
