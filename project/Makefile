#DBSTRING ?= cs421
DBSTRING = --host localhost --user postgres

clean:
	rm m21-*
	rm *.xml

rdump:
	PGPASSWORD=postgres pg_dump --host localhost --username postgres --column-inserts --data-only > dump.sql
	scp dump.sql cs421g76@comp421.cs.mcgill.ca:comp421/project/dump.sql

drop:
	psql ${DBSTRING} -f drop_tables.sql

all: 
	make drop
	make q2 q3
	python3 parse_piece.py pieces/000000000000906_Et-trop-penser_Josquin-Des-Prez_file3.xml
	#python3 parse_piece.py pieces/000000000004422_Missa-L-homme-arme_Agnus-dei-1_Du-Fay-Guillaume_file2.xml
	#python3 parse_piece.py pieces/000000000006010_Missa-Nuncqua-fue-pena-maior_Gloria_La-Rue-Pierre-de_file1.xml
	#python3 parse_piece.py pieces/000000000010001_Innsbruck-ich-mu-dich-lassen_Isaac-Henricus_file3.xml
	#python3 parse_piece.py pieces/000000000010132_Esclave-puist-yl_Binchois-Gilles-de-Bins-dit_file1.xml
	make q4 q5
	make clean
	make rdump

q2:
	psql ${DBSTRING} -f 000_schema.sql
	psql ${DBSTRING} -f 001_tables.sql
	psql ${DBSTRING} -c "SELECT table_name FROM information_schema.tables WHERE table_schema='cs421g76';" -t | xargs -I {} psql ${DBSTRING} -c "\d {}" > p2_output/q2

q3:
	psql ${DBSTRING} -f 002_insert_composers.sql > p2_output/q3_1
	psql ${DBSTRING} -c "SELECT * FROM Composer" > p2_output/q3_2

q4:
	psql ${DBSTRING} -f 006_q4.sql > p2_output/q4

q5:
	psql --host localhost --user postgres -f 003_q5.sql > p2_output/q5
