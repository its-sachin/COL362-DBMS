select distinct name as teamnames
from (
select distinct awayteamid
from games, teams
where hometeamid = teamid and name = 'Arsenal'
) temp, games, teams
where temp.awayteamid = games.awayteamid and games.hometeamid = teams.teamid and name != 'Arsenal'
order by teamnames asc;

