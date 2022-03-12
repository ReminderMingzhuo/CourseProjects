REM   Script: Q5_v2
REM   Oracle Live SQL 
Mingzhuo Li CSCI 585 HW2 Q5_v2

CREATE TABLE Hirings ( 
    Instructor VARCHAR2(30) NOT NULL, 
    Subject VARCHAR2(30) NOT NULL, 
    CONSTRAINT pk_hiring PRIMARY KEY (Instructor, Subject) 
);

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

SELECT H1.Instructor 
FROM Hirings H1 
WHERE H1.Subject = 'JavaScript' 
INTERSECT 
SELECT H2.Instructor 
FROM Hirings H2 
WHERE H2.Subject= 'Scratch' 
INTERSECT 
SELECT H3.Instructor 
FROM Hirings H3 
WHERE H3.Subject = 'Python';
--I create three subtable each contains the instructors the have that one equired subject skill.
--Then I get the intersection of them which is the Instructors can teach all three subjects.