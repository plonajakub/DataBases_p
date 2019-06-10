-- Pobranie informacji o trwajacych procesach
SELECT * 
FROM processes 
WHERE status = 'in_progress';

-- Pobranie danych wszsytkich procesów
SELECT p.process_id, d.data_type, d.data_value, t.unit
FROM process_data d
JOIN data_types t ON d.data_type = t.data_type
JOIN processes p ON d.process_id = p.process_id;