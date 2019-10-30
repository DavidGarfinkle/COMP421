--load the data from HDFS and define the schema
airplanes = LOAD '/data/airplanes.csv' USING PigStorage(',') AS (carrier_code:CHARARRAY, carrier_name:CHARARRAY, tail_number:CHARARRAY);
flights = LOAD '/data/flights.csv' USING PigStorage(',') AS (day:INT, flight_number:CHARARRAY, tail_number:CHARARRAY, origin_airport_id:INT, dest_airport_id:INT, delay:INT, distance:INT);

carrierDays = JOIN airplanes BY tail_number, flights BY tail_number;

groupedFlights = GROUP carrierDays BY (day, carrier_code);

countedFlights = FOREACH groupedFlights GENERATE FLATTEN(group), COUNT(carrierDays) as numflights;

orderedFlights = ORDER countedFlights BY carrier_code DESC, day ASC;

STORE orderedFlights INTO '~/q4' USING PigStorage(',');

-- output
DUMP orderedFlights;
