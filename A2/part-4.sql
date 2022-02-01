with recursive path (dest,arr_time,arr_day,len) as (

with dayEnum as (
select *
from (VALUES
('Monday',1),
('Tuesday',2),
('Wednesday',3),
('Thursday',4),
('Friday',5),
('Saturday',6),
('Sunday',7)
) t1 (day, num)
)

select destination_station_name,arrival_time,day_of_arrival, 1
from train_info
where source_station_name = 'DADAR' and (
(day_of_arrival = day_of_departure and departure_time <= arrival_time) or
((select num from dayEnum where day = day_of_departure) < (select num from dayEnum where day = day_of_arrival))
)

union

select destination_station_name, arrival_time, day_of_arrival, len+1
from train_info, path
where source_station_name = dest and len < 3 and
(
(day_of_arrival = day_of_departure and departure_time <= arrival_time) or
((select num from dayEnum where day = day_of_departure) < (select num from dayEnum where day = day_of_arrival))
)
and
(
(day_of_departure = arr_day and  arr_time <= departure_time) or
((select num from dayEnum where day = arr_day) < (select num from dayEnum where day = day_of_departure))
)
)

select distinct dest as destination_station_name from path
where dest != 'DADAR'
order by dest asc;

