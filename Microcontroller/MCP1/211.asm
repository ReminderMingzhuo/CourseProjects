DATA SEGMENT
A DW 005AH      ;A=90
B DW 0FFBAH     ;B=-70
C DW 0005H      ;C=5 
DATA ENDS

STACK SEGMENT
STA DW 100 DUP(?)
STACK ENDS

CODE SEGMENT
ASSUME CS:CODE,DS:DATA,SS:STACK

START:
MOV AX,DATA 
MOV DS,AX
MOV AX,A      ;AX=A
MOV BX,B      ;BX=B
ADD AX,BX     ;AX=AX+BX
MOV BX,0002H  ;BX=2
IMUL BX       ;AX=AX*BX���ʽ1
PUSH AX       ;��ʽ1ѹջ

MOV AX,A      ;AX=A
MOV BX,C      ;BX=C
IMUL BX       ;AX=AX*BX
MOV BX,0005H  ;BX=5
CWD           ;��������
IDIV BX       ;AX=AX/BX���ʽ2

POP BX        ;��һ����ʽ��ջ��BX
ADD AX,BX     ;AX=��ʽ1+��ʽ2

MOV BX,100    ;BX=100
CWD           ;��������
IDIV BX       ;AX=AX/BX
PUSH DX       ;��ʮλ�͸�λѹջ
MOV AH,02H    
MOV DL,AL     ;�����λ
ADD DL,'0'
INT 21H

POP AX        ;��ʮλ��λ��ջ��AX
MOV BL,10     
IDIV BL       ;��ʮλ����
MOV BL,AH
MOV AH,02H
MOV DL,AL     ;���ʮλ
ADD DL,'0'
INT 21H

MOV DL,BL     ;�����λ
ADD DL,'0'
INT 21H
 
MOV AH,4CH    ;����DOS
INT 21H

CODE ENDS
END START