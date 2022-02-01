--15--
select name as playernames, sum as goals
from(
    select playerid, sum(goals), rank() over (order by sum(goals) desc) rank
    from (
        select distinct g2.gameid
        from games as g1, games as g2, teams
        where g1.hometeamid != g2.hometeamid and g1.awayteamid = g2.awayteamid
             and g1.hometeamid = teams.teamid and teams.name = 'Valencia'
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
        select distinct g2.gameid
        from games as g1, games as g2, teams
        where g1.hometeamid != g2.hometeamid and g1.awayteamid = g2.awayteamid and g1.hometeamid = teams.teamid and teams.name = 'Everton'
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
        select distinct g2.gameid
        from games as g1, games as g2, teams
        where g1.hometeamid != g2.hometeamid and g1.awayteamid = g2.awayteamid and 
            g1.hometeamid = teams.teamid and teams.name = 'AC Milan' and g1.year = 2016 and g2.year = 2016
    )temp, appearances
    where temp.gameid = appearances.gameid 
    group by playerid
) temp, players
where players.playerid = temp.playerid and rank = 1
order by shotscount desc, playernames asc;

