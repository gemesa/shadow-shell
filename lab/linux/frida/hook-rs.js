Interceptor.attach(Module.getExportByName(null, "malloc"), {
    onEnter: function (args) {
        console.log("malloc(" + args[0] + ")");
    },
    onLeave: function (retval) {
        console.log("malloc ret: " + retval)
    }
});

Interceptor.attach(Module.getExportByName(null, "calloc"), {
    onEnter: function (args) {
        console.log("calloc(" + args[0] + ")");
    },
    onLeave: function (retval) {
        console.log("calloc ret: " + retval)
    }
});

Interceptor.attach(Module.getExportByName(null, "realloc"), {
    onEnter: function (args) {
        console.log("realloc(" + args[0] + ", " + args[1] + ")");
    },
    onLeave: function (retval) {
        console.log("realloc ret: " + retval)
    }
});

Interceptor.attach(Module.getExportByName(null, "free"), {
    onEnter: function (args) {
        console.log("free(" + args[0] + ")");
    },
});

var moduleName = "hook";
var baseAddress = Module.getBaseAddress(moduleName);
console.log("base address: " + baseAddress);

var offsetOfHookmon = 0x9830;
var addressOfHookmon = baseAddress.add(offsetOfHookmon);

Interceptor.attach(addressOfHookmon, {
    onEnter: function (args) {
        console.log("hookmon called");
    },
});
