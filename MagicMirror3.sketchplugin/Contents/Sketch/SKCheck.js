
var dictify = function(json) {
    return JSON.stringify(json, null, '\t')
}

// Return 1 if a > b
// Return -1 if a < b
// Return 0 if a == b
function compare(a, b) {

    if (typeof a != typeof b) {
        return "warning"
    }

    if (a === b) {
        return 0;
    }

    var a_components = a.split(".");
    var b_components = b.split(".");

    var len = Math.min(a_components.length, b_components.length);

    // loop while the components are equal
    for (var i = 0; i < len; i++) {
        // A bigger than B
        if (parseInt(a_components[i]) > parseInt(b_components[i])) {
            return 1;
        }

        // B bigger than A
        if (parseInt(a_components[i]) < parseInt(b_components[i])) {
            return -1;
        }
    }

    // If one's a prefix of the other, the longer one is greater.
    if (a_components.length > b_components.length) {
        return 1;
    }

    if (a_components.length < b_components.length) {
        return -1;
    }

    // Otherwise they are the same.
    return 0;
}

var emojify = function(value) {
    switch (value) {
        case 1: return "⚠️";
        case 0, true: return "✅";
        case -1, false: return "❌";
        case "": return "";
        default: return "⚠️";
    }
}

var stringify = function(value) {
    return value + ""
}

var SKCheck = function(identifier) {
    var _version = 1.0;
    var _identifier = identifier;

    var validate = function(title, info, handler) {
        var passes = 0;
        var warnings = 0;
        var errors = 0;
        var ignores = 0;
        var count = 0;

        for (var key in info) {
            count++;
            if (info[key] instanceof Array) {
                var array = info[key];
                var response = {};
                for (var index in array) {
                    var name = array[index];
                    var intermediateResult = handler(key, name)
                    var result = intermediateResult;
                    if (intermediateResult == "class not exists") {
                        result = false;
                    }
                    response[name] = emojify(result);
                    switch (result) {
                        case 1: warnings++; break;
                        case 0, true: passes++; break;
                        case -1, false: errors++; break;
                        case "": ignores++; break;
                        default: warnings++; break;
                    }
                }
                info[key] = response;
            } else {
                var result = handler(key, info[key]);
                switch (result) {
                    case 1: warnings++; break;
                    case 0, true: passes++; break;
                    case -1, false: errors++; break;
                    case "": ignores++; break;
                    default: warnings++; break;
                }
                info[key] =  info[key] + emojify(result);
            }
        }

        var appendStats = function(value, emoji) {
            return (value ? emoji + " " + value + ", " : "")
        }
        var results = appendStats(passes, "✅") + appendStats(errors, "❌") + appendStats(warnings, "⚠️");
        log(title + "  " + results + dictify(info));
    }

    return {
    system: function(handler) {
        var info = {
            "OS Version": stringify([NSProcessInfo processInfo].operatingSystemVersionString()),
            "Sketch": stringify([[NSBundle mainBundle] objectForInfoDictionaryKey:"CFBundleShortVersionString"]),
            "Build": stringify([[NSBundle mainBundle] objectForInfoDictionaryKey:"CFBundleVersion"]),
        };
        validate("➡️ System Check", info, handler);
    },
    plugin: function(handler) {

        var _application = NSApplication.sharedApplication();
        var _delegate = _application.delegate();
        var _plugins = _delegate.pluginManager().plugins();
        var _plugin = _plugins[identifier];

        var _path = _plugin.url().copy().path()
        var info = {
        enabled: _plugin.isEnabled(),
        name: _plugin.name(),
        identifier: _plugin.identifier(),
        version: _plugin.version(),
        author: _plugin.author(),
        email: _plugin.authorEmail(),
        compatibleVersion: _plugin.compatibleVersion() + "",
        };

        validate("➡️ Plugin Check", info, handler);
    },
        class: function(signatures, handler) {

            validate("➡️ Classes Check", signatures, function(cls, method) {
                     var c = NSClassFromString(cls)

                     var sign = method[0];
                     var methodName = method.substring(1, method.length)

                     if (c != nil) {
                     switch(sign) {
                     case "-": return c.instancesRespondToSelector(methodName) == true;
                     case "+": return c.respondsToSelector(methodName) == true;
                     default: return "?";
                     }
                     } else {
                     return "class not exists";
                     }


                     });
        },
    };
};

