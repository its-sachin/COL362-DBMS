with recursive path (dest,len) as (

select destination_station_name, 1
from train_info
where train_no = 97131 and source_station_name = 'KURLA'

union

select distinct destination_station_name, len+1
from train_info, path
where source_station_name = dest and len < 3
)

select distinct dest as destination_station_name
from path
order by destination_station_name asc;

