#![no_std]
#![no_main]

use core::arch::asm;

// x86_64 Linux

fn write_string(s: &str) {
    unsafe {
        asm!(
            "syscall",
            in("rax") 1,              // syscall NR - write: 1
            in("rdi") 1,              // arg0 - unsigned int fd - stdout: 1
            in("rsi") s.as_ptr(),     // arg1 - const char *buf
            in("rdx") s.len(),        // arg2 - size_t count
            out("rcx") _,             // clobbered by syscall
            out("r11") _,             // clobbered by syscall
            lateout("rax") _,         // return value
        );
    }
}

fn exit(code: usize) {
    unsafe {
        asm!(
            "syscall",
            in("rax") 60,             // syscall NR - exit: 60
            in("rdi") code,           // arg0 - int error_code
            options(noreturn)
        );
    }
}

#[no_mangle]
pub extern "C" fn _start() {
    let message = "Hello, World!\n";
    write_string(message);

    exit(0);
}

#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    exit(1);
    loop {}
}
