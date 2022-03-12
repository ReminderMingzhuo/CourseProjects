REM   Script: Q1
REM   Oracle Live SQL 
Mingzhuo Li CSCI 585 HW2 Q1

CREATE TABLE ProjectRoomBookings ( 
roomNum NUMBER NOT NULL, 
startTime NUMBER NOT NULL, 
endTime NUMBER NOT NULL, 
groupName CHAR(10) NOT NULL, 
CONSTRAINT pk_ProjectRoomBooking PRIMARY KEY (roomNum, startTime), 
CONSTRAINT chk_ProjectRoomBooking CHECK (startTime<endTime and 6<startTime and endTime<19));
-- I use check to make 7<=startTime<=endTime<=18.

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
--I use intrigger to check before insert and if there is a time conflict it will report error.

INSERT INTO ProjectRoomBookings VALUES (1, 9, 11, 'A');

INSERT INTO ProjectRoomBookings VALUES (2, 12, 14, 'B');

INSERT INTO ProjectRoomBookings VALUES (1, 10, 13, 'C');

INSERT INTO ProjectRoomBookings VALUES (1, 13, 14, 'D');
--Tester: the third one has conflict with the first one.

SELECT * 
FROM ProjectRoomBookings;
--Show the table.