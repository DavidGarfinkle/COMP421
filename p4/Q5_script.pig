--load the data from HDFS and define the schema
airplanes = LOAD '/data/airplanes.csv' USING PigStorage(',') AS (carrier_code:CHARARRAY, carrier_name:CHARARRAY, tail_number:CHARARRAY);
flights = LOAD '/data/flights.csv' USING PigStorage(',') AS (day:INT, flight_number:CHARARRAY, tail_number:CHARARRAY, origin_airport_id:INT, dest_airport_id:INT, delay:INT, distance:INT);

airplaneFlights = JOIN airplanes BY tail_number, flights BY tail_number;

uaFlights = FILTER airplaneFlights BY (carrier_code=='UA');

groupByDay = GROUP uaFlights BY day;

yesterday = FOREACH groupByDay GENERATE group as day, COUNT(uaFlights) as numFlights;

today = FOREACH yesterday GENERATE *;

withYesterday = JOIN yesterday BY day, today BY day + 1;

moreFlights = FILTER withYesterday BY (yesterday::numFlights < today::numFlights);

outputAttributes = FOREACH moreFlights GENERATE today::day, today::numFlights, yesterday::numFlights;


-- output
DUMP outputAttributes;
