SELECT r.recipe_id, r.recipe_name, i.ingredient_id, i.ingredient_name,
			i.quantity AS AVAILABLE_INGREDIENT_QUANTITY,
			ifr.ingredient_quantity as REQUIRED_INGEREDIENT_QUANTITY
FROM recipes r
INNER JOIN ingredients_for_recipe ifr ON r.recipe_id = ifr.recipe_id
INNER JOIN ingredients i ON ifr.ingredient_id = i.ingredient_id
WHERE i.ingredient_name IN ('OCTINOXATE', 'Tricolsan', 'Acarbose',
							'Cotton', 'Beef Bovine spp.', 'Candida albicans') -- nazwy skadników jako dane wejściowe
ORDER BY r.recipe_name;