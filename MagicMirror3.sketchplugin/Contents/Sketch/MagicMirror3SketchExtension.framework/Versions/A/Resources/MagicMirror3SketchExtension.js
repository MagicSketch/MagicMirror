/*
// To load this framework, replace the onRun method in your script.cocoscript

@import 'MagicMirror3SketchExtension.framework/MagicMirror3SketchExtension.js'

var onRun = function(context) {
   var obj = MagicMirror3SketchExtension.alloc().init()
   var uppercase = obj.uppercaseString("hello world")

   log(uppercase);
   context.document.showMessage(uppercase);
}
*/

var MagicMirror3SketchExtension_FrameworkPath = MagicMirror3SketchExtension_FrameworkPath || COScript.currentCOScript().env().scriptURL.path().stringByDeletingLastPathComponent();
var MagicMirror3SketchExtension_Log = MagicMirror3SketchExtension_Log || log;
(function() {
 var mocha = Mocha.sharedRuntime();
 var frameworkName = "MagicMirror3SketchExtension";
 var directory = MagicMirror3SketchExtension_FrameworkPath;
 if (mocha.valueForKey(frameworkName)) {
MagicMirror3SketchExtension_Log("😎 loadFramework: `" + frameworkName + "` already loaded.");
 return true;
 } else if ([mocha loadFrameworkWithName:frameworkName inDirectory:directory]) {
 MagicMirror3SketchExtension_Log("✅ loadFramework: `" + frameworkName + "` success!");
 mocha.setValue_forKey_(true, frameworkName);
 return true;
 } else {
 MagicMirror3SketchExtension_Log("❌ loadFramework: `" + frameworkName + "` failed!: " + directory + ". Please define MagicMirror3SketchExtension_FrameworkPath if you're trying to @import in a custom plugin");
 return false;
 }
 })();
