with p1 as (
select distinct source_station_name, destination_station_name
from train_info
where source_station_name != destination_station_name
),
p2 as (
select * from p1
union
select distinct p1.source_station_name, train_info.destination_station_name
from p1, train_info
where p1.destination_station_name = train_info.source_station_name and p1.source_station_name != train_info.destination_station_name
),
p3 as (
select * from p2
union
select distinct p2.source_station_name, train_info.destination_station_name
from p2, train_info
where p2.destination_station_name = train_info.source_station_name and p2.source_station_name != train_info.destination_station_name
),
p4 as (
select * from p3
union
select distinct p3.source_station_name, train_info.destination_station_name
from p3, train_info
where p3.destination_station_name = train_info.source_station_name and p3.source_station_name != train_info.destination_station_name
)

select distinct * from p4
order by source_station_name asc, destination_station_name asc;

