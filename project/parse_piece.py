import sys
import base64
import os
import psycopg2
import music21

#DBCONN = "dbname=cs421 user=cs421g76"
DBCONN = "host=localhost user=postgres"
CONN = psycopg2.connect(DBCONN)

def to_piece_sql(piece_id, name, composer, corpus, encoding, data):
	sql_str = "INSERT INTO Piece (id, encoding, composer, corpus, name, data) VALUES ('{}', '{}', '{}', '{}', '{}', '{}');".format(piece_id, encoding, composer, corpus, name, data)
	return sql_str

def to_composer_sql(composer):
	return "INSERT INTO Composer(name) VALUES ('{}') ON CONFLICT DO NOTHING;".format(composer)

def to_measure_sql(m21_score, piece_id):
	"""
	Extracts meausres from m21_score
	:todo TEST, i think this is broken
	"""
	measures = list(m21_score.makeMeasures().recurse(classFilter=['Measure']))
	values = []
	for measure in measures:
		m_write = measure.write('xml')
		with open(m_write, 'rb') as f:
			data = base64.b64encode(f.read()).decode('utf-8')
		values.append((measure.number, piece_id, data))
	
	return "INSERT INTO Measure(num, piece, data) VALUES ('{}')".format(
		"'), ('".join(["', '".join([str(elt) for elt in tpl]) for tpl in values])
	)

def parse_piece_path(piece_path):
	base, fmt = os.path.splitext(piece_path)
	fmt = fmt[1:] # skip '.'
	base = [x for x in os.path.basename(base).split("_") if not "file" in x]

	piece_id = base[0]
	name = base[1].replace('-', ' ')
	composer = base[2].replace('-', ' ')
	corpus = 'elvis'

	return piece_id, name, composer, corpus, fmt

def insert_piece(piece_path):
	m21_score = music21.converter.parse(piece_path)

	piece_id, name, composer, corpus, fmt = parse_piece_path(piece_path)

	with open(os.path.abspath(piece_path), 'rb') as f:
		data = base64.b64encode(f.read()).decode('utf-8')
	
	lazy_inserts = [
		lambda: to_composer_sql(composer),
		lambda: to_piece_sql(piece_id, name, composer, corpus, fmt, data),
		lambda: to_measure_sql(m21_score, piece_id)
	]
	
	for insert in lazy_inserts:
		with CONN, CONN.cursor() as cur:
			cur.execute(insert())

if __name__ == "__main__":
	try:
		insert_piece(sys.argv[1])
	except Exception:
		insert_piece("/Users/davidgarfinkle/elvis-project/elvisdump/MEI/000000000000005_Absalon-fili-mi_Josquin-Des-Prez_file5.mei")

