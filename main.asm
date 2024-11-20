section .data
    hostname_msg db 'Hostname: ', 0
    os_msg db 'OS: ', 0
    arch_msg db 'Architecture: ', 0
    newline db 10, 0

section .bss
    hostname resb 256           ; Buffer for storing the hostname
    os_name resb 256            ; Buffer for storing the OS name

section .text
    global _start

_start:
    ; Get Hostname (syscall 89: uname)
    ; struct utsname {
    ;   char sysname[65];    // Operating system name
    ;   char nodename[65];   // Node name (hostname)
    ;   char release[65];    // OS release
    ;   char version[65];    // OS version
    ;   char machine[65];    // Machine hardware name
    ; }

    ; Prepare syscall to get hostname
    mov rax, 0x00        ; syscall number for uname
    lea rdi, [hostname]  ; pointer to the buffer for the node name (hostname)
    syscall

    ; Print Hostname message
    mov rax, 1           ; syscall number for sys_write
    mov rdi, 1           ; file descriptor 1 (stdout)
    lea rsi, [hostname_msg]
    mov rdx, 10          ; length of the hostname message
    syscall

    ; Print Hostname
    mov rax, 1
    lea rsi, [hostname]
    mov rdx, 256
    syscall

    ; Print Newline
    mov rax, 1
    lea rsi, [newline]
    mov rdx, 1
    syscall

    ; Get OS name (syscall 89: uname)
    mov rax, 0x00        ; syscall number for uname
    lea rdi, [os_name]   ; pointer to the buffer for OS name
    syscall

    ; Print OS message
    mov rax, 1
    mov rdi, 1
    lea rsi, [os_msg]
    mov rdx, 4
    syscall

    ; Print OS name
    mov rax, 1
    lea rsi, [os_name]
    mov rdx, 256
    syscall

    ; Print Newline
    mov rax, 1
    lea rsi, [newline]
    mov rdx, 1
    syscall

    ; Get CPU Architecture (syscall 89: uname)
    ; The machine field of uname is where the architecture is stored
    mov rax, 0x00
    lea rdi, [hostname]  ; reuse the buffer to store machine type (architecture)
    syscall

    ; Print Architecture message
    mov rax, 1
    mov rdi, 1
    lea rsi, [arch_msg]
    mov rdx, 13          ; length of the architecture message
    syscall

    ; Print Architecture
    mov rax, 1
    lea rsi, [hostname]  ; machine is stored here now
    mov rdx, 256
    syscall

    ; Print Newline
    mov rax, 1
    lea rsi, [newline]
    mov rdx, 1
    syscall

    ; Exit Program
    mov rax, 60          ; syscall number for exit
    xor rdi, rdi         ; status code 0
    syscall
