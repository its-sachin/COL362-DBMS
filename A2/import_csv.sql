COPY train_info(train_no,train_name,distance,source_station_name,day_of_departure,destination_station_name,day_of_arrival,departure_time,arrival_time)
FROM 'E:\Semesters\Sem6\COL362\Assignments\A2\train_info.csv'
DELIMITER ',' 
CSV HEADER;