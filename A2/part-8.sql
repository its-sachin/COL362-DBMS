with recursive reachable(src, dest, path, day) as(
select distinct source_station_name, destination_station_name, ARRAY[source_station_name, destination_station_name], day_of_arrival
from train_info
where source_station_name = 'SHIVAJINAGAR' and destination_station_name != 'SHIVAJINAGAR' and day_of_arrival = day_of_departure

union

select distinct src, destination_station_name, path || destination_station_name, day
from train_info, reachable
where source_station_name = dest and day_of_arrival = day_of_departure and day_of_departure = day and not (destination_station_name = ANY(path))
)

select distinct dest as destination_station_name, day from reachable
order by dest asc, day asc;

