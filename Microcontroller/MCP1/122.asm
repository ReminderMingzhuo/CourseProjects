data segment
     non db ?
data ends

code segment
     ASSUME CS:CODE,DS:DATA
	    start:
	 mov ax,data
	 mov ds,ax
	 lea dx,non
	 mov ah,02h
	 int 21h
	 MOV AH,4CH
	 INT 21H
code ends
end start