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

