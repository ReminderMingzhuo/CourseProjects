DATA SEGMENT
A DB 9,6,8,7,5
B DB 5
C DB 5 DUP(0)                        ;�﷨����5dupҪ�ֿ�
N EQU 5
DATA ENDS
CODE SEGMENT
   ASSUME CS:CODE,DS:DATA,ES:DATA     ;�﷨���⣬�����ã�Ҫ�ã�
START:  MOV AX,DATA     ;ȱð��
        MOV DS,AX
	    MOV ES,AX
	    CLD
	    LEA  SI,A
	    LEA  DI,C                ;�﷨���⣬LEB����ӦΪLEA,��Ӧ��C���׵�ַ
	    MOV CX,N
	    MOV AH,0
LP1:    LODSB        ;�޴���SIָ��Ĵ洢��Ԫ�����ݸ�AL
        AAD
	    DIV  B
	    STOSB
	    LOOP LP1
        MOV CX,N
	    LEA  DI,C
LP2:    MOV DL,[DI]
        ADD DL,'0'     ;��ת��ΪASCII�����
        MOV AH,2
	    INT 21H
	    INC DI          ;ӦΪINC��DI
	    LOOP  LP2
	    MOV AH,4CH
	    INT 21H
CODE    ENDS            ;�﷨���⣬ȥ����
        END  START