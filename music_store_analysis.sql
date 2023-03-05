-- 1. Who is the senior most employee based on job title?

select * from employee;

select employee_id,first_name,last_name,title,min(hire_date)over(partition by title)senior_most_employee
from employee;

-- 2. Which countries have the most Invoices?

select * from invoice;

select count(invoice_id)invoice_count,billing_country
from invoice
group by billing_country;

-- 3. What are top 3 values of total invoice?

select distinct *
from invoice
order by total desc
limit 3;

-- 4. Which city has the best customers? We would like to throw a promotional Music
-- Festival in the city we made the most money. Write a query that returns one city that
-- has the highest sum of invoice totals. Return both the city name & sum of all invoice totals
select * from employee;
select * from invoice;
select  round(sum(iv.total)over(partition by e.city ),2)total_amt, e.city
from employee e join invoice iv
order by total_amt desc
limit 1;

-- 5. Who is the best customer? The customer who has spent the most money will be
-- declared the best customer. Write a query that returns the person who has spent the most money

select * from customer;
select * from invoice;

select round(sum(iv.total)over(partition by iv.customer_id),2)tot,c.first_name,c.last_name
from customer c join invoice iv
order by tot desc
limit 1;

-- 6. Write query to return the email, first name, last name, & Genre of all Rock Music 
-- listeners. Return your list ordered alphabetically by email starting with A.

select * from customer;
select * from genre;
select * from track;

select c.email,c.first_name,c.last_name,t.name
from customer c join genre g
join track t
where g.name = 'Rock' and c.email like 'a%';

-- 7. Let's invite the artists who have written the most rock music in our dataset. Write a
-- query that returns the Artist name and total track count of the top 10 rock bands

select * from track;
select * from genre;
select * from artist;

select distinct a.name,count(t.genre_id)over(partition by t.album_id )total_tracks
from track t join artist a
join genre g
where g.name like '%Rock'
order by total_tracks
limit 10; 

-- 8. Return all the track names that have a song length longer than the average song length.
-- Return the Name and Milliseconds for each track. Order by the song length with the
-- longest songs listed first

select * from artist;
select * from track;
with t2 as
(with table1 as
(select name,avg(milliseconds)over()average_length,milliseconds
from track)
select name,average_length,if(milliseconds > average_length,milliseconds,0)lengthy
from table1)
select * from t2
where lengthy > 0;


-- 9. . We want to find out the most popular music Genre for each country. We determine the
-- most popular genre as the genre with the highest amount of purchases. Write a query
-- that returns each country along with the top Genre. For countries where the maximum
-- number of purchases is shared return all Genres
select * from genre;
select * from customer;
select * from employee;
select * from invoice;
select * from invoice_line;
select * from track;
WITH popular_genre AS 
(SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
FROM invoice_line 
JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
JOIN customer ON customer.customer_id = invoice.customer_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN genre ON genre.genre_id = track.genre_id
GROUP BY 2,3,4
ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1;


-- 10. Write a query that determines the customer that has spent the most on music for each
-- country. Write a query that returns the country along with the top customer and how
-- much they spent. For countries where the top amount spent is shared, provide all
-- customers who spent this amount

WITH Customter_with_country AS (
SELECT customer.customer_id,first_name,last_name,billing_country,round(SUM(total),2) AS total_spending,
ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
FROM invoice
JOIN customer ON customer.customer_id = invoice.customer_id
GROUP BY 1,2,3,4
ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1;




