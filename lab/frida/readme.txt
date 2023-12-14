$ objdump -d ../../target/x86_64-unknown-linux-gnu/debug/hook | grep hookmon
$ # update offset in hook-rs.js
$ frida -l hook-rs.js -f ../../target/x86_64-unknown-linux-gnu/debug/hook
$ frida -l hook.js -f ../../build/dyn
$ frida -l hook2.js -f ../../build/dyn2
