DATA SEGMENT
     MESS1 DB 'ENTER FIVE NUMBERS:','$'
	 MESS2 DB 'RESULT OF ADDING ALL:','$'
	 RES DB 0
DATA ENDS
CODE SEGMENT
     ASSUME CS:CODE,DS:DATA
START:
     PUSH DS
	 PUSH AX
	 SUB AX,AX
	 SUB BX,BX
	 MOV AX,DATA
	 MOV DS,AX
	 MOV ES,AX
     MOV CX,5
LEA DX,MESS1
MOV AH,09
INT 21H        ;输出第一句提示语
ADDONE:
MOV AH,01H
INT 21H
SUB AL,'0'
ADD RES,AL
LOOP ADDONE      ;输入五个数字
    MOV DL,10
         MOV AH, 02H
         INT 21H
		  MOV DL,13
         MOV AH, 02H
         INT 21H

LEA DX,MESS2
MOV AH,09
INT 21H           ;输出第二句提示语
MOV DL,RES
ADD DL,'0'
MOV AH,02H
INT 21H
MOV AH,4CH
INT 21H
CODE ENDS
END START