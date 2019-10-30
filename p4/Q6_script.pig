--load the data from HDFS and define the schema
airplanes = LOAD '/data/airplanes.csv' USING PigStorage(',') AS (carrier_code:CHARARRAY, carrier_name:CHARARRAY, tail_number:CHARARRAY);
flights = LOAD '/data/flights.csv' USING PigStorage(',') AS (day:INT, flight_number:CHARARRAY, tail_number:CHARARRAY, origin_airport_id:INT, dest_airport_id:INT, delay:INT, distance:INT);

flightsByAirport = GROUP flights BY origin_airport_id;

numFlights = FOREACH flightsByAirport GENERATE group as airport_id, COUNT(flights) as num;


airplaneFlights = JOIN airplanes BY tail_number, flights BY tail_number;

numCarriers = FOREACH (GROUP airplaneFlights BY origin_airport_id) {
	A = airplaneFlights.carrier_code;
	codes = DISTINCT A;
	GENERATE COUNT(codes) as num, group as airport_id;
}

together = JOIN numFlights BY airport_id, numCarriers BY airport_id;

outputAttributes = FOREACH together GENERATE numFlights::airport_id, numCarriers::num, numFlights::num;

STORE outputAttributes INTO '~/q6' USING PigStorage(',');

-- output
DUMP outputAttributes;
