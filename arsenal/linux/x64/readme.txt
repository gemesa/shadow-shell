$ make
$ msfvenom -p linux/x64/exec CMD='echo \"Hello, World!\"' -f raw -o shellcode.bin
$ ./build/linux/x64/shexec shellcode.bin                     
file size: 57 bytes
Hello, World!
$ ./build/linux/x64/shexec build/linux/x64/shcode_hello.bin
file size: 57 bytes
Hello, World!
