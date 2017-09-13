
@import 'Skinject.framework/Skinject.js'
@import 'MagicMirror3.framework/MagicMirror.js'
@import 'SketchAsync.framework/SketchAsync.js'
@import 'MagicMirrorUI.js'

var onStartup = function(context) {
    dlog("onStartup");

//    var async = SketchAsync.alloc().init()
//    async.runInBackground_callbackActionID_(function() {
//                                                dlog("1+1=2")
//                                            },
//                                            "SketchAsync.refresh")
//
}

var onOpenDocument = function(context) {
    dlog("onOpenDocument: " + context);

}


var onRefresh = function(context) {
    dlog("onRefresh");
}

var onFlip = function(context) {
    dlog("onFlip from onstartup.js");
}
