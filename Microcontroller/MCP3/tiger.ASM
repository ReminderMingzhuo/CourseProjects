STACK SEGMENT
       DW 100 DUP(?)
STACK ENDS
DATA SEGMENT
MUSIC  DW 2 DUP(262,294,330,262)                ; 频率表,1231;1231
       DW 2 DUP(330,349,392)                    ;345;345;
       DW 2 DUP(392,440,392,349,330,262)        ;565431;565431
       dw 2 dup(294,196,262),0                  ;251;251,0表示结束
 
TIME1  DW 10 DUP(250*50),500*50,250*50,250*50,500*50      ;节拍表
       DW 2  DUP(120*50,120*50,120*50,120*50,250*50,250*50)
       DW 2  DUP(250*50,250*50,500*50)
TIME2  DW 10 DUP(250*10),500*10,250*10,250*10,500*10      ;节拍表
       DW 2  DUP(120*10,120*10,120*10,120*10,250*10,250*10)
       DW 2  DUP(250*10,250*10,500*10)
	   mess1 db 'Enter cycling times:',0ah,0dh,'$'
	   mess2 db 'ENNTER1->fast,ENTER0->slow',0ah,0dh,'$'
TIMES  DW  ?
N      EQU  32                                    ;32个音符
DATA ENDS
;**********************
CODE SEGMENT 
     MAIN PROC FAR
	 ASSUME CS:CODE,DS:DATA
START:PUSH DS
      SUB AX,AX
	  PUSH AX
	  MOV AX,DATA
	  MOV DS,AX
	  lea dx,mess1			   ;输入关键词
	  mov ah,09               
	  int 21h                     ;输出第一句话'Enter CYCLING TMIES:'
	  mov ah,01h
	  int 21h	                  	;得到歌曲循环次数
	  mov dl,0ah
	  mov ah,02h
	  int 21h
	  mov dl,13
	  mov ah,02h
	  int 21h
	  XOR CX,CX
	  MOV CL,AL
	  SUB CL,'0'
	  MOV   AL,0B6H                      ;选择方波
      OUT   43H,AL
PLAY:call once
     LOOP play
	  MOV AH,4CH                     
	  INT 21H
MAIN ENDP
;**************************
ONCE PROC NEAR
     PUSH CX
	 LEA DI,MUSIC                 ;DI存放频率地址
	 lea dx,mess2		   ;输入关键词
	  mov ah,09               
	  int 21h                     ;输出第二句话
	  mov ah,01h
	  int 21h	                  	;得到歌曲快慢
	  LEA BX,TIME1   
	  cmp al,'0'                       ;BX存放节拍地址	  	  
	  je man
	  lea bx,time2
MAN:MOV CX,N                     ;cx放音符个数
NEW_SHOT:PUSH CX                   ;剩余音符个数压栈
         CALL SOUND                   ;放出一个音符的声音
		 ADD DI,2                    ;下一个音符的频率
		 ADD BX,2                   ;下一个音符的节拍
		 MOV CX,0FFFFH               
SILENT:LOOP SILENT                     ;音符间停顿
       POP CX                        ;剩余音符个数出栈
	   LOOP NEW_SHOT                     
	   MOV AL,48H                      
	   OUT 61H,AL                      ;;通过8255输出到小喇叭
	   POP CX
	   RET
ONCE ENDP
;*************************************
SOUND PROC NEAR
IN AL,61H                              ;接收8255口的数据并低两位清零
AND AL,0FCH                        
SING:XOR AL,2                           
     OUT 61H,AL                        ;为8255输出口赋值
	 PUSH AX                            ;AX压栈
	 CALL WIDNTH
	 POP AX
	 MOV CX,DX                           ;停顿
WAITS:LOOP WAITS
      DEC WORD PTR [BX]
	  JNZ SING
	  AND AL,0FCH
	  OUT 61H,AL
	  RET
SOUND ENDP
;***************
WIDNTH PROC NEAR
MOV AX,2801
PUSH BX
MOV BX,50
MUL BX                                     ;计算计数值
DIV WORD PTR [DI]
MOV DX,AX
POP BX
RET
WIDNTH ENDP
CODE ENDS
END START