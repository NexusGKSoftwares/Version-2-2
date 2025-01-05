# Snake Game Logic in AT&T Syntax

.section .data
apple_char: .asciz "A"           # ASCII for apple
snake_char: .asciz "O"           # ASCII for snake

default_width: .long 20          # Width of the board
default_height: .long 10         # Height of the board

.section .bss
.lcomm snake_x, 100              # Snake x-coordinates
.lcomm snake_y, 100              # Snake y-coordinates
.lcomm snake_len, 4              # Snake length
.lcomm apple_x, 4                # Apple x-coordinate
.lcomm apple_y, 4                # Apple y-coordinate
.lcomm direction, 4              # Snake direction (0 = up, 1 = right, 2 = down, 3 = left)

.section .text
.globl start_game

# Entry point for the game
start_game:
    pushq %rbp
    movq %rsp, %rbp

    # Save parameters len and n_apples
    movl 16(%rbp), %eax          # Snake length
    movl %eax, snake_len
    movl 24(%rbp), %eax          # Number of apples (for now, only supports 1 apple)

    # Initialize game
    call board_init
    call initialize_game

main_game_loop:
    call get_user_input          # Process user input
    call update_game_state       # Update the game state
    call render_board            # Render the board

    # Sleep for 100ms
    movl $100000, %edi
    call usleep

    # Check if game over
    call check_game_over
    testl %eax, %eax             # Check if return value is 0 (continue) or 1 (game over)
    jnz game_over

    jmp main_game_loop           # Repeat loop

game_over:
    call game_exit               # Exit the game

    leave
    ret

# Initialize game variables
initialize_game:
    pushq %rbp
    movq %rsp, %rbp

    # Set initial snake position (center of the board)
    movl default_width, %eax
    shrl $1, %eax                # width / 2
    movl %eax, snake_x(,%eax,4)

    movl default_height, %eax
    shrl $1, %eax                # height / 2
    movl %eax, snake_y(,%eax,4)

    # Place the first apple
    call place_apple

    # Set initial direction (right)
    movl $1, direction

    leave
    ret

# Place an apple at a random position
place_apple:
    pushq %rbp
    movq %rsp, %rbp

    call rand
    xorl %edx, %edx
    movl default_width, %ecx
    divl %ecx
    movl %eax, apple_x           # apple_x = rand() % width

    call rand
    xorl %edx, %edx
    movl default_height, %ecx
    divl %ecx
    movl %eax, apple_y           # apple_y = rand() % height

    leave
    ret

# Process user input
get_user_input:
    pushq %rbp
    movq %rsp, %rbp

    call board_get_key
    cmpl $-1, %eax               # No key pressed
    je no_key_pressed

    cmpl $258, %eax              # Down arrow
    je set_direction_down
    cmpl $259, %eax              # Up arrow
    je set_direction_up
    cmpl $260, %eax              # Left arrow
    je set_direction_left
    cmpl $261, %eax              # Right arrow
    je set_direction_right

no_key_pressed:
    leave
    ret

set_direction_down:
    movl $2, direction
    jmp no_key_pressed

set_direction_up:
    movl $0, direction
    jmp no_key_pressed

set_direction_left:
    movl $3, direction
    jmp no_key_pressed

set_direction_right:
    movl $1, direction
    jmp no_key_pressed

# Update the game state
update_game_state:
    pushq %rbp
    movq %rsp, %rbp

    # Update snake head position based on direction
    cmpl $0, direction           # Up
    jne not_up
    decl snake_y(,%eax,4)
    jmp check_collision

not_up:
    cmpl $1, direction           # Right
    jne not_right
    incl snake_x(,%eax,4)
    jmp check_collision

not_right:
    cmpl $2, direction           # Down
    jne not_down
    incl snake_y(,%eax,4)
    jmp check_collision

not_down:
    decl snake_x(,%eax,4)        # Left

check_collision:
    # Check if the snake eats the apple
# Check if the snake eats the apple
    movl snake_x, %eax        # Load snake_x into %eax (32-bit register)
    cmpl apple_x, %eax        # Compare apple_x with %eax
    jne skip_apple_check      # If not equal, skip the apple check

    movl snake_y, %ebx        # Load snake_y into %ebx (32-bit register)
    cmpl apple_y, %ebx        # Compare apple_y with %ebx
    jne skip_apple_check      # If not equal, skip the apple check

    # Code to handle when the apple is eaten
    # (Add your logic here, e.g., increase score, move apple)


    # Increase snake length and place a new apple
    incl snake_len
    call place_apple

skip_apple_check:
    leave
    ret

# Render the board
render_board:
    pushq %rbp
    movq %rsp, %rbp

    # Clear screen
    movl $0, %edi
    movl $0, %esi
    call board_put_char          # Clear the board

    # Draw apple
    movl apple_x, %edi
    movl apple_y, %esi
    movl $apple_char, %edx
    call board_put_char

    # Draw snake
    movl snake_len, %ecx         # Loop through snake segments
snake_loop:
    cmpl $0, %ecx
    je end_snake_loop

    movl snake_x(,%ecx,4), %edi
    movl snake_y(,%ecx,4), %esi
    movl $snake_char, %edx
    call board_put_char

    decl %ecx
    jmp snake_loop

end_snake_loop:
    leave
    ret

# Check if the game is over
check_game_over:
    pushq %rbp
    movq %rsp, %rbp

    # Check collision with walls (implement wall logic as needed)
    movl snake_x, %eax
    cmpl $0, %eax                # Check left wall
    jl game_over_condition
    cmpl default_width, %eax    # Check right wall
    jge game_over_condition

    movl snake_y, %eax
    cmpl $0, %eax                # Check top wall
    jl game_over_condition
    cmpl default_height, %eax   # Check bottom wall
    jge game_over_condition

    movl $0, %eax                # Game continues
    leave
    ret

game_over_condition:
    movl $1, %eax                # Game over
    leave
    ret
.section .note.GNU-stack,"",@progbits
