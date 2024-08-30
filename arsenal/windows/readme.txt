$ make
$ msfvenom -p windows/x64/messagebox -b \x00 -f raw -o win_shcode.bin
$ wine build/windows/shexec.exe win_shcode.bin
