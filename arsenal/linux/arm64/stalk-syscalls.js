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
                    if (instruction.mnemonic == 'svc') {
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
    switch (context.x8.toInt32()) {
        case 64:
            console.log(`syscall @ ${context.pc}, X8: ${context.x8} (${context.x8.toInt32()}) -> write()\n` +
                `    X0: ${context.x0}\n` +
                `    X1: ${Memory.readCString(context.x1)}\n` +
                `    X2: ${context.x2}`);
            break;
        default:
            console.log(`syscall @ ${context.pc}, X8: ${context.x8} (${context.x8.toInt32()})`);
            break;
    }

}
