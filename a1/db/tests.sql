SELECT (name, population) FROM Place WHERE population < 100;

SELECT pname FROM Place JOIN Person ON Place.name = 'Montreal' AND Place.mayorid = Person.pid;

SELECT name FROM Place JOIN Person ON birthyear > 1980 AND mayorid = pid; 

SELECT name, pname FROM Person JOIN Place ON name = birthplace AND mayorid = pid;

SELECT pid FROM LivesIn AS L1 JOIN LivesIn AS L2 WHERE L1.pid = L2.pid AND L1.name = 'Montreal' AND L2.name = 'Mont-Tremblant';

SELECT pname FROM Person WHERE pid IN (
    SELECT pid FROM LivesIn WHERE name = 'Montreal' AND pid IN (
        SELECT pid FROM LivesIn WHERE name = 'Mont-Tremblant'));

SELECT L1.pid FROM LivesIn AS L1 JOIN LivesIn AS L2 ON (L1.pid = L2.pid) WHERE (L1.name != L2.name);

SELECT pid FROM LivesIn WHERE NOT pid IN (
    SELECT L1.pid FROM LivesIn AS L1 JOIN LivesIn AS L2 ON (L1.pid = L2.pid) WHERE (L1.name != L2.name));

SELECT pid FROM LivesIn WHERE name = 'Laval';

SELECT pname FROM Person WHERE pid IN
    (SELECT pid FROM LivesIn JOIN Place ON pid = mayorid WHERE LivesIn.name != Place.name);
