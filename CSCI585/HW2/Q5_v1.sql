REM   Script: Q5_v1
REM   Oracle Live SQL 
Mingzhuo Li CSCI 585 HW2 Q5_v1

CREATE TABLE Hirings ( 
    Instructor VARCHAR2(30) NOT NULL, 
    Subject VARCHAR2(30) NOT NULL, 
    CONSTRAINT pk_hiring PRIMARY KEY (Instructor, Subject) 
);

CREATE TABLE Subjects ( 
    Subject VARCHAR2(30) NOT NULL, 
    CONSTRAINT pk_subject PRIMARY KEY (Subject) 
);

INSERT INTO Subjects VALUES ('JavaScript');

INSERT INTO Subjects VALUES ('Scratch');

INSERT INTO Subjects VALUES ('Python');

INSERT INTO Hirings VALUES ('Aleph', 'Scratch');

INSERT INTO Hirings VALUES ('Aleph', 'Java');

INSERT INTO Hirings VALUES ('Aleph', 'Processing');

INSERT INTO Hirings VALUES ('Bit', 'Python');

INSERT INTO Hirings VALUES ('Bit', 'JavaScript');

INSERT INTO Hirings VALUES ('Bit', 'Java');

INSERT INTO Hirings VALUES ('CRC', 'Python');

INSERT INTO Hirings VALUES ('CRC', 'JavaScript');

INSERT INTO Hirings VALUES ('Dat', 'Scratch');

INSERT INTO Hirings VALUES ('Dat', 'Python');

INSERT INTO Hirings VALUES ('Dat', 'JavaScript');

INSERT INTO Hirings VALUES ('Emscr', 'Scratch');

INSERT INTO Hirings VALUES ('Emscr', 'Processing');

INSERT INTO Hirings VALUES ('Emscr', 'JavaScript');

INSERT INTO Hirings VALUES ('Emscr', 'Python');

SELECT H.Instructor 
FROM Hirings H 
WHERE H.Subject IN (SELECT Subject FROM Subjects) 
GROUP BY H.Instructor 
HAVING COUNT(*) = (SELECT COUNT(*) FROM Subjects);

--I create another table to contain the three subjects required and find all the instructors
--who has all the subjects in the new table.