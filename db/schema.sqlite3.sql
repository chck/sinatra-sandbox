CREATE TABLE IF NOT EXISTS followers(
id int PRIMARY KEY NOT NULL ,
screen_name text UNIQUE NOT NULL ,
description text,
created_at int NOT NULL ,
updated_at int NOT NULL
);