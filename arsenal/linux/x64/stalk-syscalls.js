let mprotect = DebugSymbol.fromName('mprotect');
var mprotectAddr = mprotect.address;

Interceptor.attach(mprotectAddr, {
    onEnter(args) {
        Stalker.follow(this.threadId, {
            events: {
                call: true,
                ret: false,
                exec: false,
                block: false
            },
            transform: function (iterator) {
                let instruction = iterator.next();
                do {
                    if (instruction.mnemonic == 'syscall') {
                        iterator.putCallout(printContext);
                    }
                    iterator.keep();
                }
                while ((instruction = iterator.next()) != null)
            }
        });
    }
})

function printContext(context) {
    switch (context.rax.toInt32()) {
        case 1:
            console.log(`syscall @ ${context.pc}, RAX: ${context.rax} (${context.rax.toInt32()}) -> write()\n` +
                `    RDI: ${context.rdi}\n` +
                `    RSI: ${Memory.readCString(context.rsi)}\n` +
                `    RDX: ${context.rdx}`);
            break;
        default:
            console.log(`syscall @ ${context.pc}, RAX: ${context.rax} (${context.rax.toInt32()})`);
            break;
    }

}
