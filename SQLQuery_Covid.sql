Select Location, date, total_cases, new_cases, total_deaths, population
From CovidProject..CovidDeath
Where continent is not null
order by 1,2

--Total Cases vs Total Deaths
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPCT
From CovidProject..CovidDeath
Where continent is not null
order by 1,2

Create View DeathRate as
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPCT
From CovidProject..CovidDeath
Where continent is not null


--Total Cases vs Population(percentage of people who got covid)
Select Location, date, total_cases, Population, (total_cases/Population)*100 as InfectionPCT
From CovidProject..CovidDeath
Where continent is not null
order by 1,2

Create View PopulationInfected as
Select Location, date, total_cases, Population, (total_cases/Population)*100 as InfectionPCT
From CovidProject..CovidDeath
Where continent is not null



--Countries infection rate compared to population
Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as InfectionPCT
From CovidProject..CovidDeath
Where continent is not null
Group by Location, Population
order by InfectionPCT desc

Create View CountryInfectionRate as
Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as InfectionPCT
From CovidProject..CovidDeath
Where continent is not null
Group by Location, Population

--Highest death per population(Continent)
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidProject..CovidDeath
Where continent is null
Group by Location
order by TotalDeathCount desc

--Highest death count(country) and deathpct
Select Location, SUM(new_cases) as total_cases, MAX(cast(total_deaths as int)) as TotalDeathCount, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPCT
From CovidProject..CovidDeath
Where continent is not null
Group by Location 
order by TotalDeathCount desc

Create View CountryDeathCount as
Select Location, SUM(new_cases) as total_cases, MAX(cast(total_deaths as int)) as TotalDeathCount, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPCT
From CovidProject..CovidDeath
Where continent is not null
Group by Location 

--Total cases, Deaths and Death pct
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPCT
From CovidProject..CovidDeath
where continent is not null
order by 1,2

--Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingCountVaccinations
From CovidProject..CovidDeath dea
Join CovidProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

Create View PopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingCountVaccinations
From CovidProject..CovidDeath dea
Join CovidProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null


--Median age to infection rate 
Select dea.Location, MAX(vac.median_age) as median_age, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as InfectionPCT
From CovidProject..CovidDeath dea
Join CovidProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Group by dea.Location, vac.median_age
order by median_age desc


Create View MedianAgeInfectionRate as
Select dea.Location, MAX(vac.median_age) as median_age, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as InfectionPCT
From CovidProject..CovidDeath dea
Join CovidProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Group by dea.Location, vac.median_age

--Median age to death rate
Select dea.Location, MAX(vac.median_age) as median_age, MAX(total_cases) as HighestInfectionCount, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPCT
From CovidProject..CovidDeath dea
Join CovidProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Group by dea.Location, vac.median_age
order by median_age desc

Create View MedianAgeDeathRate as
Select dea.Location, MAX(vac.median_age) as median_age, MAX(total_cases) as HighestInfectionCount, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPCT
From CovidProject..CovidDeath dea
Join CovidProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Group by dea.Location, vac.median_age

--smoker vs death rate
Select dea.Location, Max(cast(male_smokers as real) + cast(female_smokers as real))/2 As SmokerPCT, MAX(total_cases) as HighestInfectionCount, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPCT
From CovidProject..CovidDeath dea
Join CovidProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Group by dea.Location
order by SmokerPCT desc

Create View SmokerDeathRateCovid as
Select dea.Location, Max(cast(male_smokers as real) + cast(female_smokers as real))/2 As SmokerPCT, MAX(total_cases) as HighestInfectionCount, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPCT
From CovidProject..CovidDeath dea
Join CovidProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Group by dea.Location


--Diabetes vs death rate
Select dea.Location, vac.diabetes_prevalence, MAX(total_cases) as HighestInfectionCount, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPCT
From CovidProject..CovidDeath dea
Join CovidProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Group by dea.Location, vac.diabetes_prevalence
order by diabetes_prevalence desc

Create View DiabetesDeathRateCovid as
Select dea.Location, vac.diabetes_prevalence, MAX(total_cases) as HighestInfectionCount, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPCT
From CovidProject..CovidDeath dea
Join CovidProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Group by dea.Location, vac.diabetes_prevalence

--poverty vs death rate
Select dea.Location, vac.extreme_poverty, MAX(total_cases) as HighestInfectionCount, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPCT
From CovidProject..CovidDeath dea
Join CovidProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Group by dea.Location, vac.extreme_poverty
order by DeathPCT desc

Create View PovertyDeathRate as
Select dea.Location, vac.extreme_poverty, MAX(total_cases) as HighestInfectionCount, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPCT
From CovidProject..CovidDeath dea
Join CovidProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Group by dea.Location, vac.extreme_poverty

--poverty vs infection rate
Select dea.Location, vac.extreme_poverty, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as InfectionPCT
From CovidProject..CovidDeath dea
Join CovidProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Group by dea.Location, vac.extreme_poverty
order by InfectionPCT desc

Create View PovertyInfectionRate as
Select dea.Location, vac.extreme_poverty, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as InfectionPCT
From CovidProject..CovidDeath dea
Join CovidProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Group by dea.Location, vac.extreme_poverty

