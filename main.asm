; EXTERNAL DEPENDENCIES
INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

; EXECUTION MODE PARAMETERS
.386
.model flat, stdcall
.stack 4096

; PROTOTYPES
ExitProcess PROTO, dwExitCode:DWORD

; DATA SEGMENT
.data

;; FLAG CONTENTS 
eFlagContents		BYTE ?
signFlag			BYTE ?
zeroFlag			BYTE ?
auxFlag			BYTE ?
parityFlag		BYTE ?
carryFlag			BYTE ?
res0			     BYTE 0 ;always 0
res1                BYTE 1 ;always 1

;; FOR PRINTING TABLE
; display flag names 
signString		db " SF ", 0
zeroString		db " ZF ", 0
auxString			db " AF ", 0
parityString		db " PF ", 0
carryString		db " CF ", 0
resString			db " res ",0

; table lines & spaces
splitLine      db 186d , 0 
midT			db 206d, 0
splitDash      db 205d, 0
topT			db 203d, 0
bottomT        db 202d, 0
space          db 32d, 0

; OPERATION PHRASING 
operation1 db "Sign Flag Test: 5 - 9", 0dh, 0ah, 0
operation2 db "Zero Flag Test: 123456789 - 123456789", 0dh, 0ah, 0
operation3 db "Auxillary Carry Flag Test: 72 + 73", 0dh, 0ah, 0

; OPERATION VARIABLES 

oneByte  BYTE 1
fiveBYTE BYTE 5
nineByte BYTE 9
ddNum DD 123456789
dwNum DW 72
dwNum2 DW 73

;; Array for printing top rw (flag names and display)
arrayFLAGS		DWORD OFFSET splitLine, OFFSET signString, OFFSET splitLine, OFFSET zeroString, OFFSET splitLine, OFFSET resString, OFFSET splitLine, OFFSET auxString, OFFSET splitLine, OFFSET resString, OFFSET splitLine, OFFSET parityString, OFFSET splitLine, OFFSET resString, OFFSET splitLine, OFFSET carryString, OFFSET splitLine

; Arrays for repetitive table formatting ascii characters 
arrayMidLine		DWORD OFFSET midT, OFFSET splitDash ;Draw middle squares
arrayTopLine		DWORD OFFSET topT, OFFSET splitDash ;Draw top
arrayBottomLine     DWORD OFFSET bottomT, OFFSET splitDash ;Draw botttom

; CODE SEGMENT
.code
main PROC
     
     ; OPERATION 1: Sign Flag Test (5-9)
     mov edx, OFFSET operation1
     call WriteString
     xor eax, eax ;clear eax
     movzx eax, fiveByte
     movzx ecx, nineByte
     sub eax, ecx

     ;call DumpRegs ;built-in display for flags for verification

    ; get eflag contents 
	lahf 
	MOV eFlagContents, AH	
     ;call WriteBin         ;print bin of eflag contents in AH
	MOV AL, eFlagContents ;create backup copy in AL
	call Crlf

     ; set flag variables 
	call setSignFlag 
	call setZeroFlag
	call setAuxFlag
	call setParityFlag
	call setCarryFlag

     ; draw table 
	call drawTop
	call listFlagNames
	call drawSquare
	call listFlagInt
     call drawBottom


     ; OPERATION 2: Zero Flag Test (123456789-123456789)
     mov edx, OFFSET operation2
     call WriteString
     xor eax, eax ; clear registers 
     xor edx, edx 
     mov eax, ddNum
     mov edx, ddNum
     sub eax, edx 

     ;call DumpRegs ;built-in display for flags for verification

    ; reset eflag contents 
	lahf 
	MOV eFlagContents, AH	
     ;call WriteBin         ;print bin of eflag contents in AH
	MOV AL, eFlagContents ;create backup copy in AL
	call Crlf

     ; set flag variables 
	call setSignFlag 
	call setZeroFlag
	call setAuxFlag
	call setParityFlag
	call setCarryFlag

     ; draw table 
	call drawTop
	call listFlagNames
	call drawSquare
	call listFlagInt
     call drawBottom


     ; OPERATION 3: Auxillary Carry Flag TEST (5045 + 1)
     mov edx, OFFSET operation3
     call WriteString
     xor eax, eax ;clear registers
     xor ecx, ecx 
     movzx eax, dwNum
     movzx ecx, dwNum2
     add eax, ecx

     ;call DumpRegs ;built-in display for flags for verification

    
    ; reset eflag contents 
	lahf 
	MOV eFlagContents, AH	
     ;call WriteBin         ;print bin of eflag contents in AH
	MOV AL, eFlagContents ;create backup copy in AL
	call Crlf

     ; set flag variables 
	call setSignFlag 
	call setZeroFlag
	call setAuxFlag
	call setParityFlag
	call setCarryFlag

     ; draw table 
	call drawTop
	call listFlagNames
	call drawSquare
	call listFlagInt
     call drawBottom


	; Return to OS.
	INVOKE ExitProcess, 0
main ENDP

setSignFlag PROC

	push bx
	push cx
	push eax

	mov bh, eFlagContents    
	and bh, 128      ;point to location of flag using AND bin 10000000
	cmp bh, 128      ;check if bit 1 is set
	je setSign1   ;if set, =1
	jne setSign0  ;if not, =0

	setSign0:
		mov ch, 0
		mov signFlag, ch
		movzx eax, signFlag
          pop eax
	     pop cx 
          pop bx

	     ret
	setSign1:
		mov ch, 1
		mov signFlag, ch
		movzx eax, signFlag
          pop eax
	     pop cx 
          pop bx
	     ret

setSignFlag ENDP

setZeroFlag PROC

	push bx
	push cx
	push eax

	mov bh, eFlagContents     
	and bh, 64      ;point to location of flag using AND bin 1000000
	cmp bh, 64      ;check if bit 1 is set
	je setZero1   ;if set, =1
	jne setZero0  ;if not, =0 

	setZero0:
		mov ch, 0
		mov zeroFlag, ch
		movzx eax, zeroFlag
		pop eax
		pop cx 
		pop bx

		ret
	setZero1:
		mov ch, 1
		mov zeroFlag, ch
		movzx eax, zeroFlag
		pop eax
		pop cx 
		pop bx

		ret 

setZeroFlag ENDP

setAuxFlag PROC

	push bx
	push cx
	push eax

	mov bh, eFlagContents     
	and bh, 16  ;point to location of flag using AND bin 10000
	cmp bh, 16  ;check if bit 1 is set   
	je setAux1   
	jne setAux0  

	setAux0:
		mov ch, 0
		mov auxFlag, ch
		movzx eax, auxFlag
		pop eax
		pop cx 
		pop bx

		ret
	setAux1:
		mov ch, 1
		mov auxFlag, ch
		movzx eax, auxFlag
		pop eax
		pop cx 
		pop bx

		ret 

setAuxFlag ENDP

setParityFlag PROC

	push bx
	push cx
	push eax

	mov bh, eFlagContents     
	and bh, 4  ;point to location of flag using AND bin 100
	cmp bh, 4  ;check if bit 1 is set 
	je setParity1   
	jne setParity0  

	setParity0:
		mov ch, 0
		mov parityFlag, ch
		movzx eax, parityFlag
		pop eax
		pop cx 
		pop bx

		ret

	setParity1:
		mov ch, 1
		mov parityFlag, ch
		movzx eax, parityFlag
		pop eax
		pop cx 
		pop bx

		ret 

setParityFlag ENDP

setCarryFlag PROC

	push bx
	push cx
	push eax

	mov bh, eFlagContents     
	and bh,1      ;point to location of flag using AND bin 1
	cmp bh,1      ;check if bit 1 is set 
	je setCarry1  
	jne setCarry0 

	setCarry0:
		mov ch, 0
		mov carryFlag, ch
		movzx eax, carryFlag
		pop eax
		pop cx 
		pop bx

		ret

	setCarry1:
		mov ch, 1
		mov carryFlag, ch
		movzx eax, carryFlag
		pop eax
		pop cx 
		pop bx

		ret 

setCarryFlag ENDP

drawBottom PROC

     push ecx 
     push edx

     call crlf 

     mov ecx, 0                   
     lea edx, [arrayBottomLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

     mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

     mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]    
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                   
     lea edx, [arrayBottomLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]      
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]   
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]   
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]       
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                   
     lea edx, [arrayBottomLine + ecx * 4]  
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]      
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]  
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]  
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]  
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                   
     lea edx, [arrayBottomLine + ecx * 4]  
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]  
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]  
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]   
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]  
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                   
     lea edx, [arrayBottomLine + ecx * 4]    
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]    
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]    
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]  
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                  
     lea edx, [arrayBottomLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]    
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]  
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]  
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]  
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                   
     lea edx, [arrayBottomLine + ecx * 4]  
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]  
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]  
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]   
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]  
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]   
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                   
     lea edx, [arrayBottomLine + ecx * 4]       
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]      
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]  
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]   
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayBottomLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                   
     lea edx, [arrayBottomLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

     call crlf

     pop ecx 
     pop edx 


ret

drawBottom ENDP

drawTop PROC

     push ecx 
     push edx 

	mov ecx, 0                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                  
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                   
     lea edx, [arrayTopLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

     call crlf

     pop ecx 
     pop edx

	ret	

drawTop ENDP

drawSquare PROC
	
     push ecx 
     push edx 

	mov ecx, 0                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                  
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 0                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                  
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                  
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                  
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

     mov ecx, 0                  
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

     mov ecx, 1                  
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

     mov ecx, 1                  
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

     mov ecx, 1                  
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

     mov ecx, 1                  
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

     mov ecx, 0                  
     lea edx, [arrayMidLine + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

     call crlf 

     pop ecx
     pop edx 

    ret

drawSquare ENDP

listFlagNames PROC

     push ecx 
     push edx 

	mov ecx, 0                   
     lea edx, [arrayFlags + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 1                   
     lea edx, [arrayFlags + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 2                   
     lea edx, [arrayFlags + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 3                   
     lea edx, [arrayFlags + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 4                   
     lea edx, [arrayFlags + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 5                   
     lea edx, [arrayFlags + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 6                   
     lea edx, [arrayFlags + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

	mov ecx, 7                   
     lea edx, [arrayFlags + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

     mov ecx, 8                   
     lea edx, [arrayFlags + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

     mov ecx, 9                   
     lea edx, [arrayFlags + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

     mov ecx, 10                  
     lea edx, [arrayFlags + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

     mov ecx, 11                   
     lea edx, [arrayFlags + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

     mov ecx, 12                   
     lea edx, [arrayFlags + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

     mov ecx, 13                   
     lea edx, [arrayFlags + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

     mov ecx, 14                   
     lea edx, [arrayFlags + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

     mov ecx, 15                   
     lea edx, [arrayFlags + ecx * 4]     
     mov edx, [edx]                      
     call WriteString

     mov ecx, 16                   
     lea edx, [arrayFlags + ecx * 4]     
     mov edx, [edx]                      
     call WriteString






	call Crlf
	    
     pop ecx 
     pop edx 

	ret

listFlagNames ENDP

listFlagInt PROC 

     push edx
     push eax

	mov edx, OFFSET splitLine
	call WriteString
     mov edx, OFFSET space
     call WriteString
     call WriteString
	movzx eax, signFlag
	call WriteDec
     mov edx, OFFSET space
     call WriteString


     mov edx, OFFSET splitLine
	call WriteString
     mov edx, OFFSET space
     call WriteString
     mov edx, OFFSET space
     call WriteString
	movzx eax, zeroFlag
	call WriteDec
     mov edx, OFFSET space
     call WriteString

     mov edx, OFFSET splitLine
	call WriteString
     mov edx, OFFSET space
     call WriteString
     mov edx, OFFSET space
     call WriteString
     movzx eax, res0
	call WriteDec
     mov edx, OFFSET space
     call WriteString
     mov edx, OFFSET space
     call WriteString


	mov edx, OFFSET splitLine
	call WriteString
     mov edx, OFFSET space
     call WriteString
     mov edx, OFFSET space
     call WriteString
	movzx eax, auxFlag
	call WriteDec
     mov edx, OFFSET space
     call WriteString

	mov edx, OFFSET splitLine
	call WriteString
     mov edx, OFFSET space
     call WriteString
     mov edx, OFFSET space
     call WriteString
     movzx eax, res0
	call WriteDec
     mov edx, OFFSET space
     call WriteString
     mov edx, OFFSET space
     call WriteString


	mov edx, OFFSET splitLine
	call WriteString
     mov edx, OFFSET space
     call WriteString
     mov edx, OFFSET space
     call WriteString
	movzx eax, parityFlag
	call WriteDec
     mov edx, OFFSET space
     call WriteString

	mov edx, OFFSET splitLine
	call WriteString
     mov edx, OFFSET space
     call WriteString
     mov edx, OFFSET space
     call WriteString
     movzx eax, res1
	call WriteDec
     mov edx, OFFSET space
     call WriteString
     mov edx, OFFSET space
     call WriteString


	mov edx, OFFSET splitLine
	call WriteString
     mov edx, OFFSET space
     call WriteString
     mov edx, OFFSET space
     call WriteString
	movzx eax, carryFlag
	call WriteDec
     mov edx, OFFSET space
     call WriteString
	mov edx, OFFSET splitLine
	call WriteString


     pop eax
     pop edx

	ret

listFlagInt ENDP

END main								; end of OPCODES