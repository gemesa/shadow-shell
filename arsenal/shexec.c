#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <shellcode_file>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    const char *filename = argv[1];
    int fd = open(filename, O_RDONLY);
    if (fd == -1) {
        perror("open");
        exit(EXIT_FAILURE);
    }

    struct stat st;
    if (fstat(fd, &st) == -1) {
        perror("fstat");
        close(fd);
        exit(EXIT_FAILURE);
    }
    size_t shellcode_size = st.st_size;

    void *shellcode = mmap(NULL, shellcode_size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (shellcode == MAP_FAILED) {
        perror("mmap");
        close(fd);
        exit(EXIT_FAILURE);
    }

    if (read(fd, shellcode, shellcode_size) != shellcode_size) {
        perror("read");
        munmap(shellcode, shellcode_size);
        close(fd);
        exit(EXIT_FAILURE);
    }

    close(fd);

    if (mprotect(shellcode, shellcode_size, PROT_EXEC | PROT_READ | PROT_WRITE) == -1) {
        perror("mprotect");
        exit(EXIT_FAILURE);
    }

    void (*shellcode_func)() = shellcode;
    shellcode_func();

    munmap(shellcode, shellcode_size);

    return 0;
}