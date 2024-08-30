# sudo docker build -t my-arm64-dev-env .
$ sudo docker run --rm -it -v "$(pwd)":/workspace my-arm64-dev-env /bin/bash
# make arm
# ./build/linux/arm64/shexec build/linux/arm64/shcode_hello.bin 
Hello!
# ./build/linux/arm64/shexec build/linux/arm64/shcode_shell.bin
# id
uid=0(root) gid=0(root) groups=0(root)
# exit
