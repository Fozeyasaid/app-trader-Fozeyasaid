--1
SELECT *
FROM app_store_apps;

SELECT *
FROM play_store_apps;
------------------------
--filter the app with min price and max rating to get the most profitable app
SELECT name,price::money::numeric,genres,rating
FROM play_store_apps
WHERE ROUND(rating*4)/4 = 5.0 and price::money::numeric < 2.5;

SELECT name,price,primary_genre,rating
FROM APP_store_apps
WHERE ROUND(rating*4)/4 = 5.0 and price< 2.5;

-- Develop some general recommendations about the price range, genre, content rating, or any other app characteristics that the company should target.

  SELECT name, price::money::numeric,rating, review_count::numeric,
              -- Calculate the price
         CASE WHEN price::money::numeric <= 2.5 THEN 25000
                 WHEN price::money::numeric > 2.5 THEN (price::numeric*10000)
                 END AS purchase_price,
            -- Calculate the apps longevity (round rating to the nearest .25 using "ROUND(rating*4)/4)"
                   ROUND(1 + (ROUND(rating*4)/4*2) * 12, 2) AS longevity
   FROM play_store_apps
   WHERE price::money::numeric <= 2.50 
                AND ROUND(rating*4)/4 = 5.0
   ORDER BY review_count DESC
   LIMIT 7;
																   
																   
 SELECT name, price,rating, review_count::numeric,
              -- Calculate the price
         CASE WHEN price <= 2.5 THEN 25000
                 WHEN price > 2.5 THEN (price*10000)
                 END AS purchase_price,
            -- Calculate the apps longevity (round rating to the nearest .25 using "ROUND(rating*4)/4)"
                   ROUND(1 + (ROUND(rating*4)/4*2) * 12, 2) AS longevity
 FROM app_store_apps
 WHERE price <= 2.50 
                AND rating= 5.0
 ORDER BY review_count DESC
 LIMIT 7;																   
	--------------------------															   
---b. Develop a Top 10 List of the apps that App Trader should buy based on profitability/return on investment as the sole priority.               
-- use CTE that contains apps with the minimum price and maxium ratings in both tables (the most profitable apps)by combinig union all.

--.25 increase in rating = 6 month increase in longevity
---.50 increase in rating = 12 month increase in longevity
---.75 increase in rating = 36 month increase in longevity
---1 increase in rating = 24 month increase in longevity

---1 increase in rating = 2 years increase in longevity
(WITH both_tables AS ((SELECT name, 
                              price::money::decimal,rating,review_count::decimal,
                              -- Calculate the purchase price
                              CASE WHEN price::money::decimal <= 2.5 THEN 25000
                                   WHEN price::money::decimal > 2.5 THEN (price::decimal*10000)
                                   END AS purchase_price,
                              -- Calculate the apps longevity (round rating to the nearest .25 using "ROUND(rating*4)/4")
                              ROUND(1 + (ROUND(rating*4)/4*2) * 12, 2) AS longevity
                    FROM play_store_apps
                    -- Filter for apps with the minimum price and maximum rating
                    WHERE price::money::decimal <= 2.50 
                          AND ROUND(rating*4)/4 = 5.0)
     UNION ALL
                    (SELECT name, price,rating, review_count::numeric,
                            -- Calculate the purchase price
                            CASE WHEN price <= 2.5 THEN 25000
                                 WHEN price > 2.5 THEN (price*10000)
                                 END AS purchase_price,
                            -- Calculate the apps longevity (round rating to the nearest .25 using "ROUND(rating*4)/4")
                            ROUND(1 + (ROUND(rating*4)/4*2) * 12, 2) AS longevity
                    FROM app_store_apps
                    WHERE price <= 2.50 
                          AND ROUND(rating*4)/4 = 5.0))

SELECT name,
       purchase_price,
       -- Calculate total_revenue (revenue per month * longevity)
       2500 * longevity AS total_revenue,
       -- Calculate total_profit (total revenue - purchase price)
       (2500 * longevity) - purchase_price AS total_profit
FROM both_tables
ORDER BY review_count DESC
LIMIT 10);																   
																   
--Each of these apps will cost 2,500 and have a lifespan of 121 months the smallest possible cost, and the highest possible lifespan															   
----------
 -- c. Develop a Top 4 list of the apps that App Trader should buy that are profitable but that also are thematically appropriate for the upcoming Halloween themed campaign.
--by using CTE and wild cards.
																   
WITH both_tables AS ((SELECT name,price,rating,review_count::numeric
			        FROM app_store_apps
                    WHERE price<=2.5 
					   AND ROUND(rating*4)/4=5.0)
                    UNION ALL
				   (SELECT name,PRICE::MONEY::numeric,rating,review_count::numeric
					FROM play_store_apps
					WHERE price::money::numeric<=2.5 
					     AND round(rating*4)/4=5.0))
SELECT *
FROM both_tables
WHERE name ILIKE '% Halloween%' OR
      name ILIKE '% zombie%' OR
	  name ILIKE '% spookey%' OR
	  name ILIKE '% ghost%' OR
	  name ILIKE '% scary%' OR
	  name ILIKE '%creepy%'	  
ORDER BY review_count DESC
LIMIT 4;															   
																   
																   
																   
																   
																   
																   
												   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
																   
								