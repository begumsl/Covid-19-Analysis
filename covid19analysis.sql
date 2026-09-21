/*
    COVID-19 DATA EXPLORATION (SQL Server / T-SQL)
    Data: Our World in Data COVID-19 dataset, loaded as CovidDeaths and CovidVaccinations
    Coverage: 01-01-2020 to 30-04-2021
    Part 1 (Q1-Q8): guided exploration adapted from Alex the Analyst's COVID Portfolio Project
    Part 2 (Q9-Q12): my own extended analysis

    Data notes:
    - All figures are based on confirmed/reported numbers only. They depend on testing and
      reporting practices and should not be read as true infection or fatality rates.
    - total_* columns are cumulative, so MAX() returns a country's latest value.
      Cumulative values can decrease when the source applies corrections.
    - Rows with continent IS NULL are aggregates (World, Europe, High income...), not countries.
    - Some numeric columns were imported as nvarchar, hence the CAST calls.

    Terminology:
    - Case fatality rate (CFR) = total_deaths / total_cases * 100
    - Confirmed case rate = total_cases / population * 100
    - Doses relative to population = cumulative doses / population * 100 (can exceed 100%)
*/

-------------Initial Analysis


---Q1: Case Fatality Rate Over Time (Turkey)
--How did the COVID-19 case fatality rate (deaths as a percentage of confirmed cases) change over time in Turkey?

--total_cases is float, so the division keeps its decimal part; ROUND limits the result to 2 decimals.
--Note: CFR uses confirmed cases only, so it reflects testing and reporting practices as well as severity.

select Location,
	   date,
	   total_cases,
	   total_deaths,
	   Round((cast(total_deaths as bigint)/nullif(total_cases,0))*100,2) as case_fatality_rate 
from CovidDeaths
where location = 'Turkey' 
order by date


---Q2: Confirmed Cases Relative to Population Over Time (Turkey)
--How did the cumulative confirmed COVID-19 cases as a percentage of the population change over time in Turkey?

--Note:This represents confirmed cases relative to population, not the true percentage of people who were infected.

select Location,
	   date,
	   population,
	   total_cases,
	   Round((total_cases/population)*100,2) as percent_population_infected
from CovidDeaths
where location= 'Turkey' 
order by date


---Q3: Countries with the Highest Confirmed Case Rate Relative to Population
--Which countries recorded the highest cumulative confirmed COVID-19 case rates relative to their populations?

select location,
	 Max(total_cases) as total_confirmed_cases,
	 population,
	 (Max(total_cases)/ population)*100 as confirmed_case_rate
from CovidDeaths
where continent is not null 
group by location,population
order by confirmed_case_rate desc


---Q4: Countries with the Highest Total COVID-19 Deaths
--Which countries recorded the highest cumulative number of COVID-19 deaths?

select Location,
	 Max(cast(total_deaths as bigint)) as country_total_deaths
from CovidDeaths
where continent is not null
group by location
order by country_total_deaths desc;


---Q5: Total COVID-19 Deaths by Continent
--Which continents recorded the highest cumulative number of COVID-19 deaths?

--Grouping MAX(total_deaths) directly by continent would return only the highest single country, not the continent total
--Step 1: Get the latest cumulative death count for each country.
--Step 2: country totals are summed per continent

with country_totals
as 
(
select Location,continent,
	 Max(cast(total_deaths as bigint)) as country_total_deaths
from CovidDeaths
where continent is not null
group by location,continent
)
select continent,
	   sum(country_total_deaths) as continent_total_deaths
from country_totals
group by continent
order by continent_total_deaths desc


---Q6: Global COVID-19 Statistics
--What were the worldwide totals for confirmed COVID-19 cases and deaths, and what was the global case fatality rate?
--Note: same CFR definition as Q1, based on confirmed cases only.

select 
	   sum(new_cases) as global_total_cases,
	   sum(cast(new_deaths as float)) as global_total_deaths,
	  (sum(cast(new_deaths as float)) / sum(new_cases))*100 as global_case_fatality_rate
from CovidDeaths
where continent is not null


---Q7: Rolling Vaccination Doses by Country
--How did cumulative COVID-19 vaccination doses change over time across countries?

--Note: the running total counts doses, not people, so it can exceed the population when individuals receive multiple doses.

select d.continent,
	   d.location,
	   d.date,
	   d.population,
	   v.new_vaccinations,
	   sum(cast(v.new_vaccinations as bigint)) Over (Partition by d.Location Order by d.date) as rolling_vaccination_doses
from CovidVaccinations v
join CovidDeaths d
on d.location=v.location and d.date=v.date
where d.continent is not null;


---Q8: Cumulative Vaccination Doses Relative to Population
--How did cumulative COVID-19 vaccination doses relative to population size vary across countries?

--Note: new_vaccinations counts doses, not people, so the ratio can exceed 100%.

with vac 
as 
(select d.continent,
	   d.location,
	   d.date,
	   d.population,
	   v.new_vaccinations,
	   sum(cast(v.new_vaccinations as bigint)) Over (Partition by d.Location Order by d.date) as rolling_vaccination_doses
from CovidVaccinations v
join CovidDeaths d
on d.location=v.location and d.date=v.date
where d.continent is not null
)
select  location,
		population,
		rolling_vaccination_doses,
		new_vaccinations,
	    (cast(rolling_vaccination_doses as float)/nullif(population,0))*100 as percent_population_doses

from vac

------------- My Extended Analysis

---Q9: Monthly Cumulative Deaths by Country
--How did cumulative COVID-19 deaths change month by month across countries?

--Approach: dates are converted to yyyy-MM for monthly grouping; MAX(total_deaths) returns the month-end cumulative value.
--Note: if the source corrects earlier figures, a cumulative value can decrease, so MAX() may not equal the last daily value.
select location,
	   format(date,'yyyy-MM') as month_period,
	   Max(cast(total_deaths as bigint)) as month_end_total_deaths
from CovidDeaths
where continent is not null
group by location,format(date,'yyyy-MM')
order by location,month_period asc;


---Q10: Monthly New Deaths and Monthly Percentage Change by Country
--How did monthly new COVID-19 deaths change compared with the previous month across countries?

--CASE WHEN calculates the percentage change only if the previous month is above 0, otherwise NULL (avoids division by zero).
--Note: negative monthly values come from source corrections and are kept, so monthly sums stay consistent with the cumulative series.
--Large percentages from small death counts should be read together with the actual counts.
with deaths as
(
select  location,
	    format(date,'yyyy-MM') as month_period,
		sum(cast(new_deaths as bigint)) as monthly_deaths
from CovidDeaths
where continent is not null 
group by location,format(date,'yyyy-MM')
),
monthly_deaths 
as
(
select  location,
	    month_period,
	    monthly_deaths,
	    LAG(monthly_deaths) Over (partition by location order by month_period) as previous_month_deaths
from deaths		
)
select  location,
		month_period,
		monthly_deaths,
		previous_month_deaths,
		CASE WHEN previous_month_deaths > 0
			THEN
			cast(
				 (monthly_deaths - previous_month_deaths)*100.0
				 /(previous_month_deaths) as decimal(10,2)			) 
		 END AS monthly_death_change_pct
from monthly_deaths
order by location,month_period asc;


---Q11: Older Population Share vs. COVID-19 Deaths per Million
--How did cumulative COVID-19 deaths per million vary across groups of elderly population share and Human Development Index (HDI)?

--Countries were grouped by Human Development Index (HDI) as a proxy for differences in human development level.
--The elderly population share was divided into manually defined groups based on the distribution of the data. The group boundaries were selected to make demographic differences between
--groups more visible while maintaining a sufficient and reasonably balanced number of countries in each group.

--For each country, the maximum cumulative COVID-19 deaths per million observed during the available data period were identified.
with country_base
as
(
select  v.location,
        cast(v.aged_65_older as float) as aged_65_older,
        cast(v.human_development_index as float) as human_development_index,
        Max(cast(d.total_deaths_per_million as float)) as total_deaths_per_million
from CovidVaccinations v
join CovidDeaths d
on v.location=d.location and v.date=d.date
where v.continent is not null
      and aged_65_older is not null
      and human_development_index is not null
      and d.total_deaths_per_million is not null
group by v.location,
         cast(aged_65_older as float),
         cast(human_development_index as float)
),
classified_countries 
as
(
select *,
        CASE 
            WHEN aged_65_older < 4   THEN 'Low'
            WHEN aged_65_older < 10  THEN 'Medium'
            WHEN aged_65_older < 15  THEN 'High'
            ELSE 'Very High'
        END AS elderly_population_group,
        CASE
             WHEN human_development_index < 0.55 THEN '< 0.55'
             WHEN human_development_index < 0.70 THEN '0.55–0.69'
             WHEN human_development_index < 0.80 THEN '0.70–0.79'
             WHEN human_development_index < 0.90 THEN '0.80–0.89'
             ELSE '0.90+'
        END AS development_group
from country_base
)
select
    elderly_population_group,
    development_group,
    count(*) AS country_count,
    avg(total_deaths_per_million) AS avg_deaths_per_million
from classified_countries
group by
    elderly_population_group,
    development_group
order by avg_deaths_per_million desc

/*	Result & Observation:

Elderly population groups were manually defined based on the distribution of the data, so the group boundaries involve some degree of interpretation.
The three groups with the highest average deaths per million (1,102.96 to 1,828.21) all belong to the "Very High" elderly population group.

The least developed countries (<0.55) show the lowest averages, this may be influenced by differences in testing and reporting capacity.

Conclusion: higher elderly population share is associated with higher recorded deaths per million at the country-group level.
These patterns are descriptive observations, not evidence of a direct or causal relationship.
*/

---Q12: Testing Intensity vs. Reported Cases
--How did reported cases and positivity rates vary across countries grouped by testing intensity?

-- Step 1:
-- To ensure a fair comparison across countries, dates were ranked by the number of countries
-- with complete data for the selected indicators.
-- The most recent date among those with the highest data completeness was selected.
-- This approach reduces potential bias caused by missing data while maintaining the most recent comparable snapshot.

select top 10
    v.date,
    count(*) as countries_with_complete_data
from CovidVaccinations v
join CovidDeaths d
    on v.location = d.location
    and v.date = d.date
where v.continent is not null
  and v.total_tests_per_thousand is not null
  and d.total_cases_per_million is not null
  and v.positive_rate is not null
group by v.date
order by countries_with_complete_data desc;

-- Step 2:
-- Only countries with complete data for all three selected indicators were included in the analysis.
-- Countries were ranked by testing intensity and divided into five approximately equal-sized groups using NTILE(5).
-- CASE WHEN was used to assign descriptive labels to the groups, making the results easier to interpret.
-- The analysis then summarizes positive rates and reported cases for each testing-intensity group using average, minimum, and maximum values.

with snapshot 
as
(
select v.location,
	   cast(v.total_tests_per_thousand as float) as tests_per_thousand,
	   cast(d.total_cases_per_million as float) as cases_per_million,
	   cast(v.positive_rate as float)*100 as positive_rate_percent
from CovidVaccinations v 
join CovidDeaths d 
on v.location=d.location and v.date=d.date
where v.continent is not null
	  and v.total_tests_per_thousand is not null
	  and d.total_cases_per_million is not null
	  and v.positive_rate is not null
	  and v.date = '2021-01-25'
),
leveled 
as
(
select * ,
	   Ntile(5) over (order by tests_per_thousand,location) as test_group
	
from snapshot
)
select  CASE test_group
			WHEN 1 THEN 'Very Low'
			WHEN 2 THEN 'Low'
			WHEN 3 THEN 'Medium'
			WHEN 4 THEN 'High'
			WHEN 5 THEN 'Very High'
			END AS test_level,
		count(*) as country_count,	
		round(min(tests_per_thousand), 1)        as min_tests_per_thousand,
		round(max(tests_per_thousand), 1)        as max_tests_per_thousand,

		round(avg(positive_rate_percent), 2)     as avg_positive_rate_percent,
		round(min(positive_rate_percent), 2)     as min_positive_rate_percent,
		round(max(positive_rate_percent), 2)     as max_positive_rate_percent,

		round(avg(cases_per_million), 1)         as avg_cases_per_million,
		round(min(cases_per_million), 1)         as min_cases_per_million,
		round(max(cases_per_million), 1)         as max_cases_per_million
	
from leveled
group by test_group
order by test_group

/*
	 Result & Observation:
Average positivity rates did not follow a monotonic pattern across testing categories.
The positivity rate increased from 11.86% in the Very Low testing group to 14.73% in the Low testing group, before declining steadily to 5.18% in the Very High testing group.

In contrast, the average number of reported cases per million increased consistently with testing intensity. 
Average cases per million rose from 2,405 in the Very Low group to 51,294 in the Very High group, representing an approximately 21-fold increase.

These findings suggest that countries with higher testing levels tend to report more cases while maintaining lower positivity rates. 
This pattern may indicate more comprehensive case detection in countries with extensive testing. 
However, the observed relationship should not be interpreted as causal, as factors such as income level, reporting quality, healthcare capacity, and the timing of epidemic waves may also influence the results.
 */