use sakila;

-- 1a. Display first and last names of all actors

select first_name, last_name
from actor a;

-- 1b. Display first and list name together in a separate column

select first_name, 
		last_name, 
        concat_ws(' ',first_name, last_name) as Name
from actor;

-- 2a. Find all actors whose first name is Joe

select actor_id, first_name, last_name 
from actor
where first_name = 'JOE';

-- 2b. Find all authors whose last names contain the letters GEN

select a.first_name, a.last_name
from actor a
where a.last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. 
-- Order the rows by last name and first name

select a.first_name, a.last_name
from actor a 
where a.last_name like '%LI%'
order by 
	a.last_name asc,
    a.first_name asc;
    
 -- 2d. Display the country_id and country columns of Afghanistan, Bangladesh, and China  
select *
from country c
where c.country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Create a column in the table actor named description of data type BLOB 
alter table actor
add description blob;

-- 3b. Delete the description column
alter table actor 
drop column description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*)
from actor
group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors

select last_name, count(*) as num_actors
from actor
group by last_name
having num_actors >= 2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
-- Write a query to fix the record.

update actor set first_name = 'HARPO' 
where first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4d. Change the name of the actor from 4c back from HARPO to GROUCHO 

update actor set first_name = 'GROUCHO' 
where first_name = 'HARPO' and last_name = 'WILLIAMS';

-- 5a. Locate the schema of the address table

show create table address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address:

select s.first_name, s.last_name, a.address
from staff s
inner join address a on s.address_id = a.address_id;

-- 6b. Display the total amount rung up by each staff member in August of 2005. 

select s.first_name, s.last_name, sum(p.amount)
from staff s
inner join payment p on s.staff_id = p.staff_id
where year(p.payment_date) = 2005 and month(p.payment_date) = 8
group by s.last_name;

-- 6c. List each film and the number of actors who are listed for that film. 

select f.title, count(fa.actor_id) as number_of_actors
from film f
inner join film_actor fa on f.film_id = fa.film_id
group by f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

select f.title, count(i.inventory_id)
from inventory i
inner join film f on f.film_id = i.film_id
where f.title = 'Hunchback Impossible';

-- 6e. List the total paid by each customer.
-- List the customers alphabetically by last name:
select c.first_name, c.last_name, sum(p.amount)
from payment p
inner join customer c on c.customer_id = p.customer_id
group by c.customer_id
order by c.last_name asc;

-- 7a. Display the titles of movies starting with Q or K and whose language is English

select f.title, l.name
from film f
inner join language l on f.language_id = l.language_id
where f.title like 'K%' 
		or f.title like 'Q%' 
        and l.name = 'English';
        
-- 7b. Display all actors who appear in the film Alone Trip.

select a.first_name, a.last_name, f.title
from film f
inner join film_actor fa on f.film_id = fa.film_id
inner join actor a on fa.actor_id = a.actor_id
where f.title = 'Alone Trip';

-- 7c. Retrieve names and email addresses of all Canadian customers. 

select c.first_name, c.last_name, c.email, co.country
from customer c 
inner join address a on c.address_id = a.address_id
inner join city ct on ct.city_id = a.city_id
inner join country co on co.country_id = ct.country_id
where co.country = 'Canada';

-- 7d. Identify all movies categorized as family films.

select f.title, c.name
from film f
inner join film_category fc on f.film_id = fc.film_id
inner join category c on c.category_id = fc.category_id
where c.name = 'Family'

-- 7e. Display the most frequently rented movies in descending order.

select f.title, count(r.rental_date) as times_rented
from film f
inner join inventory i on i.film_id = f.film_id
inner join rental r on i.inventory_id = r.inventory_id
group by f.title
order by times_rented desc
limit 10;

-- 7f. Display how much business, in dollars, each store brought in.
select s.store_id, sum(p.amount) as total_payments
from store s
inner join customer c on c.store_id = s.store_id
inner join payment p on p.customer_id = c.customer_id
group by s.store_id;

-- 7g. Display each store's ID, city, and country.

select s.store_id, c.city, co.country
from store s
inner join address a on s.address_id = a.address_id
inner join city c on a.city_id = c.city_id
inner join country co on c.country_id = co.country_id;

-- 7h. List the top five genres in gross revenue in descending order. 

select c.name, sum(p.amount) as revenue_from_category
from category c 
inner join film_category fc on c.category_id = fc.category_id
inner join inventory i on i.film_id = fc.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join payment p on p.rental_id = r.rental_id
group by c.name
order by revenue_from_category desc
limit 5;

-- 8a. Create a view of the top five genres by the gross revenue. 

create view top_five_vw as 
select c.name, sum(p.amount) as revenue_from_category
from category c 
inner join film_category fc on c.category_id = fc.category_id
inner join inventory i on i.film_id = fc.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join payment p on p.rental_id = r.rental_id
group by c.name
order by revenue_from_category desc
limit 5;

-- 8b. Display the view, created in 8a

select * from top_five_vw;

-- 8c. Delete the view top_five_vw
drop view top_five_vw;


