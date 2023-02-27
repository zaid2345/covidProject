
-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in iraq

select location , date , total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercantage
from covidDeaths
where location = 'iraq'
order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid in iraq

select location,date , population , total_cases , (total_cases/population)*100 as infectionPercentage
from covidDeaths
where location = 'iraq'
order by 1,2



-- countries with highest infection rate compared to population

select location, population , max(total_cases) as highestInfectionCount , max((total_cases/population))*100 as infectionPercentage
from covidDeaths
where continent is not null
group by location, population
order by infectionPercentage desc



-- Countries with Highest Death Count per Population

select location, population  ,max(cast(total_deaths as int)) as highestDeathsCount,MAX(total_deaths/population)*100 as deathpercentage
from covidDeaths
where continent is not null
group by location, population
order by deathpercentage desc



-- countries with highest death count

select location, population  ,max(cast(total_deaths as int)) as highestDeathsCount
from covidDeaths
where continent is not null
group by location, population
order by highestDeathsCount desc



-- continents whit highest infcetion rate

select location, population , max(total_cases) as highestInfectionCount , max((total_cases/population))*100 as infectionPercentage
from covidDeaths
where continent is null
and location not like '%income%' 
and location not like '%union%'
and location not like 'world'
and population is not null
group by location, population
order by infectionPercentage desc



-- Showing contintents with the highest death count per population

select location, population  ,max((total_deaths/population))*100 as deathpercentage
from covidDeaths
where continent is null
and location not like '%income%' 
and location not like '%union%'
and location not like 'world'
and population is not null
group by location, population
order by deathpercentage desc



-- continets with highest death count

select location, population  ,max(cast(total_deaths as int)) as highestDeathsCount
from covidDeaths
where continent is null
and location not like '%income%' 
and location not like '%union%'
and location not like 'world'
and population is not null
group by location, population
order by highestDeathsCount desc




-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3




-- Using CTE to perform Calculation on Partition By in previous query

with popvsvac (continent,location,date,population,new_vaccinations,rollingPeopleVaccination)
as
(
select dea.continent , dea.location ,dea.date,dea.population , vac.new_vaccinations
,sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location ,dea.date) as rollingPeopleVaccination
from covidDeaths as dea
join CovidVaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select * , (rollingPeopleVaccination/population)*100 as rollingPeopleVaccinationPercentage
from popvsvac
