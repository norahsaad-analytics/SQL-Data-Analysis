-- =====================================================================
-- SQL Practice Queries
-- Completed as part of a data analysis course.
--
-- Queries 1-4 and 7-10 use a DVD rental sample database
-- (tables: actor, film, film_category, category, address, payment).
-- Queries 5-6 use a separate movies table (director, film_year, revenue_mils).
-- No data is included in this repository, only the queries.
-- =====================================================================


-- 1. List the last names of actors (alphabetically), as well as how many
--    actors have that last name.

SELECT last_name, COUNT(actor_id) AS actor_count
FROM actor
GROUP BY last_name
ORDER BY last_name ASC;


-- 2. List last names of actors and the number of actors who have that last
--    name, but only for names shared by at least three actors. Highest count first.

SELECT last_name, COUNT(actor_id) AS actor_count
FROM actor
GROUP BY last_name
HAVING COUNT(actor_id) >= 3
ORDER BY actor_count DESC;


-- 3. List all comedy films (regardless of other genres) with title and year,
--    highest revenue first.
--    Note: this database has no revenue_mils column, so rental_rate is used instead.

SELECT f.title, f.release_year, f.rental_rate
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Comedy'
ORDER BY f.rental_rate DESC;


-- 4. Number of films per year, oldest first.

SELECT release_year AS film_year, COUNT(film_id) AS film_count
FROM film
GROUP BY release_year
ORDER BY release_year ASC;


-- 5. Directors who have directed more than 4 films, most films first,
--    ties sorted alphabetically.

SELECT director, COUNT(*) AS film_count
FROM movies
GROUP BY director
HAVING COUNT(*) > 4
ORDER BY film_count DESC, director ASC;


-- 6. Highest revenue amount for each year, oldest first.

SELECT film_year, MAX(revenue_mils) AS highest_revenue
FROM movies
GROUP BY film_year
ORDER BY film_year ASC;


-- 7. Highest postal code for all districts starting with A, B, C or D,
--    ordered by the starting letter.

SELECT district, MAX(postal_code) AS highest_postal_code
FROM address
WHERE LEFT(district, 1) IN ('A', 'B', 'C', 'D')
GROUP BY district
ORDER BY LEFT(district, 1) ASC;


-- 8. ID and average money spent (rounded to 3 decimals) for the 15 top
--    spending customers (by average) who spent below 4.5.

SELECT customer_id, ROUND(AVG(amount), 3) AS avg_spent
FROM payment
GROUP BY customer_id
HAVING AVG(amount) < 4.5
ORDER BY avg_spent DESC
LIMIT 15;


-- 9. Total number of actors who share their last name with 3 or more other actors.

SELECT COUNT(*) AS total_actors
FROM actor
WHERE last_name IN (
    SELECT last_name
    FROM actor
    GROUP BY last_name
    HAVING COUNT(actor_id) >= 3
);


-- 10. Total revenue by month.

SELECT EXTRACT(MONTH FROM payment_date) AS payment_month,
       SUM(amount) AS total_revenue
FROM payment
GROUP BY payment_month
ORDER BY payment_month ASC;
