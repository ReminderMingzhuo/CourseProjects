DATA SEGMENT
ATA   DW   262    ;1(C)                                             
      DW   294    ;2(D)
      DW   330    ;3(E)
      DW   349    ;4(F)
      DW   392    ;5(G)
      DW   440    ;6(A)                       
      DW   494    ;7(B)                        
      DW   523    ;8(C)
  MSG          DB    'piano1:input1-8 to get melody.',0ah,0dh              
               DB    '(Q->quit)',0ah,0dh,'$'
MSG1  DB    'QUIT!',0ah,0dh,'$'
DATA ENDS

STCK SEGMENT STACK
          db    100 DUP(?)
STCK ENDS

CODE SEGMENT
  ASSUME CS:CODE,DS:DATA
START:
  MOV AX,DATA;
  MOV DS,AX;

  LEA DX,MSG;        输出提示信息
  MOV AH,09H;
  INT 21H;

;输入音符
INPUT:
  MOV AH,07H;
  INT 21H;
  
  CMP AL,51H;        若输入Q,则退出程序
  JZ QUIT
  
  CALL PIANOFUC;     调用程序,根据输入音符发出相应声音
  
  JMP INPUT

;退出程序
QUIT:
  LEA DX,MSG1;        输出退出信息
  MOV AH,09H;
  INT 21H;
  MOV AH,4CH;
  INT 21H;
 
 ;子程序名：PIANOFUC
 ;功能：    将AL寄存器中字符1、2、3、4、5、6、7、i的ASCII作为音符
 ;          查频率表(RATETABLE),使扬声器发出不同频率的声音
 PIANOFUC PROC
  PUSH BX;
  PUSH AX; 
  PUSH DX;

  CMP AL,'1' 
  JZ ONE
  
  CMP AL,'2'
  JZ TWO
  
  CMP AL,'3'
  JZ THREE
  
  CMP AL,'4'
  JZ FOUR
  
  CMP AL,'5'
  JZ FIVE
  
  CMP AL,'6'
  JZ SIX
  
  CMP AL,'7'
  JZ SEVEN
  
  CMP AL,'8'
  JZ EIGHT
  
  JMP QUIT_PIANOFUC
ONE:
  MOV BX,0
  JMP OUT_VOI
TWO:
  MOV BX,2
  JMP OUT_VOI
THREE:
  MOV BX,4
  JMP OUT_VOI
FOUR:
  MOV BX,6
  JMP OUT_VOI
FIVE:
  MOV BX,8
  JMP OUT_VOI
SIX:
  MOV BX,10
  JMP OUT_VOI
SEVEN:
  MOV BX,12
  JMP OUT_VOI
EIGHT:
  MOV BX,14 
  
  

OUT_VOI: 
  
  MOV AX,0000H;           常熟120000H做被除数
  MOV DX,0012H;
  
  DIV ATA[BX];      计算频率值
  MOV BX,AX;              将之存入BX寄存器
  
  MOV AL,10110110B;       设置定时器工作方式，计数器2，先低字节后高字节，方式3方波发生器，二进制
  OUT 43H,AL
  
  MOV AX,BX;              
  OUT 42H,AL;             设置低位
  
  MOV AL,AH;              设置高位
  OUT 42H,AL
  
  IN AL,61H;             打开与门
  OR AL,03H;
  OUT 61H,AL
  
  CALL DELAY
  
  IN AL,61H;             关闭与门
  AND AL,0FCH;
  OUT 61H,AL;

;退出程序
QUIT_PIANOFUC:      
  POP DX
  POP AX
  POP BX; 
  RET
 PIANOFUC ENDP
 
 
 
 
;子程序名：DELAY
;功能：    延迟一定时间
 DELAY  PROC
  PUSH CX

  MOV CX,03H;
DELAYLOOP1: 
  PUSH CX;
  
  MOV CX,0FFFFH
DELAYLOOP2:
  LOOP DELAYLOOP2
  
  POP CX;
  LOOP DELAYLOOP1
  
  POP CX
  RET
 DELAY ENDP
 
 
CODE ENDS
     END START
