select name as teamnames, homegoals - awaygoals as goaldiff
from (
select distinct g2.hometeamid
from games as g1, games as g2, teams
where g1.hometeamid != g2.hometeamid and g1.awayteamid = g2.awayteamid and g1.hometeamid = teams.teamid and teams.name = 'Leicester'
) temp, games, teams
where temp.hometeamid = games.hometeamid and year = 2015 and homegoals - awaygoals > 3 and teams.teamid = temp.hometeamid
order by goaldiff asc, teamnames asc;

