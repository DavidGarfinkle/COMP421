CREATE TABLE Composer (
	name VARCHAR(80) PRIMARY KEY,
	birth INT,
	death INT
);
CREATE TABLE Corpus (
	name VARCHAR(80) PRIMARY KEY,
	source TEXT
);
CREATE TABLE Piece (
	id SERIAL PRIMARY KEY,
	encoding CHAR(3),
	composer VARCHAR(80) NOT NULL REFERENCES Composer(name),
	corpus VARCHAR(80) REFERENCES Corpus(name),
	name VARCHAR(80),
	data TEXT
);
CREATE TABLE Docvec (
	piece_id INT PRIMARY KEY REFERENCES Piece(id),
	dimension INT NOT NULL,
	vector REAL[] 
);
CREATE TABLE Interval (
 	id SERIAL PRIMARY KEY,
	point POINT NOT NULL,
	pitch_type VARCHAR(20),
	document_frequency INT
);
CREATE TABLE Measure (
	id SERIAL PRIMARY KEY,
	num INT NOT NULL,
	piece INT REFERENCES Piece(id),
	data TEXT
);
CREATE TABLE Part (
	id SERIAL PRIMARY KEY,
	name VARCHAR(20),
	piece INT REFERENCES Piece(id)
);
CREATE TABLE Note (
	id SERIAL PRIMARY KEY,
	measure INT REFERENCES Measure(id),
	piece_id INT REFERENCES Piece(id),
	part INT REFERENCES Part(id),
	piece_idx INT NOT NULL,
	onset REAL NOT NULL,
	"offset" REAL NOT NULL,
	"pitch-b7" REAL,
	"pitch-b12" REAL,
	"pitch-b40" REAL
);
CREATE TABLE Trigram (
	id SERIAL PRIMARY KEY,
	points POINT[3] NOT NULL ,
	pitch_type VARCHAR(20),
	document_frequency INT
);

INSERT INTO Corpus (name) VALUES ('elvis');
