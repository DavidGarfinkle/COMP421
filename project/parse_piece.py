import sys
import os
import psycopg2
import music21

DBCONN = "dbname=cs421 user=cs421g76"
CONN = psycopg2.connect(DBCONN)

us = music21.environment.UserSettings()
us['directoryScratch'] = "./"

def to_piece_sql(name, composer, corpus, encoding, symbolic_data):
	sql_str = "INSERT INTO Piece (encoding, composer, corpus, name, data) VALUES ({}, {}, {}, {}, {});".format(encoding, composer, corpus, name, data)
	print("to_piece_sql(): \n{}".format(sql_str))

def insert_piece(piece_path):
	m21_score = music21.converter.parse(piece_path)

	base, fmt = os.path.splitext(piece_path)
	base = [x for x in base.split("_") if not x.contains("file")]

	piece_id = base[0]
	composer = [c for c in base if c.contains("-")][0]
	name = " ".join(base[1:base.index(composer)])
	composer = composer.replace("-", " ")
	corpus = "elvis"

	with open(os.path.abspath(piece_path), 'r') as f:
		data = f.read()
	
	with CONN, CONN.cursor() as cur:
		cur.execute(to_piece_sql(name, composer, corpus, fmt, data))

if __name__ == "__main__":
	insert_piece(sys.argv[1])

