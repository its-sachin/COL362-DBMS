EXPLAIN ANALYZE
SELECT driverid, COUNT(driverid) as count
FROM (
    SELECT results.driverId, positionOrder, RANK() OVER (
        PARTITION BY results.raceId ORDER BY lapTimes.milliseconds asc
        ) rank
    FROM results, lapTimes
    WHERE results.fastestLap != -1 AND results.raceId = lapTimes.raceId AND results.driverId = lapTimes.driverId AND results.fastestLap = lapTimes.lap
) Temp
WHERE rank = 1 AND positionOrder = 1
GROUP BY driverid