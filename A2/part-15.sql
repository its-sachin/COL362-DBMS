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

