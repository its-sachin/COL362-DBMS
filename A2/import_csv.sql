-- COPY train_info(train_no,train_name,distance,source_station_name,departure_time,day_of_departure,destination_station_name,arrival_time,day_of_arrival)
-- -- FROM 'E:\Semesters\Sem6\COL362\Assignments\A2\train_info.csv'
-- FROM '/home/mrstark/Desktop/COL362/A2/train_info.csv'
-- DELIMITER ',' 
-- CSV HEADER;

COPY train_info(train_no,train_name,distance,source_station_name,departure_time,day_of_departure,destination_station_name,arrival_time,day_of_arrival)
-- FROM 'E:\Semesters\Sem6\COL362\Assignments\A2\train_info.csv'
FROM '/home/mrstark/Desktop/COL362/A2/train_small.csv'
DELIMITER ',' 
CSV HEADER;

-- COPY teams(teamid,name)
-- FROM '/home/mrstark/Desktop/COL362/A2/processed_dataset/teams.csv'
-- DELIMITER ',' 
-- CSV HEADER;

-- COPY players(playerid,name)
-- FROM '/home/mrstark/Desktop/COL362/A2/processed_dataset/players.csv'
-- DELIMITER ',' 
-- CSV HEADER;

-- COPY leagues(leagueid,name)
-- FROM '/home/mrstark/Desktop/COL362/A2/processed_dataset/leagues.csv'
-- DELIMITER ',' 
-- CSV HEADER;

-- COPY games(gameid,leagueid,hometeamid,awayteamid,year,homegoals,awaygoals)
-- FROM '/home/mrstark/Desktop/COL362/A2/processed_dataset/games.csv'
-- DELIMITER ',' 
-- CSV HEADER;

-- COPY appearances(gameid,playerid,leagueid,goals,owngoals,assists,keypasses,shots)
-- FROM '/home/mrstark/Desktop/COL362/A2/processed_dataset/appearances.csv'
-- DELIMITER ',' 
-- CSV HEADER;