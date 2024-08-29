$ msfvenom -p linux/x64/exec CMD='echo \"Hello, World!\"' -f raw -o shellcode.bin
$ ./build/shexec shellcode.bin                     
file size: 57 bytes
Hello, World!
$ ./build/x64/shexec build/x64/shcode_hello.bin
file size: 57 bytes
Hello, World!
