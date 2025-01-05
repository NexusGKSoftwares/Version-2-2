#include <stdio.h>
#include <stdlib.h>

// Function prototype for starting the game
extern void start_game(int snake_length, int num_apples);

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <snake_length> <num_apples>\n", argv[0]);
        return 1;
    }

    int snake_length = atoi(argv[1]); // Convert first argument to integer
    int num_apples = atoi(argv[2]);  // Convert second argument to integer

    if (snake_length <= 0 || num_apples <= 0) {
        fprintf(stderr, "Invalid arguments. Snake length and number of apples must be positive integers.\n");
        return 1;
    }

    printf("Game started with snake length: %d, apples: %d\n", snake_length, num_apples);

    // Start the game
    start_game(snake_length, num_apples);
    return 0;
}
