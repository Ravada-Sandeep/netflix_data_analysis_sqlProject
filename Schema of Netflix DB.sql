--SCHEMA OF NETFLIX DB

CREATE DATABASE  netflixdata;
CREATE TABLE IF NOT EXISTS netflix (
    show_id VARCHAR(20),
    type VARCHAR(20),
    title TEXT,
    director TEXT,
    cast TEXT,
    country TEXT,
    date_added TEXT,
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(20),
    listed_in TEXT,
    description TEXT
);
SELECT * FROM netflix;
