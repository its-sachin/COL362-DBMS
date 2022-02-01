with recursive allpath (src, dest, path ,trains, len) as (

select source_station_name, destination_station_name, ARRAY[source_station_name,destination_station_name], ARRAY[train_no], 1
from train_info
where source_station_name = 'CST-MUMBAI'

union

select distinct src, destination_station_name, path || destination_station_name, trains || train_no, len+1
from train_info, allpath
where source_station_name = dest and len < 3 and not (destination_station_name = ANY(path))
)

select count(*) from allpath where src = 'CST-MUMBAI'  and dest = 'VASHI';

