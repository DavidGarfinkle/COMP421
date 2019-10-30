--Q1: How many airports are there in each state?
--The output is then ordered by the ascending order of the airport code.

--load the data from HDFS and define the schema
airports = LOAD '/data/airports.csv' USING PigStorage(',') AS (airport_id:INT, airport_code:CHARARRAY, city_name:CHARARRAY, state:CHARARRAY);

groupbyState = GROUP airports BY state;

airportcount = FOREACH groupbyState GENERATE group as state, COUNT(airports) as numairports;

-- Order that by airport code.
orderAttributes= ORDER airportcount BY state;

-- output
DUMP orderAttributes;

ILLUSTRATE orderAttributes;
