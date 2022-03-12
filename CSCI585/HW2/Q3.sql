REM   Script: Q3
REM   Oracle Live SQL 
Mingzhuo Li CSCI 585 HW2 Q3

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

