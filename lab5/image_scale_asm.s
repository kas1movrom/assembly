bits 64

section .text

old_width equ 4
old_height equ old_width+4
new_width equ old_height+4
new_height equ new_width+4
channels equ new_height+4

global image_scale_asm
image_scale_asm:
    mov eax, dword [rsp+8]

    push rbp
    mov rbp, rsp
    sub rsp, channels
    and rsp, -8

    push rbx

    mov dword [rbp-old_width], edx
    mov dword [rbp-old_height], ecx
    mov dword [rbp-new_width], r8d
    mov dword [rbp-new_height], r9d
    mov dword [rbp-channels], eax

    xor r8d, r8d ; y
    mov ecx, dword [rbp-new_height]
.y_loop:
    mov eax, r8d
    mul dword [rbp-old_height]
    div dword [rbp-new_height]
    mov r9d, eax ; src_y

    push rcx
    xor r10d, r10d ; x
    mov ecx, dword [rbp-new_width] 
.x_loop:
    mov eax, r10d
    mul dword [rbp-old_width]
    div dword [rbp-new_width]
    mov r11d, eax ; src_x

    mov eax, r9d
    mul dword [rbp-old_width]
    add eax, r11d
    mul dword [rbp-channels]
    mov ebx, eax ; src_ind

    mov eax, r8d
    mul dword [rbp-new_width]
    add eax, r10d
    mul dword [rbp-channels]
    ; eax - dest_ind

    push rcx
    mov ecx, dword [rbp-channels]
.c_loop
    mov dl, byte [rsi+rbx]
    mov byte [rdi+rax], dl

    inc ebx
    inc eax
    loop .c_loop

    pop rcx
    inc r10d
    loop .x_loop

    pop rcx
    inc r8d
    loop .y_loop

    pop rbx

    leave
    ret