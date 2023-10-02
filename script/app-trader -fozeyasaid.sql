1. a.
 --for app_store_apps
SELECT name, price,min(price)over()
FROM app_store_apps
GROUP BY name,price
HAVING min(price)>=2.5;


--the minimum price to purchase the right app I got =2.99
--I use from sub_qurries to find the app to purchase by the min price

SELECT name ,price
FROM 
	(SELECT name, price,min(price)over()
	FROM app_store_apps
	GROUP BY name,price
	HAVING  min(price) >=2.5) AS lowest_price_appstore
WHERE price = 2.99;

--for play_store_app
SELECT name, price,min(price)over()
FROM play_store_apps
GROUP BY name,price
HAVING (min(price)::money::numeric)>=2.5;

SELECT name, price
FROM 
	(SELECT name, price,min(price)over()
FROM play_store_apps
GROUP BY name,price
HAVING (min(price)::money::numeric)>=2.5)AS lowest_price_playstore
WHERE price::money::numeric = 10.00;


--finially combine both app and play store app by union to get all apps to purcahse by min price.

(SELECT name ,price
FROM 
	(SELECT name, price,min(price)over()
	FROM app_store_apps
	GROUP BY name,price
	HAVING  min(price) >=2.5) AS lowest_price_appstore
WHERE price = 2.99)

UNION ALL
(SELECT name, price::money::numeric
FROM 
	(SELECT name, price,min(price)over()
	FROM play_store_apps
	GROUP BY name,price
	HAVING (min(price)::money::numeric)>=2.5)AS lowest_price_playstore
	WHERE price::money::numeric = 10.00);


--b. Apps earn $5000 per month on average from in-app advertising and in-app purchases regardless of the price of the app.
 
 
-- revenue= $5000per/month 
-- total_profit = revenue _total cost
-- for play store
SELECT SUM(price::money::numeric) as total_cost
FROM play_store_apps

--using sub_quries		
	
SELECT name,
	(5000*12-(SELECT SUM(price::money::numeric) AS total_cost
      FROM play_store_apps)) AS profit	
FROM play_store_apps;
-- profit from play_stor_apps =48863									

--for app_store_apps

SELECT SUM(price) as total_cost
FROM app_store_apps;

SELECT name,
	(5000*12-(SELECT SUM(price) AS total_cost
      FROM app_store_apps)) AS profit	
FROM app_store_apps;

-- profit from app_stor_apps =47576.41
--I conclude that play store is more profitable than app store.

SELECT rating, 
	CASE WHEN rating =0 then '1_year_lifespan'
         WHEN rating =1.0 then '3-years_lifespan'
	     WHEN rating = 4.0 then '9_years_lifespan' ELSE 'UNKNOWN' END  AS 'longevity'
FROM play_store_apps
WHERE round(rating*4)4;


(SELECT name,price::money::numeric,genres,content_rating
FROM play_store_apps
WHERE rating > 5.0 and price::money::numeric < 2.5)
INTERSECT
(SELECT name,price,primary_genre,content_rating
FROM APP_store_apps
WHERE rating > 5.0 and price< 2.5);


																   
WITH apps_stores AS (SELECT name,price,rating
			         from app_store_apps
                     where price<=2.5 AND ROUND(RATING*4)/4=5.0)
UNION ALL
				(SELECT NAME,PRICE::MONEY::numeric,RATING
					from play_store_apps
					where price::money::numeric<=2.5 and round(rating*4)/4=5.0))
														
														
select *
from app_store
where name (select name from play_store_apps)
intersect 
select name 
from app_store_apps);
																   
																   
																   
								