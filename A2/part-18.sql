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

