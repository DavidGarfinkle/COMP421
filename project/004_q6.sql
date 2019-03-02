UPDATE Note SET "pitch-b7" = CAST("pitch-b40" AS INT) % 7;

UPDATE Note SET onset = onset/(SELECT min(onset) FROM Note WHERE onset > 0);

UPDATE Trigram SET points[1] = '(x, y % 12)',  pitch_type = 'b-12';

DELETE FROM Trigram WHERE document_frequency < 20;
