--Explore the dataset

SELECT *
FROM CovidDeaths$
--WHERE continent IS NOT NULL
ORDER BY 3,4

SELECT *
FROM CovidVaccinations$
ORDER BY 3,4

-- Determine the spacific data you will be using from the large dataset

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths$
ORDER BY 1,2

-- Total Cases vs Total Deaths
-- Shows chances of dying if you are infected with covid in your country

SELECT location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 AS Death_Percentage
FROM CovidDeaths$
ORDER BY 1,2

-- Further Data exploration

SELECT location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 AS Death_Percentage
FROM CovidDeaths$
WHERE location LIKE 'Canada'
ORDER BY 1,2 

-- Total Cases vs Population
-- Shows percentage of the population infected with covid

SELECT location, date, population, total_cases, (total_cases / population)*100 AS Covid_Infection_Rate
FROM CovidDeaths$
WHERE location LIKE 'Canada'
ORDER BY 1,2

-- Countries with the highest Infection Rate vs Population

SELECT location, population, MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases / population))*100 AS Population_Percent_Infected
FROM CovidDeaths$
--WHERE location LIKE 'Canada'
GROUP BY location, population
ORDER BY Population_Percent_Infected DESC

-- Countries with highest Death Count vs Population

SELECT location, MAX(total_deaths) AS Total_Death_Count
FROM CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Total_Death_Count DESC

-- Continents with highest Death Count vs Population

SELECT continent, MAX(total_deaths) AS Total_Death_Count
FROM CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_Death_Count DESC

-- Alternate Method

SELECT location, MAX(total_deaths) AS Total_Death_Count
FROM CovidDeaths$
WHERE continent IS NULL
GROUP BY location
ORDER BY Total_Death_Count DESC

-- Continents with the highest Infection Rate vs Population

--SELECT continent, population, MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases / population))*100 AS Population_Percent_Infected
--FROM CovidDeaths$
--WHERE location LIKE 'Canada'
--GROUP BY continent, population
--ORDER BY Population_Percent_Infected DESC

--Global Numbers

SELECT date, SUM(new_cases) AS Total_Cases, SUM(new_deaths) AS Total_Deaths, SUM(new_deaths)/SUM(new_cases)*100 AS Death_Percentage
FROM CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

-- Overall Numbers Across the World

SELECT SUM(new_cases) AS Total_Cases, SUM(new_deaths) AS Total_Deaths, SUM(new_deaths)/SUM(new_cases)*100 AS Death_Percentage
FROM CovidDeaths$
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2

-- Covid Vaccinations Table

SELECT *
FROM CovidVaccinations$
ORDER BY 3,4

--JOIN

SELECT *
FROM CovidDeaths$ AS cD
JOIN CovidDeaths$ AS cV
	ON cD.location = cV.location 
	AND cD.date = cV.date

-- Total Population vs Vaccinations

SELECT cD.continent, cD.location, cD.date, cd.population, cV.new_vaccinations
FROM CovidDeaths$ AS cD
JOIN CovidDeaths$ AS cV
	ON cD.location = cV.location 
	AND cD.date = cV.date
WHERE cD.continent IS NOT NULL
ORDER BY 2,3

-- Total Population vs Vaccinations (ADVANCED)
-- Using CTE's

WITH Pop_vs_Vac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT cD.continent, cD.location, cD.date, cd.population, cV.new_vaccinations
, SUM(cV.new_vaccinations) OVER (PARTITION BY cD.location ORDER BY cD.location, cD.date) AS RollingPeopleVaccinated
FROM CovidDeaths$ AS cD
JOIN CovidDeaths$ AS cV
	ON cD.location = cV.location 
	AND cD.date = cV.date
WHERE cD.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated / population)*100 AS PercentPopulationVaccinated
FROM Pop_vs_Vac

-- Total Population vs Vaccinations (ADVANCED)
--Using TEMP Tables

DROP TABLE IF EXISTS #PercentPopulationVaccinated 
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT cD.continent, cD.location, cD.date, cd.population, cV.new_vaccinations
, SUM(cV.new_vaccinations) OVER (PARTITION BY cD.location ORDER BY cD.location, cD.date) AS RollingPeopleVaccinated
FROM CovidDeaths$ AS cD
JOIN CovidDeaths$ AS cV
	ON cD.location = cV.location 
	AND cD.date = cV.date
WHERE cD.continent IS NOT NULL
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated / population)*100 AS PercentPopulationVaccinated
FROM #PercentPopulationVaccinated

-- CREATE VIEWS TO STORE FOR LATER VISUALIZATIONS

CREATE VIEW PercentPopulationVaccinated AS
SELECT cD.continent, cD.location, cD.date, cd.population, cV.new_vaccinations
, SUM(cV.new_vaccinations) OVER (PARTITION BY cD.location ORDER BY cD.location, cD.date) AS RollingPeopleVaccinated
FROM CovidDeaths$ AS cD
JOIN CovidDeaths$ AS cV
	ON cD.location = cV.location 
	AND cD.date = cV.date
WHERE cD.continent IS NOT NULL
--ORDER BY 2,3

CREATE VIEW CovidDeaths AS
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths$
--ORDER BY 1,2

CREATE VIEW DeathPercentage AS
SELECT location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 AS Death_Percentage
FROM CovidDeaths$
--ORDER BY 1,2

CREATE VIEW CovidInfectionRate AS
SELECT location, date, population, total_cases, (total_cases / population)*100 AS Covid_Infection_Rate
FROM CovidDeaths$
--WHERE location LIKE 'Canada'
--ORDER BY 1,2

CREATE VIEW PopulationPercentInfected AS
SELECT location, population, MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases / population))*100 AS Population_Percent_Infected
FROM CovidDeaths$
--WHERE location LIKE 'Canada'
GROUP BY location, population
--ORDER BY Population_Percent_Infected DESC

CREATE VIEW CountryTotalDeathCount AS
SELECT location, MAX(total_deaths) AS Total_Death_Count
FROM CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY location
--ORDER BY Total_Death_Count DESC

CREATE VIEW Population_vs_NewVaccinations AS
SELECT cD.continent, cD.location, cD.date, cd.population, cV.new_vaccinations
FROM CovidDeaths$ AS cD
JOIN CovidDeaths$ AS cV
	ON cD.location = cV.location 
	AND cD.date = cV.date
WHERE cD.continent IS NOT NULL
--ORDER BY 2,3