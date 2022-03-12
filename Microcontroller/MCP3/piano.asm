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

  LEA DX,MSG;        �����ʾ��Ϣ
  MOV AH,09H;
  INT 21H;

;��������
INPUT:
  MOV AH,07H;
  INT 21H;
  
  CMP AL,51H;        ������Q,���˳�����
  JZ QUIT
  
  CALL PIANOFUC;     ���ó���,������������������Ӧ����
  
  JMP INPUT

;�˳�����
QUIT:
  LEA DX,MSG1;        ����˳���Ϣ
  MOV AH,09H;
  INT 21H;
  MOV AH,4CH;
  INT 21H;
 
 ;�ӳ�������PIANOFUC
 ;���ܣ�    ��AL�Ĵ������ַ�1��2��3��4��5��6��7��i��ASCII��Ϊ����
 ;          ��Ƶ�ʱ�(RATETABLE),ʹ������������ͬƵ�ʵ�����
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
  
  MOV AX,0000H;           ����120000H��������
  MOV DX,0012H;
  
  DIV ATA[BX];      ����Ƶ��ֵ
  MOV BX,AX;              ��֮����BX�Ĵ���
  
  MOV AL,10110110B;       ���ö�ʱ��������ʽ��������2���ȵ��ֽں���ֽڣ���ʽ3������������������
  OUT 43H,AL
  
  MOV AX,BX;              
  OUT 42H,AL;             ���õ�λ
  
  MOV AL,AH;              ���ø�λ
  OUT 42H,AL
  
  IN AL,61H;             ������
  OR AL,03H;
  OUT 61H,AL
  
  CALL DELAY
  
  IN AL,61H;             �ر�����
  AND AL,0FCH;
  OUT 61H,AL;

;�˳�����
QUIT_PIANOFUC:      
  POP DX
  POP AX
  POP BX; 
  RET
 PIANOFUC ENDP
 
 
 
 
;�ӳ�������DELAY
;���ܣ�    �ӳ�һ��ʱ��
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
