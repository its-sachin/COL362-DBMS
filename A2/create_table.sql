CREATE table IF NOT EXISTS train_info(
    train_no integer,
    train_name text,
    distance integer NOT NULL,
    source_station_name text,
    departure_time  TIME  NOT NULL,
    day_of_departure text,
        
    destination_station_name text,
    arrival_time    TIME NOT NULL,
    day_of_arrival text,
    CONSTRAINT train_info_key PRIMARY KEY (train_no) 
);

-- create table if not EXISTS teams(
--     teamid integer,
--     name text,
--     CONSTRAINT team_key PRIMARY KEY (teamid)
-- );

-- create table if not EXISTS players(
--     playerid integer,
--     name text,
--     CONSTRAINT player_key PRIMARY KEY (playerid)
-- );

-- create table if not EXISTS leagues(
--     leagueid integer,
--     name text,
--     CONSTRAINT league_key PRIMARY KEY (leagueid)
-- );

-- create table if not EXISTS games(
--     gameid integer,
--     leagueid integer,
--     hometeamid integer,
--     awayteamid integer,
--     year integer,
--     homegoals integer,
--     awaygoals integer,
--     CONSTRAINT game_key PRIMARY KEY (gameid),
--     CONSTRAINT league_ref FOREIGN KEY (leagueid) references leagues(leagueid),
--     CONSTRAINT hometeam_ref FOREIGN KEY (hometeamid) references teams(teamid),
--     CONSTRAINT awayteam_ref FOREIGN KEY (awayteamid) references teams(teamid)
-- );
-- create table if not EXISTS appearances(
--     gameid  integer, 
--     playerid  integer, 
--     leagueid  integer, 
--     goals  integer,
--     owngoals  integer,
--     assists  integer, 
--     keypasses  integer, 
--     shots  integer,
--     CONSTRAINT game_ref FOREIGN KEY (gameid) references games(gameid),
--     CONSTRAINT player_ref FOREIGN KEY (playerid) references players(playerid),
--     CONSTRAINT league_ref FOREIGN KEY (leagueid) references leagues(leagueid)
-- );

