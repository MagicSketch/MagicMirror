
var resourcesPath = function(context) {
	if ( ! context.plugin) {
		return "/Users/james/Library/Application Support/com.bohemiancoding.sketch3/Plugins/MagicMirror2/MagicMirror2.sketchplugin/Contents/Resources";
	}
	return context.plugin.url() + "/Contents/Resources/";
}

var loadFramework = function(frameworkName, directory){
	log("loadFramework: " + frameworkName);
	log("  in dir: " + directory);
	var mocha = Mocha.sharedRuntime();
	log("mocha: " + mocha);
	return [mocha loadFrameworkWithName:frameworkName inDirectory:directory];
};

var run = function(context) {
	log("run");
	var path = resourcesPath(context);
	if (NSClassFromString("MagicMirror") == null) {
		if ( ! loadFramework("MagicMirror", path)) {
			log("loadFramework failed");
		}
	}

    // If I remove this the window disappears immediately after the plugin gets executed
    // coscript.setShouldKeepAround(true);
    log(coscript);

	var magicmirror = [[MagicMirror alloc] initWithPlugin:context.plugin
												 document:context.document
											    selection:context.selection
												  command:context.command];
	[magicmirror showWindow]

	log(context.command.session());
}
