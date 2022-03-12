data segment
	mess1 db 'Enter keykeyword:','$'
	mess2 db 'Enter Sentence:','$'
	mess3 db 'Match at location:','$' 
	mess4 db 'No match!',13,10,'$ '
	mess5 db 'match.',13,10,'$ '
	mess6 db 'H of the sentence.',13,10,'$ '
;
stoknin1 label byte
	max1 db 10                      ;�ؼ�������ַ���Ϊ10
	act1 db ?                       ;����ؼ��ֵ��ַ�����
	keyword db 10 dup(?)               ;��Źؼ���
;
stoknin2 label byte
	max2 db 50                      ;��������ַ���Ϊ50
	act2 db ?                         ;������ӵ��ַ�����
	sentence db 50 dup(?)                 ;��ž���
data ends
;***********************************************************************************
code segment
;ϵͳ����������ΪDOS���õ�һ���ӳ���DOS�ں�����������ͬһ���ε�ַ---------------------------------
main proc far                            
	assume cs:code ,ds:data,es:data
start:              
	mov ax,data 
	mov ds,ax                  
	mov es,ax                  ;ds��es�õ����ݶε�ַ
;MAIN PART-----------------------------------------
;����ؼ���-----------------------------------
	lea dx,mess1			   ;����ؼ���
	mov ah,09               
	int 21h                     ;�����һ�仰'Enter keykeyword:'
	lea dx,stoknin1 
	mov ah,0ah
	int 21h	                  	;��stoknin1��Ϊ���������Ӽ�������ؼ���
	cmp act1,0
	je exit	        			;��act=0����ת��exit
;�������-----------------------------------------
a10:					
	call crlf                       ;���У��س�
	lea dx,mess2
	mov ah,09
	int 21h                         ;����ڶ��仰'Enter Sentence:','$'
	lea dx,stoknin2
	mov ah,0ah
	int 21h                          ;��stoknin2��Ϊ���������Ӽ����������
	cmp act2,0
	je nmatch	                     ;���sentence�ַ�����Ϊ0����ת��nmatch
	mov al,act1                       
	cbw                               
	mov cx,ax                         ;��keyword�ַ�������cx
	push cx				              ;keyword�ַ�����ת��Ϊ�ֺ�ѹջ
	mov al,act2                                          
	sub al,act1                          ;al��ţ�sentence-keyword�����ַ�����
	js nmatch			                  ;����ؼ��ֱȾ��ӳ�����nmatch
	mov di,0
	mov si,0
	lea bx,sentence                          ;bx�õ����Ӵ洢���ĵ�ַ
	inc al				
;��ʼ�Ƚ�----------------------------------------------------------------------
a20:
	mov ah,[bx+di]			
	cmp ah,keyword[si]               
	jne a30                        ;��ǰ�ַ�������ת��bx+1      
	inc si
	inc di
	dec cx
	cmp cx,0                          
	je match                         ;��ȫƥ��,��match
	jmp a20			                ;��δ��ȫƥ�䣬���ٴαȽ�
a30:
	inc bx
	dec al
	cmp al,0                       
	je nmatch                            ;���δ�Ƚϵ�sentence���ַ�����keyword���ַ����٣���nmatch
	mov si,0
	mov di,0                              ;����keyword,sentence�Ƚϵ�ַ
	pop cx
	push cx                               ;���ô��Ƚ�keyword���ַ���
	jmp a20	                               ;�����Ƚ�
;�˳�(����������-----------------------------------------
exit:   
	mov ah,4ch
	int 21h
	ret 
;no match�����No match-------------------------------------
nmatch:				
	call crlf	
	lea dx,mess4
	mov ah,09
	int 21h
	jmp a10
;match�����λ����Ϣ----------------------------------------------
match:				
	call crlf				
	lea dx,mess3
	mov ah,09                     
	int 21h				                    ;���У������'Match at location:'
	sub bx,offset sentence
	inc bx					                
	call trans 			                        ;�õ���ǰ���sentence�׵�ַ��ƫ�Ƶ�ַ����bx�У���ת��Ϊ16�������
	lea dx,mess6
	mov ah,09
	int 21h                                    ;���'H of the sentence.'
	jmp a10                                     ;���һ�β��ң������������
;crlf�س�������------------------
crlf proc near 			 
	mov dl,0dh
	mov ah,2
	int 21h
	mov dl,0ah
	mov ah,2
	int 21h
	ret
crlf   endp
;2���Ƶ�ַת��Ϊ16����------------------------------------
trans proc near			 
	mov ch,4 		 ;4λ��
rotate: mov cl,4  	         
	rol bx,cl		 
	mov al,bl		 
	and al,0fh		 ;bx������λ����������λ��al
	add al,30h		 ;al����ת��ΪASCII��
	cmp al,3ah		 
	jl printit		 ;�����������ֱ�����
	add al,7h		 ;��������ĸ����Ҫ+7
printit:
	mov dl,al 		 
	mov ah,2		 
	int 21h			 ;���dl������
	dec ch			 
	jnz rotate		 ;�ж��Ƿ��Ѿ����4λ
	ret			 ;return from trans
trans endp			;
main endp
;----------------------------------
code ends
;**********************************	
	end start		
