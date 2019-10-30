CREATE VIEW ComposerPiece (composer, name) AS SELECT Composer.name, Piece.name
FROM Composer, Piece
WHERE composer = Composer.name
CREATE VIEW PartNoteMeasure (name, pitch, onset, measure) AS SELECT name, "pitch-b40", onset, Measure.id
FROM Part, Note, Measure
WHERE part = Part.id;
