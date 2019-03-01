#DBSTRING ?= cs421
DBSTRING = --host localhost --user postgres

clean:
	psql ${DBSTRING} -f drop_tables.sql

all: 
	make q2 q3

q2:
	psql ${DBSTRING} -f 000_schema.sql
	psql ${DBSTRING} -f 001_tables.sql
	psql ${DBSTRING} -c "SELECT table_name FROM information_schema.tables WHERE table_schema='cs421g76';" -t | xargs -I {} psql cs421 -c "\d {}" > p2_output/q2

q3:
	psql ${DBSTRING} -f 002_insert_composers.sql > p2_output/q3_1
	psql ${DBSTRING} -c "SELECT * FROM Composer" > p2_output/q3_2
