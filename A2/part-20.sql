with recursive search(src, dest, len, path) as (
select distinct hometeamid, awayteamid, 1, ARRAY[hometeamid, awayteamid]
from games where hometeamid != awayteamid

union

select distinct src, awayteamid, len+1, path || awayteamid
from games, search
where dest = hometeamid and  not (awayteamid = any(path))
)

select max(len) as count from search;

