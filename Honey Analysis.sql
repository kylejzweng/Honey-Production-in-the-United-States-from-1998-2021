USE honey_project;

-- Let's take a look at our data!

SELECT * FROM honey19982012;

-- The original data set I downloaded looks all good!

-- I wanted more up to date information so I went to USDA Economics, Statistics, and Market Information System - the same place the other data was from, 
-- and collected this data in Excel. I formatted it, but let's take a look at the data I collected.

SELECT * FROM honey20132021;

-- For some reason we have three extra columns with no data that we don't need. Let's drop them.

ALTER TABLE honey20132021
DROP COLUMN `__1`;

ALTER TABLE honey20132021
DROP COLUMN `__2`;

ALTER TABLE honey20132021
DROP COLUMN `__3`;

-- Sweet!

-- It looks like I'll need to further alter the data so I need this command to do so.

SET SQL_SAFE_UPDATES = 0;
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- Most of the data I collected was not written in real figures because they would've been so large.
-- For example, the original data listed 7 honey producing colonies in Alabama in thousands of colonies.
-- Therefore, I need to adjust the data now that it's been imported into SQL so we can understand the true reality of each value
-- and to have it match the data set I was initially provided.

UPDATE honey20132021
SET numcol = numcol * 1000;

UPDATE honey20132021
SET totalprod = totalprod * 1000;

-- I noticed the original data set created by the other person accidently miscalculated the stocks. This is simply a correction.

UPDATE honey19982012
SET stocks = stocks * .1;

UPDATE honey20132021
SET stocks = stocks * 1000;

-- Price per pound was listed in cents, but it would be more helpful if it was in pounds.

ALTER TABLE honey20132021
MODIFY priceperlb FLOAT;

UPDATE honey20132021
SET priceperlb = priceperlb * .01;

UPDATE honey20132021
SET prodvalue = prodvalue * 1000;

-- Now that the values/units are set, we also need to detail with the variance in how the state's are labeled
-- For example, the original data set has Alabama as AL, while the data I collected has it as Alabama.
-- It's easier to understand the full text so we'll stick with that. I'll now convert the original dataset to this version.

UPDATE honey19982012
SET
	state = 'Alabama'
WHERE
	stateidnum = 1;
    
UPDATE honey19982012
SET state = 'Arizona'
WHERE
	stateidnum = 2;
    
UPDATE honey19982012
SET state = 'Arkansas'
WHERE 
	stateidnum = 3;

UPDATE honey19982012
SET state = 'California'
WHERE 
	stateidnum = 4;
    
UPDATE honey19982012
SET state = 'Colorado'
WHERE 
	stateidnum = 5;
    
UPDATE honey19982012
SET state = 'Florida'
WHERE 
	stateidnum = 6;
    
UPDATE honey19982012
SET state = 'Georiga'
WHERE 
	stateidnum = 7; 
    
UPDATE honey19982012
SET state = 'Hawaii'
WHERE 
	stateidnum = 8; 

UPDATE honey19982012
SET state = 'Idaho'
WHERE 
	stateidnum = 9; 
    
UPDATE honey19982012
SET state = 'Illinois'
WHERE 
	stateidnum = 10; 
    
UPDATE honey19982012
SET state = 'Indiana'
WHERE 
	stateidnum = 11; 
    
UPDATE honey19982012
SET state = 'Iowa'
WHERE 
	stateidnum = 12; 
    
UPDATE honey19982012
SET state = 'Kansas'
WHERE 
	stateidnum = 13; 
    
UPDATE honey19982012
SET state = 'Kentucky'
WHERE 
	stateidnum = 14; 
    
UPDATE honey19982012
SET state = 'Louisiana'
WHERE 
	stateidnum = 15; 

UPDATE honey19982012
SET state = 'Maine'
WHERE 
	stateidnum = 16;
    
UPDATE honey19982012
SET state = 'Michigan'
WHERE 
	stateidnum = 17; 

UPDATE honey19982012
SET state = 'Minnesota'
WHERE 
	stateidnum = 18; 

UPDATE honey19982012
SET state = 'Mississippi'
WHERE 
	stateidnum = 19; 
    
UPDATE honey19982012
SET state = 'Missouri'
WHERE 
	stateidnum = 20; 
    
UPDATE honey19982012
SET state = 'Montana'
WHERE 
	stateidnum = 21; 
    
UPDATE honey19982012
SET state = 'Nebraska'
WHERE 
	stateidnum = 22; 

UPDATE honey19982012
SET state = 'NewJersey'
WHERE 
	stateidnum = 23; 

UPDATE honey19982012
SET state = 'New York'
WHERE 
	stateidnum = 24; 

UPDATE honey19982012
SET state = 'North Carolina'
WHERE 
	stateidnum = 25; 
    
UPDATE honey19982012
SET state = 'North Dakota'
WHERE 
	stateidnum = 26; 
    
UPDATE honey19982012
SET state = 'Ohio'
WHERE 
	stateidnum = 27; 
    
UPDATE honey19982012
SET state = 'Oregon'
WHERE 
	stateidnum = 28; 
    
UPDATE honey19982012
SET state = 'Pennsylvania'
WHERE 
	stateidnum = 29; 

UPDATE honey19982012
SET state = 'South Carolina'
WHERE 
	stateidnum = 30; 
    
UPDATE honey19982012
SET state = 'South Dakota'
WHERE 
	stateidnum = 31; 
    
UPDATE honey19982012
SET state = 'Tennessee'
WHERE 
	stateidnum = 32; 
    
UPDATE honey19982012
SET state = 'Texas'
WHERE 
	stateidnum = 33; 
    
UPDATE honey19982012
SET state = 'Utah'
WHERE 
	stateidnum = 34; 
    
UPDATE honey19982012
SET state = 'Vermont'
WHERE 
	stateidnum = 35; 
    
UPDATE honey19982012
SET state = 'Virgina'
WHERE 
	stateidnum = 36; 
    
UPDATE honey19982012
SET state = 'Washington'
WHERE 
	stateidnum = 37;

UPDATE honey19982012
SET state = 'West Virginia'
WHERE 
	stateidnum = 38; 

UPDATE honey19982012
SET state = 'Wisconsin'
WHERE 
	stateidnum = 39;

UPDATE honey19982012
SET state = 'Wyoming'
WHERE 
	stateidnum = 40; 

UPDATE honey19982012
SET state = 'Maryland'
WHERE 
	stateidnum = 43; 

UPDATE honey19982012
SET state = 'New Mexico'
WHERE 
	stateidnum = 44; 
    
UPDATE honey19982012
SET state = 'Nevada'
WHERE 
	stateidnum = 45; 

UPDATE honey19982012
SET state = 'Oklahoma'
WHERE 
	stateidnum = 46; 
    
-- Now both data sets should all be in the same units. Let's make sure!

SELECT * FROM honey19982012;

SELECT * FROM honey20132021
ORDER BY stateidnum ASC;

-- Looks good! Now that the data has been cleaned (same units, same state names, etc.) it's time to merge them into one table so
-- we can get started with our analysis.

CREATE TABLE honey1998to2021
SELECT * FROM honey19982012
	UNION
SELECT * FROM honey20132021;

-- Let's see our new table!

SELECT * FROM honey1998to2021
ORDER BY stateidnum;

-- Look at that! Two separate data collections in one table! Sweet! This will make it worlds easier to do some analysis.

-- I collected some additional data on expenditures honey producers with five or more colonies have accrued. Let's clean that quickly too to get
-- the correct values in real dollars.

SELECT * FROM expenditures;

UPDATE expenditures
SET varroacontrol = varroacontrol * 1000;

UPDATE expenditures
SET otherissues = otherissues * 1000;

UPDATE expenditures
SET feed = feed * 1000;

UPDATE expenditures
SET foundation = foundation * 1000;

UPDATE expenditures
SET wood = wood * 1000;

SELECT * FROM expenditures;

-- Let's confirm it's good to go

-- Total number of bee colonies from 1998 to 2021

SELECT
	state,
	SUM(numcol) AS total_bee_colonies
FROM
	honey1998to2021
GROUP BY stateidnum
ORDER BY total_bee_colonies DESC;

-- This data has the total for all the United States. That will be helpful for later, but now, so let's exclude it.

SELECT
	state,
	SUM(numcol) AS total_bee_colonies_per_state
FROM
	honey1998to2021
WHERE state != 'United States'
GROUP BY stateidnum
ORDER BY total_bee_colonies_per_state DESC;

-- Much better. North Dakota and California lap everyone.

-- Percent of bee colonies that come from North Dakota and California

SELECT
	SUM(numcol) AS total_bee_colonies
FROM
	honey1998to2021;
    
-- 86,801,000 total US colonies
-- 18,985,000 total North Dakota + California
-- ND and CA make up 21.87% of all bee colonies in US.

-- Are there more efficient states with their honey though?

SELECT
	state,
	AVG(yieldpercol) AS avg_yield_per_colony_per_state
FROM
	honey1998to2021
WHERE state != 'United States'
GROUP BY stateidnum
ORDER BY avg_yield_per_colony_per_state DESC;

-- Hawaii gets their most out of their colonies, but North Dakota still rates highly. California does not. It would be interesting to find out why

-- Which state has the highest total production of honey (number of colonies * yield per colony)

SELECT
	state,
	SUM(totalprod) AS total_prod_from_1998_to_2021
FROM
	honey1998to2021
WHERE state != 'United States'
GROUP BY stateidnum
ORDER BY total_prod_from_1998_to_2021 DESC;

-- Obviously ND and California are at the top with SD just behind. It should be noted that some states' data was not
-- recorded everywhere by the USDA so those at the bottom of the list can be hard to determine their true production. This typically
-- only happened to smaller produces though so we can have confidence in the top of the list.

-- Average price per pound per state

SELECT
	state,
	AVG(priceperlb) AS avg_price_per_pound
FROM
	honey1998to2021
WHERE state != 'United States'
GROUP BY stateidnum
ORDER BY avg_price_per_pound DESC;

-- Here we also see some limitations of this data. The 'Other States' category is a collection of states with few/1 producer.
-- The USDA didn't want to report data from just the one business in the state so they lumped them together in 'Other States'.
-- Regardless, honey is more expensive is less expansive honey producing states.
-- In fact, the honey in ND and SD is some of the cheapest in the country. 

-- Let's some it all up with which states produced the most economic value from their honey production (totalprod * priceperlb)
-- from 1998 to 2021.

SELECT
	state,
	SUM(prodvalue) AS total_economic_value
FROM
	honey1998to2021
WHERE state != 'United States'
GROUP BY stateidnum
ORDER BY total_economic_value DESC;

-- Again, no suprises with ND, SD, and CA being the top dogs.
-- How much of the US honey economy do they control?

SELECT
	SUM(prodvalue) AS total_economic_value
FROM
	honey1998to2021
WHERE stateidnum IN (26, 31, 4);

-- Total economic output of SD, ND, CA combined = $2,277,405,000

SELECT 
	SUM(prodvalue) 
FROM honey1998to2021;

-- Total of US = $8,906,341,000
-- SD, ND, and CA combine to make up 25.57% of the US honey market.

-- That's a good overview of the major players in the honey market from 1998 to 2021.
-- But we have some great cross-sectional data. Let's see the changes that have happened over time in the US.
-- In 2006 global concner was raised over the rapid decline in bee population. Can that be seen from this data?

SELECT
	year,
	SUM(numcol) AS number_of_colonies_per_year
FROM
	honey1998to2021
WHERE state != 'United States'
GROUP BY year
ORDER BY year ASC;

-- Seems relatively stable/seems to be growing steadily?

-- Maybe production of honey has at least dropped?
    
SELECT
	year,
	SUM(totalprod) AS total_honey_prod_per_year
FROM
	honey1998to2021
WHERE state != 'United States'
GROUP BY year
ORDER BY year ASC;

-- Honey production has tanked! The US is producing 57.61% less honey with the relatively same number of colonies!
-- If the colonies are about the same, but production has gone down, the yield must have dipped.
-- Let's check!

SELECT
	year,
	AVG(yieldpercol) AS avg_yield_per_year
FROM
	honey1998to2021
WHERE state != 'United States'
GROUP BY year
ORDER BY year ASC;

-- Yup, 2021 marked the lowest average yield in the data set (the last year of data) and 1998
-- was the highest yield in the data set (the first year of data). It's a 66% drop in yield per colony!

-- This lack of honey production must surely have raised honey prices in the US over this time.

SELECT
	year,
	AVG(priceperlb) AS avg_price_per_lb_per_year
FROM
	honey1998to2021
WHERE state != 'United States'
GROUP BY year
ORDER BY year ASC;

-- Jeez, prices have increased by 400%!

SELECT
	year,
	SUM(prodvalue) AS total_prod_value_per_year
FROM
	honey1998to2021
WHERE state != 'United States'
GROUP BY year
ORDER BY year ASC;

-- And despite less honey being produced, the money in the market has never been higher. The higher prices are more than
-- making up for the lack of money...at least for those producing it.

-- While collecting the data from 2013-2021 I also noticed the reports had some additional interesting info that the original person didn't collect.
-- From 2015-2017 the USDA collected information relating to small producers of honey, those with less than 5 colonies.
-- Unfortunately it's very granular data. Rather than a state by state breakdown, it was only collected across the US.
-- And with onlyl 3 years of data the USDA is reporting isn't much, so any conclusions can't be that strong.

SELECT * FROM smallfarms;

-- The number of colonies isn't that interesting, other than that it's slowly decreasing. If only there was more data!
-- Maybe we can see a difference in efficiency between small scale producers and more industrialized processes?

SELECT
	AVG(yieldpercol)
FROM
	smallfarms;
    
SELECT 
	AVG(yieldpercol)
FROM
	honey1998to2021;

-- Small farms averged 31.06lbs per colony. As we learned earlier, larger scall operations averaged 58.33lbs per colony. Huge difference.
-- It would be interesting to learn the technological/metholodigal practices that cause this.

-- Since 2016 the USDA has also been collected various expenditures operations with more than 5 colonies have accrued. This data is not state specific but
-- rather shows expenditures from the entire US.

SELECT * FROM expenditures;

-- The varroa mite is one of the huge bee killers, and producers are clearly spending heavily on means of reducing their impact on their hives.
-- It's unfortunate we don't have access to more data on this as their outbreak in the US occurred in 2006.
-- It would have been interesting to see related spending over this time frame, but we can actually see spending on varroa control has decreased recently.
-- Hopefully that's because they're less of a pest!
-- In fact, all of the expenditures have deceased recently despite the number of colonies remaining stable. It would be interesting to investigate this further.
