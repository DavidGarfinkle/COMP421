--load the data from HDFS and define the schema
airports = LOAD '/data/airports.csv' USING PigStorage(',') AS (airport_id:INT, airport_code:CHARARRAY, city_name:CHARARRAY, state:CHARARRAY);
airplanes = LOAD '/data/airplanes.csv' USING PigStorage(',') AS (carrier_code:CHARARRAY, carrier_name:CHARARRAY, tail_number:CHARARRAY);
flights = LOAD '/data/flights.csv' USING PigStorage(',') AS (day:INT, flight_number:CHARARRAY, tail_number:CHARARRAY, origin_airport_id:INT, dest_airport_id:INT, delay:INT, distance:INT);

A = JOIN airports BY airport_id, flights BY origin_airport_id;
B = JOIN airports BY airport_id, flights BY dest_airport_id;
C = UNION A, B;

joinAirplane = JOIN C BY tail_number, airplanes BY tail_number;
project = FOREACH joinAirplane GENERATE airplanes::tail_number, distance;
byAirplane = GROUP project BY tail_number;
cumulative = FOREACH byAirplane GENERATE group as tail_number, SUM(project.distance) AS totaldistance;

ordered = ORDER cumulative BY totaldistance DESC;

topten = LIMIT ordered 10;

STORE topten INTO '~/q7' USING PigStorage(',');

EXPLAIN topten;

-- output
DUMP topten;
