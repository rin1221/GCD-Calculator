; Name:    Nicholas Watkins
; 
; Course:  CS 3230, Section 01, Spring 2013
;
; Purpose: This program takes in two integers and then
; finds their GCD.
;
; Input:   The user is asked to input two positive integers.
;
; Output:  This program outputs the GCD and the stack after each subprogram call.
;

%include "asm_io.inc"

segment .data

segment .bss

segment .text
	global _asm_main
_asm_main:
	enter 0,0	;setup routine
	pusha

	push eax	;read in the two integers
	push ebx
	dump_stack 1,0,2
	call int_cin
	dump_stack 2, 0,2
	add esp,8
	
	push ebx	;calculate the GCD
	push eax
	dump_stack 3,0,2
	call gcd_calc
	dump_stack 4,0,2
	add esp,8
	
	popa
	mov eax, 0
	leave	;return to C
	ret
;Subprogram int_cin
;This Subprogram asks the user to input two positive integers and then makes sure
;that they are positive otherwise it will loop until both are greater than zero.
segment .data
input1 db "Please enter two positive integers.",0

segment .bss

segment .text

int_cin:
	push ebp	;setup routine
	mov ebp, esp
input:
	mov eax, input1		;loop if either inputs is negative 
	call print_string
	call print_nl
	call read_int
	mov [ebx+12], eax
	call read_int
	mov [ebx+8], eax
	cmp dword[ebx+12], 0
	jl input
otherwise:
	cmp dword[ebx+8], 0
	jl input
valid_input:
	mov eax, [ebx+12]	;copy the values to the registers
	mov ebx, [ebx+8]
	dump_regs 1
	pop ebp		;return to main
	ret

;Subprogram gcd_calc
;This subprogram calculates the GCD of two integers and outputs the GCD.	
segment .data
gcd1 db "The GCD of the inputed integers is: ",0

segment .bss
gcd resd 1
x resd 1
y resd 1

segment .text
gcd_calc:
	enter 0,0
	
	mov eax, gcd1
	call print_string
	
	mov eax, [ebp+12]	;check which of the values is lower
	mov ebx, [ebp+8]
	mov [y], ebx
	mov [x], eax
	cmp eax, ebx
	jg countervar_y
countervar_x:
	mov ecx, [x]
	jmp again
countervar_y:
	mov ecx, [y]
again:
	mov edx, 0	;loop until there is a common divisor for both the values
	cdq
	idiv ecx
	cmp edx,dword 0
	jne looping
	
	mov edx, 0
	mov eax, [y]
	cdq
	idiv ecx
	cmp edx, dword 0
	jne looping
	
	mov [gcd], ecx
	jmp print
	
looping:
	loop again
		
print:	
	mov eax, [gcd]	;print out the gcd value
	call print_int
	call print_nl
	leave
	ret