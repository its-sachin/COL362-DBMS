--1--
SELECT drivers.driverId, forename, surname, nationality, milliseconds as time
FROM drivers, (
    SELECT driverId, milliseconds, RANK() OVER (ORDER BY milliseconds desc) rank
    FROM lapTimes, races, circuits
    WHERE lapTimes.raceId = races.raceId AND races.year = 2017 AND
         races.circuitID = circuits.circuitID AND circuits.country = 'Monaco' 
) Temp
WHERE drivers.driverId = Temp.driverId AND rank = 1
ORDER BY forename asc, surname asc, nationality asc;

--2--
SELECT constructors.name, constructors.constructorId, constructors.nationality, SUM(points) as points
FROM constructors, constructorResults, races
WHERE races.year = 2012 AND races.raceId = constructorResults.raceId AND constructors.constructorId = constructorResults.constructorId
GROUP BY constructors.constructorId, races.year
ORDER BY points desc, constructors.name ASC, constructors.nationality ASC, constructors.constructorId ASC
limit 5;

--3--
SELECT drivers.driverId, forename, surname, spoint as points
FROM(
    SELECT driverId, SUM(points) as spoint,
        RANK () OVER ( 
            ORDER BY SUM(points) desc
        ) rank
    FROM results, races
    WHERE races.raceId = results.raceId AND year > 2000 AND year < 2021
    GROUP BY driverId
) Temp, drivers
WHERE drivers.driverId = Temp.driverId AND rank = 1
ORDER BY forename ASC, surname ASC, driverId ASC;

--4--
SELECT constructors.constructorId, name, nationality, spoint as points
FROM(
    SELECT constructorId, SUM(points) as spoint,
        RANK () OVER ( 
            ORDER BY SUM(points) desc
        ) rank
    FROM constructorResults, races
    WHERE races.raceId = constructorResults.raceId AND year > 2009 AND year < 2021
    GROUP BY constructorId
) Temp, constructors
WHERE constructors.constructorId = Temp.constructorId AND rank = 1
ORDER BY name ASC, nationality ASC, constructorId ASC;

--5--
SELECT drivers.driverid, forename, surname, race_wins
FROM (
    SELECT driverId, count(driverId) as race_wins, RANK () OVER ( 
                ORDER BY count(driverId) desc
            ) rank
    FROM results
    WHERE positionOrder = 1
    GROUP BY driverId
) Temp, drivers
WHERE rank = 1 AND drivers.driverId = Temp.driverId
ORDER BY forename asc, surname asc, driverid asc;

--6--
SELECT Temp.constructorId, name, num_wins
FROM (
    SELECT constructorId, COUNT (Temp.constructorId) as num_wins, RANK () OVER ( 
            ORDER BY COUNT (Temp.constructorId) desc
        ) rank
    FROM(
        SELECT constructorId, raceId, SUM(points) as points, RANK () OVER ( 
                PARTITION BY raceId ORDER BY SUM(points) desc
            ) rank
        FROM constructorResults 
        GROUP BY constructorId, raceId
    ) Temp
    WHERE rank = 1
    GROUP BY constructorId
) Temp, constructors
WHERE Temp.constructorId = constructors.constructorId AND rank = 1
ORDER BY name asc, constructorId asc;

--7--
SELECT drivers.driverId, forename, surname, points
FROM(
    SELECT driverId, SUM(points) as points, RANK () OVER ( 
            ORDER BY SUM(points) desc
        ) rank
    FROM results
    WHERE driverId NOT IN (
        SELECT DISTINCT driverId
        FROM (
            SELECT year, driverId, spoint, MAX(spoint) OVER (PARTITION BY year) as mpoint
            FROM (
                SELECT year, driverId, SUM(points) as spoint
                FROM results, races
                WHERE results.raceId = races.raceId
                GROUP BY year, driverId
            ) Temp
        ) Temp
        WHERE Temp.spoint = mpoint
    )
    GROUP BY driverId
    ORDER BY rank
    limit 3
) Temp, drivers
WHERE drivers.driverId = Temp.driverId
ORDER BY points desc, forename asc, surname asc, driverId asc;

--8--
WITH countryCount AS (
    SELECT driverId, count(driverId) as num_countries
    FROM (
        SELECT DISTINCT driverId, country
        FROM results, races, circuits
        WHERE positionOrder = 1 AND races.raceId = results.raceId AND races.circuitId = circuits.circuitId
    ) Temp
    GROUP BY driverId
)
SELECT drivers.driverId, forename, surname, num_countries
FROM countryCount, drivers
WHERE num_countries = (
    SELECT MAX(num_countries)
    FROM countryCount
) AND drivers.driverId = countryCount.driverId
ORDER BY forename asc, surname asc, drivers.driverId asc;

--9--
SELECT drivers.driverId, forename, surname, num_wins
FROM(
    SELECT driverId, count(driverId) as num_wins, RANK () OVER ( 
        ORDER BY count(driverId) desc
    ) rank
    FROM results
    WHERE positionOrder = 1 AND grid = 1
    GROUP BY driverId
) Temp, drivers
WHERE drivers.driverId = Temp.driverId
ORDER BY num_wins desc, forename asc, surname asc, drivers.driverId asc
limit 3;

--10--
WITH pitCount AS (
    SELECT results.raceId, results.driverId, count(stop) as stops
    FROM results, pitStops
    WHERE results.raceId = pitStops.raceId AND results.driverId = pitStops.driverId AND positionOrder = 1
    GROUP BY results.raceId, results.driverId
)
SELECT pitCount.raceId, stops as num_stops, pitCount.driverId, forename, surname, circuits.circuitId, circuits.name
FROM pitCount, drivers, races, circuits
WHERE stops = (
    SELECT MAX(stops)
    FROM pitCount
) AND drivers.driverId = pitCount.driverId AND races.raceId = pitCount.raceId AND races.circuitId = circuits.circuitId
ORDER BY forename asc, surname asc, circuits.name asc, circuitId asc, driverId asc;

--11--
SELECT races.raceId, circuits.name, location, num_collisions
FROM (
    SELECT raceId, count(raceId) as num_collisions, RANK () OVER ( 
                ORDER BY count(raceId) desc
            ) rank
    FROM results, status
    WHERE status.statusId = results.statusId AND status.status = 'Collision'
    GROUP BY raceId
) Temp, races, circuits
WHERE rank = 1 AND Temp.raceId = races.raceId AND races.circuitId = circuits.circuitId
ORDER BY name asc, location asc, raceId asc;

--12--
SELECT drivers.driverId, forename, surname, count 
FROM (
    SELECT driverId, count(driverId) as count, RANK () OVER ( 
            ORDER BY count(driverId) desc
        ) rank
    FROM (
        SELECT results.raceId, results.driverId, positionOrder, lapTimes.milliseconds as fastestLap, MIN(lapTimes.milliseconds) OVER (PARTITION BY results.raceId) as fastestInRace
        FROM results, lapTimes
        WHERE fastestLap != -1 AND results.raceId = lapTimes.raceId AND results.driverId = lapTimes.driverId AND results.fastestLap = lapTimes.lap 
    ) Temp
    WHERE Temp.fastestLap = fastestInRace AND positionOrder = 1
    GROUP BY driverId
) Temp, drivers
WHERE rank = 1 AND drivers.driverId = Temp.driverId
ORDER BY forename asc, surname asc, driverId asc;

--13--
WITH yearWiseRank AS (
    SELECT year, constructorId, SUM(points) as points, RANK() OVER(
        PARTITION BY year ORDER BY SUM(points) desc
    ) rank
    FROM constructorResults, races
    WHERE races.raceId = constructorResults.raceId
    GROUP BY year, constructorId
)
SELECT year, point_diff, constructor1_id, constructors1.name as constructor1_name, constructor2_id, constructors2.name as constructor2_name
FROM (
    SELECT rank1.year, rank1.constructorId as constructor1_id, rank2.constructorId as constructor2_id, (rank1.points - rank2.points) as point_diff, RANK() OVER (
        ORDER BY (rank1.points - rank2.points) desc
    )
    FROM yearWiseRank as rank1, yearWiseRank as rank2
    WHERE rank1.year = rank2.year AND rank1.rank = 1 AND rank2.rank = 2
) Temp, constructors as constructors1, constructors as constructors2
WHERE rank = 1 AND constructor1_id = constructors1.constructorId AND constructor2_id = constructors2.constructorId
ORDER BY constructor1_name asc, constructor2_name asc, constructor1_id asc, constructor2_id asc;

--14--
SELECT drivers.driverId, forename, surname, circuits.circuitId, country, grid as pos
FROM (
    SELECT driverId, circuitID, grid, RANK() OVER (ORDER BY grid desc) rank
    FROM results, races
    WHERE races.raceId = results.raceId AND races.year = 2018 AND positionOrder = 1
) Temp, drivers, circuits
WHERE rank = 1 AND drivers.driverId = Temp.driverId AND circuits.circuitID = Temp.circuitID
ORDER BY forename desc, surname asc, country asc, driverId asc, circuitID asc;

--15--
SELECT constructors.constructorId, name, num
FROM (
    SELECT constructorId, count(constructorId) AS num, RANK() OVER (ORDER BY count(constructorId) desc) rank
    FROM results, races
    WHERE statusId = 5 AND races.raceId = results.raceId AND year > 1999
    GROUP BY constructorId
) Temp, constructors
WHERE rank = 1 AND constructors.constructorId = Temp.constructorId
ORDER BY name asc, constructorId asc;

--16--
SELECT DISTINCT drivers.driverId, forename, surname
FROM drivers, results, races, circuits
WHERE positionOrder = 1 AND nationality = 'American' AND drivers.driverId = results.driverId
    AND results.raceId = races.raceId AND races.circuitID = circuits.circuitID AND circuits.country = 'USA'
ORDER BY forename asc, surname asc, driverId asc
limit 5;

--17--
SELECT constructors.constructorId, name, count
FROM (
    SELECT result1.constructorId, count(result1.constructorId) AS count, RANK() OVER (ORDER BY count(result1.constructorId) desc) rank
    FROM results AS result1, results AS result2
    WHERE result1.raceId = result2.raceId AND result1.positionOrder = 1 AND result2.positionOrder = 2 AND result1.constructorId = result2.constructorId
    GROUP BY result1.constructorId
) Temp, constructors
WHERE rank = 1 AND constructors.constructorId = Temp.constructorId
ORDER BY name asc, constructorId asc;

-- 18--
SELECT drivers.driverId, forename, surname, num_laps
FROM(
    SELECT driverId, count(driverId) as num_laps, RANK() OVER (ORDER BY count(driverId) desc) rank
    FROM lapTimes
    WHERE position = 1
    GROUP BY driverId
) Temp, drivers
WHERE rank = 1 AND drivers.driverId = Temp.driverId
ORDER BY forename asc, surname asc, driverId asc;

--19--
SELECT drivers.driverid, forename, surname, count
FROM (
    SELECT driverId, count(driverId) as count, RANK () OVER ( 
        ORDER BY count(driverId) desc
    ) rank
    FROM results
    WHERE positionOrder = 1 or positionOrder = 2 or positionOrder = 3
    GROUP BY driverId
) Temp, drivers
WHERE rank = 1 AND drivers.driverId = Temp.driverId
ORDER BY forename asc, surname desc, driverid asc;

--20--
SELECT drivers.driverId, forename, surname, num_champs
FROM (
    SELECT driverId, count(driverId) as num_champs, RANK () OVER ( 
        ORDER BY count(driverId) desc
    ) rank
    FROM (
        SELECT year, driverId, spoint, MAX(spoint) OVER (PARTITION BY year) as mpoint
        FROM (
            SELECT year, driverId, SUM(points) as spoint
            FROM results, races
            WHERE results.raceId = races.raceId
            GROUP BY year, driverId
        ) Temp
    ) Temp
    WHERE Temp.spoint = mpoint
    GROUP BY driverId
) Temp, drivers
WHERE rank <= 5 AND drivers.driverId = Temp.driverId
ORDER BY num_champs desc, forename asc, surname desc, driverId asc;

