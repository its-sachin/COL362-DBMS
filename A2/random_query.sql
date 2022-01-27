SELECT constructors.constructorId, name, count
FROM (
    SELECT result1.constructorId, count(result1.constructorId) AS count, RANK() OVER (ORDER BY count(result1.constructorId) desc) rank
    FROM results AS result1, results AS result2, races
    WHERE races.raceId = result1.raceId AND result1.raceId = result2.raceId AND result1.positionOrder = 1 AND result2.positionOrder = 2 
        AND result1.constructorId = result2.constructorId AND races.year >= 2014
    GROUP BY result1.constructorId
) Temp, constructors
WHERE rank = 1 AND constructors.constructorId = Temp.constructorId
ORDER BY name asc, constructorId asc;