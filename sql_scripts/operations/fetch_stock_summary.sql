-- narzędzia używane
SELECT t.tool_id, t.type, t.model, t.manufacturer_name
FROM tools_in_use tiu
INNER JOIN processes p ON tiu.process_id = p.process_id
INNER JOIN tools t ON tiu.tool_id = t.tool_id
WHERE p.status = 'in_progress';

-- narzędzia nieużywane
SELECT t.tool_id, t.type, t.model, t.manufacturer_name
FROM tools_in_use tiu
INNER JOIN processes p ON tiu.process_id = p.process_id
INNER JOIN tools t ON tiu.tool_id = t.tool_id
WHERE p.status <> 'in_progress';

-- skadniki, które sie kończa
SELECT ingredient_id, ingredient_name, quantity AS AVAILABLE_INGREDIENT_QUANTITY
FROM ingredients
WHERE quantity < 200;