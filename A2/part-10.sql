with recursive reachable(src, dest, path, dist, ischain) as(
select distinct source_station_name, destination_station_name, ARRAY[destination_station_name], distance, (source_station_name = destination_station_name)
from train_info

union

select distinct src, destination_station_name, path || destination_station_name, dist + distance, (src = destination_station_name)
from train_info, reachable
where source_station_name = dest and (not ischain) and not (destination_station_name = ANY(path))
)

select distinct src as source_station_name, max(dist) as distance
from reachable
where ischain = true
group by src
order by source_station_name asc, distance asc;


