#include <stdio.h>
#include <sys/stat.h>
#include <stddef.h>

int main() {
    struct stat file_stat;
    printf("Size of struct stat: %zu bytes\n", sizeof(file_stat));

    size_t offset = offsetof(struct stat, st_size);
    printf("Offset of st_size: %zu bytes\n", offset);

    return 0;
}
