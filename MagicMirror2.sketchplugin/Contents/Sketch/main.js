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
	var basePath = NSString.stringWithFormat_(context.scriptPath)
	.stringByDeletingLastPathComponent()
	.stringByDeletingLastPathComponent()
	.stringByDeletingLastPathComponent()

	var plugin = context.plugin
	if ( ! basePath || ! plugin) {
		var _application = [NSApplication sharedApplication]
		var _delegate = _application.delegate()
		var _plugins = _delegate.pluginManager().plugins()
		var _plugin = _plugins["design.magicmirror"]
		var _path = _plugin.url().copy().path() + "/Contents/Resources"
		return _path
	}
	return basePath + "/Contents/Resources/";
}

var urlForResourceNamed = function(context, name) {
	return context.plugin.urlForResourceNamed_(name);
}

var loadFramework = function(frameworkName, directory){
	var mocha = Mocha.sharedRuntime();
	if ([mocha loadFrameworkWithName:frameworkName inDirectory:directory]) {
		debug("loadFramework: `" + frameworkName + "` success!");
		return true;
	}
	debug("❌  loadFramework: `" + frameworkName + "` failed!");
	return false;
}

var initialize = function(context) {

	try {
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

} catch (exception) {
	log("MM2: exception " + exception);
}
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
