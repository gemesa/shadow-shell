fn main() {
    hookmon();
    let mut numbers = Vec::new();
    for i in 1..=20 {
        numbers.push(i);
        hookmon();
    }
}

#[no_mangle]
pub fn hookmon() {
    std::thread::sleep(std::time::Duration::from_nanos(1));
}
