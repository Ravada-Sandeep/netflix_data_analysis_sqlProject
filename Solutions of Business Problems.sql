-- Netflix Data Analysis using SQL
-- Solutions of 15 business problems
-- 1. Count the number of Movies vs TV Shows

SELECT 
    type, COUNT(show_id)
FROM
    netflix
GROUP BY type;


-- 2. Find the most common rating for movies and TV shows

SELECT 
    type,
    rating
FROM (
    SELECT 
        type, 
        rating, 
        COUNT(*) AS count,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM 
        netflix
    GROUP BY 
        type, 
        rating
    ORDER BY 
        type, 
        count DESC
) AS t1
WHERE 
    ranking = 1;


-- 3. List all movies released in a specific year (e.g., 2020)

SELECT 
    *
FROM 
    netflix
WHERE 
    type = 'Movie' 
    AND release_year = 2020;


-- 4. Find the top 5 countries with the most content on Netflix

SELECT country, COUNT(*) AS total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;


-- 5. Identify the longest movie

SELECT 
    show_id, title, duration
FROM
    netflix
WHERE
    type = 'Movie'
        AND duration = (SELECT 
            MAX(duration)
        FROM
            netflix);


-- 6. Find content added in the last 5 years

SELECT 
    *
FROM
    netflix
WHERE
    STR_TO_DATE(date_added, '%M %d, %Y') >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT 
    show_id, type, title
FROM
    netflix
WHERE
    director = 'Rajiv Chilaka';


-- 8. List all TV shows with more than 5 seasons

SELECT 
    *
FROM
    netflix
WHERE
    type = 'TV Show'
        AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;


-- 9. Count the number of content items in each genre

SELECT 
    listed_in, COUNT(show_id) AS total_count
FROM
    netflix
GROUP BY listed_in
ORDER BY total_count DESC;


-- 10. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !


SELECT 
    AVG(c)
FROM
    (SELECT 
        release_year, COUNT(show_id) AS c
    FROM
        netflix
    WHERE
        country = 'India'
    GROUP BY release_year) AS t1;



-- 11. List all movies that are documentaries


SELECT 
    *
FROM
    netflix
WHERE
    type = 'Movie'
        AND listed_in LIKE '%Documentaries%';


-- 12. Find all content without a director

SELECT 
    *
FROM
    netflix
WHERE
    Director IS NULL OR TRIM(director) = '';

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT 
    *
FROM
    netflix
WHERE
    cast LIKE '%Salman Khan%'
        AND STR_TO_DATE(date_added, '%M %d, %Y') > DATE_SUB(CURDATE(), INTERVAL 10 YEAR);
        


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.


WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n <= 10
),
split_actors AS (
    SELECT
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(casts, ',', numbers.n), ',', -1)) AS actor
    FROM 
        netflix, numbers
    WHERE 
        country = 'India'
        AND casts IS NOT NULL
        AND numbers.n <= LENGTH(casts) - LENGTH(REPLACE(casts, ',', '')) + 1
)
SELECT 
    actor,
    COUNT(*) AS appearances
FROM 
    split_actors
GROUP BY 
    actor
ORDER BY 
    appearances DESC
LIMIT 10;

/*
Question 15:
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/


SELECT 
    category,
    type,
    COUNT(*) AS content_count
FROM (
    SELECT 
        *,
        CASE 
            WHEN LOWER(description) LIKE '%kill%' 
              OR LOWER(description) LIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM 
        netflix
) AS categorized_content
GROUP BY 
    category, type
ORDER BY 
    type;




-- End of reports
