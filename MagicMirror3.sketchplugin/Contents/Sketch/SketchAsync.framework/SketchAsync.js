var SketchAsync_FrameworkPath = SketchAsync_FrameworkPath || COScript.currentCOScript().env().scriptURL.path().stringByDeletingLastPathComponent();
var SketchAsync_Log = SketchAsync_Log || log;
(function() {
 var mocha = Mocha.sharedRuntime();
 var frameworkName = "SketchAsync";
 var directory = SketchAsync_FrameworkPath;
 if (mocha.valueForKey(frameworkName)) {
 SketchAsync_Log("😎 loadFramework: `" + frameworkName + "` already loaded.");
 return true;
 } else if ([mocha loadFrameworkWithName:frameworkName inDirectory:directory]) {
 SketchAsync_Log("✅ loadFramework: `" + frameworkName + "` success!");
 mocha.setValue_forKey_(true, frameworkName);
 return true;
 } else {
 SketchAsync_Log("❌ loadFramework: `" + frameworkName + "` failed!: " + directory + ". Please define SketchAsync_FrameworkPath if you're trying to @import in a custom plugin");
 return false;
 }
 })();
