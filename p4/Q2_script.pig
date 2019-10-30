--Question 2: Find the name of the carriers that operated at the least one flight with a delay of more than 600 minutes in the month of January 2018. (15 Points)

--load the data from HDFS and define the schema
airplanes = LOAD '/data/airplanes.csv' USING PigStorage(',') AS (carrier_code:CHARARRAY, carrier_name:CHARARRAY, tail_number:CHARARRAY);
flights = LOAD '/data/flights.csv' USING PigStorage(',') AS (day:INT, flight_number:CHARARRAY, tail_number:CHARARRAY, origin_airport_id:INT, dest_airport_id:INT, delay:INT, distance:INT);

delayedFlights = FILTER flights BY (delay > 600);

SET default_parallel 4;
withTailNumber = JOIN airplanes BY tail_number, delayedFlights BY tail_number;

carrierCodes = FOREACH withTailNumber GENERATE carrier_code;

outputCodes = ORDER carrierCodes BY carrier_code;

distinctCodes = DISTINCT outputCodes;

-- output
DUMP distinctCodes;
