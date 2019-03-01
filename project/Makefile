clean:
	psql cs421 -f drop_tables.sql

all: 
	make q2 q3

q2:
	psql cs421 -f 001_tables.sql
	psql cs421 -c "SELECT table_name FROM information_schema.tables WHERE table_schema='cs421g76';" -t | xargs -I {} psql cs421 -c "\d {}" > p2_output/q2

q3:
	psql cs421 -f 002_insert_composers.sql > p2_output/q3_1
	psql cs421 -c "SELECT * FROM Composer" > p2_output/q3_2
