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

