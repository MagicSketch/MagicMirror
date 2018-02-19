/*
// To load this framework, add the following code in your manifest.json

"commands": [
:
:
{
    "script" : "MagicMirror3Panel.framework/MagicMirror3Panel.js",
    "handlers" : {
        "actions" : {
            "Startup" : "onStartup",
            "OpenDocument":"onOpenDocument",
            "SelectionChanged.finish" : "onSelectionChanged"
        }
    }
}
]
*/

var onStartup = function(context) {
  var MagicMirror3Panel_FrameworkPath = MagicMirror3Panel_FrameworkPath || COScript.currentCOScript().env().scriptURL.path().stringByDeletingLastPathComponent().stringByDeletingLastPathComponent();
  var MagicMirror3Panel_Log = MagicMirror3Panel_Log || log;
  (function() {
    var mocha = Mocha.sharedRuntime();
    var frameworkName = "MagicMirror3Panel";
    var directory = MagicMirror3Panel_FrameworkPath;
    if (mocha.valueForKey(frameworkName)) {
      MagicMirror3Panel_Log("😎 loadFramework: `" + frameworkName + "` already loaded.");
      return true;
    } else if ([mocha loadFrameworkWithName:frameworkName inDirectory:directory]) {
      MagicMirror3Panel_Log("✅ loadFramework: `" + frameworkName + "` success!");
      mocha.setValue_forKey_(true, frameworkName);
      return true;
    } else {
      MagicMirror3Panel_Log("❌ loadFramework: `" + frameworkName + "` failed!: " + directory + ". Please define MagicMirror3Panel_FrameworkPath if you're trying to @import in a custom plugin");
      return false;
    }
  })();
};

var onSelectionChanged = function(context) {
    var identifier = context.plugin.valueForKey("_identifier");
    var disabledIdentifier = identifier + ".disabled";
    var isDisabled = NSUserDefaults.standardUserDefaults().boolForKey(disabledIdentifier);
    
    if (isDisabled){
        return false;
    }
    MagicMirror3Panel.onSelectionChanged(context);
};

var enable = function(context) {
        var identifier = context.plugin.valueForKey("_identifier");
        var disabledIdentifier = identifier + ".disabled";
        NSUserDefaults.standardUserDefaults().setBool_forKey(false, disabledIdentifier);
        NSUserDefaults.standardUserDefaults().synchronize();
        
        //context.document.reloadInspector();
        var panel = MagicMirror3Panel.getSharedInstance(context);
        panel.track("Enabled MagicMirror");
        panel.onSelectionChange([]);
        
        context.document.showMessage("Magic Mirror 3 Enabled");
};

var disable = function(context) {
    var identifier = context.plugin.valueForKey("_identifier");
    var disabledIdentifier = identifier + ".disabled";
    NSUserDefaults.standardUserDefaults().setBool_forKey(true, disabledIdentifier);
    NSUserDefaults.standardUserDefaults().synchronize();
    
    //context.document.reloadInspector();
    var panel = MagicMirror3Panel.getSharedInstance(context);
    panel.track("Disabled MagicMirror");
    
    var stacks = context.document.inspectorController().currentController().stackView().sectionViewControllers();
    
    for(var i=0; i<stacks.length; i++){
        if(stacks[i].isKindOfClass(MagicMirror3PanelSketchPanel)){
            context.document.inspectorController().currentController().stackView().sectionViewControllers().splice(i, 1);
            context.document.inspectorController().currentController().stackView().reloadSubviews();
            break;
        }
    }
    
    
    context.document.showMessage("Magic Mirror 3 Disabled");
};

var refreshAll = function(context){
    var identifier = context.plugin.valueForKey("_identifier");
    var disabledIdentifier = identifier + ".disabled";
    var isDisabled = NSUserDefaults.standardUserDefaults().boolForKey(disabledIdentifier);
    
    if (isDisabled){
        context.document.showMessage("Please enable Magic Mirror 3 first");
        return false;
    }
    
    var panel = MagicMirror3Panel.getSharedInstance(context);
    if(panel){
        panel.track("Refresh All From Menu");
        panel.refreshAll();
        context.document.showMessage("Artboards refreshed");
    }
}
