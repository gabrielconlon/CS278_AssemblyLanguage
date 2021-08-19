TITLE EX08_03       (main.asm)

INCLUDE Irvine32.inc
.data
colorString BYTE "KaChow", 0

rows BYTE ?
colm BYTE ?
randRows DWORD ?
randColm DWORD ?

.code
main PROC
	;set window dimensions
	call GetMaxXY
	mov rows, al
	mov colm, dl

	mov ecx, 100
	;call Randomize

	;dh is the y coordinate, dl is the x coordinate
	;eax is the register range for RandomRange
	;eax is the register for SetTextColor color attribute

L1:
	;generate random cursor location
	movzx eax, rows
	call RandomRange
	mov randRows, eax	;	rows generated
	movzx eax, colm
	call RandomRange
	mov randColm, eax	;	columns generated

	;move to random cursor location
	mov dh, BYTE PTR randRows
	mov dl, BYTE PTR randColm
	call Gotoxy

	;set text color
	mov eax, 16
	call RandomRange
	add eax, 1
	call SetTextColor

	;writeline with delay
	mov eax, 100
	call Delay
	mov edx, OFFSET colorString
	call WRITESTRING
	call Crlf

	loop L1
	exit
main ENDP
END main