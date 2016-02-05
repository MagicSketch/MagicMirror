var debug = function(arg) {
	log(arg);
}

var run = function(context) {
	//debug("run");
	log("run");

	var url = context.plugin.url()
	log(url);
	//var magicmirror = init(context);
	//[magicmirror showWindow];
}

var resourcesPath = function(context) {
	if ( ! context.plugin) {
		return "/Users/james/Library/Application Support/com.bohemiancoding.sketch3/Plugins/MagicMirror2/MagicMirror2.sketchplugin/Contents/Resources";
	}
	return context.plugin.url().path() + "/Contents/Resources/";
}

var loadFramework = function(frameworkName, directory){
	var mocha = Mocha.sharedRuntime();
	if ([mocha loadFrameworkWithName:frameworkName inDirectory:directory]) {
		debug("loadFramework: `" + frameworkName + "` success!");
		return true;
	}
	debug("loadFramework: `" + frameworkName + "` failed!");
	return false;
}

var initialize = function(context) {
	var path = resourcesPath(context);
	log("resource:" + path);
	if (NSClassFromString("MagicMirror") == null) {
		loadFramework("MagicMirror", path);
	}

	var context = [[SketchPluginContext alloc] initWithPlugin:context.plugin
													 document:context.document
												    selection:context.selection
													  command:context.command];

	var magicmirror = [MagicMirror sharedInstanceWithContext:context];
	return magicmirror;
}

var mirrorPage = function(context) {
	debug("mirrorPage");
	var magicmirror = initialize(context);
	[magicmirror mirrorPage];
}

var configureSelection = function(context) {
	debug("configureSelection");
	var magicmirror = initialize(context);
	[magicmirror configureSelection];
}

var artboards = function(context) {
	var magicmirror = initialize(context);
	log([magicmirror artboards]);
}

var licenseInfo = function(context) {
	var magicmirror = initialize(context);
	[magicmirror licenseInfo];
}

var selectedLayers = function(context) {
	var magicmirror = initialize(context);
	var layers = [magicmirror selectedLayers];
	log(layers);
}

var rotateSelection = function(context) {
	var magicmirror = initialize(context);
	[magicmirror rotateSelection];
}

var flipSelection = function(context) {
	var magicmirror = initialize(context);
	[magicmirror flipSelection];
}

var jumpSelection = function(context) {
	var magicmirror = initialize(context);
	[magicmirror jumpSelection];
}

var checkForUpdates = function(context) {
	var magicmirror = initialize(context);
	[magicmirror checkForUpdates];
}

var refresh = function(context) {
	var magicmirror = initialize(context);
	[magicmirror refreshPageOrSelection];
}
