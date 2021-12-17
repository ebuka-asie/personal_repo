
-- This is to add new columns (language_category, brand_category, quarter_category) for easy answers to some of the questions.
ALTER TABLE international_breweries
ADD language_category varchar,
ADD brand_category varchar,
ADD quarter_category varchar;

-- This section is to update the table values based on language conditions 
UPDATE international_breweries
	SET language_category = CASE
		WHEN countries = 'Benin' THEN 'Francophone'
		WHEN countries = 'Ghana' THEN 'Anglophone'
		WHEN countries = 'Nigeria' THEN 'Anglophone'
		WHEN countries = 'Senegal' THEN 'Francophone'
		WHEN countries = 'Togo' THEN 'Francophone'
END;
	
-- This section is to update the table values based on brand conditions 
UPDATE international_breweries
	SET brand_category = CASE
		WHEN brands = 'beta malt' THEN 'malt'
		WHEN brands = 'budweiser' THEN 'beer'
		WHEN brands = 'castle lite' THEN 'beer'
		WHEN brands = 'eagle lager' THEN 'beer'
		WHEN brands = 'grand malt' THEN 'malt'
		WHEN brands = 'hero' THEN 'beer'
		WHEN brands = 'trophy' THEN 'beer'
END;
		
-- This section is to update the table values based on months conditions 
UPDATE international_breweries
	SET quarter_category = CASE
		WHEN months = 'January' THEN 'first quarter'
		WHEN months = 'February' THEN 'first quarter'
		WHEN months = 'March' THEN 'first quarter'
		WHEN months = 'April' THEN 'second quarter'
		WHEN months = 'May' THEN 'second quarter'
		WHEN months = 'June' THEN 'second quarter'
		WHEN months = 'July' THEN 'third quarter'
		WHEN months = 'August' THEN 'third quarter'
		WHEN months = 'September' THEN 'third quarter'
		WHEN months = 'October' THEN 'fourth quarter'
		WHEN months = 'November' THEN 'fourth quarter'
		WHEN months = 'December' THEN 'fourth quarter'
END;

-- Section A question 1:  Within the space of the last three years, what was the profit worth of the breweries,
-- inclusive of the anglophone and the francophone territories?
SELECT 
	to_char(SUM(profit), '999,999,999.99') AS "Total Profit"
FROM international_breweries;

-- Section A question 2:  Compare the total profit between these two territories in order for the territory manager,
-- Mr. Stone to make a strategic decision that will aid profit maximization in 2020
SELECT 
	language_category,
	to_char(SUM(profit),'999,999,999.99') AS gross_profit
FROM international_breweries 
GROUP BY language_category
ORDER BY Gross_Profit DESC;

-- Section A question 3: Country that generated the highest profit in 2019?
SELECT 
	countries,
	years,
	to_char(SUM(profit), '999,999,999.99') AS Country_Profit
FROM international_breweries
WHERE years = 2019
GROUP BY countries, years
ORDER BY Country_profit DESC
LIMIT 1;

-- Section A question 4: Help him find the year with the highest profit.
SELECT 
	years,
	to_char(SUM(profit), '999,999,999.99') AS yearly_profit
FROM international_breweries
GROUP BY years
ORDER BY yearly_profit DESC
LIMIT 1;

-- Section A question 5: Which month in the three years was the least profit generated?
SELECT 
	years,
	months,
	to_char(SUM(profit), '999,999,999.99') AS monthly_profit
FROM international_breweries
GROUP BY years, months
ORDER BY monthly_profit ASC
LIMIT 1;

-- Section A question 6: What was the minimum profit in the month of December 2018?
SELECT
	years,
	months,
	to_char(MIN(profit), '999,999,999.99') AS "Minimum Profit"
FROM international_breweries
WHERE years = 2018 AND months = 'December'
GROUP BY years, months;

-- Section A question 7: Compare the profit in percentage for each of the month in 2019
SELECT 
	years,
	months,
	to_char(SUM(profit), '999,999,999.99') AS monthly_profit,
	to_char((SUM(profit)/SUM(SUM(profit)) OVER () *100), '999.99%') AS percentage_profit
FROM international_breweries
WHERE years = 2019
GROUP BY years, months
ORDER BY to_date(months,'Month');

-- Section A question 8: Which particular brand generated the highest profit in Senegal?
SELECT 
	brands,
	countries,
	to_char(SUM(profit), '999,999,999.99') AS total_Profit
FROM international_breweries
WHERE countries = 'Senegal'
GROUP BY brands, countries
ORDER BY total_profit DESC
LIMIT 1;

-- Section B question 1: Within the last two years, the brand manager wants to know the top three brands
-- consumed in the francophone countries
SELECT 
	brands,
	SUM(quantity) AS sold_quantity,
	language_category
FROM international_breweries
WHERE language_category = 'Francophone' AND years IN (2018,2019)
GROUP BY brands,language_category
ORDER BY sold_quantity DESC
LIMIT 3;
	
-- Section B question 2: Find out the top two choice of consumer brands in Ghana
SELECT 
	brands,
	SUM(quantity) AS sold_quantity,
	countries
FROM international_breweries
WHERE countries = 'Ghana' 
GROUP BY brands,countries
ORDER BY sold_quantity DESC
LIMIT 2;
	
-- Section B question 3: Find out the details of beers consumed in the past three years in the most oil rich
-- country in West Africa.
SELECT 
	years,
	brand_category,
	countries,
	SUM(quantity) AS quantity_consumed,
	to_char(SUM(profit), '999,999,999.99') AS total_profit
FROM international_breweries
WHERE brand_category = 'beer' AND countries = 'Nigeria'
GROUP BY brand_category, countries, years
ORDER BY quantity_consumed DESC;

-- Section B question 4: Favorite malt brand in Anglophone region between 2018 and 2019
SELECT 
	brands,
	brand_category,
	language_category,
	SUM(quantity) AS sold_quantity
FROM international_breweries
WHERE brand_category = 'malt' AND language_category = 'Anglophone' AND years IN(2018,2019)
GROUP BY brand_category, brands, language_category
ORDER BY sold_quantity DESC
LIMIT 1;

-- Section B question 5: Which brands sold the highest in 2019 in Nigeria?
SELECT 
	brands,
	to_char(SUM(cost), '999,999,999,999.99') AS sales,
	SUM(quantity) AS quantity_sold
FROM international_breweries
WHERE countries = 'Nigeria' AND years = 2019
GROUP BY brands
ORDER BY sales DESC
LIMIT 5;

-- Section B question 6: Favorite brand in South_South region in Nigeria
SELECT
	brands,
	region,
	SUM(quantity) AS quantity_sold
FROM international_breweries
WHERE region = 'southsouth' AND countries = 'Nigeria'
GROUP BY brands, region
ORDER BY quantity_sold DESC
LIMIT 1;

-- Section B question 7:  Beer consumption in Nigeria
SELECT
	brand_category,
	countries,
	SUM(quantity) AS quantity_consumed
FROM international_breweries
WHERE brand_category = 'beer' AND countries = 'Nigeria'
GROUP BY brand_category, countries
ORDER BY quantity_consumed DESC;

-- Section B question 8: Level of consumption of Budweiser in the regions in Nigeria
SELECT
	brands,
	region,
	SUM(quantity) AS quantity_consumed
FROM international_breweries
WHERE brands = 'budweiser' AND countries = 'Nigeria'
GROUP BY brands, region
ORDER BY quantity_consumed DESC;

-- Section B question 9: Level of consumption of Budweiser in the regions in Nigeria in 2019 (Decision on Promo)
SELECT
	brands,
	region,
	years,
	SUM(quantity) AS quantity_consumed
FROM international_breweries
WHERE brands = 'budweiser' AND countries = 'Nigeria' AND years = 2019
GROUP BY brands, region, years
ORDER BY quantity_consumed DESC;
-- Promo on Budweiser should hold in North Central region as there was no quantity consumed in North Central in 2019. 

-- Section C question 1:  Country with the highest consumption of beer.
SELECT
	brand_category,
	countries,
	SUM(quantity) AS quantity_consumed
FROM international_breweries
WHERE brand_category = 'beer'
GROUP BY brand_category, countries
ORDER BY quantity_consumed DESC
LIMIT 1;

-- Section C question 2: Highest sales personnel of Budweiser in Senegal
SELECT 
	sales_rep,
	brands,
	countries,
	to_char(SUM(cost), '999,999,999.99') AS sales,
	SUM(quantity) AS quantity_sold
FROM international_breweries
WHERE brands = 'budweiser' AND countries = 'Senegal'
GROUP BY sales_rep, brands, countries
ORDER BY sales DESC
LIMIT 1;

-- Section C question 3: Country with the highest profit of the fourth quarter in 2019
SELECT
	countries,
	quarter_category,
	to_char(SUM(profit), '999,999,999,999.99') AS total_profit
FROM international_breweries
WHERE quarter_category = 'fourth quarter' AND years = 2019
GROUP BY countries, quarter_category
ORDER BY total_profit DESC
LIMIT 1;
