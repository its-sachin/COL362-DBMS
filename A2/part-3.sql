with recursive path (dest, day, distance, len) as (
select destination_station_name, day_of_arrival, distance, 1
from train_info
where source_station_name = 'DADAR' and day_of_arrival = day_of_departure

union

select distinct destination_station_name, day, path.distance + train_info.distance, len+1
from train_info, path
where source_station_name = dest and day_of_arrival = day_of_departure and day_of_arrival = day and len < 3
)

select distinct dest as destination_station_name, distance, day from path
where dest != 'DADAR'
order by dest asc, distance asc, day asc;

