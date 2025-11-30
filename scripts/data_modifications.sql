-- ==========================================
-- UPDATE COMMANDS
-- ==========================================

-- 1. Update Profile: Jamie Oliver changes his phone number
-- Scenario: User updates their contact info.
UPDATE "User"
SET phone = '555-9999'
WHERE name = 'Jamie' AND last_name = 'Oliver';

-- 2. Publish Recipe: Change Alice's 'Pale Ale' from Draft to Published
-- Scenario: A user finishes writing a recipe and makes it public.
-- We also update the 'updated_at' timestamp to the current date.
UPDATE Recipe
SET status = 'Published', 
    updated_at = CURRENT_DATE
WHERE id = 2;

-- 3. Fix Typo: Correcting instructions in the Beef Wellington recipe
-- Scenario: The author realized a mistake in step 1.
UPDATE Step
SET instructions = 'Sear the beef fillet in a VERY hot pan with oil until browned all over. Do not burn.'
WHERE recipe_id = 1 AND "order" = 1;


-- ==========================================
-- DELETE COMMANDS
-- ==========================================

-- 4. Unlike: Remove Alice's like from Jamie's execution
-- Scenario: A user accidentally liked a post and wants to remove it.
DELETE FROM Recipe_Execution_likes
WHERE user_id = 3 AND recipe_execution_id = 1;

-- 5. Remove Ingredient: Removing 'Citra Hops' from the Pale Ale
-- Scenario: The recipe changed and this ingredient is no longer needed.
DELETE FROM Ingredients
WHERE recipe_id = 2 AND name = 'Citra Hops';

-- 6. Unfriend/Unfollow: Jamie stops following Gordon
-- Scenario: Breaking a social connection.
DELETE FROM User_Relation
WHERE follower_id = 2 AND followed_id = 1;


-- ==========================================
-- SOFT DELETE
-- ==========================================
-- In production, we rarely run actual DELETEs on core data (like Recipes). 
-- Instead, we perform a "Soft Delete" by updating the date.

-- Soft Delete Gordon's Recipe
UPDATE Recipe
SET deleted_at = CURRENT_DATE,
    status = 'Private'
WHERE id = 1;