-- 1. Insert Users (Start with picture = NULL to avoid circular dependency with Upload table)
INSERT INTO "User" (name, last_name, email, age, phone) VALUES 
('Gordon', 'Ramsay', 'gordon@kitchen.com', 56, '555-0101'),
('Jamie', 'Oliver', 'jamie@easycook.com', 47, '555-0102'),
('Alice', 'Brewer', 'alice@craftbeer.com', 32, '555-0103');

-- 2. Insert Tools
INSERT INTO Tool (name, metadata) VALUES 
('Stand Mixer', '{"brand": "KitchenAid", "capacity": "5L"}'),
('Cast Iron Skillet', '{"brand": "Lodge", "size": "12 inch"}'),
('Fermentation Bucket', '{"material": "Plastic", "volume": "5 Gallon"}');

-- 3. Insert Recipes
-- Gordon creates a Beef Wellington (Published)
-- Alice creates a Pale Ale (Draft)
INSERT INTO Recipe (author_id, created_at, status) VALUES 
(1, '2023-10-01', 'Published'),
(3, '2023-10-05', 'Draft');

-- 4. Insert Steps
-- Steps for Recipe 1 (Beef Wellington)
INSERT INTO Step (recipe_id, name, instructions, duration, "order") VALUES 
(1, 'Sear Beef', 'Sear the beef fillet in a hot pan with oil until browned all over.', 10, 1),
(1, 'Prepare Mushroom Duxelles', 'Finely chop mushrooms and fry until moisture evaporates.', 20, 2),
(1, 'Wrap and Bake', 'Wrap beef in puff pastry and bake at 200C.', 35, 3);

-- Steps for Recipe 2 (Pale Ale)
INSERT INTO Step (recipe_id, name, instructions, duration, "order") VALUES 
(2, 'Mash', 'Steep grains in hot water for 60 minutes.', 60, 1),
(2, 'Boil', 'Boil wort and add hops.', 60, 2);

-- 5. Insert Ingredients
-- Ingredients for Beef Wellington (Recipe 1) linked to steps
INSERT INTO Ingredients (recipe_id, step_id, name, hobbie, metadata) VALUES 
(1, 1, 'Beef Fillet', 'cook', '{"quantity": "1kg", "quality": "Prime"}'),
(1, 2, 'Mushrooms', 'cook', '{"type": "Chestnut", "quantity": "500g"}'),
(1, 3, 'Puff Pastry', 'bake', '{"type": "Ready-rolled"}');

-- Ingredients for Pale Ale (Recipe 2)
INSERT INTO Ingredients (recipe_id, step_id, name, hobbie, metadata) VALUES 
(2, 1, 'Maris Otter Malt', 'brew', '{"weight": "5kg"}'),
(2, 2, 'Citra Hops', 'brew', '{"weight": "100g", "alpha_acid": "12%"}');

-- 6. Link Tools to Recipes (Recipe_Tool)
INSERT INTO Recipe_Tool (recipe_id, tool_id, step_id) VALUES 
(1, 2, 1), -- Beef Wellington uses Skillet at Step 1
(2, 3, 1); -- Pale Ale uses Bucket at Step 1

-- 7. Insert Recipe Execution
-- Jamie (User 2) tries cooking Gordon's Beef Wellington (Recipe 1)
INSERT INTO Recipe_Execution (recipe_id, user_id, current_step_id, duration, description, rate, status, created_at) VALUES 
(1, 2, 3, 65, 'Turned out a bit soggy on the bottom, but taste was great.', 4.5, 'done', '2023-11-01');

-- 8. Insert Uploads (Photos)
-- Photo for the Recipe Execution (Jamie's result)
INSERT INTO Upload (recipe_execution_id, file_url, content_type, created_at) VALUES 
(1, 'http://uploads.site.com/jamie_wellington.jpg', 'image/jpeg', '2023-11-01');

-- Photo for Gordon's Profile
INSERT INTO Upload (user_id, file_url, content_type, created_at) VALUES 
(1, 'http://uploads.site.com/gordon_profile.jpg', 'image/jpeg', '2023-01-01');

-- 10. Insert Interactions (Likes and Comments)
-- Alice likes Jamie's execution of the Wellington
INSERT INTO Recipe_Execution_likes (recipe_execution_id, user_id, created_at) VALUES 
(1, 3, '2023-11-02');

-- Gordon comments on Jamie's execution
INSERT INTO Recipe_execution_comment (recipe_execution_id, user_id, text) VALUES 
(1, 1, 'Make sure the mushrooms are bone dry before wrapping!');

-- 11. Insert User Relations
-- Jamie follows Gordon
INSERT INTO User_Relation (follower_id, followed_id, status, created_at) VALUES 
(2, 1, 'Friends', '2023-09-01');