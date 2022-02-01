with recursive path (dest, day, len) as (
select destination_station_name, day_of_arrival, 1
from train_info
where train_no = 97131 and source_station_name = 'KURLA' and day_of_arrival = day_of_departure

union

select distinct destination_station_name, day, len+1
from train_info, path
where source_station_name = dest and day_of_arrival = day_of_departure and day_of_arrival = day and len < 3
)

select distinct dest as destination_station_name
from path
order by destination_station_name asc;

