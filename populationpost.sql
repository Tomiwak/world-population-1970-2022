-- creating a database
create database mybase;
use mybase;

select *
from wp;
-- creating a copy of the table wp
create table wp1
like wp;
insert into wp1
select *
from wp;

select *
from wp1;
-- changing the names of the columns
alter table wp1
rename column `Growth Rate` to Growth_rate;
alter table wp1
rename column `Country/Territory` to Country;
alter table wp1
rename column `2022 Population` to `2022_Population`;
alter table wp1
rename column `2020 Population` to `2020_Population`;
alter table wp1
rename column `2015 Population` to `2015_Population`;
alter table wp1
rename column `2010 Population` to `2010_Population`;
alter table wp1
rename column `2000 Population` to `2000_Population`;
alter table wp1
rename column `1990 Population` to `1990_Population`;
alter table wp1
rename column `1980 Population` to `1980_Population`;
alter table wp1
rename column `1970 Population` to `1970_Population`;
alter table wp1
rename column `Area (kmÂ²)` to `Area`;
alter table wp1
rename column `Density (per kmÂ²)` to `Density`;
alter table wp1
rename column `World Population Percentage` to `World_Population_Percentage`;

-- INSIGHTS
-- 1. Total Number of Countries in Each Continent
-- This query counts the number of countries in each continent.
select Continent, count(*) number_of_countries
from wp1
group by Continent
order by number_of_countries desc;
-- 2. Top 10 Most Densely Populated Countries in 2022
-- This query calculates population density
select Country, Density
from wp1
order by Density
limit 10;
-- 3. Countries with the Largest Population in Each Continent in 2022
-- This query uses a window function to rank countries by population within each continent
-- and selects the top-ranked country for each continent.
with CTE(Country,Continent,Population,rank_cont) as
(select Country,Continent, 2022_Population,
rank() over(partition by Continent order by 2022_Population desc) rank_cont
from wp1)
select Country,Continent,Population
from CTE
where rank_cont = 1
order by Population desc;
-- 4. Continent with the Largest Land Area
-- This query sums the land area for each continent and identifies the continent with the largest total land area.
select Continent, sum(Area) land_area
from wp1
group by Continent
order by land_area desc;
-- 5. Countries with Population Above the Global Average in 2022
-- This query first calculates the global average population for 2022,
-- then selects countries with a population greater than this average.
select Country, 2022_Population,round((
select avg(2022_Population)
from wp1
),0) avg_population
from wp1
where 2022_Population > (
select avg(2022_Population)
from wp1
);
-- 6. Top 10 Most Populated Countries in 2022
-- This query retrieves the top 10 countries with the highest population in 2022.
select Country, 2022_Population
from wp1
order by 2 desc;
-- 7. Countries with Population Decline Between 2020 and 2022
-- This query identifies countries where the population in 2022 is less than the population in 2020.
select Country, 2022_Population, 2020_Population
from wp1
where 2022_Population < 2020_Population
;
