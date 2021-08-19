TITLE MASM Template (main.asm)
INCLUDE Irvine32.inc
.data
array DWORD 1,1,2,3,4,5,6,7,8,9,10
.code
main PROC

	cld				;clears the direction flag, we are now incrementing ESI EDI
	mov ecx,(LENGTHOF array) - 1
	mov esi,OFFSET array+4
	mov edi,OFFSET array
	rep movsd		;repeats until ecx = 0

	exit
main ENDP

END main
