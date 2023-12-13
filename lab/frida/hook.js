Interceptor.attach(Module.getExportByName(null, "malloc"), {
    onEnter: function (args) {
        this.size = args[0].toInt32();
        console.log("malloc(" + this.size + ")");
    },
    onLeave: function (retval) {
        if (this.size === 21) {
            console.log("String allocated at: " + retval);
            try {
                console.log("String content: " + Memory.readUtf8String(retval));
            } catch (e) {
                console.log("Error reading string: " + e.message);
            }
        }
    }
});

var addressOfGenerateRandomString = ptr('0x401176');

Interceptor.attach(addressOfGenerateRandomString, {
    onEnter: function (args) {
        console.log("generateRandomString called with length: " + args[0]);
    },
    onLeave: function (retval) {
        console.log("generateRandomString returned string at: " + retval);
        console.log("String content: " + Memory.readUtf8String(retval));
    }
});
