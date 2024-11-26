--Q1: who is the highest position employee?

select * from employee
order by levels desc
limit 1;
select * from invoice;
--Q2: find the country who has most invoices;
select  count(*),billing_country from invoice
group by billing_country
order by count Desc
limit 1;
--Q3:give me top 3 total invoices ? 
select * from invoice;
select total from invoice
order by total desc
limit 3;
--Q4:give the which city has the best customers?
select sum(total) as invoice_total ,billing_city from invoice
group by billing_city
order by invoice_total desc
limit 1;

--Q5 :who is the best customer ? based on the money spent will be declard.
select sum(invoice.total) as billing,customer.first_name,customer.last_name,customer.customer_id 
from customer
join invoice on customer.customer_id=invoice.customer_id
group by customer.customer_id
order by billing desc
limit 1;

--set-2
--Q1:give me the first name,last name ,email with genere rock
SELECT DISTINCT email,first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
	SELECT track_id FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'Rock'
)
ORDER BY email;
--Q2:give the aitist name,id who sang rock music more in a top 10;

select artist.artist_id,artist.name,count(artist.artist_id) as no_of_songs
from track
join album on album.album_id=track.album_id
join artist on artist.artist_id =album.artist_id
join genre ON genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by no_of_songs desc 
limit 10;

--Q3 :return the song and its length that has more length than avg of the song length

select track.name,track.milliseconds from track

where milliseconds>(
	select avg(track.milliseconds) from track
)
order by milliseconds 


--set 3: 

/* Question Set 3 - Advance */

/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

/* Steps to Solve: First, find which artist has earned the most according to the InvoiceLines. Now use this artist to find 
which customer spent the most on this artist. For this query, you will need to use the Invoice, InvoiceLine, Track, Customer, 
Album, and Artist tables. Note, this one is tricky because the Total spent in the Invoice table might not be on a single product, 
so you need to use the InvoiceLine table to find out how many of each product was purchased, and then multiply this by the price
for each artist. */

WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;


