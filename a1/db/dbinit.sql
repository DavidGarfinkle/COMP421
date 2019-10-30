CREATE TABLE Person (
  pid SERIAL PRIMARY KEY,
  pname TEXT,
  birthyear INT
);

INSERT INTO Person (pname, birthyear) VALUES
  ('Rich', 1990),
  ('Carl', 1970),
  ('Louise', 1980),
  ('Applebaum', 1980);

CREATE TABLE Place (
  name TEXT PRIMARY KEY,
  population INT,
  mayorid INT REFERENCES Person(pid)
);

CREATE TABLE LivesIn (
  pid INT REFERENCES Person(pid),
  name TEXT REFERENCES Place(name)
);

INSERT INTO Place (name, population, mayorid) VALUES
  ('Montreal', 150, 1),
  ('Boston', 100, 2),
  ('Mont-Tremblant', 20, 3),
  ('Philadelphia', 50, 4);

ALTER TABLE Person ADD birthplace TEXT REFERENCES Place(name);
UPDATE Person SET birthplace = 'Montreal' WHERE pname = 'Rich';
UPDATE Person SET birthplace = 'Montreal' WHERE pname = 'Carl';
UPDATE Person SET birthplace = 'Mont-Tremblant' WHERE pname = 'Louise';
UPDATE Person SET birthplace = 'Philadelphia' WHERE pname = 'Applebaum';

INSERT INTO LivesIn (pid, name) VALUES
  (1, 'Montreal'),
  (2, 'Boston'),
  (3, 'Mont-Tremblant'),
  (3, 'Montreal');
