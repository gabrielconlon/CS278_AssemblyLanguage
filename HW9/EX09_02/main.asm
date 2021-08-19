TITLE EX08_03       (main.asm)

INCLUDE Irvine32.inc
.data
rows BYTE ?
colm BYTE ?
int1 SDWORD ?
int2 SDWORD ?
welcome BYTE "Enter an integer: ", 0

.code

center PROC
	call Clrscr
	;move to center screen
	movzx ax, rows
	mov bl, 2
	div bl
	mov dh, al

	movzx ax, colm
	mov bl, 2
	div bl
	mov dl, al
	call Gotoxy
	ret
center ENDP

main PROC
	;set window dimensions
	call GetMaxXY
	mov rows, al
	mov colm, dl

	;dh is the y coordinate, dl is the x coordinate
	;eax is the register range for RandomRange
	;eax is the register for SetTextColor color attribute

	mov ecx, 3

	call center
	;readint returns the integer to EAX
	mov edx, OFFSET welcome
	call WriteString
	call ReadInt
	mov int1, eax
	call center

	mov edx, OFFSET welcome
	call WriteString
	call ReadInt
	mov int2, eax
L1:
	;perform addition
	mov eax, int2
	add eax, int1
	mov int1, eax

	call center
	mov eax, int1
	call WriteInt

	mov eax, 2500
	call Delay
	loop L1

	call Crlf

	exit
main ENDP
END main