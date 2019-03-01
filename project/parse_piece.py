import sys
import base64
import os
import psycopg2
import music21

#DBCONN = "dbname=cs421 user=cs421g76"
DBCONN = "host=localhost user=postgres"
CONN = psycopg2.connect(DBCONN)

def to_piece_sql(name, composer, corpus, encoding, data):
	sql_str = "INSERT INTO Piece (encoding, composer, corpus, name, data) VALUES ('{}', '{}', '{}', '{}', '{}');".format(encoding, composer, corpus, name, data)
	return sql_str

def to_composer_sql(composer):
	return "INSERT INTO Composer(name) VALUES ('{}');".format(composer)

def insert_piece(piece_path):
	m21_score = music21.converter.parse(piece_path)

	base, fmt = os.path.splitext(piece_path)
	fmt = fmt[1:] # skip '.'
	base = [x for x in os.path.basename(base).split("_") if not "file" in x]

	piece_id = base[0]
	name = base[1].replace('-', ' ')
	composer = base[2].replace('-', ' ')
	corpus = 'elvis'

	with open(os.path.abspath(piece_path), 'rb') as f:
		data = base64.b64encode(f.read()).decode('utf-8')
	
	with CONN, CONN.cursor() as cur:
		cur.execute(to_composer_sql(composer))
		cur.execute(to_piece_sql(name, composer, corpus, fmt, data))

if __name__ == "__main__":
	insert_piece(sys.argv[1])

