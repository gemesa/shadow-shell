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
    console.log(`syscall @ ${context.pc}, RAX: ${context.rax} (${context.rax.toInt32()})`);

}