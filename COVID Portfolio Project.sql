select * from dbo.CovidDeaths
where continent is not null
ORDER BY 3, 4



--SELECT * from dbo.covidvaccinations
--ORDER BY 3, 4



Select location, date, total_cases, new_cases, total_deaths, population
from dbo.CovidDeaths
order by 1, 2


-- Total Deaths vs Total Cases


Select location, date, total_cases, total_deaths,CONVERT(FLOAT,total_deaths)/(CONVERT(FLOAT, total_cases))* 100 as Deathpercentage
from dbo.CovidDeaths
WHERE location like '%canada%'
and continent is not null
order by 1, 2


-- Total Cases vs Population

Select location, date, total_cases, population, CONVERT(FLOAT,total_cases)/(CONVERT(FLOAT, population))* 100 as Casepercentage
from dbo.CovidDeaths
WHERE location like '%canada%'
and continent is not null
order by 1, 2

--Countries with thw highest infection rate per population

Select location, population, MAX(CONVERT(FLOAT,total_cases)) as HighestInfectionCount, Max(CONVERT(FLOAT,total_cases))/(CONVERT(FLOAT, population))* 100 as Percentpopulationinfected
from dbo.CovidDeaths
where continent is not null
GROUP BY location, population
order by Percentpopulationinfected desc

--Countries with the highest death count per population


Select location,  MAX(CONVERT(FLOAT,total_deaths)) as TotalDeathCount
from dbo.CovidDeaths
where continent is not null
GROUP BY location
order by TotalDeathcount desc

-- CONTINENTS


--Continents with the highest death count per population

Select continent,  MAX(CONVERT(FLOAT,total_deaths)) as TotalDeathCount
from dbo.CovidDeaths
where continent is not null
GROUP BY continent
order by TotalDeathcount desc



-- GLOBAL NUMBERS

Select date, SUM(CONVERT(FLOAT,new_cases)) as total_cases, SUM(CONVERT(FLOAT,new_deaths)) as total_deaths,SUM(CONVERT(FLOAT,new_deaths))/SUM(CONVERT(FLOAT,new_cases))* 100 as Deathpercentage
from dbo.CovidDeaths
WHERE continent is not null
Group by date
order by 1, 2


Select SUM(CONVERT(FLOAT,new_cases)) as total_cases, SUM(CONVERT(FLOAT,new_deaths)) as total_deaths,SUM(CONVERT(FLOAT,new_deaths))/SUM(CONVERT(FLOAT,new_cases))* 100 as Deathpercentage
from dbo.CovidDeaths
WHERE continent is not null
order by 1, 2


-- Total Population vs Vaccinations

Select deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations
, SUM(CONVERT(FLOAT,vac.new_vaccinations)) OVER (Partition by deaths.location order by deaths.location, deaths.date) as rollingcountpeoplevaccinated,
--(rollingcountpeoplevaccinated/population)*100
from dbo.CovidDeaths deaths
join dbo.CovidVaccinations Vac
on deaths.location= vac.location
and deaths.date= vac.date
WHERE deaths.continent is not null
order by 2,3

-- USE CTE

With PopvsVac (continent, location, date, population, new_vaccinations, rollingcountpeoplevaccinated)
as

(Select deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations
, SUM(CONVERT(FLOAT,vac.new_vaccinations)) OVER (Partition by deaths.location order by deaths.location, deaths.date) as rollingcountpeoplevaccinated
from dbo.CovidDeaths deaths
join dbo.CovidVaccinations Vac
on deaths.location= vac.location
and deaths.date= vac.date
WHERE deaths.continent is not null)

Select *, (Rollingcountpeoplevaccinated/population) * 100 from PopvsVac


-- TEMP TABLE

DROP Table if exists  #percentpopulationvaccinated
Create table #percentpopulationvaccinated
(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingcountpeoplevaccinated numeric)

insert into #percentpopulationvaccinated

Select deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations
, SUM(CONVERT(FLOAT,vac.new_vaccinations)) OVER (Partition by deaths.location order by deaths.location, deaths.date) as rollingcountpeoplevaccinated
from dbo.CovidDeaths deaths
join dbo.CovidVaccinations Vac
on deaths.location= vac.location
and deaths.date= vac.date
WHERE deaths.continent is not null

Select *, (Rollingcountpeoplevaccinated/population) * 100 from #percentpopulationvaccinated


--Creating view to store data for later visualizations

Create view percentpopulationvaccinated as
Select deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations
, SUM(CONVERT(FLOAT,vac.new_vaccinations)) OVER (Partition by deaths.location order by deaths.location, deaths.date) as rollingcountpeoplevaccinated
from dbo.CovidDeaths deaths
join dbo.CovidVaccinations Vac
on deaths.location= vac.location
and deaths.date= vac.date
WHERE deaths.continent is not null


select * from percentpopulationvaccinated
