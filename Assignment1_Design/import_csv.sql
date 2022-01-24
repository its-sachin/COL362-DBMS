COPY drivers(driverId,driverRef,forename,surname,nationality)
FROM '/home/mrstark/Desktop/COL362/A1/Assignment1_Design/drivers.csv'
DELIMITER ',' 
CSV HEADER;

COPY circuits(circuitId,circuitRef,name,location,country)
FROM '/home/mrstark/Desktop/COL362/A1/Assignment1_Design/circuits.csv'
DELIMITER ',' 
CSV HEADER;

COPY constructors(constructorId,constructorRef,name,nationality)
FROM '/home/mrstark/Desktop/COL362/A1/Assignment1_Design/constructors.csv'
DELIMITER ',' 
CSV HEADER;

COPY status(statusId,status)
FROM '/home/mrstark/Desktop/COL362/A1/Assignment1_Design/status.csv'
DELIMITER ',' 
CSV HEADER;

COPY races(raceId,year,round,circuitId,name)
FROM '/home/mrstark/Desktop/COL362/A1/Assignment1_Design/races.csv'
DELIMITER ',' 
CSV HEADER;

COPY pitStops(raceId,driverId,stop,lap,milliseconds)
FROM '/home/mrstark/Desktop/COL362/A1/Assignment1_Design/pit_stops.csv'
DELIMITER ',' 
CSV HEADER;

COPY lapTimes(raceId,driverId,lap,position,milliseconds)
FROM '/home/mrstark/Desktop/COL362/A1/Assignment1_Design/lap_times.csv'
DELIMITER ',' 
CSV HEADER;

COPY qualifying(qualifyId,raceId,driverId,constructorId,position)
FROM '/home/mrstark/Desktop/COL362/A1/Assignment1_Design/qualifying.csv'
DELIMITER ',' 
CSV HEADER;

COPY results(resultId,raceId,driverId,constructorId,grid,positionOrder,points,laps,milliseconds,fastestLap,rank,statusId)
FROM '/home/mrstark/Desktop/COL362/A1/Assignment1_Design/results.csv'
DELIMITER ',' 
CSV HEADER;

COPY constructorResults(constructorResultsId,raceId,constructorId,points)
FROM '/home/mrstark/Desktop/COL362/A1/Assignment1_Design/constructor_results.csv'
DELIMITER ',' 
CSV HEADER;

