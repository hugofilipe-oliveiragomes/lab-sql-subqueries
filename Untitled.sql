-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT COUNT(*) AS number_of_copies
FROM inventory i
JOIN film f ON i.film_id = f.film_id
WHERE f.title = 'Hunchback Impossible';
-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);
-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Alone Trip';

-- Bonus:
-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';
-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT cu.first_name, cu.last_name, cu.email
FROM customer cu
JOIN address a ON cu.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada';
-- 6. Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
SELECT actor_id
FROM film_actor
GROUP BY actor_id
ORDER BY COUNT(*) DESC;

SELECT f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = 107;
-- 7. Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
JOIN (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
    ORDER BY total_spent DESC
) AS top_customer ON p.customer_id = top_customer.customer_id;
-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.
SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(total_amount)
    FROM (
        SELECT SUM(amount) AS total_amount
        FROM payment
        GROUP BY customer_id
    ) AS subquery
);