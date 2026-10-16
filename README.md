# COVID 19 ANALYSIS WITH SQL SERVER & POWER BI :earth_americas:
This portfolio project analyzes global COVID-19 trends using the Our World in Data (OWID) dataset, SQL Server, and Power BI. The SQL analysis examines reported cases, deaths, vaccinations, and testing metrics across countries and over time. An interactive Power BI dashboard presents selected findings through KPI cards, filters, geographic visualizations, country rankings, and time-series analysis.

## Objective :test_tube:
Explore the Our World in Data COVID-19 dataset with T-SQL to compare how reported cases, deaths, vaccinations and testing varied across countries and over time, and to examine how factors such as elderly population share, HDI and testing intensity relate to these outcomes.

## Project Note :chart_with_upwards_trend:
This project is based on Alex The Analyst's [COVID-19 Data Exploration](https://www.youtube.com/watch?v=qfyynHBFOsM) video.

- Q1–Q8:  Original questions and queries from Alex The Analyst's project.
- Q9–Q12: Additional questions and queries I developed independently to extend the analysis.

## Power BI Dashboard :bar_chart:
The interactive Power BI dashboard provides an overview of selected global COVID-19 indicators from 1 January 2020 to 30 April 2021. It supports analysis across time periods, continents, and countries.

<img width="1530" height="862" alt="COVID-19 Power BI Dashboard" src="https://github.com/user-attachments/assets/991ab60f-7284-4c54-a8de-f8687b3be634" />


### The dashboard includes:

- KPI cards for confirmed cases, deaths and fully vaccinated population
- Interactive date range filtering
- Continent-based filtering
- Dynamic metric selection (Cases Rate / Deaths Rate)
- Top 5 country ranking by selected metric
- Geographic analysis using world map visualization
- Time-series trend analysis of COVID-19 deaths
- Cross-filtering between dashboard visuals

## Dataset
 Source: [Our World in Data — COVID-19 Deaths](https://ourworldindata.org/covid-deaths)  
 Coverage: 01-01-2020 to 30-04-2021

## Tools 
- Microsoft SQL Server (T-SQL)  
- Microsoft Power BI 
 
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

**Key Findings 💡**

* The United States recorded the highest cumulative COVID-19 death count in the dataset, followed by Brazil, Mexico, India, and the United Kingdom.
* Europe recorded the highest cumulative COVID-19 deaths (1,016,750), while Oceania recorded the lowest (1,046).
* Monthly COVID-19 deaths varied substantially across countries and over time; percentage changes were particularly large when the previous month's death count was low, reflecting sensitivity to small baseline values.
* Countries with a higher elderly population share generally showed higher average COVID-19 deaths per million, with mortality levels also varying across HDI groups.
* Higher testing intensity was associated with higher reported cases per million and lower average positivity rates.

**Limitations ⚠️**

* Reported cases and deaths may differ from actual infection and mortality levels due to differences in testing capacity, reporting practices, and data availability across countries. Testing intensity and case counts should therefore not be interpreted as direct measures of true infection prevalence.
* Missing values and inconsistent data coverage may affect cross-country comparisons.
* All observational relationships identified in this analysis (elderly population/HDI vs. mortality, testing intensity vs. case detection) are associational, not causal.








