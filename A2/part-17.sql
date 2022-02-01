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

