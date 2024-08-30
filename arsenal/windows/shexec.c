#include <stdio.h>
#include <stdlib.h>
#include <windows.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <shellcode_file>\n", argv[0]);
        return EXIT_FAILURE;
    }

    const char *filename = argv[1];
    HANDLE file = CreateFileA(filename, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    if (file == INVALID_HANDLE_VALUE) {
        fprintf(stderr, "Error: Unable to open file %s\n", filename);
        return EXIT_FAILURE;
    }

    DWORD fileSize = GetFileSize(file, NULL);
    if (fileSize == INVALID_FILE_SIZE) {
        fprintf(stderr, "Error: Unable to get file size\n");
        CloseHandle(file);
        return EXIT_FAILURE;
    }

    LPVOID shellcode = VirtualAlloc(NULL, fileSize, MEM_COMMIT | MEM_RESERVE, PAGE_READWRITE);
    if (shellcode == NULL) {
        fprintf(stderr, "Error: VirtualAlloc failed\n");
        CloseHandle(file);
        return EXIT_FAILURE;
    }

    DWORD bytesRead;
    if (!ReadFile(file, shellcode, fileSize, &bytesRead, NULL) || bytesRead != fileSize) {
        fprintf(stderr, "Error: Failed to read file\n");
        VirtualFree(shellcode, 0, MEM_RELEASE);
        CloseHandle(file);
        return EXIT_FAILURE;
    }

    CloseHandle(file);

    DWORD oldProtect;
    if (!VirtualProtect(shellcode, fileSize, PAGE_EXECUTE_READWRITE, &oldProtect)) {
        fprintf(stderr, "Error: VirtualProtect failed\n");
        VirtualFree(shellcode, 0, MEM_RELEASE);
        return EXIT_FAILURE;
    }

    void (*shellcode_func)() = (void (*)())shellcode;
    shellcode_func();

    VirtualFree(shellcode, 0, MEM_RELEASE);

    return 0;
}
