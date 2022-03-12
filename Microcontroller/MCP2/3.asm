DATA SEGMENT
    A DB 4,4 DUP(?)
    B DB 4,4 DUP(?)
    C DB 4,4 DUP(?)
    D DB 4,4 DUP(?)
    E DB 4,4 DUP(?)
    IN1 DB 'Please input 5 numbers',':',10,'$'
    OUT1 DB 'Sorted result ',':',10,'$'
    MAX DB 'max',':','$'
    MIN  DB 'min',':','$'
    AVERAGE  DB 'average',':','$'
SUM       DW ?
AVER   DB  3 DUP(?)
CHUSHU   DB 100,10
DATA ENDS

STACKS SEGMENT STACK
       DW 100 DUP(?)
STACKS ENDS

CODE SEGMENT
ASSUME CS:CODE,DS:DATA,SS:STACKS,ES:DATA
START: MOV AX,DATA
       MOV DS,AX
       MOV ES,AX
       MOV DX,STACKS
       MOV SS,DX
       LEA DX, IN1
       MOV AH,09H
       INT 21H;             ;输出‘Please input 5 numbers:'

       MOV CX ,5
       MOV SI,0
       CALL INPUT			;调用输入子程序
       CALL SORT			;调用排序子程序
       LEA DX,OUT1
       MOV AH,09H
       INT 21H			    ;输出'Sorted result:’
       MOV SI ,0;
       MOV CX ,5
       CALL RESULT			;调用输出三位数子函数
	   CALL MINS            ;调用最小值函数
	   CALL MAXS            ;调用最大值函数
	   CALL AVERAGES        ;调用平均值函数
	   MOV AH,4CH
       INT 21H

;-------------------------------------------------------------
   INPUT PROC			    ;接收五个数子函数
         PUSH CX
         PUSH SI
         N1:  LEA DX,[A+SI]
         MOV AH,0AH
         INT 21H
         MOV DL,10
         MOV AH, 02H
         INT 21H		    ;换行
         ADD SI,5
         LOOP N1		    ;输入五个数
         POP SI
         POP CX
         RET
   INPUT ENDP
;-----------------------------------------------------------------
  RESULT PROC			     ;输出数子函数
         PUSH CX
         PUSH SI
  NUM:   PUSH CX
         MOV CX ,3
  N2:    MOV DL,[A+SI+2]
         MOV AH,02H
         INT 21H
         INC SI
         LOOP N2			;输出个三位数
         MOV DL,10
         MOV AH, 02H
         INT 21H			;输出一个回车
         ADD SI,2
         POP  CX
         LOOP NUM			;输出五个数
         POP SI
         POP CX
         RET
  RESULT ENDP
;-------------------------------------------------
  SORT PROC
       PUSH CX			;保护断点
       PUSH SI
       CLD
       MOV CX,4
  A1:  MOV BP,0
       PUSH CX			    ;堆栈保存外层循环次数
  P1:  PUSH CX			    ;内层循环次数
       MOV CX,3
       LEA SI,[A+BP+2]
       LEA DI,[A+BP+7]
       REPZ CMPSB			;比较字符串
       JB T1
       MOV CX ,3
  T2:  MOV AL,[A+BP+2]
       XCHG AL,[A+BP+7]
       XCHG AL,[A+BP+2]
       INC BP
       LOOP T2			   ;交换
       SUB BP,3
  T1:  ADD BP,5
       POP CX			  ;内层循环
       LOOP P1			  ;比较一次；内层循环
       POP CX			  ;外层循环次数
       LOOP A1
       POP SI
       POP CX			  ;断点出栈
       RET
  SORT ENDP
;-------------------------
MINS PROC
       LEA DX,MIN
       MOV AH,09H			;输出'min'
       INT 21H;
       MOV CX,3
       LEA SI,A
       ADD SI,2
X2:    MOV DL,[SI]
       MOV AH,02H
       INT 21H
       INC SI
       LOOP X2			     ;输出最小值
       MOV DL,0AH
       MOV AH,02H
       INT 21H;
	   RET
	MINS ENDP

MAXS PROC
       LEA DX,MAX			 ;输出'max'
       MOV AH,09H
       INT 21H;	
       MOV CX,3
       LEA SI,E
       ADD SI,2
X1:    MOV DL,[SI]
       MOV AH,02H
       INT 21H
       INC SI
       LOOP X1			      ;输出最大值
		 			          
       MOV DL,10
       MOV AH, 02H
       INT 21H
       MOV DL,13
       MOV AH, 02H
       INT 21H
	   RET
	MAXS ENDP
;----------------------------------
AVERAGES PROC
       LEA DX,AVERAGE		
       MOV AH,09H
       INT 21H
       MOV CX,3
       MOV BX,10;除数10
       MOV SI,2   
AD:    MOV DX,0
       MOV AH,0
       PUSH CX
       MOV CX,3
SUM1:  MOV AL,[B+SI]	     ;将十进制数转换为二进制数，为后面求平均值做准备
       SUB AL,30H
       PUSH AX
       MOV AX,DX
       MUL BX
       MOV DX,AX
       POP AX
       ADD DX,AX
       INC SI
       LOOP SUM1			 ;执行3次完成3个十进制数的转换
       ADD SI,2
       POP CX
       ADD SUM,DX			;将DX的数放在SUM中
       LOOP AD			    ;循环后得到三个十进制数转换为二进制数之后的相加和
       MOV DX,SUM;
       MOV AX,DX
       XOR DX,DX
       MOV BX,3
       DIV BX			    ;除3取平均值,结果将商放在AX中，余数放在DX中
       MOV BX,AX			;给BX赋值平均数，然后将BX中表示的十进制数转换为对应的字符串
       DIV CHUSHU			;除100取最高位
       ADD AL,30H			;转换为ASCII码
       MOV AVER,AL
       MOV AL,AH
       XOR AH,AH 
       DIV [CHUSHU+1]         ;除10取十位
       ADD AL,30H
       ADD AH,30H             ;余数就是个位
       MOV [AVER+1],AL
       MOV [AVER+2],AH 
       MOV CX,3
       MOV SI,0       
AVERSS:
       MOV DL,[AVER+SI]       ;输出平均值
       MOV AH,2
       INT 21H
       INC SI
       LOOP AVERSS
       MOV DL,10
       MOV AH,2
       INT 21H
       MOV DL,0DH
       MOV AH,2
       INT 21H
	   RET
AVERAGES ENDP

CODE ENDS
END START
