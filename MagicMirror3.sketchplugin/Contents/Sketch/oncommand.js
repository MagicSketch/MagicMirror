@import 'Skinject.framework/Skinject.js'
@import 'MagicMirror3.framework/MagicMirror.js'
@import 'onchange.js'
@import 'MagicMirrorUI.js'

var enable = function(context) {
    //    context.command.setValue_forKey_onDocument_(1, "enable", context.document.documentData());

    COScript.currentCOScript().setShouldKeepAround_(true);



    var identifier = context.plugin.valueForKey("_identifier");
    var disabledIdentifier = identifier + ".disabled";
    NSUserDefaults.standardUserDefaults().setBool_forKey(false, disabledIdentifier);
    NSUserDefaults.standardUserDefaults().synchronize();

    var magicmirror = dispatch_once_per_document("MagicMirrorJS", function() { return MagicMirrorJS(identifier) });
    var skinject = dispatch_once_per_document("Skinject", function() { return Skinject(identifier) });
    magicmirror.onRun(context);
    skinject.onRun(context);

    magicmirror.trackForEvent("Enabled MagicMirror", {});

    context.document.reloadInspector()
    onCurrentSelection(context, true);

    var document = context.document || context.actionContext.document;
    document.showMessage("Magic Mirror 3 Enabled");

};

var disable = function(context) {
    //    context.command.setValue_forKey_onDocument_(0, "enable", context.document.documentData());
    var identifier = context.plugin.valueForKey("_identifier");
    var disabledIdentifier = identifier + ".disabled";
    NSUserDefaults.standardUserDefaults().setBool_forKey(true, disabledIdentifier);
    NSUserDefaults.standardUserDefaults().synchronize();

    //    if(NSClassFromString("MagicMirror3") != null){
    //        var magicmirror = MagicMirrorJS(identifier);
    //        magicmirror.trackForEvent("Executed Disable MagicMirror", {});
    //    }

    var magicmirror = dispatch_once_per_document("MagicMirrorJS", function() { return MagicMirrorJS(identifier) });
    var skinject = dispatch_once_per_document("Skinject", function() { return Skinject(identifier) });
    magicmirror.onRun(context);
    skinject.onRun(context);

    magicmirror.trackForEvent("Disabled MagicMirror", {});

    context.document.reloadInspector()

    var document = context.document || context.actionContext.document;
    document.showMessage("Magic Mirror 3 Disabled");
};
