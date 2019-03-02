CREATE VIEW piece AS
	SELECT N2.piece_id, N2.onset, N2.piece_idx, N1.piece_id, N1.onset, N1.piece_idx
	FROM Note as N1 JOIN Note as N2
	ON N1.piece_idx=N2.piece_idx+1 AND N1.piece_id = N2.piece_id;

