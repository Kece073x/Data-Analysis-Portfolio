--preview the first 10 rows of deaths
select *
from CovidDeaths;

select *
from CovidVaccination;

--column details
exec sp_columns CovidDeaths;
exec sp_columns CovidVaccination;

--standardizing datatype
select column_name,data_type, character_maximum_length
from INFORMATION_SCHEMA.columns
where table_schema = 'dbo' and table_name = 'covidvaccination'
order by ordinal_position;

alter table coviddeaths
alter column total_deaths bigint

alter table coviddeaths
alter column total_cases bigint

alter table coviddeaths
alter column new_cases bigint

alter table coviddeaths
alter column total_deaths float

alter table coviddeaths
alter column new_deaths bigint

alter table coviddeaths
alter column total_cases_per_million decimal(18,2)

alter table coviddeaths
alter column new_cases_per_million decimal(18,2)

alter table coviddeaths
alter column new_cases_smoothed_per_million decimal(18,2)

alter table coviddeaths
alter column total_deaths_per_million decimal(18,2)

alter table coviddeaths
alter column new_deaths_per_million decimal(18,2)

alter table coviddeaths
alter column new_deaths_smoothed_per_million decimal(18,2)

alter table coviddeaths
alter column reproduction_rate decimal(5,2)

alter table coviddeaths
alter column icu_patients bigint

alter table coviddeaths
alter column icu_patients_per_million decimal(18,2)

alter table coviddeaths
alter column hosp_patients bigint

alter table coviddeaths
alter column hosp_patients_per_million decimal(18,2)

alter table coviddeaths
alter column weekly_icu_admissions float

alter table coviddeaths
alter column weekly_icu_admissions_per_million decimal(18,2)

alter table coviddeaths
alter column weekly_hosp_admissions float

alter table coviddeaths
alter column weekly_hosp_admissions_per_million decimal(18,2)

alter table coviddeaths
alter column new_tests bigint

-- standardization for covidvaccination table
alter table covidvaccination
alter column total_tests bigint

alter table covidvaccination
alter column total_tests_per_thousand decimal(18,2)

alter table covidvaccination
alter column new_tests_per_thousand decimal(18,2)

alter table covidvaccination
alter column new_tests_smoothed float

alter table covidvaccination
alter column new_tests_smoothed_per_thousand decimal(18,2)

alter table covidvaccination
alter column positive_rate decimal(5,4)

alter table covidvaccination
alter column tests_per_case decimal(10,4)

alter table covidvaccination
alter column tests_units nvarchar(50)

alter table covidvaccination
alter column total_vaccinations bigint

alter table covidvaccination
alter column people_vaccinated bigint

alter table covidvaccination
alter column people_fully_vaccinated bigint

alter table covidvaccination
alter column new_vaccinations bigint

alter table covidvaccination
alter column total_vaccinations_per_hundred decimal(5,2)

alter table covidvaccination
alter column new_vaccinations_smoothed_per_million decimal(18,2)

alter table covidvaccination
alter column new_vaccinations_smoothed float

alter table covidvaccination
alter column stringency_index decimal(5,2)

alter table covidvaccination
alter column population bigint

alter table covidvaccination
alter column population_density decimal(10,2) 

alter table covidvaccination
alter column median_age decimal(4,1)

alter table covidvaccination
alter column aged_65_older decimal(5,2) 

alter table covidvaccination
alter column aged_70_older decimal(5,2)

alter table covidvaccination
alter column gdp_per_capita decimal(18,2)

alter table covidvaccination
alter column extreme_poverty decimal(5,2)

alter table covidvaccination
alter column cardiovasc_death_rate decimal(10,2)

alter table covidvaccination
alter column diabetes_prevalence decimal(5,2)

alter table covidvaccination
alter column female_smokers decimal(5,2)

alter table covidvaccination
alter column male_smokers decimal(5,2)

alter table covidvaccination
alter column handwashing_facilities decimal(5,2)

alter table covidvaccination
alter column hospital_beds_per_thousand decimal(5,2)

alter table covidvaccination
alter column life_expectancy decimal(5,2)

alter table covidvaccination
alter column human_development_index decimal(5,3)


--missing values
--coviddeaths
select 
	sum(case when location is null then 1 else 0 end) as location_null,
	sum(case when continent is null then 1 else 0 end) as continent_null,
	sum(case when total_cases is null then 1 else 0 end) as total_cases_null,
	sum(case when new_cases is null then 1 else 0 end) as new_cases_null,
	sum(case when total_deaths is null then 1 else 0 end) as total_deaths_null,
	sum(case when new_deaths is null then 1 else 0 end) as new_deaths_null
from CovidDeaths;

select
	sum(case when location is null then 1 else 0 end) as location_null,
	sum(case when continent is null then 1 else 0 end) as continent_null,
	sum(case when total_tests is null then 1 else 0 end) as total_tests_null,
	sum(case when total_vaccinations is null then 1 else 0 end) as total_vaccinations_null,
	sum(case when new_vaccinations is null then 1 else 0 end) as new_vaccinations_null,
	sum(case when population is null then 1 else 0 end) as  population_null
from CovidVaccination;

--duplicates check
select 
	location,
	date,
	count(*) as duplicate_count
from CovidDeaths
group by location,date
having count(*) > 1 ;

select
	location,
	date,
	count(*) as duplicate_count
from CovidVaccination
group by location,date
having count(*) > 1;

--summary stat
select 
	min(total_cases) as min_case,
	max(total_cases) as max_case,
	round(avg(total_cases),2) as avg_case,
	min(total_deaths) as min_deaths,
	max(total_deaths) as max_deaths,
	round(avg(total_deaths),2) as avg_deaths
from CovidDeaths
where continent is not null

select 
	min(total_vaccinations) as min_total_vaccinations,
	max(total_vaccinations) as max_total_vaccinations,
	round(avg(total_vaccinations),2) as avg_total_vaccinations
from CovidVaccination
where continent is not null

--time series analysis
select
	date,
	location,
	sum(new_cases) as daily_new_cases,
	sum(new_deaths) as daily_new_deaths
from CovidDeaths
where continent is not null
group by location,date
order by location,date;

select
	location,
	date,
	sum(new_vaccinations) as daily_vacc,
	sum(total_vaccinations) as cumulative_vacc
from CovidVaccination
where continent is not null
group by location,date
order by location,date;


--Running total per country
select
	date,
	location,
	sum(new_cases) as daily_new_cases,
	sum(new_deaths) as daily_new_deaths,
	sum(sum(new_cases)) over(partition by location order by date) as cum_cases,
	sum(sum(new_deaths)) over(partition by location order by date) as cum_deaths
from CovidDeaths
where continent is not null
group by location,date
order by location,date;


--Top countries
select top 10
	date,
	location,
	max(total_cases) as max_cases
from CovidDeaths
where continent is not null
group by date,location
order by max_cases desc

select top 10
	date,
	location,
	max(total_vaccinations) as max_vacc
from CovidVaccination
where continent is not null
group by date,location
order by max_vacc desc


--cases and deaths per million
select
	location,
	max(total_cases) as max_cases,
	max(total_deaths) as max_deaths,
	max(population) as population,
	round(cast(max(total_cases) as float)/ max(population) * 1000000, 2) as cases_per_mill,
	round(cast(max(total_deaths) as float)/ max(population) * 1000000,2) as deaths_per_mill
from CovidDeaths
where continent is not null
group by location;

--vaccination rate
select location,
	max(total_vaccinations) as max_vacc,
	max(population) as max_pop,
	round(cast(max(total_vaccinations) as float) / max(population) * 100,2) as vacc_rate_percent
from CovidVaccination
group by location;


--combine analysis
with combined as(
select 
	cd.location, cd.date, cd.total_cases, cd.new_cases, cd.total_deaths, cd.new_deaths,
	cv.total_vaccinations, cv.new_vaccinations, cv.population 
from CovidDeaths cd
left join CovidVaccination cv
	on cd.location = cv.location and
	cd.date = cv.date
) 
select *
from combined 
where location = 'united states'


--vaccination vs death per country
with vacc_and_death as(
select 
	cd.location, cd.date, cd.total_cases, cd.new_cases, cd.total_deaths, cd.new_deaths,
	cv.total_vaccinations, cv.new_vaccinations, cv.population 
from CovidDeaths cd
left join CovidVaccination cv
	on cd.location = cv.location and
	cd.date = cv.date
) 
select location, max(total_deaths) as max_deaths,
	max(total_vaccinations) as max_vaccination,
	round(cast(max(total_vaccinations) as float)/max(population) * 100,2) as vaccination_rate_percent
from vacc_and_death
group by location
order by vaccination_rate_percent


--growth rate(daily change)
with change_cte as (
select 
	location, 
	date, 
	new_cases,
	lag(new_cases) over(partition by location order by date) as prev_day_cases
from CovidDeaths
)
select location, date, new_cases,
	case
		when prev_day_cases = 0 or prev_day_cases is null then null
		else cast(new_cases as float)/prev_day_cases * 100
	end as daily_growth_rate_percent
from change_cte

--total cases vs total death
--likelyhood of dying from covid-19
select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as death_percentage
from CovidDeaths
where location like '%states'
order by 1,2



--table combining both covid and deaths
DROP TABLE IF EXISTS #CovidSummary;
select 
	cd.continent,
	cd.location,
	cd.date,
	cd.population,
	cd.total_cases,
	cd.new_cases,
	cd.total_deaths,
	cd.new_deaths,
	cv.total_vaccinations,
	cv.new_vaccinations
into #CovidSummary
from CovidDeaths cd
left join CovidVaccination cv
on cd.location = cv.location and 
cd.date = cv.date

--preview
select top 10 *
from #CovidSummary

--row count
select count(*)
from #CovidSummary

--derived columns
select *,
	case when population is null or population = 0 then null
	  else cast(total_cases as float)/ population * 1000000 end as case_per_million, 
    case when population is null or population = 0 then null
	  else cast(total_deaths as float)/ population * 1000000 end as deaths_per_million,
	case when population is null or population = 0 then null
	  else cast(total_vaccinations as float)/ population * 100 end as vaccination_rate_percent
into #CovidSummaryEnhanced
from #CovidSummary;

IF OBJECT_ID('dbo.vw_CovidSummary', 'v') is not null
	DROP VIEW dbo.vw_CovidSummary
	go;

--useful metrics
CREATE VIEW dbo.vw_CovidSummary as 
select 
	cd.continent,
	cd.location,
	cd.date,
	cd.population,
	cd.total_cases,
	cd.new_cases,
	cd.total_deaths,
	cd.new_deaths,
	cv.total_vaccinations,
	cv.new_vaccinations,
	case when cd.population is null or cd.population = 0 then null
	  else cast(total_cases as float)/ cd.population * 1000000 end as case_per_million, 
    case when cd.population is null or cd.population = 0 then null
	  else cast(total_deaths as float)/ cd.population * 1000000 end as deaths_per_million,
	case when cv.population is null or cv.population = 0 then null
	  else cast(total_vaccinations as float)/ cv.population * 100 end as vaccination_rate_percent
from CovidDeaths cd
left join CovidVaccination cv
on cd.location = cv.location and 
cd.date = cv.date
GO

--top results
select top 10 *
from dbo.vw_CovidSummary;

--top countries by vaccination rate
select
	location,
	max(vaccination_rate_percent) as vaccination_rate
from dbo.vw_CovidSummary
group by location
order by vaccination_rate desc;
