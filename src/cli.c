#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>

// Define empty functions for each option
void optionA() {
    // Add functionality for option A here
    printf("Option A called.\n");
}

void optionB() {
    // Add functionality for option B here
    printf("Option B called.\n");
}

void optionC() {
    // Add functionality for option C here
    printf("Option C called.\n");
}

int fileExists(const char *filename) {
    FILE *file = fopen(filename, "r");
    if (file) {
        fclose(file);
        return 1; // File exists
    }
    return 0; // File does not exist
}

int main(int argc, char *argv[]) {
    const char *filename = "~/.librc";

    // check if rcfile exists
    if (fileExists(filename)) {
        printf("File exists: %s\n", filename);
    } else {
        // download newest rcfile
        printf("File does not exist: %s\n", filename);
    }
    
    int opt;
    while ((opt = getopt(argc, argv, "abc:")) != -1) {
        switch (opt) {
            case 'a':
                optionA();
                break;
            case 'b':
                optionB();
                break;
            case 'c':
                optionC();
                break;
            default:
                fprintf(stderr, "Usage: %s -a -b -c [argument]\n", argv[0]);
                exit(EXIT_FAILURE);
        }
    }

    return 0;
}
