--1--
with recursive path (dest,len) as (

    select destination_station_name, 1
    from train_info
    where train_no = 97131 and source_station_name = 'KURLA' 

    union

    select distinct destination_station_name, len+1
    from train_info, path
    where source_station_name = dest and len < 3
)

select distinct dest as destination_station_name
from path
order by destination_station_name asc;

--2--
with recursive path (dest, day, len) as (
    select destination_station_name, day_of_arrival, 1
    from train_info
    where train_no = 97131 and source_station_name = 'KURLA' and day_of_arrival = day_of_departure

    union

    select distinct destination_station_name, day, len+1
    from train_info, path
    where source_station_name = dest and day_of_arrival = day_of_departure and day_of_arrival = day and len < 3
)

select distinct dest as destination_station_name
from path
order by destination_station_name asc;

--3--
with recursive path (dest, day, distance, len) as (
    select destination_station_name, day_of_arrival, distance, 1
    from train_info
    where source_station_name = 'DADAR' and day_of_arrival = day_of_departure

    union

    select distinct destination_station_name, day, path.distance + train_info.distance, len+1
    from train_info, path
    where source_station_name = dest and day_of_arrival = day_of_departure and day_of_arrival = day and len < 3
)

select distinct dest as destination_station_name, distance, day from path
where dest != 'DADAR'
order by dest asc, distance asc, day asc;

--4--
with recursive path (dest,arr_time,arr_day,len) as (

    with dayEnum as (
        select *
        from (VALUES 
            ('Monday',1),
            ('Tuesday',2),
            ('Wednesday',3),
            ('Thursday',4),
            ('Friday',5),
            ('Saturday',6),
            ('Sunday',7)
        ) t1 (day, num)
    )

    select destination_station_name,arrival_time,day_of_arrival, 1
    from train_info
    where source_station_name = 'DADAR' and (
        (day_of_arrival = day_of_departure and departure_time <= arrival_time) or
        ((select num from dayEnum where day = day_of_departure) < (select num from dayEnum where day = day_of_arrival))
    )

    union

    select destination_station_name, arrival_time, day_of_arrival, len+1
    from train_info, path
    where source_station_name = dest and len < 3 and 
    (
        (day_of_arrival = day_of_departure and departure_time <= arrival_time) or
        ((select num from dayEnum where day = day_of_departure) < (select num from dayEnum where day = day_of_arrival))
    ) 
    and 
    (
        (day_of_departure = arr_day and  arr_time <= departure_time) or
        ((select num from dayEnum where day = arr_day) < (select num from dayEnum where day = day_of_departure))
    )
)

select distinct dest as destination_station_name from path
where dest != 'DADAR'
order by dest asc;

--5--
with recursive allpath (src, dest, path ,trains, len) as (

    select source_station_name, destination_station_name, ARRAY[source_station_name,destination_station_name], ARRAY[train_no], 1
    from train_info
    where source_station_name = 'CST-MUMBAI' 

    union

    select distinct src, destination_station_name, path || destination_station_name, trains || train_no, len+1
    from train_info, allpath
    where source_station_name = dest and len < 3 and not (destination_station_name = ANY(path))
)

select count(*) from allpath where src = 'CST-MUMBAI'  and dest = 'VASHI';

--6--
with recursive allpath (src, dest, path, dist, len) as (

    select src, dest, path, dist, len 
    from (
        select source_station_name as src, destination_station_name as dest, ARRAY[source_station_name,destination_station_name] as path, 
            distance as dist, 1 as len, rank() over (partition by source_station_name, destination_station_name order by distance asc) rank
        from train_info
    ) t
    where rank = 1

    union

    select src, dest, path, dist, len
    from (
        select src, dest, path, dist, len, rank() over (partition by src, dest order by dist asc) rank
        from (
            select src, destination_station_name as dest, path || destination_station_name as path, distance + dist as dist, len+1 as len
            from train_info, allpath
            where source_station_name = dest and len < 6 and not (destination_station_name = ANY(path))
        ) t
    ) t
    where rank = 1

)

select distinct destination_station_name, source_station_name, distance
from (
    select dest destination_station_name , src as source_station_name, dist as distance, rank() over (partition by src, dest order by dist asc)
    from allpath
) temp 
where rank = 1
order by destination_station_name asc, source_station_name asc, distance asc;

--7--
with p1 as (
    select distinct source_station_name, destination_station_name
    from train_info
    where source_station_name != destination_station_name
), 
p2 as (
    select * from p1
    union 
    select distinct p1.source_station_name, train_info.destination_station_name 
    from p1, train_info
    where p1.destination_station_name = train_info.source_station_name and p1.source_station_name != train_info.destination_station_name
),
p3 as (
    select * from p2
    union 
    select distinct p2.source_station_name, train_info.destination_station_name 
    from p2, train_info
    where p2.destination_station_name = train_info.source_station_name and p2.source_station_name != train_info.destination_station_name
),
p4 as (
    select * from p3
    union 
    select distinct p3.source_station_name, train_info.destination_station_name 
    from p3, train_info
    where p3.destination_station_name = train_info.source_station_name and p3.source_station_name != train_info.destination_station_name
)

select distinct * from p4
order by source_station_name asc, destination_station_name asc;

--8--
with recursive reachable(src, dest, path, day) as(
    select distinct source_station_name, destination_station_name, ARRAY[source_station_name, destination_station_name], day_of_arrival
    from train_info
    where source_station_name = 'SHIVAJINAGAR' and destination_station_name != 'SHIVAJINAGAR' and day_of_arrival = day_of_departure

    union

    select distinct src, destination_station_name, path || destination_station_name, day
    from train_info, reachable
    where source_station_name = dest and day_of_arrival = day_of_departure and day_of_departure = day and not (destination_station_name = ANY(path))
)

select distinct dest as destination_station_name, day from reachable
order by dest asc, day asc;

--9--
with recursive reachable(src, dest, path, day, dist) as(
    select distinct source_station_name, destination_station_name, ARRAY[source_station_name, destination_station_name], day_of_arrival, distance
    from train_info
    where source_station_name = 'LONAVLA' and destination_station_name != 'LONAVLA' and day_of_arrival = day_of_departure

    union

    select distinct src, destination_station_name, path || destination_station_name, day, dist + distance
    from train_info, reachable
    where source_station_name = dest and day_of_arrival = day_of_departure and day_of_departure = day and not (destination_station_name = ANY(path))
)

select distinct dist as distance, dest as destination, day
from ( 
    select src, dest, dist, day, rank() over (partition by src, dest order by dist asc) rank
    from reachable 
) t 
where rank = 1
order by distance asc, destination asc, day asc;

--10--
with recursive reachable(src, dest, path, dist, ischain) as(
    select distinct source_station_name, destination_station_name, ARRAY[destination_station_name], distance, (source_station_name = destination_station_name)
    from train_info

    union

    select distinct src, destination_station_name, path || destination_station_name, dist + distance, (src = destination_station_name)
    from train_info, reachable
    where source_station_name = dest and (not ischain) and not (destination_station_name = ANY(path))
)

select distinct src as source_station_name, max(dist) as distance
from reachable
where ischain = true
group by src
order by source_station_name asc, distance asc;


--11--
with recursive reachable(src, dest, len) as(
    select distinct source_station_name, destination_station_name, 1
    from train_info
    where source_station_name != destination_station_name

    union

    select distinct src, destination_station_name, len + 1
    from train_info, reachable
    where source_station_name = dest and len < 2 and src != destination_station_name
),

allstation as(
    select distinct source_station_name as station
    from train_info

    union

    select distinct destination_station_name as station
    from train_info
)

select distinct src as source_station_name from (
    select src , count(distinct dest)
    from reachable
    group by src
)temp
where count+1 = (select count(*) from allstation)
order by source_station_name asc;

--12--
select distinct name as teamnames
from (
    select distinct awayteamid 
    from games, teams
    where hometeamid = teamid and name = 'Arsenal'
) temp, games, teams
where temp.awayteamid = games.awayteamid and games.hometeamid = teams.teamid and name != 'Arsenal'
order by teamnames asc;

--13--
with total_goal as(
    select id, sum(sum) as goals
    from (
        select hometeamid as id, sum(homegoals)
        from games
        group by hometeamid
        union all
        select awayteamid as id, sum(awaygoals)
        from games
        group by awayteamid
        order by id
    ) temp
    group by id
    order by id
) 

select name as teamnames, goals, year
from (
    select name, min(year) as year, goals, rank() over (order by min(year) asc, goals desc) rank
    from (
        select distinct awayteamid 
        from games, teams
        where hometeamid = teamid and name = 'Arsenal'
    ) temp, games, teams, total_goal
    where temp.awayteamid = games.awayteamid and games.hometeamid = teams.teamid and id = teams.teamid and name != 'Arsenal'
    group by name, goals
) temp
where rank = 1
order by goals desc, year asc, teamnames asc;

--14--
select name as teamnames, homegoals - awaygoals as goaldiff
from (
    select distinct g2.hometeamid
    from games as g1, games as g2, teams
    where g1.hometeamid != g2.hometeamid and g1.awayteamid = g2.awayteamid and g1.hometeamid = teams.teamid and teams.name = 'Leicester'
) temp, games, teams
where temp.hometeamid = games.hometeamid and year = 2015 and homegoals - awaygoals > 3 and teams.teamid = temp.hometeamid
order by goaldiff asc, teamnames asc;

--15--
select name as playernames, sum as goals
from(
    select playerid, sum(goals), rank() over (order by sum(goals) desc) rank
    from (
        select distinct games.gameid
        from (
            select distinct g2.hometeamid as id
            from games as g1, games as g2, teams
            where g1.hometeamid != g2.hometeamid and g1.awayteamid = g2.awayteamid and g1.hometeamid = teams.teamid and teams.name = 'Valencia'
        ) temp, games, appearances
        where id = hometeamid and games.gameid = appearances.gameid
    )temp, appearances
    where temp.gameid = appearances.gameid 
    group by playerid
) temp, players
where players.playerid = temp.playerid and rank = 1
order by goals desc, playernames asc;

--16--
select name as playernames, sum as assitscount
from(
    select playerid, sum(assists), rank() over (order by sum(assists) desc) rank
    from (
        select distinct games.gameid
        from (
            select distinct g2.hometeamid as id
            from games as g1, games as g2, teams
            where g1.hometeamid != g2.hometeamid and g1.awayteamid = g2.awayteamid and g1.hometeamid = teams.teamid and teams.name = 'Everton'
        ) temp, games, appearances
        where id = hometeamid and games.gameid = appearances.gameid
    )temp, appearances
    where temp.gameid = appearances.gameid 
    group by playerid
) temp, players
where players.playerid = temp.playerid and rank = 1
order by assitscount desc, playernames asc;

--17--
select name as playernames, sum as shotscount
from(
    select playerid, sum(shots), rank() over (order by sum(shots) desc) rank
    from (
        select distinct games.gameid
        from (
            select distinct g2.hometeamid as id
            from games as g1, games as g2, teams
            where g1.hometeamid != g2.hometeamid and g1.awayteamid = g2.awayteamid and g1.hometeamid = teams.teamid and teams.name = 'AC Milan'
        ) temp, games, appearances
        where id = hometeamid and games.gameid = appearances.gameid and year = 2016
    )temp, appearances
    where temp.gameid = appearances.gameid 
    group by playerid
) temp, players
where players.playerid = temp.playerid and rank = 1
order by shotscount desc, playernames asc;

--18--
select distinct name as teamname, year
from(
    select id, sum(awaygoals), year
    from(
        select distinct g2.hometeamid as id
        from games as g1, games as g2, teams
        where g1.hometeamid != g2.hometeamid and  g1.awayteamid = g2.awayteamid and g1.hometeamid = teams.teamid and teams.name = 'AC Milan'
    ) temp, games
    where id = awayteamid and year = 2020
    group by id, year
) temp, teams
where sum = 0 and teamid = id
order by teamname asc
limit 5;

--19--
with leagueWinner as (
    select leagueid, id , goals
    from (
        select leagueid, id, sum(goals) as goals, rank() over ( partition by leagueid order by sum(goals) desc) rank
        from (
            select leagueid, hometeamid as id, sum(homegoals) as goals
            from games
            where year = 2019
            group by leagueid, hometeamid
            union all
            select leagueid, awayteamid as id, sum(awaygoals) as goals
            from games
            where year = 2019
            group by leagueid, awayteamid
        ) temp 
        group by leagueid, id
        order by rank, leagueid
    ) temp
    where rank = 1
)
select leagues.name as leaguename, players.name as playernames, pgoals as playertopscore, teams.name as teamname, tgoals as  teamtopscore
from (
    select lid, winid, tgoals, playerid, pgoals
    from (
        select lid, winid, tgoals, playerid, sum(appearances.goals) as pgoals, rank() over (
                partition by lid, winid, tgoals order by sum(appearances.goals) desc
            ) rank
        from (

            select distinct lid, winid, temp.goals as tgoals, gameid
            from (
                -- select lid, winid, temp.goals as tgoals, playerid, 
                select distinct leagueWinner.leagueid as lid, id as winid, goals, g2.hometeamid as comid
                from games as g1, games as g2, leagueWinner
                where g1.hometeamid != g2.hometeamid and  g1.awayteamid = g2.awayteamid and g1.hometeamid = id
            )temp, games
            where comid = hometeamid  and year = 2019

        ) temp, appearances
        where appearances.gameid = temp.gameid
        group by lid, winid, tgoals, playerid
    ) temp
    where rank = 1
) temp, leagues, players, teams
where lid = leagueid and teamid = winid and players.playerid = temp.playerid
order by playertopscore desc, teamtopscore desc, playernames asc, leaguename asc, teamname asc;

--20--
with recursive search(src, dest, len, path) as (
    select distinct hometeamid, awayteamid, 1, ARRAY[hometeamid, awayteamid]
    from games where hometeamid != awayteamid

    union

    select distinct src, awayteamid, len+1, path || awayteamid
    from games, search
    where dest = hometeamid and  not (awayteamid = any(path))
)

select max(len) as count from search;

--21--
with recursive search(src, dest, len, path) as (
    with manchUn as(
        select teamid from teams where name = 'Manchester United'
    )

    select distinct hometeamid, awayteamid, 1, ARRAY[hometeamid, awayteamid]
    from games where hometeamid != awayteamid and hometeamid in (select teamid from manchUn)

    union

    select distinct src, awayteamid, len+1, path || awayteamid
    from games, search
    where dest = hometeamid and  not (awayteamid = any(path))
),

manchC as(
    select teamid from teams where name = 'Manchester City'
)

select count(*) from search where dest in (select teamid from manchC);

--22--
with recursive search(src, dest, len, path, league) as (
    select distinct hometeamid, awayteamid, 1, ARRAY[hometeamid, awayteamid], leagueid
    from games where hometeamid != awayteamid

    union

    select distinct src, awayteamid, len+1, path || awayteamid, league
    from games, search
    where dest = hometeamid and league = leagueid and not (awayteamid = any(path)) 
)

select distinct leagues.name as leaguename, t1.name as teamAname, t2.name as teamBname, len as count
from (
    select src, dest, league, len, rank() over (partition by league order by len desc) rank
    from search
)t, leagues, teams as t1, teams as t2
where rank = 1 and leagues.leagueid = league and t1.teamid = src and t2.teamid = dest
order by leaguename asc, count desc, teamAname asc, teamBname asc;
