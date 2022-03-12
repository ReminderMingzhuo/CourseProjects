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
       INT 21H;             ;�����Please input 5 numbers:'

       MOV CX ,5
       MOV SI,0
       CALL INPUT			;���������ӳ���
       CALL SORT			;���������ӳ���
       LEA DX,OUT1
       MOV AH,09H
       INT 21H			    ;���'Sorted result:��
       MOV SI ,0;
       MOV CX ,5
       CALL RESULT			;���������λ���Ӻ���
	   CALL MINS            ;������Сֵ����
	   CALL MAXS            ;�������ֵ����
	   CALL AVERAGES        ;����ƽ��ֵ����
	   MOV AH,4CH
       INT 21H

;-------------------------------------------------------------
   INPUT PROC			    ;����������Ӻ���
         PUSH CX
         PUSH SI
         N1:  LEA DX,[A+SI]
         MOV AH,0AH
         INT 21H
         MOV DL,10
         MOV AH, 02H
         INT 21H		    ;����
         ADD SI,5
         LOOP N1		    ;���������
         POP SI
         POP CX
         RET
   INPUT ENDP
;-----------------------------------------------------------------
  RESULT PROC			     ;������Ӻ���
         PUSH CX
         PUSH SI
  NUM:   PUSH CX
         MOV CX ,3
  N2:    MOV DL,[A+SI+2]
         MOV AH,02H
         INT 21H
         INC SI
         LOOP N2			;�������λ��
         MOV DL,10
         MOV AH, 02H
         INT 21H			;���һ���س�
         ADD SI,2
         POP  CX
         LOOP NUM			;��������
         POP SI
         POP CX
         RET
  RESULT ENDP
;-------------------------------------------------
  SORT PROC
       PUSH CX			;�����ϵ�
       PUSH SI
       CLD
       MOV CX,4
  A1:  MOV BP,0
       PUSH CX			    ;��ջ�������ѭ������
  P1:  PUSH CX			    ;�ڲ�ѭ������
       MOV CX,3
       LEA SI,[A+BP+2]
       LEA DI,[A+BP+7]
       REPZ CMPSB			;�Ƚ��ַ���
       JB T1
       MOV CX ,3
  T2:  MOV AL,[A+BP+2]
       XCHG AL,[A+BP+7]
       XCHG AL,[A+BP+2]
       INC BP
       LOOP T2			   ;����
       SUB BP,3
  T1:  ADD BP,5
       POP CX			  ;�ڲ�ѭ��
       LOOP P1			  ;�Ƚ�һ�Σ��ڲ�ѭ��
       POP CX			  ;���ѭ������
       LOOP A1
       POP SI
       POP CX			  ;�ϵ��ջ
       RET
  SORT ENDP
;-------------------------
MINS PROC
       LEA DX,MIN
       MOV AH,09H			;���'min'
       INT 21H;
       MOV CX,3
       LEA SI,A
       ADD SI,2
X2:    MOV DL,[SI]
       MOV AH,02H
       INT 21H
       INC SI
       LOOP X2			     ;�����Сֵ
       MOV DL,0AH
       MOV AH,02H
       INT 21H;
	   RET
	MINS ENDP

MAXS PROC
       LEA DX,MAX			 ;���'max'
       MOV AH,09H
       INT 21H;	
       MOV CX,3
       LEA SI,E
       ADD SI,2
X1:    MOV DL,[SI]
       MOV AH,02H
       INT 21H
       INC SI
       LOOP X1			      ;������ֵ
		 			          
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
       MOV BX,10;����10
       MOV SI,2   
AD:    MOV DX,0
       MOV AH,0
       PUSH CX
       MOV CX,3
SUM1:  MOV AL,[B+SI]	     ;��ʮ������ת��Ϊ����������Ϊ������ƽ��ֵ��׼��
       SUB AL,30H
       PUSH AX
       MOV AX,DX
       MUL BX
       MOV DX,AX
       POP AX
       ADD DX,AX
       INC SI
       LOOP SUM1			 ;ִ��3�����3��ʮ��������ת��
       ADD SI,2
       POP CX
       ADD SUM,DX			;��DX��������SUM��
       LOOP AD			    ;ѭ����õ�����ʮ������ת��Ϊ��������֮�����Ӻ�
       MOV DX,SUM;
       MOV AX,DX
       XOR DX,DX
       MOV BX,3
       DIV BX			    ;��3ȡƽ��ֵ,������̷���AX�У���������DX��
       MOV BX,AX			;��BX��ֵƽ������Ȼ��BX�б�ʾ��ʮ������ת��Ϊ��Ӧ���ַ���
       DIV CHUSHU			;��100ȡ���λ
       ADD AL,30H			;ת��ΪASCII��
       MOV AVER,AL
       MOV AL,AH
       XOR AH,AH 
       DIV [CHUSHU+1]         ;��10ȡʮλ
       ADD AL,30H
       ADD AH,30H             ;�������Ǹ�λ
       MOV [AVER+1],AL
       MOV [AVER+2],AH 
       MOV CX,3
       MOV SI,0       
AVERSS:
       MOV DL,[AVER+SI]       ;���ƽ��ֵ
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
