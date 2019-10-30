--load the data from HDFS and define the schema
rmf ~/q3

airplanes = LOAD '/data/airplanes.csv' USING PigStorage(',') AS (carrier_code:CHARARRAY, carrier_name:CHARARRAY, tail_number:CHARARRAY);
flights = LOAD '/data/flights.csv' USING PigStorage(',') AS (day:INT, flight_number:CHARARRAY, tail_number:CHARARRAY, origin_airport_id:INT, dest_airport_id:INT, delay:INT, distance:INT);

groupedFlightsByRoute = GROUP flights BY (origin_airport_id, dest_airport_id);

routeCount = FOREACH groupedFlightsByRoute GENERATE group as route, COUNT(flights) as numflights;

orderedRoutes = ORDER routeCount BY numflights DESC;

STORE orderedRoutes INTO '~/q3' USING PigStorage(',');

-- output
DUMP orderedRoutes;
