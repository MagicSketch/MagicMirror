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

// Maths

function getPercentage(string) {
    var array = string.match(/(\-?[0-9]+\.?[0-9]+)%/)
    if (array && array.length > 1) {
        return parseFloat(array[1]) / 100
    }
    return nil
}

function getNumber(string) {
    return parseFloat(string)
}

function getResultOf(original, offset) {
    if (getPercentage(offset)) {
        return original * getPercentage(offset)
    } else if (getNumber(offset)) {
        return original + getNumber(offset)
    } else {
        return 0
    }
}

// Strings

function replace(original, from, to) {
    var message = NSString.stringWithString(original)
    var result = message.stringByReplacingOccurrencesOfString_withString_(from, to);
    return result
}
