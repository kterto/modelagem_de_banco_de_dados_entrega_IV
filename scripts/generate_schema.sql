-- 1. Create ENUM types for status fields
CREATE TYPE relation_status_type AS ENUM ('Friends', 'Blocked');
CREATE TYPE recipe_status_type AS ENUM ('Draft', 'Published', 'Private');
CREATE TYPE execution_status_type AS ENUM ('in_progress', 'paused', 'done');
CREATE TYPE hobbie_type AS ENUM ('brew', 'bake', 'cook', 'woodwork', 'diy');

-- 2. Create Tables

-- Table: User 
-- We will add the constraint at the end to avoid circular dependency errors during creation.
CREATE TABLE IF NOT EXISTS "User" (
    id SERIAL PRIMARY KEY, 
    name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    email VARCHAR(50),
    age INT,
    phone VARCHAR(50)
);

-- Table: User_Relation
CREATE TABLE IF NOT EXISTS User_Relation (
    id SERIAL PRIMARY KEY,
    follower_id INT NOT NULL,
    followed_id INT NOT NULL,
    status relation_status_type,
    created_at DATE NOT NULL,
    CONSTRAINT fk_follower FOREIGN KEY (follower_id) REFERENCES "User"(id),
    CONSTRAINT fk_followed FOREIGN KEY (followed_id) REFERENCES "User"(id)
);

-- Table: Federated_Identity
CREATE TABLE IF NOT EXISTS Federated_Identity (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    provider VARCHAR(50) NOT NULL,
    provider_id VARCHAR(100) NOT NULL,
    linked_at DATE NOT NULL,
    CONSTRAINT fk_fed_user FOREIGN KEY (user_id) REFERENCES "User"(id)
);

-- Table: Tool
CREATE TABLE IF NOT EXISTS Tool (
    id SERIAL PRIMARY KEY,
    name VARCHAR(30),
    metadata JSONB
);

-- Table: Recipe
CREATE TABLE IF NOT EXISTS Recipe (
    id SERIAL PRIMARY KEY,
    author_id INT NOT NULL,
    created_at DATE NOT NULL,
    updated_at DATE,
    deleted_at DATE,
    status recipe_status_type,
    CONSTRAINT fk_recipe_author FOREIGN KEY (author_id) REFERENCES "User"(id)
);

-- Table: Step
CREATE TABLE IF NOT EXISTS Step (
    id SERIAL PRIMARY KEY,
    recipe_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    instructions VARCHAR(2000),
    duration INT, -- Assuming minutes/seconds represented as integer
    "order" INT NOT NULL,
    CONSTRAINT fk_step_recipe FOREIGN KEY (recipe_id) REFERENCES Recipe(id)
);

-- Table: Ingredients
CREATE TABLE IF NOT EXISTS Ingredients (
    id SERIAL PRIMARY KEY,
    recipe_id INT NOT NULL,
    step_id INT,
    name VARCHAR(50) NOT NULL,
    hobbie hobbie_type,
    metadata JSONB,
    CONSTRAINT fk_ing_recipe FOREIGN KEY (recipe_id) REFERENCES Recipe(id),
    CONSTRAINT fk_ing_step FOREIGN KEY (step_id) REFERENCES Step(id)
);

-- Table: Recipe_Tool
CREATE TABLE IF NOT EXISTS Recipe_Tool (
    UniqueID SERIAL PRIMARY KEY,
    recipe_id INT NOT NULL,
    tool_id INT NOT NULL,
    step_id INT,
    CONSTRAINT fk_rt_recipe FOREIGN KEY (recipe_id) REFERENCES Recipe(id),
    CONSTRAINT fk_rt_tool FOREIGN KEY (tool_id) REFERENCES Tool(id),
    CONSTRAINT fk_rt_step FOREIGN KEY (step_id) REFERENCES Step(id)
);

-- Table: Recipe_Execution
CREATE TABLE IF NOT EXISTS Recipe_Execution (
    id SERIAL PRIMARY KEY,
    recipe_id INT,
    user_id INT,
    current_step_id INT,
    duration INT,
    description VARCHAR(1000),
    rate DECIMAL(2,1),
    status execution_status_type,
    created_at DATE NOT NULL,
    CONSTRAINT fk_exec_recipe FOREIGN KEY (recipe_id) REFERENCES Recipe(id),
    CONSTRAINT fk_exec_user FOREIGN KEY (user_id) REFERENCES "User"(id),
    CONSTRAINT fk_exec_step FOREIGN KEY (current_step_id) REFERENCES Step(id)
);

-- Table: Upload
CREATE TABLE IF NOT EXISTS Upload (
    id SERIAL PRIMARY KEY,
    step_id INT,
    recipe_id INT,
    recipe_execution_id INT,
    user_id INT,
    file_url VARCHAR(300) NOT NULL,
    thumbnail_url VARCHAR(300),
    content_type VARCHAR(50),
    created_at DATE NOT NULL,
    updated_at DATE,
    deleted_at DATE,
    CONSTRAINT fk_up_step FOREIGN KEY (step_id) REFERENCES Step(id),
    CONSTRAINT fk_up_recipe FOREIGN KEY (recipe_id) REFERENCES Recipe(id),
    CONSTRAINT fk_up_exec FOREIGN KEY (recipe_execution_id) REFERENCES Recipe_Execution(id),
    CONSTRAINT fk_up_user FOREIGN KEY (user_id) REFERENCES "User"(id)
);

-- Table: Recipe_Execution_likes
CREATE TABLE IF NOT EXISTS Recipe_Execution_likes (
    id SERIAL PRIMARY KEY,
    recipe_execution_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at DATE NOT NULL,
    CONSTRAINT fk_like_exec FOREIGN KEY (recipe_execution_id) REFERENCES Recipe_Execution(id),
    CONSTRAINT fk_like_user FOREIGN KEY (user_id) REFERENCES "User"(id)
);

-- Table: Recipe_execution_comment
CREATE TABLE IF NOT EXISTS Recipe_execution_comment (
    id SERIAL PRIMARY KEY,
    recipe_execution_id INT NOT NULL,
    user_id INT NOT NULL,
    text VARCHAR(300) NOT NULL DEFAULT '',
    parent_id INT,
    CONSTRAINT fk_com_exec FOREIGN KEY (recipe_execution_id) REFERENCES Recipe_Execution(id),
    CONSTRAINT fk_com_user FOREIGN KEY (user_id) REFERENCES "User"(id),
    CONSTRAINT fk_com_parent FOREIGN KEY (parent_id) REFERENCES Recipe_execution_comment(id)
);

-- Table: Recipe_execution_comment_like
CREATE TABLE IF NOT EXISTS Recipe_execution_comment_like (
    id SERIAL PRIMARY KEY,
    recipe_execution_comment_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at DATE NOT NULL,
    CONSTRAINT fk_comlike_comment FOREIGN KEY (recipe_execution_comment_id) REFERENCES Recipe_execution_comment(id),
    CONSTRAINT fk_comlike_user FOREIGN KEY (user_id) REFERENCES "User"(id)
);