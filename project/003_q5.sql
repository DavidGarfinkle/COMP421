-- [aggregator] select number of notes per piece
SELECT name, Count(*) FROM Note JOIN Piece ON piece_id=Piece.id GROUP BY name LIMIT 20;

-- [join query] select notes in a piece
SELECT onset, "pitch-b40" FROM Note JOIN Piece ON piece_id=Piece.id LIMIT 20;

-- [aggregator] extract chords in a piece
SELECT piece_id, onset, array_agg("pitch-b40") as chords FROM Note GROUP BY piece_id, onset ORDER BY piece_id, onset LIMIT 20;

-- [subquery] measures without any notes... i.e., whole rests
SELECT num FROM Measure WHERE NOT EXISTS ( SELECT measure FROM Note ) LIMIT 20;

-- [select] pieces by composer X
SELECT name FROM Piece WHERE composer='Josquin Des Prez' LIMIT 20;
