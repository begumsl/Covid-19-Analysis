# Covid-19-Analysis :earth_americas:
This project explores global COVID-19 trends using SQL Server and the Our World in Data dataset. The analysis examines reported cases, deaths, vaccinations, and testing metrics across countries and over time. Advanced SQL techniques such as CTEs, window functions, joins, and aggregate analysis were used to uncover trends and relationships in the data.

## Objective :test_tube:
Explore the Our World in Data COVID-19 dataset with T-SQL to compare how reported cases, deaths, vaccinations and testing varied across countries and over time, and to examine how factors such as elderly population share, HDI and testing intensity relate to these outcomes.

## Project Note :chart_with_upwards_trend:
This project is based on Alex The Analyst's [COVID-19 Data Exploration](https://www.youtube.com/watch?v=qfyynHBFOsM) video.

- Q1–Q8:  Original questions and queries from Alex The Analyst's project.
- Q9–Q12: Additional questions and queries I developed independently to extend the analysis.

## Dataset
 Source: [Our World in Data — COVID-19 Deaths](https://ourworldindata.org/covid-deaths)  
 Coverage: 01-01-2020 to 30-04-2021

## Tools 
 Microsoft SQL Server (T-SQL)
 
 ## SQL Concepts Demonstrated :brain:
- SELECT, WHERE, GROUP BY and ORDER BY
- Aggregate Functions: SUM(), MAX(), AVG(), MIN(), COUNT()
- JOINs
- Common Table Expressions (CTEs)
- Window Functions: LAG(), NTILE(), and SUM() OVER()
- CASE WHEN Statements
- Date and Time Functions: FORMAT()
- Type Casting: CAST()
- NULL Handling: IS NULL, IS NOT NULL, NULLIF()
- Conditional calculations and percentage analysis
- Monthly aggregation and time-series analysis
- Data grouping and classification

## Questions :question:
1. Case Fatality Rate Over Time (Turkey)  
How did the COVID-19 case fatality rate (deaths as a percentage of confirmed cases) change over time in Turkey?

2. Confirmed Cases Relative to Population Over Time (Turkey)  
How did the cumulative confirmed COVID-19 cases as a percentage of the population change over time in Turkey?

3. Countries with the Highest Confirmed Case Rate Relative to Population  
Which countries recorded the highest cumulative confirmed COVID-19 case rates relative to their populations?

4. Countries with the Highest Total COVID-19 Deaths  
Which countries recorded the highest cumulative number of COVID-19 deaths?

5. Total COVID-19 Deaths by Continent  
Which continents recorded the highest cumulative number of COVID-19 deaths?

6. Global COVID-19 Statistics  
What were the worldwide totals for confirmed COVID-19 cases and deaths, and what was the global case fatality rate?

7. Rolling Vaccination Doses by Country  
How did cumulative COVID-19 vaccination doses change over time across countries?

8. Cumulative Vaccination Doses Relative to Population  
How did cumulative COVID-19 vaccination doses relative to population size vary across countries?

9. Monthly Cumulative Deaths by Country  
How did cumulative COVID-19 deaths change month by month across countries?

10. Monthly New Deaths and Monthly Percentage Change by Country  
How did monthly new COVID-19 deaths change compared with the previous month across countries?

11. Older Population Share vs. COVID-19 Deaths per Million  
How did cumulative COVID-19 deaths per million vary across groups of elderly population share and Human Development Index (HDI)?

12. Testing Intensity vs. Reported Cases  
How did reported cases and positivity rates vary across countries grouped by testing intensity?

## Key Findings :bulb:
- The United States recorded the highest cumulative COVID-19 death count in the dataset, followed by Brazil, Mexico, India, and the United Kingdom.  

- Europe recorded the highest cumulative COVID-19 deaths, with 1,016,750 deaths, while Oceania recorded the lowest, with 1,046 deaths.  

- Monthly COVID-19 deaths varied substantially across countries and over time. Percentage changes could be particularly large when the previous month's death count was low, making percentage changes sensitive to small baseline values.  

- Average recorded COVID-19 deaths per million varied across elderly population and HDI groups, with higher elderly population shares generally associated with higher mortality levels. However, this finding should not be interpreted as a causal relationship.  
 
- Higher testing intensity was associated with higher reported cases per million and lower average positivity rates. This pattern may reflect greater case detection in countries with more extensive testing and should not be interpreted as a causal relationship.  


## Limitations :warning:
- Reported COVID-19 cases and deaths may differ from actual infections and deaths due to differences in testing, reporting practices and data availability.
- Missing values and differences in data coverage may affect cross-country comparisons.
- Testing intensity and reported case counts should not be interpreted as a direct measure of actual infection prevalence.
- Observational relationships identified in the analysis do not imply causation.









