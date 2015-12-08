var debug = function(arg) {
	log(arg);
}

var resourcesPath = function(context) {
	if ( ! context.plugin) {
		return "/Users/james/Library/Application Support/com.bohemiancoding.sketch3/Plugins/MagicMirror2/MagicMirror2.sketchplugin/Contents/Resources";
	}
	return context.plugin.url() + "/Contents/Resources/";
}

var loadFramework = function(frameworkName, directory){
	var mocha = Mocha.sharedRuntime();
	if ([mocha loadFrameworkWithName:frameworkName inDirectory:directory]) {
		debug("loadFramework: `" + frameworkName + "` success!");
		return true;
	}
	debug("loadFramework: `" + frameworkName + "` failed!");
	return false;
};

var init = function(context) {
	var path = resourcesPath(context);
	// if (NSClassFromString("MagicMirror") == null) {
		loadFramework("MagicMirror", path);
	// }

	var context = [[SketchPluginContext alloc] initWithPlugin:context.plugin
													 document:context.document
												    selection:context.selection
													  command:context.command];

	var magicmirror = [[MagicMirror alloc] initWithContext:context];
	return magicmirror;
}

var run = function(context) {
	debug("run");
	var magicmirror = init(context);
	[magicmirror showWindow];
}

var mirrorPage = function(context) {
	debug("mirrorPage");
	var magicmirror = init(context);
}