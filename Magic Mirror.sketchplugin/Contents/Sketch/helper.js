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

var contains = function(array, object) {
    return array.indexOf(object) != -1
}

var merge = function(obj1, obj2){
    var obj3 = {};
    for (var attrname in obj1) { obj3[attrname] = obj1[attrname]; }
    for (var attrname in obj2) { obj3[attrname] = obj2[attrname]; }
    return obj3;
}

var join = function(object, separator, string) {
    var result = ""
    for (var key in object) {
        var value = object[key]
        result += key + separator + value + string
    }
    return result
}