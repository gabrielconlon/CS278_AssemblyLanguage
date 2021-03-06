TITLE Windows Application                   (WindowedAssembler.asm)

; This program displays a resizable application window and
; several popup message boxes.
; Thanks to Tom Joyce for creating a prototype
; from which this program was derived.
; Last update: 9/24/01

INCLUDE Irvine32.inc
INCLUDE GraphWin.inc

DTFLAGS = 25h  ; Needed for drawtext

;==================== DATA =======================
.data

AppLoadMsgTitle BYTE "Application Loaded",0
AppLoadMsgText  BYTE "The Application has successfully ",0

LeftPopupTitle	BYTE "Left Mouse Button Popup Window",0
LeftPopupText	BYTE "This window was activated by a "
				BYTE "WM_LBUTTONDOWN message",0

GreetTitle BYTE "Main Window Active",0
GreetText  BYTE "Author: Gabe Conlon "
	       BYTE "CreateWindow and UpdateWindow are called.",0

CloseMsg   BYTE "WM_CLOSE message received",0

str1   BYTE "Assembler is so much fun!",0
rc RECT <0,0,200,200>
ps PAINTSTRUCT <?>
hdc DWORD ?

ErrorTitle  BYTE "Error",0
WindowName  BYTE "ASM Windows App",0
className   BYTE "ASMWin",0

; Define the Application's Window class structure.
MainWin WNDCLASS <NULL,WinProc,NULL,NULL,NULL,NULL,NULL, \
	COLOR_WINDOW,NULL,className>

msg	     MSGStruct <>
winRect   RECT <>
hMainWnd  DWORD ?
hInstance DWORD ?

;=================== CODE =========================
.code
WinMain PROC
; Get a handle to the current process.
	INVOKE GetModuleHandle, NULL
	mov hInstance, eax
	mov MainWin.hInstance, eax

; Load the program's icon and cursor.
	INVOKE LoadIcon, NULL, IDI_APPLICATION
	mov MainWin.hIcon, eax
	INVOKE LoadCursor, NULL, IDC_ARROW
	mov MainWin.hCursor, eax

; Register the window class.
	INVOKE RegisterClass, ADDR MainWin
	.IF eax == 0
	  call ErrorHandler
	  jmp Exit_Program
	.ENDIF

; Create the application's main window.
; Returns a handle to the main window in EAX.
	INVOKE CreateWindowEx, 0, ADDR className,
	  ADDR WindowName,MAIN_WINDOW_STYLE,
	  CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,
	  CW_USEDEFAULT,NULL,NULL,hInstance,NULL
	mov hMainWnd,eax

; If CreateWindowEx failed, display a message & exit.
	.IF eax == 0
	  call ErrorHandler
	  jmp  Exit_Program
	.ENDIF

; Show and draw the window.
	INVOKE ShowWindow, hMainWnd, SW_SHOW
	INVOKE UpdateWindow, hMainWnd

; Display a personalized author message
	INVOKE MessageBox, hMainWnd, ADDR GreetText,
	  ADDR GreetTitle, MB_OK	;Author: Gabe Conlon

; Begin the program's message-handling loop.
Message_Loop:
	; Get next message from the queue.
	INVOKE GetMessage, ADDR msg, NULL,NULL,NULL

	; Quit if no more messages.
	.IF eax == 0
	  jmp Exit_Program
	.ENDIF

	; Relay the message to the program's WinProc.
	INVOKE DispatchMessage, ADDR msg
    jmp Message_Loop

Exit_Program:
	  INVOKE ExitProcess,0
WinMain ENDP

;-----------------------------------------------------
WinProc PROC,
	hWnd:DWORD, localMsg:DWORD, wParam:DWORD, lParam:DWORD
; The application's message handler, which handles
; application-specific messages. All other messages
; are forwarded to the default Windows message
; handler.
;-----------------------------------------------------

LOCAL hBrush:DWORD  ; Hold a brush for drawing a filled rectangle
	
	mov eax, localMsg

	.IF eax == WM_LBUTTONDOWN		; left mouse button?
	  INVOKE MessageBox, hWnd, ADDR LeftPopupText,
	    ADDR LeftPopupTitle, MB_OK
	  jmp WinProcExit
	.ELSEIF eax == WM_CREATE		; create window?
	  INVOKE MessageBox, hWnd, ADDR AppLoadMsgText,
	    ADDR AppLoadMsgTitle, MB_OK
	  jmp WinProcExit
	.ELSEIF eax == WM_CLOSE		; close window?
	  INVOKE MessageBox, hWnd, ADDR CloseMsg,
	    ADDR WindowName, MB_OK
	  INVOKE PostQuitMessage,0
	  jmp WinProcExit
	.ELSEIF eax == WM_RBUTTONDOWN
		;Draws a triangle
		INVOKE MessageBox, hWnd, ADDR LeftPopupText,
	    ADDR LeftPopupTitle, MB_OK
		jmp WinProcExit
	.ELSEIF eax == WM_PAINT		; window needs redrawing? 
	  INVOKE BeginPaint, hWnd, ADDR ps 
	  mov hdc, eax
	  
	  ; Draw a rectangle
	  
	  ; Create an RGB value in ebx  32 BITS: { BLANK, BLUE, GREEN,  RED }
	  ; each of the four values is one byte
	  ; The RGB value is needed to set the color of the brush
	  xor ebx, ebx  ; Clear out ebx
	                ; ebx = { 0, 0, 0,  0 }
	  mov bl, 150   ; This will be the blue color
	  	           ; ebx = { 0, 0, 0, 150 }
	  shl ebx, 8    ; Make room in ebx to add the green
	  	  	      ; ebx = { 0, 0, 150, 0 }
	  mov bl, 100   ; This sets the green color
	  	  	  	 ; ebx = { 0, 0, 150, 100 }
	  shl ebx, 8    ; Make room for the red color'
		  	  	 ; ebx = { 0,150, 100, 0 }  
      mov bl, 50    ; This sets the red color
	  		  	 ; ebx = { 0,150, 100, 50 } 
	  		  	 	  	 
	  INVOKE CreateSolidBrush, bx		;bx = green
	  
	  mov hBrush, eax  ; Mov the brush handle into hBrush
	  
	  INVOKE SelectObject, hdc, hBrush
	  
	  INVOKE Rectangle, hdc, 10, 10, 90, 40		;This is the colored Shape
	  ;INVOKE Triangle, hdc, 0, 0, 0, 10, 10, 5

	  INVOKE CreateSolidBrush, bh		;bh = maroon
	  INVOKE Rectangle, hdc, 10, 150, 90, 190		;Second Rectangle, can not get it to be another color however
	  

	  ;draws the spider web
	  INVOKE MoveToEx, hdc, 0, 0, 0		;top left corner
	  INVOKE LineTo, hdc, 200, 200		;diagnol cut
	  INVOKE LineTo, hdc, 0, 200		;back to left wall
	  INVOKE LineTo, hdc, 400, 400  	;diagnol cut
	  INVOKE LineTo, hdc, 0,   400		;back to wall
	  INVOKE LineTo, hdc, 800, 800  	;diagnol cut
	  INVOKE LineTo, hdc, 0,   800		;back to wall
	  INVOKE DrawTextA, hdc, ADDR str1, -1, ADDR rc, DTFLAGS 
	  INVOKE EndPaint, hWnd, ADDR ps
	  jmp WinProcExit
	.ELSE		; other message?
	  INVOKE DefWindowProc, hWnd, localMsg, wParam, lParam
	  jmp WinProcExit
	.ENDIF

WinProcExit:
	ret
WinProc ENDP

;---------------------------------------------------
ErrorHandler PROC
; Display the appropriate system error message.
;---------------------------------------------------
.data
pErrorMsg  DWORD ?		; ptr to error message
messageID  DWORD ?
.code
	INVOKE GetLastError	; Returns message ID in EAX
	mov messageID,eax

	; Get the corresponding message string.
	INVOKE FormatMessage, FORMAT_MESSAGE_ALLOCATE_BUFFER + \
	  FORMAT_MESSAGE_FROM_SYSTEM,NULL,messageID,NULL,
	  ADDR pErrorMsg,NULL,NULL

	; Display the error message.
	INVOKE MessageBox,NULL, pErrorMsg, ADDR ErrorTitle,
	  MB_ICONERROR+MB_OK

	; Free the error message string.
	INVOKE LocalFree, pErrorMsg
	ret
ErrorHandler ENDP

END WinMain