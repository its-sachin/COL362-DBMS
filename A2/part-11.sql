with recursive reachable(src, dest, len) as(
select distinct source_station_name, destination_station_name, 1
from train_info
where source_station_name != destination_station_name

union

select distinct src, destination_station_name, len + 1
from train_info, reachable
where source_station_name = dest and len < 2 and src != destination_station_name
),

allstation as(
select distinct source_station_name as station
from train_info

union

select distinct destination_station_name as station
from train_info
)

select distinct src as source_station_name from (
select src , count(distinct dest)
from reachable
group by src
)temp
where count+1 = (select count(*) from allstation)
order by source_station_name asc;

