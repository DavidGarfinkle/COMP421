import sys
import base64
import os
import psycopg2
import music21
from smr_search.indexers import NotePointSet

#DBCONN = "dbname=cs421 user=cs421g76"
DBCONN = "host=localhost user=postgres"
CONN = psycopg2.connect(DBCONN)

def tuples_to_values_str(tuples):
	return "('" + "'), ('".join(["', '".join([str(elt) for elt in tpl]) for tpl in tuples]) + "')"

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
	
	return "INSERT INTO Measure(num, piece, data) VALUES {}".format(tuples_to_values_str(values))

def to_part_sql(m21_score, piece_id):
	"""
	Extracts parts from m21_score
	"""
	parts = list(m21_score.recurse(classFilter=['Part']))
	values = []
	for part in parts:
		values.append((part.partName, piece_id))
	
	return "INSERT INTO Part(name, piece) VALUES {}".format(tuples_to_values_str(values))

def to_note_sql(m21_score, piece_id):

	notes = list(NotePointSet(m21_score).flat.notes)

	def note_to_measure_num(note):
		return list(m21_score.makeMeasures().getElementsByOffset(note.offset, mustBeginInSpan=False))[0].number

	values = []
	for idx, note in enumerate(notes):
		values.append(
			(note_to_measure_num(note), piece_id, idx, note.offset, 
			note.offset + note.duration.quarterLength, music21.musedata.base40.pitchToBase40(note))
		)
	
	return 'INSERT INTO Note(measure, "piece_id", piece_idx, onset, "offset", "pitch-b40") VALUES {}'.format(tuples_to_values_str(values))

def to_trigram_sql(m21_score, piece_id):
	notes = list(NotePointSet(m21_score).flat.notes)
	values = []
	for idx in range(len(notes)):
		triplet = notes[idx:idx+3]
		if len(triplet) < 3: continue

		string = '"({})", "({})", "({})"'.format(*(
			", ".join([str(note.offset), str(music21.musedata.base40.pitchToBase40(note))]) for note in triplet))
		values.append(('{' + string + '}', 'pitch-b40', 1))

	# :todo find way to determine conflict (points has no comparison function)... i.e. use your own trigram serial counter?
	#return 'INSERT INTO Trigram(points, pitch_type, document_frequency) VALUES {} ON CONFLICT (id) DO UPDATE SET document_frequency = Trigram.document_frequency + 1'.format(tuples_to_values_str(values))
	return 'INSERT INTO Trigram(points, pitch_type, document_frequency) VALUES {}'.format(tuples_to_values_str(values))

"""
def to_interval_sql(m21_score, piece_id, window=5):
	notes = list(NotePointSet(m21_score).flat.notes)
	values = []
	for idx in range(len(notes)):
		triplet = notes[idx:idx+3]
		if len(triplet) < 3: continue

		string = '"({})", "({})", "({})"'.format(*(
			", ".join([str(note.offset), str(music21.musedata.base40.pitchToBase40(note))]) for note in triplet))
		values.append(('{' + string + '}', 'pitch-b40', 1))

	return 'INSERT INTO Trigram(points, pitch_type, document_frequency) VALUES {} ON CONFLICT DO UPDATE SET document_frequency = document_frequency + 1'.format(tuples_to_values_str(values))
	"""

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
		lambda: to_measure_sql(m21_score, piece_id),
		lambda: to_part_sql(m21_score, piece_id),
		lambda: to_note_sql(m21_score, piece_id),
		lambda: to_trigram_sql(m21_score, piece_id)
		#lambda: to_interval_sql(m21_score, piece_id)
	]
	
	for insert in lazy_inserts:
		with CONN, CONN.cursor() as cur:
			cur.execute(insert())

if __name__ == "__main__":
	try:
		insert_piece(sys.argv[1])
	except Exception:
		insert_piece("/Users/davidgarfinkle/elvis-project/elvisdump/MEI/000000000000005_Absalon-fili-mi_Josquin-Des-Prez_file5.mei")

