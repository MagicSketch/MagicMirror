var count = function(array) {
    if (!array) return
    var count = 0
    if ( typeof(array.count) == "number") {
        count = array.count
    } else if (typeof(array.count) == "function") {
        count = array.count()
    } else if (typeof(array.length) == "number") {
        count = array.length
    } else if (typeof(array.length) == "function") {
        count = array.length()
    } 
    return count
}

var map = function(array, callback) {
    if (!array) return
    var values = []
    for (var i = 0; i < count(array); i++) {
        var value = array[i]
        values.push(callback(value))
    }
    return values
}

// Mavericks doesn't have for...of loop
var each = function(array, callback) {
    for (var i = 0; i < count(array); i++) {
        callback(array[i])
    }
}
