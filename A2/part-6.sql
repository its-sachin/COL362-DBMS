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

