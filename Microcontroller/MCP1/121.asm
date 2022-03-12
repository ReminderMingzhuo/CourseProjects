data segment
	mess1 db 'Enter keykeyword:','$'
	mess2 db 'Enter Sentence:','$'
	mess3 db 'Match at location:','$' 
	mess4 db 'No match!',13,10,'$ '
	mess5 db 'match.',13,10,'$ '
	mess6 db 'H of the sentence.',13,10,'$ '
;
stoknin1 label byte
	max1 db 10                      ;关键字最大字符数为10
	act1 db ?                       ;输入关键字的字符个数
	keyword db 10 dup(?)               ;存放关键字
;
stoknin2 label byte
	max2 db 50                      ;句子最大字符数为50
	act2 db ?                         ;输入句子的字符个数
	sentence db 50 dup(?)                 ;存放句子
data ends
;***********************************************************************************
code segment
;系统把主程序作为DOS调用的一个子程序，DOS内核与主程序不在同一个段地址---------------------------------
main proc far                            
	assume cs:code ,ds:data,es:data
start:              
	mov ax,data 
	mov ds,ax                  
	mov es,ax                  ;ds、es得到数据段地址
;MAIN PART-----------------------------------------
;输入关键词-----------------------------------
	lea dx,mess1			   ;输入关键词
	mov ah,09               
	int 21h                     ;输出第一句话'Enter keykeyword:'
	lea dx,stoknin1 
	mov ah,0ah
	int 21h	                  	;将stoknin1作为缓冲区，从键盘输入关键词
	cmp act1,0
	je exit	        			;若act=0则跳转至exit
;输入句子-----------------------------------------
a10:					
	call crlf                       ;换行，回车
	lea dx,mess2
	mov ah,09
	int 21h                         ;输出第二句话'Enter Sentence:','$'
	lea dx,stoknin2
	mov ah,0ah
	int 21h                          ;将stoknin2作为缓冲区，从键盘输入句子
	cmp act2,0
	je nmatch	                     ;如果sentence字符个数为0至跳转至nmatch
	mov al,act1                       
	cbw                               
	mov cx,ax                         ;将keyword字符个数给cx
	push cx				              ;keyword字符个数转换为字后压栈
	mov al,act2                                          
	sub al,act1                          ;al存放（sentence-keyword）的字符个数
	js nmatch			                  ;如果关键字比句子长，则nmatch
	mov di,0
	mov si,0
	lea bx,sentence                          ;bx得到句子存储区的地址
	inc al				
;开始比较----------------------------------------------------------------------
a20:
	mov ah,[bx+di]			
	cmp ah,keyword[si]               
	jne a30                        ;当前字符不等则转到bx+1      
	inc si
	inc di
	dec cx
	cmp cx,0                          
	je match                         ;完全匹配,则match
	jmp a20			                ;尚未完全匹配，则再次比较
a30:
	inc bx
	dec al
	cmp al,0                       
	je nmatch                            ;如果未比较的sentence的字符数比keyword的字符数少，则nmatch
	mov si,0
	mov di,0                              ;重置keyword,sentence比较地址
	pop cx
	push cx                               ;重置待比较keyword的字符数
	jmp a20	                               ;继续比较
;退出(返回主程序）-----------------------------------------
exit:   
	mov ah,4ch
	int 21h
	ret 
;no match则输出No match-------------------------------------
nmatch:				
	call crlf	
	lea dx,mess4
	mov ah,09
	int 21h
	jmp a10
;match则输出位置信息----------------------------------------------
match:				
	call crlf				
	lea dx,mess3
	mov ah,09                     
	int 21h				                    ;换行，并输出'Match at location:'
	sub bx,offset sentence
	inc bx					                
	call trans 			                        ;得到当前相对sentence首地址的偏移地址存在bx中，并转化为16进制输出
	lea dx,mess6
	mov ah,09
	int 21h                                    ;输出'H of the sentence.'
	jmp a10                                     ;完成一次查找，重新输入句子
;crlf回车，换行------------------
crlf proc near 			 
	mov dl,0dh
	mov ah,2
	int 21h
	mov dl,0ah
	mov ah,2
	int 21h
	ret
crlf   endp
;2进制地址转换为16进制------------------------------------
trans proc near			 
	mov ch,4 		 ;4位数
rotate: mov cl,4  	         
	rol bx,cl		 
	mov al,bl		 
	and al,0fh		 ;bx左环移四位，并将第四位给al
	add al,30h		 ;al内容转换为ASCII码
	cmp al,3ah		 
	jl printit		 ;如果是数字则直接输出
	add al,7h		 ;若果是字母还需要+7
printit:
	mov dl,al 		 
	mov ah,2		 
	int 21h			 ;输出dl的内容
	dec ch			 
	jnz rotate		 ;判断是否已经输出4位
	ret			 ;return from trans
trans endp			;
main endp
;----------------------------------
code ends
;**********************************	
	end start		
