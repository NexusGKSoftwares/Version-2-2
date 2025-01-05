# Define the code section
.section .text

# Declare global symbols
.global _start

# Entry point
_start:
    # Get argc (argument count) from the stack
    movl 4(%esp), %eax    # Load argc into %eax
    movl %eax, %edi       # Move argc to %edi (1st argument to main)
    
    # Get argv (argument vector) from the stack
    lea 8(%esp), %esi     # Load address of argv into %esi (2nd argument to main)

    # Call main(argc, argv)
    call main

    # Handle return value from main (in %eax)
    movl %eax, %ebx       # Move return value from %eax to %ebx
    movl $1, %eax         # SYS_exit system call number
    int $0x80             # Make the system call

# Main function (to be implemented in C or another file)
.section .text
.global main
main:
    # Placeholder: return 0
    movl $0, %eax         # Return 0
    ret

