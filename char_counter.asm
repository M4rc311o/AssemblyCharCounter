global _start

section .text
_start:
	;sys_write initial prompt to stdout
	mov rax, 1
	mov rdi, 1
	lea rsi, [inPrompt]
	mov rdx, inPromptLen
	syscall
	
	xor r12, r12						;set calle saved register r12 to 0

	read_loop:
		;sys_read from stdin
		mov rax, 0
		mov rdi, 0
		lea rsi, [buffer]
		mov rdx, bufferSize
		syscall

		;loop through buffer and count charcters
		xor r8, r8					;set caller saved register r8 to 0
		buffer_loop:
			;check for new line
			cmp byte [buffer + r8], 10
			je exit_loop
			
			inc r12
			inc r8					;increment counter

			;check if whole buffer has been checked
			cmp r8, bufferSize
			je read_loop

			jmp buffer_loop

	exit_loop:
	xor r8, r8						;clear register for digit counter
	mov rax, r12						;prepare dividend to rax
	mov rcx, 10						;prepare divisor to rcx

	divide:
	xor rdx, rdx						;clear register for reminder
	div rcx							;divide by 10
	push rdx						;push reminder on stack
	inc r8							;increment digit counter
	test rax, rax						;check for last digit
	jnz divide

	;convert numbers to string
	xor r9, r9
	digit:
	pop rax
	add al, 48
	mov byte [numBuf + r9], al
	inc r9
	cmp r8, r9
	jne digit

	;sys_write output prompt
	mov rax, 1
	mov rdi, 1
	lea rsi, [outPrompt]
	mov rdx, outPromptLen
	syscall

	;sys_write number of characters
	mov rax, 1
	mov rdi, 1
	lea rsi, [numBuf]
	mov rdx, r8
	syscall

	exit:
	;sys_exit with code 0	
	mov rax, 60
	mov rdi, 0
	syscall	

section .data
	inPrompt: db  "Write any text and press enter:", 10	;static prompt, append new line
	inPromptLen: equ $-inPrompt				;get size of prompt
	outPrompt: db "Number of characters is: "
	outPromptLen: equ $-outPrompt
	bufferSize: equ 100					;define buffer size

section .bss
	buffer: resb bufferSize
	numBuf: resb 20
