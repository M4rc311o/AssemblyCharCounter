global _start

section .text

;print(byte* text, int length)
print:
	;push calee saved registers on stack
	push rdi						
	push rsi

	;sys_write
	mov rax, 1
	mov rdi, 1
	mov rsi, rcx
	syscall

	;restore calee saved registers
	pop rsi						
	pop rdi
	ret

_start:
	;print input prompt
	lea rcx, [inPrompt]
	mov rdx, inPromptLen
	call print
	
	xor r12, r12						;clear char counter

	read_loop:
	;sys_read from stdin
	mov rax, 0
	mov rdi, 0
	lea rsi, [buffer]
	mov rdx, bufferSize
	syscall	

	add r12, rax						;add input to total char count
	cmp byte [buffer + rax - 1], 10				;check for end of user input ('\n')
	jne read_loop
	dec r12

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
	mov byte [numBuf + r9], 10

	;print output text
	lea rcx, [outText]
	mov rdx, outTextLen
	call print

	;print number of characters
	lea rcx, [numBuf]
	mov rdx, r8
	inc rdx
	call print

	exit:
	;sys_exit with code 0	
	mov rax, 60
	mov rdi, 0
	syscall	

section .data
	inPrompt: db  "Write any text and press enter:", 10	;static prompt, append new line
	inPromptLen: equ $-inPrompt				;get size of prompt
	outText: db 10, "Number of characters is: "
	outTextLen: equ $-outText
	bufferSize: equ 100					;define buffer size

section .bss
	buffer: resb bufferSize
	numBuf: resb 21
