
@import 'Skinject.framework/Skinject.js'
@import 'MagicMirror3.framework/MagicMirror.js'
@import 'SketchAsync.framework/SketchAsync.js'
@import 'MagicMirrorUI.js'

var onStartup = function(context) {
    log("onStartup");

//    var async = SketchAsync.alloc().init()
//    async.runInBackground_callbackActionID_(function() {
//                                                log("1+1=2")
//                                            },
//                                            "SketchAsync.refresh")
//
}

var onOpenDocument = function(context) {
    log("onOpenDocument: " + context);

}


var onRefresh = function(context) {
    log("onRefresh");
}

var onFlip = function(context) {
    log("onFlip from onstartup.js");
}
