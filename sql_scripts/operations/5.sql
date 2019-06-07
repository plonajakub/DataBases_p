SELECT r.recipe_id, r.recipe_name, i.ingredient_id, i.ingredient_name, i.quantity AS INGREDIENT_QUANTITY_IN_STOCK, ifr.ingredient_quantity as REQUIRED_INGEREDIENT_QUANTITY
FROM recipes r INNER JOIN ingredients_for_recipe ifr ON r.recipe_id = ifr.recipe_id
               INNER JOIN ingredients i ON ifr.ingredient_id = i.ingredient_id
WHERE i.ingredient_name IN ('OCTINOXATE', 'Propranolol Hydrochloride', 'Guaifenesin')
ORDER BY r.recipe_name;