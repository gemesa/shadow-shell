#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>

char* generateRandomString(int length) {
    char *str = (char*) malloc(sizeof(char) * (length + 1));
    if (str) {
        const char charset[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        for (int i = 0; i < length; i++) {
            int key = rand() % (sizeof(charset) - 1);
            str[i] = charset[key];
        }
        str[length] = '\0';
    }
    return str;
}

int main() {
    srand(time(NULL));

    const int numberOfStrings = 10;
    const int stringLength = 20;

    char **strings = (char**) malloc(numberOfStrings * sizeof(char*));

    for (int i = 0; i < numberOfStrings; i++) {
        strings[i] = generateRandomString(stringLength);
        usleep(500000);
        printf("%s\n", strings[i]);
    }

    for (int i = 0; i < numberOfStrings; i++) {
        free(strings[i]);
    }
    free(strings);

    return 0;
}
