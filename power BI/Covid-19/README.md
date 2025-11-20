# Global COVID-19 Dashboard

## Project Description
This dashboard visualizes covid-19 cases, deaths and vaccination progresss across the world. using SQL Server for data processing and Power BI for data proessing and Power BI for visualiztion, it provides a comprehensive view of the pandemic trends and country-level insights.

##  Objecties
- Track global and country-level COVID-19 trends
- compare cases, deaths, and vaccinations
- Explore correlations between vaccination rates and death rates

## Data source
- ** COVID-19 cases & Deaths ** `coviddeaths` table from 
[our world in data](htttps://ourworldindata.org/covid-cases)
- ** Vaccination** `covidvaccination` table from 
[our world in data](htttps://ourworldindata.org/covid-vaccination)

## Tools & Technology
-** SQL Server manangement Studio(ssms) **: for data cleaning, aggregation, and view creation
- ** Power BI **: for visualizatioon and dashboard creation

## Dashboard Structure
** page 1: Global Overview & Trends **
- KPI cards: total cases, deaths, vaccination, death rate %, vaccination rate %
- line chart: Global new cases over time
- Column chart: cases vs deaths per continent
- Map: Global spread of COVID-19

** page 2: Country Insights & Vaccination Impact ** 
- Slicer: continent,country,date
- Bar chart: top 10 countries by cases
- Line chart: vaccination progress
- Scatter plot: vaccination rate vs death rate

## key Features
- Interative filter for continent, country, and date
- Dynamic KPIs for latest data
- Comparative analysis of vaccination impact
- Drill-down from global trends to country-level insights

## How to use 
1. Connect to the SQL Server database using Power BI
2. Load the view `vw_CovidSummary` 
3. Interact with slicer to filter by country,continent, or date
4. Explore the dashboards to explore trends and insights

## Author
**Kelechi Emmanuel**
- Email:emmanuelgowdin952@gmail.com
- portfolio: https://github/emmanuelkece.com