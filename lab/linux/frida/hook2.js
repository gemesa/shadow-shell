var targetAddresses = [];
var targetSize = 21;

Interceptor.attach(Module.getExportByName(null, 'malloc'), {
    onLeave: function (retval) {
        if (!retval.isNull()) {
            console.log("String allocated at: " + retval);
            targetAddresses.push(ptr(retval));
        }
    }
});


setInterval(function() {
    targetAddresses.forEach(function(address) {
        try {
            var currentData = Memory.readByteArray(address, targetSize);
            console.log("Data addr: " + address);
            console.log("Data size: " + targetSize);
            console.log("Data: ", currentData);
        } catch (e) {
            console.log("Error reading memory at " + address + ": " + e.message);
        }
    });
}, 200);
