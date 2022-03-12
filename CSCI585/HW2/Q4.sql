REM   Script: Q4
REM   Oracle Live SQL 
Mingzhuo Li CSCI 585 HW2 Q4

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

