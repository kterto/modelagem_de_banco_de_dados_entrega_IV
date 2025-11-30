-- Query 1: "The Feed"
-- Goal: Find the 5 most recent 'Published' recipes and show the author's name.
-- Concepts: JOIN (Recipe -> User), WHERE, ORDER BY, LIMIT
SELECT 
    r.id AS recipe_id, 
    u.name AS author_name, 
    u.last_name AS author_lastname,
    r.created_at, 
    r.status
FROM Recipe r
JOIN "User" u ON r.author_id = u.id
WHERE r.status = 'Published'
ORDER BY r.created_at DESC
LIMIT 5;

-- Query 2: "The Ingredients List"
-- Goal: Get all ingredients for Recipe #1, ordered by the step they are used in.
-- Concepts: JOIN (Ingredients -> Step), WHERE, ORDER BY (using a reserved keyword column)
SELECT 
    s."order" AS step_number,
    s.name AS step_name,
    i.name AS ingredient,
    i.metadata
FROM Ingredients i
JOIN Step s ON i.step_id = s.id
WHERE i.recipe_id = 1
ORDER BY s."order" ASC;

-- Query 3: "Hall of Fame"
-- Goal: Find completed recipe executions rated 4 stars or higher, showing who cooked it.
-- Concepts: Double JOIN (Execution -> User & Execution -> Recipe), Complex WHERE
SELECT 
    u.name AS cook_name,
    re.rate AS rating,
    re.description AS review,
    re.created_at
FROM Recipe_Execution re
JOIN "User" u ON re.user_id = u.id
JOIN Recipe r ON re.recipe_id = r.id
WHERE re.status = 'done' AND re.rate >= 4.0
ORDER BY re.rate DESC, re.created_at DESC;