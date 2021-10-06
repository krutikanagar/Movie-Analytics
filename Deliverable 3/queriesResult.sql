/******************1 Query **************************/

SELECT id AS movie_id,title 
FROM movies 
WHERE revenue=SELECT max(revenue) FROM movies; 

/*1 Result: 
 19995,Avatar 
 */



/********************2 Query ************************/
	
/*2 query with first three movies which did not recoup its budget ordered by imdb id*/
SELECT imdb_id,title FROM movies WHERE revenue<budget AND 
imdb_id IS NOT NULL ORDER BY imdb_id LIMIT 3; 

/*2 
 Result:
tt0000417	A Trip to the Moon
tt0000439	The Great Train Robbery
tt0000498	Rescued by Rover
*/



/*2 query if top three movies with most losses(did not recoup bufget) required, ordered by imdb id
SELECT  imdb_id ,title FROM (
SELECT imdb_id ,title, dense_rank() OVER (ORDER BY budget-revenue desc) AS rn
FROM movies WHERE imdb_id IS NOT null )
WHERE rn <=3 ORDER BY imdb_id ; 

 2 Result:
tt0185906	Band of Brothers
tt0780653	The Wolfman
tt1210819	The Lone Ranger
tt4503906	Pokémon the Movie: Hoopa and the Clash of Ages
 */

/*************************3 Query***********************/

SELECT genre_name, avg(revenue) avg_revenue FROM movies m , genres g 
WHERE g.movies_id=m.id
GROUP BY genre_name
ORDER BY avg(revenue) desc  LIMIT 3;

/*3 Result:
Adventure 57300478.326647565
Fantasy	45014411.65006497
Family	38706164.676183596
*/


/*********************4 Query******************************/

SELECT count(*) AS movies_mult_lang FROM 
SELECT id 
FROM movies m , languages l 
WHERE m.id=l.movies_id 
GROUP BY id
HAVING count(DISTINCT  lang_name)>1;
/* 4 Result: 
   7745 
*/

/***********************5 Query*****************************/
 
WITH cte1 AS 
(SELECT  MONTH(release_date) AS mnth ,count(DISTINCT id) AS totalmovies 
FROM movies m , genres g 
WHERE m.id=g.movies_id 
GROUP BY  MONTH(release_date) ),
cte2 AS 
(SELECT  MONTH(release_date) AS mnth ,g.genre_name,count(DISTINCT id)   AS totalmovies_genre
FROM movies m , genres g 
WHERE m.id=g.movies_id 
GROUP BY  MONTH(release_date),g.genre_name
),
cte3 AS
(SELECT cte1.mnth, cte2.genre_name , RANK() OVER( partition BY cte1.mnth ORDER BY cte2.totalmovies_genre/cte1.totalmovies DESC) AS rn
FROM cte1,cte2
WHERE cte1.mnth=cte2.mnth ORDER BY cte1.mnth, cte2.genre_name)
SELECT cte3.mnth, cte3.genre_name  FROM cte3  WHERE rn=1;


/*5 Result:
1	Drama
2	Drama
3	Drama
4	Drama
5	Drama
6	Drama
7	Drama
8	Drama
9	Drama
10	Drama
11	Drama
12	Drama
*/