REM   Script: Q2
REM   Oracle Live SQL 
Mingzhuo Li CSCI 585 HW2 Q2

CREATE TABLE Enrollments (  
   SID NUMBER NOT NULL, 
   ClassName CHAR(20) NOT NULL, 
   Grade CHAR, 
   CONSTRAINT pk_enrollment PRIMARY KEY (SID,ClassName));

INSERT INTO Enrollments VALUES (123, 'Processing', 'A');

INSERT INTO Enrollments VALUES (123, 'Python', 'B');

INSERT INTO Enrollments VALUES (123, 'Scratch', 'B');

INSERT INTO Enrollments VALUES (662, 'Java', 'B');

INSERT INTO Enrollments VALUES (662, 'Python', 'A');

INSERT INTO Enrollments VALUES (662, 'JavaScript', 'A');

INSERT INTO Enrollments VALUES (662, 'Scratch', 'B');

INSERT INTO Enrollments VALUES (345, 'Scratch', 'A');

INSERT INTO Enrollments VALUES (345, 'JavaScript', 'B');

INSERT INTO Enrollments VALUES (555, 'Python', 'B');

INSERT INTO Enrollments VALUES (555, 'JavaScript', 'B');

INSERT INTO Enrollments VALUES (213, 'JavaScript', 'A');

SELECT ClassName, COUNT(*) AS Total 
FROM Enrollments 
GROUP BY ClassName 
ORDER BY Total DESC, ClassName;

