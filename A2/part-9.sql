with recursive reachable(src, dest, path, day, dist) as(
select distinct source_station_name, destination_station_name, ARRAY[source_station_name, destination_station_name], day_of_arrival, distance
from train_info
where source_station_name = 'LONAVLA' and destination_station_name != 'LONAVLA' and day_of_arrival = day_of_departure

union

select distinct src, destination_station_name, path || destination_station_name, day, dist + distance
from train_info, reachable
where source_station_name = dest and day_of_arrival = day_of_departure and day_of_departure = day and not (destination_station_name = ANY(path))
)

select distinct dist as distance, dest as destination, day
from (
select src, dest, dist, day, rank() over (partition by src, dest order by dist asc) rank
from reachable
) t
where rank = 1
order by distance asc, destination asc, day asc;

