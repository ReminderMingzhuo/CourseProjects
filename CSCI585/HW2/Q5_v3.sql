REM   Script: Q5_v3
REM   Oracle Live SQL 
Mingzhuo Li CSCI 585 HW2 Q5_v3

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

SELECT Instructor 
FROM Hirings join Subjects 
ON Hirings.Subject = Subjects.Subject 
GROUP BY Instructor 
HAVING COUNT(*) = (SELECT COUNT(*) FROM Subjects);
--I create a new table to contain the required subjects
--Then I find the Instructors who have three subjects and the same as the subjects in the new table.