## Q1

```sql
#I used the livesql that professor recommaned.
CREATE TABLE ProjectRoomBookings 
(roomNum INTEGER NOT NULL, 
startTime INTEGER NOT NULL, 
endTime INTEGER NOT NULL, 
groupName CHAR(10) NOT NULL, 
constraint pk_ProjectRoomBooking primary key (roomNum, startTime));

ALTER TABLE ProjectRoomBookings
ADD constraint chk_ProjectRoomBooking CHECK (7<=startTime<=18 AND 7<=endTime<=18 AND startTime<endTime);


create or replace trigger ProjectRoomBookings_insert
  instead of insert
  on ProjectRoomBookings
if exists(SELECT * FROM ProjectRoomBookings where startTime<=inserted.startTime<=endTime)
  BEGIN
    ROLLBACK;
  END;
else
  BEGIN
    insert into ProjectRoomBookings(roomNum, startTime, endTime, groupName) Value (inserted.roomNum, inserted.startTime, inserted.endTime, inserted.groupName);
  END;
/

```

## Q2

```sql
create table classes as
select ClassName, 
count(ClassName)
from enrollments
group by ClassName;
```

##	Q3

```sql
declare
temp VARCHAR(4);
begin 
select PID into temp
from Projects
where Step = 0 and Status = "W";
    dbms_output.put_line(temp); 
end; 
```

##	Q4

```sql
```



## Q1.1

```sql
CREATE TABLE ProjectRoomBookings (
roomNum NUMBER NOT NULL,
startTime NUMBER NOT NULL,
endTime NUMBER NOT NULL,
groupName CHAR(10) NOT NULL,
CONSTRAINT pk_ProjectRoomBooking PRIMARY KEY (roomNum, startTime),
CONSTRAINT chk_ProjectRoomBooking CHECK (startTime<endTime and 6<startTime and endTime<19));

CREATE OR REPLACE TRIGGER roomcheck 
BEFORE INSERT OR UPDATE ON ProjectRoomBookings 
FOR EACH ROW 
DECLARE 
num NUMBER; 
BEGIN 
select count(*) into num 
from ProjectRoomBookings 
where :new.roomNum=roomNum and NOT (:new.startTime>=endTime or :new.endTime<=startTime); 
IF num>0 
THEN 
  RAISE_APPLICATION_ERROR(-20001, 'Error'); 
END IF; 
END;
/

INSERT INTO ProjectRoomBookings VALUES (1, 9, 11, 'A');
INSERT INTO ProjectRoomBookings VALUES (2, 12, 14, 'B');
INSERT INTO ProjectRoomBookings VALUES (1, 10, 13, 'C');
INSERT INTO ProjectRoomBookings VALUES (1, 13, 14, 'D');

SELECT *
FROM ProjectRoomBookings;

/*
CREATE OR REPLACE TRIGGER roomcheck
BEFORE INSERT OR UPDATE ON ProjectRoomBookings
FOR EACH ROW
DECLARE
tmp NUMBER;
BEGIN
select count(*) into tmp
from ProjectRoomBookings
where :new.roomNum=roomNum and (startTime<:new.startTime<endTime or startTime<:new.endTime<endTime);
IF tmp>0
THEN
  RAISE_APPLICATION_ERROR(-20001, 'Error');
END IF;
END;
/
*/
```



## Q2.1

```sql
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
```



## Q3.1

```sql
CREATE TABLE Projects (
    PID CHAR(4) NOT NULL,
    Step NUMBER NOT NULL,
    status_Project char,
    CONSTRAINT pk_project PRIMARY KEY (PID, Step));

INSERT INTO Projects VALUES ('P100', 0, 'C');
INSERT INTO Projects VALUES ('P100', 1, 'W');
INSERT INTO Projects VALUES ('P100', 2, 'W');
INSERT INTO Projects VALUES ('P201', 0, 'C');
INSERT INTO Projects VALUES ('P201', 1, 'C');
INSERT INTO Projects VALUES ('P333', 0, 'W');
INSERT INTO Projects VALUES ('P333', 1, 'W');
INSERT INTO Projects VALUES ('P333', 2, 'W');
INSERT INTO Projects VALUES ('P333', 3, 'W');

SELECT DISTINCT PID
FROM Projects P1
WHERE Step = 0
AND status_Project = 'C'
AND 'W' = ALL (SELECT status_Project
               FROM Projects P2
               WHERE Step = 1
               AND P1.PID = P2.PID);
```



## Q4.1

```sql
CREATE TABLE Lecturers (
    LrID NUMBER NOT NULL,
    LName VARCHAR2(30) NOT NULL,
    Bonus NUMBER,
    CONSTRAINT pk_lecture PRIMARY KEY (LrID)
);

CREATE TABLE Classes (
    CID NUMBER NOT NULL,
    CName VARCHAR2(30) NOT NULL,
    CONSTRAINT pk_class PRIMARY KEY (CID)
);
    
CREATE TABLE Teachings (
    StuNum NUMBER NOT NULL,
    CID NUMBER NOT NULL,
    LrID NUMBER NOT NULL,
    CONSTRAINT pk_teaching PRIMARY KEY (CID, LrID),
    CONSTRAINT fk_teaching_lrID FOREIGN KEY (LrID)
        REFERENCES Lecturers (LrID),
    CONSTRAINT fk_teaching_CID FOREIGN KEY (CID)
        REFERENCES Classes (CID)
);

INSERT INTO Classes VALUES (0, 'JavaScript');
INSERT INTO Classes VALUES (1, 'Java');
INSERT INTO Classes VALUES (2, 'Python');

INSERT INTO Lecturers (LrID, LName) VALUES (0, 'Adams');
INSERT INTO Lecturers (LrID, LName) VALUES (1, 'Jack');

INSERT INTO  Teachings (StuNum, LrID, CID)
   VALUES (10, 
      (SELECT LrID 
       FROM Lecturers
       WHERE LName = 'Adams'), 
      (SELECT CID
       FROM Classes
       WHERE CName = 'JavaScript'));
         
INSERT INTO  Teachings (StuNum, LrID, CID)
   VALUES (20, 
      (SELECT LrID 
       FROM Lecturers
       WHERE LName = 'Adams'), 
      (SELECT CID
       FROM Classes
       WHERE CName = 'Python'));
       
INSERT INTO  Teachings (StuNum, LrID, CID)
   VALUES (30, 
      (SELECT LrID 
       FROM Lecturers
       WHERE LName = 'Jack'), 
      (SELECT CID
       FROM Classes
       WHERE CName = 'JavaScript'));
       
INSERT INTO  Teachings (StuNum, LrID, CID)
   VALUES (40, 
      (SELECT LrID 
       FROM Lecturers
       WHERE LName = 'Jack'), 
      (SELECT CID
       FROM Classes
       WHERE CName = 'Java'));





UPDATE Lecturers L
SET Bonus = 300*(SELECT SUM(StuNum)
              FROM Teachings T
              GROUP BY T.LrID
              HAVING T.LrID = L.LrID)*0.1;
SELECT MAX(Bonus) FROM Lecturers;
/*
UPDATE Lecturers
SET BONUS = 3 * 0.1 * (SELECT SUM(StuNum)
                       FROM Teachings
                       GROUP BY LrID
    )
WHERE Teachings.LrID = Lecturers.LrID;
```

## 5.11

```sql
/*
CREATE TABLE Instructors (
    InsName VARCHAR2(30) NOT NULL,
    CONSTRAINT pk_lecture PRIMARY KEY (InsID)
);
*/
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
```



## 5.12

```sql
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
```



## 5.13

```sql
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
WHERE H3.Subject = 'Python'
```













