Create database music;

use music;

create table artist
(artist_id Int not null primary key,
name varchar(16380) not null);

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQLalbum Server 8.0/Uploads/artist_.csv'
INTO TABLE artist
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

create table album
(album_id int not null primary key,
title varchar(500) not null,
artist_id int not null,
foreign key(artist_id) references artist(artist_id));

SET FOREIGN_KEY_CHECKS = 0;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/album.csv'
INTO TABLE album
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

create table playlist
(playlist_id int not null primary key,
name varchar(500) not null);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/playlist.csv'
INTO TABLE playlist
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

create table playlist_track
(playlist_id int not null,
track_id int not null,
foreign key(playlist_id) references playlist(playlist_id));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/playlist_track.csv'
INTO TABLE playlist_track
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

create table media_type
(media_type_id int not null primary key,
name varchar(500) not null);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/media_type.csv'
INTO TABLE media_type
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

create table genre
(genre_id int not null primary key,
name varchar(500) not null);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/genre.csv'
INTO TABLE genre
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

create table employee
(employee_id int not null primary key,
last_name varchar(100) not null,
first_name varchar(100) not null,
title varchar(200) not null,
reports_to int,
birthdate date,
hire_daemployeete date,
address varchar(200) not null,
city varchar(150),
state varchar (10),
country varchar(100),
postal_code varchar(20),
phone varchar (150), 
fax varchar (150),
email varchar(250));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/employee.csv'
INTO TABLE employee
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

create table customer
(customer_id int not null primary key,
first_name varchar(100) not null,
last_name varchar(100) not null,
company varchar(200) not null,
address varchar(200) not null,
city varchar(150),
state varchar (10),
country varchar(100),
postal_code varchar(20),
phone varchar (150), 
fax varchar (150),
email varchar(250),
support_rep_id int not null,
foreign key(support_rep_id) references employee(employee_id));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customer.csv'
INTO TABLE customer
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

create table invoice
(invoice_id int not null primary key,
customer_id int,
invoice_date date,
billing_address varchar (200),
billing_city varchar(200),
billing_state varchar(150),
billing_country varchar(100),
billing_postal_code varchar(100),
total float(7,2),
foreign key(customer_id) references customer(customer_id));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/invoice.csv'
INTO TABLE invoice
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

create table invoice_line
(invoice_line_id int primary key,
invoice_id int,
track_id int,
unit_price float,
quantity int,
foreign key(invoice_id) references invoice(invoice_id));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/invoice_line.csv'
INTO TABLE invoice_line
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

create table track
(track_id int not null primary key,
name varchar (250),
album_id int,
media_type_id int,
genre_id int,
composer varchar(250),
milliseconds int,
bytes int,
unit_price float,
foreign key (album_id) references album(album_id),
foreign key (media_type_id) references media_type(media_type_id),
foreign key (genre_id) references genre(genre_id));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/track.csv'
INTO TABLE track
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


use music;

/*	Question Set 1 - Easy */

/* Q1: Who is the senior most employee based on job title? */

select concat (first_name, ' ', last_name) as 'Name', title as 'Job Title', employee_id as 'Employee Id',levels as 'level'
from employee
order by levels desc
limit 2;

/* Q2: Which countries have the most Invoices? */

select billing_country as 'Country', count(billing_country) as 'Number of Invoices'
from invoice
group by billing_country
order by `Number of Invoices` Desc
limit 5;

/* Q3: What are top 3 values of total invoice? */

select invoice.invoice_id, invoice.customer_id, concat(customer.first_name, " ", customer.last_name) as "Customer Name", invoice.total
from invoice
inner join customer on invoice.customer_id=customer.customer_id
order by total Desc
limit 3;

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

select billing_city as "city", billing_country as "country", sum(total) as "Total Invoice"
from invoice
group by billing_city, billing_country
order by `Total Invoice` desc
limit 5;

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

SELECT 
    invoice.customer_id AS 'Customer Id',
    CONCAT(customer.first_name,
            ' ',
            customer.last_name) AS 'Customer Name',
    customer.city AS 'City',
    customer.country AS 'Country',
    SUM(invoice.total) AS 'Total'
FROM
    invoice
        INNER JOIN
    customer ON customer.customer_id = invoice.customer_id
GROUP BY invoice.customer_id
ORDER BY total DESC
limit 5;

/* Question Set 2 - Moderate */

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

# Method 1

select MIN(genre.name) as "Genre Name", invoice.customer_id, concat(customer.first_name," ",customer.last_name) as "Name", customer.email
from genre
inner join track on track.genre_id=genre.genre_id
inner join invoice_line on invoice_line.track_id=track.track_id
inner join invoice on invoice.invoice_id=invoice_line.invoice_id
inner join customer on customer.customer_id=invoice.customer_id
where genre.name like ('%rock%')
group by customer.customer_id
order by customer.email asc;

# Method 2

SELECT DISTINCT email,first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoiceline ON invoice.invoice_id = invoiceline.invoice_id
WHERE track_id IN(
	SELECT track_id FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'Rock'
)
ORDER BY email;

/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select	artist.name as "Artist Name", count(track.track_id) as "Total Track Count"
from artist
Join album ON artist.artist_id = album.artist_id
Join track on album.album_id = track.album_id
join genre on track.genre_id = genre.genre_id
where genre.name like "%Rock%"
GROUP BY artist.name
ORDER BY COUNT(track.track_id) DESC
LIMIT 10;

SELECT artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock%'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

select track.name as "Song Name", track.milliseconds as "Song Length in minutes" 
from track
order by milliseconds desc
limit 10;

SELECT track.name, track.milliseconds
FROM track
WHERE milliseconds > (
	SELECT AVG(milliseconds) AS avg_track_length
	FROM track )
ORDER BY milliseconds DESC;

/* Question Set 3 - Advance */

/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

/* Steps to Solve: First, find which artist has earned the most according to the InvoiceLines. Now use this artist to find 
which customer spent the most on this artist. For this query, you will need to use the Invoice, InvoiceLine, Track, Customer, 
Album, and Artist tables. Note, this one is tricky because the Total spent in the Invoice table might not be on a single product, 
so you need to use the InvoiceLine table to find out how many of each product was purchased, and then multiply this by the price
for each artist. */

select artist.name, sum(invoice_line.quantity) as "total songs sold"
from artist
join album on album.artist_id = artist.artist_id
join track on track.album_id = album.album_id
join invoice_line on invoice_line.track_id = track.track_id
group by artist.name
order by sum(invoice_line.quantity) desc;

SELECT 
    CONCAT(customer.first_name,
            ' ',
            customer.last_name) AS 'Customer Name',
    SUM(invoice.total) AS 'Money Spent',
    SUM(invoice_line.quantity) AS 'Number of Songs',
    artist.name AS 'Artist Name'
FROM
    customer
        JOIN
    invoice ON invoice.customer_id = customer.customer_id
        JOIN
    invoice_line ON invoice_line.invoice_id = invoice.invoice_id
        JOIN
    track ON track.track_id = invoice_line.track_id
        JOIN
    album ON album.album_id = track.album_id
        JOIN
    artist ON artist.artist_id = album.artist_id
GROUP BY customer.customer_id , artist.artist_id
ORDER BY SUM(invoice.total) DESC;

WITH ArtistEarnings AS (
    SELECT 
        artist.artist_id,
        artist.name AS artist_name,
        SUM(invoice_line.quantity * track.unit_price) AS total_earnings
    FROM 
        invoice_line
    JOIN track ON track.track_id = invoice_line.track_id
    JOIN album ON album.album_id = track.album_id
    JOIN artist ON artist.artist_id = album.artist_id
    GROUP BY artist.artist_id
    ORDER BY total_earnings DESC
    LIMIT 5 
)
SELECT 
    CONCAT(customer.first_name, ' ', customer.last_name) AS "Customer Name", 
    artist.name AS "Artist Name", 
    SUM(invoice_line.quantity * track.unit_price) AS "Total Spent"
FROM 
    invoice
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN customer ON customer.customer_id = invoice.customer_id
JOIN ArtistEarnings ON ArtistEarnings.artist_id = artist.artist_id
GROUP BY customer.customer_id, artist.name  
ORDER BY "Total Spent" DESC
LIMIT 5;  

/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

/* Steps to Solve:  There are two parts in question- first most popular music genre and second need data at country level. */

SELECT 
    customer.country AS 'Country Name',
    genre.name AS 'Genre Name',
    SUM(invoice_line.unit_price * invoice_line.quantity) AS 'Total Money Earned'
FROM
    customer
        JOIN
    invoice ON invoice.customer_id = customer.customer_id
        JOIN
    invoice_line ON invoice_line.invoice_id = invoice.invoice_id
        JOIN
    track ON track.track_id = invoice_line.track_id
        JOIN
    genre ON genre.genre_id = track.genre_id
GROUP BY customer.country , genre.genre_id
ORDER BY SUM(invoice_line.unit_price * invoice_line.quantity) DESC;
    
    SELECT 
    customer.country AS "Country Name", 
    genre.name AS "Genre Name", 
    SUM(invoice_line.unit_price * invoice_line.quantity) AS "Total Money Earned"
FROM 
    customer
JOIN 
    invoice ON invoice.customer_id = customer.customer_id
JOIN 
    invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN 
    track ON track.track_id = invoice_line.track_id
JOIN 
    genre ON genre.genre_id = track.genre_id
GROUP BY 
    customer.country, genre.genre_id
HAVING 
    SUM(invoice_line.unit_price * invoice_line.quantity) = (
        SELECT 
            MAX(genre_total) 
        FROM (
            SELECT 
                SUM(invoice_line.unit_price * invoice_line.quantity) AS genre_total,
                customer.country
            FROM 
                customer
            JOIN 
                invoice ON invoice.customer_id = customer.customer_id
            JOIN 
                invoice_line ON invoice_line.invoice_id = invoice.invoice_id
            JOIN 
                track ON track.track_id = invoice_line.track_id
            JOIN 
                genre ON genre.genre_id = track.genre_id
            GROUP BY 
                customer.country, genre.genre_id
        ) AS country_genre_totals
        WHERE country_genre_totals.country = customer.country
    )
ORDER BY 
   "Total Money Earned" DESC;
   
   /* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

/* Steps to Solve:  Similar to the above question. There are two parts in question- 
first find the most spent on music for each country and second filter the data for respective customers. */

SELECT 
    CONCAT(customer.first_name,
            ' ',
            customer.last_name) AS 'Customer Name',
    customer.country AS 'Country',
    SUM(invoice_line.unit_price * invoice_line.quantity) AS 'Total Money Spent'
FROM
    customer
        JOIN
    invoice ON invoice.customer_id = customer.customer_id
        JOIN
    invoice_line ON invoice_line.invoice_id = invoice.invoice_id
GROUP BY customer.country , customer.customer_id
ORDER BY SUM(invoice_line.unit_price * invoice_line.quantity) DESC;

SELECT 
    concat(customer.first_name," ",customer.last_name) as "Customer Name",
    customer.country AS "Country",
    SUM(invoice_line.unit_price * invoice_line.quantity) AS "Total Money Spent"
FROM 
    customer
JOIN 
    invoice ON invoice.customer_id = customer.customer_id
JOIN 
    invoice_line ON invoice_line.invoice_id = invoice.invoice_id
GROUP BY 
    customer.country,customer.customer_id
ORDER BY 
    "Total Money Spent" DESC;
