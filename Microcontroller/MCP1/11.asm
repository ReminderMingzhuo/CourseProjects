DATA SEGMENT
A DB 9,6,8,7,5
B DB 5
C DB 5 DUP(0)                        ;语法错误，5dup要分开
N EQU 5
DATA ENDS
CODE SEGMENT
   ASSUME CS:CODE,DS:DATA,ES:DATA     ;语法问题，不能用；要用，
START:  MOV AX,DATA     ;缺冒号
        MOV DS,AX
	    MOV ES,AX
	    CLD
	    LEA  SI,A
	    LEA  DI,C                ;语法问题，LEB错误，应为LEA,且应给C的首地址
	    MOV CX,N
	    MOV AH,0
LP1:    LODSB        ;无错，把SI指向的存储单元的内容给AL
        AAD
	    DIV  B
	    STOSB
	    LOOP LP1
        MOV CX,N
	    LEA  DI,C
LP2:    MOV DL,[DI]
        ADD DL,'0'     ;需转化为ASCII码输出
        MOV AH,2
	    INT 21H
	    INC DI          ;应为INC　DI
	    LOOP  LP2
	    MOV AH,4CH
	    INT 21H
CODE    ENDS            ;语法问题，去掉：
        END  START