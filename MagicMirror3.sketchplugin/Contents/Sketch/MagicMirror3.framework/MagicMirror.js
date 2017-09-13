//@import '../SKCheck.js'

var NSMakeRect = function(origin, size) {
    return NSRectFromString("{" + NSStringFromPoint(origin) + "," + NSStringFromSize(size) + "}");
}

var CGRectEqualsToRect = function(rect1, rect2) {
    return NSStringFromRect(rect1).isEqual(NSStringFromRect(rect2));
}
// Utilities
var count = function(array) {
    if (array instanceof Array) {
        return array.length;
    } else if (typeof array == 'object' && [array isKindOfClass:[NSArray class]]) {
        return array.count();
    }
    return -1;
}
var each = function(array, handler) {
    var count = array.count ? array.count() : array.length;     // Both NSArray and javascript array
    for (var i = 0; i < count; i++) {
        var layer = array[i];
        handler(layer, i);
    }
}
var map = function(array, handler) {
    var newArray = [NSMutableArray array];
    each(array, function(item) {
         var object = handler(item);
         if (object) {
         newArray.addObject(object);
         }
         });
    return newArray.copy();
}
var filter = function(array, handler) {
    var newArray = [NSMutableArray array];
    each(array, function(item) {
         if (handler(item)) {
             newArray.addObject(item);
         }
    });
    return newArray.copy();
}
var enumerate = function(object, handler) {     // everything in nested array
    if (typeof object === "Array" || object.isKindOfClass(NSArray)) {
        each(object, function(item) {
             enumerate(item, handler);
        });
    } else {
        handler(object);
    }
};
var isNullOrNil = function(value) {
    if (value && [value isKindOfClass:NSNull]) {
//        log("artboardID is null")
        return true
    } else if (value) {
  //      log("artboardID is not nil")
        return false
    }
    return true
}

var mixedComparison = function(last, num, mixed, initial) {
    if (last == initial) {
        return num;
    } else if (num == initial) {
        return last;
    } else if (last != num) {
        return mixed;
    } else {
        return last;
    }
}

var reduce = function(array, handler, optMixed, optInitial) {
    var initial = optInitial || null;
    var mixed = optMixed || -1;
    var last = initial;
    each(array, function(item) {
         last = handler(last, item, mixed, initial)
         });
    return last;
}

var Class = function(className, BaseClass, selectorHandlerDict){
    var uniqueClassName = className + NSUUID.UUID().UUIDString();
    var delegateClassDesc = MOClassDescription.allocateDescriptionForClassWithName_superclass_(uniqueClassName, BaseClass);

    for (var selectorString in selectorHandlerDict) {
        delegateClassDesc.addInstanceMethodWithSelector_function_(selectorString, selectorHandlerDict[selectorString]);
    }
    delegateClassDesc.registerClass();

    return NSClassFromString(uniqueClassName);
};

var timer = function(name) {
    var _start;
    var _time = 0;
    var _startedCount = 0;
    var _stoppedCount = 0;
    var _labs = [];
    var _lastLab;
    var _state = "init";

    var self = {
        getElapsed: function() { return this.elapsed },
    getLap: function(name) {
        var thatLap = {};
        each(_labs, function(lap) {
             if (lap.name == name) {
                 thatLap = lap;
             }
             });
        return thatLap;
    },
        reloadData: function() {
            this.name = name;
            this.elapsed = _time + "ms";
            this.startedCount = _startedCount;
            this.stoppedCount = _stoppedCount;
            this.state = _state;
            this.labs = _labs;
        },
        lab: function(name) {
            var lastMark = _start;
            var timeStamp = new Date();
            if (_lastLab) {
                lastMark = _lastLab.timeStamp;
            }
            var lab = {
                timeStamp: timeStamp,
                name: name,
                mark: timeStamp.getTime() - _start.getTime() + "ms",
                elapsed: timeStamp.getTime() - lastMark.getTime() + "ms",
            };
            _labs.push(lab);
            _lastLab = lab;
            this.reloadData();
        },
        start: function() {
             if (_state == "started") {
                return this;
             }
             _state = "started";
             _startedCount++;
             _start = new Date();
             this.reloadData();
             return this;
        },
        stop: function() {
             if (_state == "stopped") {
                return this;
             }
            _state = "stopped";
            _stoppedCount++;
            var end  = new Date();
            var time = end.getTime() - _start.getTime();
            _time += time;
            this.print();
            this.reloadData();
            return time;
        },
        print: function() {
          log('Timer: ' + name + ' finished in ' + _time + 'ms');
        }
    }

    self.reloadData();
    return self;
};

//

// Sketch Helpers
var isEqual = function (first, second) {
    if (typeof first !== typeof second) {
        return false
    }
    var tree = MSTreeDiff.alloc().initWithFirstObject_secondObject_(first, second);
    return tree.diffs().count() == 0
}
//

var MagicMirrorJS = function(identifier) {

    var _pluginIdentifier = identifier;
    var _buildIdentifier = identifier + ".lastBuild"
    var _migrationIdentifier = identifier + ".lastMigration"    // build number

    var _context, _document, _command;
    var _artboards, _artboardsLookupByName, _enabledArtboardIDs;

    var _layerIterator, _flattener;
    var _licenseManager;
    var _versionChecker, _checkerDelegate;

    var dlog = function(message) {
        log(identifier + ": " + message);
    }

    var pluginBundle = function(identifier) {
        var _application = NSApplication.sharedApplication();
        var _delegate = _application.delegate();
        var _plugins = _delegate.pluginManager().plugins();
        var _plugin = _plugins[identifier];
        return _plugin;
    }

    var manifestForIdentifier = function(identifier) {
        var bundle = pluginBundle(identifier);
        var manifestPath = NSURL.fileURLWithPath(bundle.url().path() + "/Contents/Sketch/manifest.json");
        var data = NSData.dataWithContentsOfFile(manifestPath)
        var json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]
        return json;
    }

    var sketchPath = function() {
        var _application = NSApplication.sharedApplication();
        var _delegate = _application.delegate();
        var _plugins = _delegate.pluginManager().plugins();
        var _plugin = _plugins[_pluginIdentifier];
        var _path = _plugin.url().copy().path() + "/Contents/Sketch";
        return _path;
    };

    var resourcePath = function() {
        var _application = NSApplication.sharedApplication();
        var _delegate = _application.delegate();
        var _plugins = _delegate.pluginManager().plugins();
        var _plugin = _plugins[_pluginIdentifier];
        var _path = _plugin.url().copy().path() + "/Contents/Resources";
        return _path;
    };

    var loadFramework = function(name) {
        var mocha = Mocha.sharedRuntime();
        var frameworkName = name || "MagicMirror3";
        var directory = sketchPath();

        if ([mocha loadFrameworkWithName:frameworkName inDirectory:directory]) {
            dlog("loadFramework: `" + frameworkName + "` success!");
            return true;
        } else {
            dlog("❌  loadFramework: `" + frameworkName + "` failed!: " + directory);
            return false;
        }
    }

    var getArtboards = function() {
        var artboards = _document.valueForKeyPath("pages.artboards").valueForKeyPath("@unionOfArrays.self").mutableCopy()
        var slices = _document.allExportableLayers()
        for (var i = 0; i < slices.count(); i++) {
            var slice = slices[i];
            if ([slice isKindOfClass:MSSliceLayer]) {
                artboards.addObject(slice);
            }
        }
        return artboards;
    }

    var loadDependancy = function() {
        _layerIterator = dispatch_once("MM3LayerIterator", function () { return [[MM3LayerIterator alloc] init]; });
        _magicmirror = dispatch_once("MagicMirror3", function () { return [[MagicMirror3 alloc] init]; });
        _imageTransform = [[MM3ImageTransform alloc] init];
        _mmshape = [[MM3Shape alloc] init];
        _flattener = dispatch_once_per_document("MSLayerFlattener", function () { return [[MSLayerFlattener alloc] init]; });
        _licenseManager = dispatch_once("MM3LicenseManager", function () {
                                        return MM3LicenseManager.alloc()["initWithIdentifier:"](_pluginIdentifier);
                                        });
        _checkerDelegate = dispatch_once("MM3VersionCheckerDelegate", function() {
                                            return Class("MM3VersionCheckerDelegate", NSObject, {
                                                  "checkerDidFinish:":function(checker) {
                                                      if (checker.success()) {
                                                          if ( ! checker.isExpired()) {
                                                                 _document.showMessage(checker.name() + " Version Checked ✅");
                                                          } else {
                                                                 _document.showMessage(checker.name() + " Version Expired ❌");
                                                          }
                                                      } else {
                                                             _document.showMessage(checker.name() + " Version Check Failed ⚠️");
                                                      }
                                                  }
                                                  }).alloc().init();
                                         });
        _runtimePluginBuild = dispatch_once("MM3Build", function() { return manifestForIdentifier(_pluginIdentifier).build; });
        _versionChecker = dispatch_once("MM3VersionChecker", function() {
            var checker = MM3VersionChecker.checkerWithIdentifier_name_(identifier, _magicmirror.pluginName());
            checker.delegate = _checkerDelegate;
            return checker;
        });
        _artboards = getArtboards();
        _artboardsLookupByName = NSDictionary.dictionaryWithObjects_forKeys_(_artboards, _artboards.valueForKeyPath("name"));
        _artboardsLookupByID = NSDictionary.dictionaryWithObjects_forKeys_(_artboards, _artboards.valueForKeyPath("objectID"));
        _enabledArtboardIDs = [NSMutableSet set];

        var app = [MSDocument currentDocument];
        var perDocId = app + "-" + identifier;
        _linkedArtboardsIdentifier = perDocId + ".linkedArtboardIDs";
    }


    // Migrations

    var lastBuild = (function() {
                     var build = NSUserDefaults.standardUserDefaults().objectForKey(_buildIdentifier);
                         if ( ! build && NSUserDefaults.standardUserDefaults().objectForKey(_pluginIdentifier + ".deviceId")) {
                            return 1;
                         }
                         return build;
                     })();

    var lastSuccessfulMigrationBuild = (function() {
                                        var build = NSUserDefaults.standardUserDefaults().objectForKey(_migrationIdentifier);
                                        return build;
                                   })();
    
    var currentBuild = (function() {
                        return manifestForIdentifier(_pluginIdentifier).build
                        })();

    var migrations = [      // key is build
            {
                      build: 1,
                      description: "alising identified users",
                      apply: function() {
                        // Do all migrations here
                          return true; // after implementation change return to true
                      }
            },
    ];

    var toMigrate = function(migrations, lastBuild, currentBuild) {
        var todo = []
        each(migrations, function(migration) {
             var build = migration.build;
             if (build < currentBuild && build >= lastBuild) {
                 todo.push(migration)
             }
             });
        return todo
    }

    var doMigration = function(migrations) {
        var haveFails = false;
        each(migrations, function(migration) {
             log("applying migration (" + migration.build + "): " + migration.description);
                 var success = migration.apply();
                 if (success) {
                     [NSUserDefaults standardUserDefaults].setObject_forKey_(migration.build, _migrationIdentifier);
                     [NSUserDefaults standardUserDefaults].synchronize();
                     log("migration completed (" + migration.build + "): ✅");
                 } else {
                     log("migration failed (" + migration.build + "): ❌");
                     haveFails = true;
                     return;
                 }
             });
        log("finish doMigration");
        return ! haveFails;
    }
    // End of Migrations


    //
    // Maths
    //
    var areaOfBounds = function(rect) {
        var origin = rect.origin;
        var size = rect.size;
        var width = size.width - origin.y;
        var height = size.height - origin.x;
        return width*height;
    }
    var areaOfTriangle = function(side1, side2, side3) {
        var perimeter = (side1 + side2 + side3)/2;
        var area = Math.sqrt(perimeter*((perimeter-side1)*(perimeter-side2)*(perimeter-side3)));
        return area;
    }
    var distance = function(p1, p2) {
        var distance = Math.sqrt(Math.pow(p2.x - p1.x, 2) + Math.pow(p2.y - p1.y, 2));
        return distance;
    }
    var areaOfRectangle = function(points) {
        var p0 = NSPointFromString(points[0]);
        var p1 = NSPointFromString(points[1]);
        var p2 = NSPointFromString(points[2]);
        var p3 = NSPointFromString(points[3]);
        var tri1 = {
        side1: distance(p0, p1),
        side2: distance(p1, p2),
        side3: distance(p2, p0)
        };
        var tri2 = {
        side1: distance(p2, p3),
        side2: distance(p3, p0),
        side3: distance(p0, p2)
        };
        var area1 = areaOfTriangle(tri1.side1, tri1.side2, tri1.side3)
        var area2 = areaOfTriangle(tri2.side1, tri2.side2, tri2.side3);
        return area1 + area2;
    }
    var targetScale = function(source, destination) {
        return destination / source;
    }
    //
    // End of Maths
    //

    // Utilities

    var getMasterSymbol = function(instance) {

        var getAllSymbols = function() {
            return _document.documentData().allSymbols();
        };

        var masterContainsInstance = function(master, instance) {
            var allInstances = master.allInstances();
            //     log("master: " + master.objectID())
            for (var i = 0; i < allInstances.length; i++) {
                var s = allInstances[i];
                //         log("child: " + s.objectID())
                if (s.objectID() == instance.objectID()) {
                    return 1;
                }
            }
            return 0;
        };

        var symbols = getAllSymbols();
        //    log(symbols.length)
        var master;

        for (var i = 0; i < symbols.length; i++) {
            var s = symbols[i];
            if (masterContainsInstance(s, instance)) {
                master = s;
            }
        }
        
        return master;
    };

    var disableFillImageOnLayer = function(layer) {
        var fills = layer.style().fills()
        for (var i = 0; i < fills.count(); i++) {
            var f = fills[i];
            if (f.fillType() == 4 && f.isEnabled() == 1) {
                f.setIsEnabled(false);
                break;
            }
        }
    }

    var fillImageOnLayer = function(layer, image) {
        log("var fillImageonLayer");
        var fills = layer.style().fills()
        var fill = nil;

        for (var i = 0; i < fills.count(); i++) {
            var f = fills[i];
            if (f.fillType() == 4 && f.isEnabled() == 1) {
                fill = f;
                break;
            }
        }

        if ( ! fill) {
            fill = layer.style().addStylePartOfType(0);
            [fill setFillType:4];
            [fill setPatternFillType:1];
            [fill setIsEnabled:true];
        }

        var data = [[MSImageData alloc] initWithImage:image convertColorSpace:false];
        [fill setImage:data];
    };

    var generateImage = function(layer, scale) {
        var flattener = _flattener;
        var array = MSLayerArray.arrayWithLayer(layer)
        var page = layer.parentPage()
        var document = _document.documentData().immutableModelObject()
        var impage = page.immutableModelObject()


        var request = nil;
        if ([layer isKindOfClass:MSSliceLayer]) {
            request = _document.exportRequestForArtboardOrSlice(layer);
        } else {
            request = [flattener exportRequestFromLayers:array immutablePage:impage immutableDoc:document];
        }
        request.scale = scale;


//        request.includedLayerIDs = [NSMutableSet setWithArray:layer.parentArtboard().layers().valueForKeyPath("objectID")];
//        log("ids: " + request.includedLayerIDs());

        var renderer = [MSExportRendererWithSVGSupport exporterForRequest:request colorSpace:[NSColorSpace sRGBColorSpace]];
        var image = renderer.image()
//        var scaledImage = MM3Image.scaleImage_size_(image, size);
        return image;
    }

    var getCurvePointsFromLayer = function(layer) {
        if (layer.isKindOfClass(MSShapeGroup)) {
            var shapePathLayer = layer.layers()[0]
            var curvePoints = shapePathLayer.allCurvePoints().valueForKeyPath("point");
            return curvePoints
        }
        return [NSArray array];
    }

    var isClockwised = function(points) {
        return MM3Shape.pointsAreClockwised(points);
    }

    var getPointsFromLayer = function(layer) {
        log("getPointsFromLayer: " + layer);
        if (typeof layer === 'object' && ! layer.isKindOfClass(MSShapeGroup)) {
            var bounds = layer.bounds()
            var points = [
                          "{" + bounds.origin.x + "," + bounds.origin.y + "}",
                          "{" + bounds.size.width + "," + bounds.origin.y + "}",
                          "{" + bounds.size.width + "," + bounds.size.height + "}",
                          "{" + bounds.origin.x + "," + bounds.size.height + "}",
                          ];

//            log("points: " + points);
            return NSArray.arrayWithArray(points);
        }

        var selectionRect = function(layer) {
            return layer.bounds();
        }

        var straightPoints = function(layer, childIndex) {
            var shapePathLayer = layer.layers()[childIndex]
            var curvePoints = shapePathLayer.allCurvePoints()
            var rect = selectionRect(layer);
            var size = rect.size;
            var origin = rect.origin;
            var points = [NSMutableArray array];
            for (var i = 0; i < curvePoints.count(); i++) {
                var point = curvePoints[i].point();
                var x = point.x * size.width + origin.x;
                var y = point.y * size.height + origin.y;

                point = "{" + x + "," + y + "}"
                points.addObject(point);
            }

            return points;
        }

        return straightPoints(layer, 0);

    }

    var findLayer = function(layerID) {
        return _document.documentData().layerWithID(layerID);
    };

    var validateLayer = function(mslayer) {
//        var shape = mslayer.layers().firstObject();
//        return false;
        var points = getPointsFromLayer(mslayer);

        if ( ! mslayer.isKindOfClass(MSShapeGroup)) {
            return false;
        }

        if (points.count() != 4) {
            return false;
        }

        if (mslayer.isLocked()) {
            return false;
        }

        if ( ! mslayer.isVisible()) {
            return false;
        }

        // 3.0.2: Show menu for mask layer
//        if (mslayer.hasClippingMask()) {
//            return false;
//        }

        return true;
    }

    var layerHasLinked = function(mslayer) {
        if (mslayer.isKindOfClass(MSShapeGroup)) {
            var artboardID = getPotentiallyLinkedArtboardID(mslayer);
            if (isNullOrNil(artboardID)) {
                return false;
            }
        } else {
            return false;
        }
        return true;
    }

    var symbolizeLayers = function(array, symbolInstance) {
        layers = [NSMutableArray array];


//        log("symbolizeLayers: count(array)" + count(array) + " symbolInstance: " + symbolInstance);
//        log("array: " + array);
        for (var i = 0; i < count(array); i++) {
            var layer = array[i];
            var dict = {}
            dict.symbolInstanceID = symbolInstance.objectID()
            dict.objectID = layer.objectID
            dict.previewImages = layer.previewImages
            dict.name = layer.name
            dict.bounds = layer.bounds;
            layers.addObject(dict);
        }
        return layers;
    }

    var getEffectiveLayers = function(selection, forceRecursive) {
        var mslayer = selection;
        if (selection && [selection isKindOfClass:NSArray]) {
            log("getEffectiveLayers: array selection " + selection);
            var all = [NSMutableArray array];
            for (var i = 0; i < selection.count(); i++) {
                var layer = selection[i];
                var effective = nil;

                var snapshot = remind(layer.objectID() + ".snapshot")
                if ( ! snapshot || isEqual(snapshot, layer.immutableModelObject())) {
                    effective = remind(layer.objectID() + ".effectiveLayer");
                } else {
                }

                var equals = isEqual(snapshot, layer.immutableModelObject());
                if ( ! effective || ! equals) {
                    effective = getEffectiveLayers(layer, forceRecursive);
                    remember(effective, layer.objectID() + ".effectiveLayer");
                    remember(layer.immutableModelObject(), layer.objectID() + ".snapshot");
                }

                all.addObjectsFromArray(effective);
            }
            return all
        } else if (mslayer && [mslayer isKindOfClass:MSShapeGroup]) {
//            log("getEffectiveLayers: shapegroup: " + mslayer.name() + " isvalid? " + validateLayer(mslayer));
            return validateLayer(mslayer) ? [NSArray arrayWithObject:mslayer] : [];
        } else if (mslayer && [mslayer isKindOfClass:MSSymbolMaster]) {
//            log("getEffectiveLayers: master: " + mslayer.name());

            var children = mslayer.children()

            log("getEffectiveLayers: master: " + mslayer.name() + " " + children);
            var all = [NSMutableArray array];
            for (var i = 0; i < children.count(); i++) {
                var layer = children[i];
                if (layer.objectID().isEqual(mslayer.objectID())) {
                    continue;
                }
//                var effective = getEffectiveLayers(layer);
//
                if (validateLayer(layer) || layerHasLinked(layer)) {
                    all.addObject(layer);
                }

//                all.addObjectsFromArray(effective);
            }
            return all;
        } else if (mslayer && [mslayer isKindOfClass:MSArtboardGroup]) {

            if ( ! forceRecursive) {
                log("getEffectiveLayers: not recursive");
                return [NSArray array];
            } else {
                log("getEffectiveLayers: recursive");

                var children = mslayer.layers()
                log("getEffectiveLayers: recursive: children " + children);
                var all = [NSMutableArray array];
                for (var i = 0; i < children.count(); i++) {
                    var layer = children[i];

                    if (layer.objectID().isEqual(mslayer.objectID())) {
                        continue;
                    }

                    var effective = getEffectiveLayers(layer);
//                    effective = map(effective, function(e) {
//                                    return layerHasLinked(e) ? e : nil;
//                                    });
                    all.addObjectsFromArray(effective);
                }
                return all;

                log("getEffectiveLayers: artboard test");
                return [NSArray array];
            }
        } else if (mslayer && [mslayer isKindOfClass:MSSymbolInstance]) {
            log("getEffectiveLayers: symbolinstance: " + mslayer.name());
            var master = getMasterSymbol(mslayer);
            var effective = getEffectiveLayers(master, forceRecursive);
            log("getEffectiveLayers: symbolinstance: effective " + effective);
            var layers = symbolizeLayers(effective, mslayer);
            return layers;
        } else if (mslayer && [mslayer isKindOfClass:MSLayerGroup]) {
//            log("getEffectiveLayers: group: " + mslayer.name());
            var children = mslayer.children()
            var all = [NSMutableArray array];

            return all;   // no search inside group

            for (var i = 0; i < children.count(); i++) {
                var layer = children[i];
                if (layer.objectID().isEqual(mslayer.objectID())) {
                    continue;
                }

                if (validateLayer(layer) && layerHasLinked(layer)) {
                    all.addObject(layer);
                } else if (layer.isKindOfClass(MSSymbolInstance)) {
                    all.addObjectsFromArray(getEffectiveLayers(layer));
                }
            }
            return all;

        } else if (mslayer && [mslayer isKindOfClass:MSShapePathLayer]) {
//            log("getEffectiveLayers: shapepathlayer: " + mslayer.name());
            var parent = mslayer.ancestors().lastObject();
            return validateLayer(parent) ? [parent] : []
        }
        return [NSArray array]
    }

    var getPotentiallyLinkedArtboardID = function(layer) {
        var artboardID_mm2_name = _command.valueForKey_onLayer_forPluginIdentifier("source", layer, "design.magicmirror") // mm1;
        var artboardID = self.valueForLayer("artboardID", layer);
        var artboardID2 = nil;
        if (artboardID_mm2_name) {
//            log("artboardLookup:" + _artboardsLookupByName);
            artboardID2 = ! isNullOrNil(_artboardsLookupByName[artboardID_mm2_name]) ? _artboardsLookupByName[artboardID_mm2_name].objectID() : nil;
//            log("artboardLookup: artboardID2" + artboardID2);
        }
//        log("artboardLookup: artboardID" + artboardID);

        return artboardID || artboardID2;
    }

    var getLayerInfo = function(layer, symbol) {

        var info = [NSMutableDictionary dictionary];

        var artboardID_mm2_name = _command.valueForKey_onLayer_forPluginIdentifier("source", layer, "design.magicmirror");

        info["objectID"] = layer.objectID();
        info["class"] = layer.className();
        info["imageQuality"] = self.imageQuality(layer);
        info["needsPro"] = false;

        info["artboardID"] = self.valueForLayer("artboardID", layer);

        if (artboardID_mm2_name) {
            info["artboardID_mm2"] = ! isNullOrNil(_artboardsLookupByName[artboardID_mm2_name]) ? _artboardsLookupByName[artboardID_mm2_name].objectID() : nil;
        }

        info["getPotentiallyLinkedArtboardID"] = getPotentiallyLinkedArtboardID(layer);

        if (info["imageQuality"] >= 2) {
            info["needsPro"] = true;
            info["needsProReason"] = "Image Quality @2x or above is a Pro feature.";
        }

        if (info["artboardID"]) {
            var parent = findLayer(info["artboardID"]);

            if (isNullOrNil(parent)) {

            } else if (parent.isKindOfClass(MSSliceLayer)) {
                info["needsPro"] = true;
                info["needsProReason"] = "Using Slice as the source is a Pro feature.";
            }
        }

        if (symbol) {
            info["needsPro"] = true;
            info["needsProReason"] = "Symbol perspective overrides is a Pro feature.";
        }

        if (layer.isKindOfClass(MSArtboardGroup)) {
            info["isIncluded"] = self.isIncluded(layer);
        }

        if (layer.isKindOfClass(MSSliceLayer)) {
            info["isIncluded"] = self.isIncluded(layer);
        }

        if (layer.isKindOfClass(MSSymbolInstance)) {
            var overrides = self.valueForLayer("overrides", layer);
            info["symbolInstanceOverrides"] = overrides;
            var overrides2 = layer.overrides();
            info["symbolMasterOverrides"] = overrides2;
            info["needsPro"] = true;
            info["needsProReason"] = "Symbol perspective overrides is a Pro feature.";
        }

        var points = getPointsFromLayer(layer);
        _mmshape.scale = self.imageQuality(layer) || 1;
        _mmshape.path = points;
        _mmshape.bounds = layer.bounds();
        info["bounds"] = NSStringFromRect(layer.bounds());
        info["points"] = getPointsFromLayer(layer).componentsJoinedByString(", ");
        info["crop"] = NSStringFromRect(getCropRectFromLayer(layer));
        info["isClockwised"] = isClockwised(points);

        // MMShape
        info["scaledCropRect"] = NSStringFromRect(_mmshape.scaledCroppingRect());
        info["scaledSize"] = NSStringFromSize(_mmshape.scaledSize());
        info["normalizedPoints"] = _mmshape.normalizedPoints().componentsJoinedByString(", ");

        if (layer.isKindOfClass(MSShapeGroup)) {
            var path = layer.layers().firstObject();
            var curvePoints = path.allCurvePoints();
            info["allCurvePoints"] = curvePoints;
            var allCornerRadius = [NSMutableArray array];
            each(curvePoints, function(point) {
                 [allCornerRadius addObject:point.cornerRadius()];
                 if (point.cornerRadius() > 0) {
                     info["hasRoundCorners"] = true;
                     info["needsPro"] = true;
                     info["needsProReason"] = "Layers has corner radius is a Pro feature.";
                 }
            });
            info["allCornerRadius"] = allCornerRadius;
        }

        return info;
    }

    var addWatermarkIfNeeded = function(image, scale, needsPro) {
        var persister = MM3Persister.alloc().init();
        var licenseManager = _licenseManager;
        if (licenseManager.isPro()) {
            return image;
        }

        if (needsPro == true || needsPro == 1) {
            var watermarked = MM3Image.addWatermarkToImage(image);
            return watermarked;
        }

        return image;
    }

    var getCropRectFromLayer = function(layer) {

        var size = layer.bounds().size;
        var points = getPointsFromLayer(layer);
        var pointsBounds = function(points) {
            var origin = CGPointMake(0, 0);
            for (var i = 0; i < points.count(); i++) {
                var point = NSPointFromString(points[i])
                origin.x = Math.min(point.x, origin.x);
                origin.y = Math.max(-point.y, origin.y);
            }

            origin.x = -origin.x;

            var bounds = CGRectMake(0, 0, 0, 0);
//            size.width += origin.x;
            bounds.size = size;
            bounds.origin = origin;

            return bounds
        }


        return pointsBounds(points);
    }

    var getCropped = function(layer, image, scale) {

        var bounds = getCropRectFromLayer(layer);

        log("fillImageOnLayerWIthScale: 1.3");

        var cropped;
        if (true /*! CGRectEqualsToRect(bounds, layer.bounds()) */) {

            _mmshape.scale = scale;
            _mmshape.path = getPointsFromLayer(layer);
            _mmshape.bounds = layer.bounds();

            var rect = _mmshape.scaledCroppingRect();
            var scaledSize = _mmshape.scaledSize();

            cropped = MM3Image.cropImage_withBounds_(image, rect);
            log("crop image: " + NSStringFromRect(rect) + " realSize:" + NSStringFromSize(scaledSize) + " image size: " + NSStringFromSize(image.size()));
        } else {
            log("no need to crop image");
        }

        log("fillImageOnLayerWIthScale: 1.4");


        return cropped;
    }


    var check = function() {
        var check = SKCheck(identifier);
        check.system(function(key, value) {
                     switch(key) {
                     case "OS Version": return compare(value, "Version 10.9") >= 0;
                     case "Sketch": return compare(value, "41") >= 0;
                     default: return "";
                     }
                     });

        check.plugin(function(key, value) {
                     switch(key) {
                     case "enabled": return compare(value, 1) >= 0;
                     case "compatibleVersion": return compare(value, "41") >= 0;
                     default: return "";
                     };
                     });

        check.class({
                    "MSSymbolInstance": [
                                         "-symbolMaster",
                                         "-setOverrides:",
                                         ],
                    "MSSymbolMaster": [
                                       "-children",
                                       ],
                    "MSShapeGroup": [
                                     "-layers",
                                     ],
                    "MSShapePathLayer": [
                                         "-bezierPath",
                                         ],
                    "MSLayerFlattener": [
                                         "-exportRequestFromLayers:immutablePage:immutableDoc:",
                                         ],
                    "SKViewController": [
                                         "+alloc",
                                         "+loadNibNamed:",
                                         "-initWithNibName:bundle:"
                                         ],
                    "SKImage": [
                                "+alloc",
                                "+scaleImage:size:",
                                ],
                    "MagicMirror3": [
                                     "+alloc",
                                     "-env",
                                     "-trackForEvent:properties:",
                                     ],
                    "MM3ImageTransform": [
                                     "+alloc",
                                     "-input",
                                     "-createOutput",
                                     "-tl",
                                     "-tr",
                                     "-bl",
                                     "-br",
                                     "-flipped",
                                     "-scale",
                                     "-rotation",
                                     ],
                    "MM3Image": [
                                 "+alloc",
                                 "+scaleImage:size:",
                                 "+fillImage:insideBounds:scale:shouldTrimTransparent:",
                                 "+fillImage:insideBounds:scale:shouldTrimTransparent:shadow:",
                                 "+cropImage:withBounds:",
                                 "+addWatermarkToImage:",
                                 ],
                    "MM3LayerIterator": [
                                         "-extractPointsFromLayer:",
                                         ],
                    "MM3ViewController": [
                                          "-setImageQuality:",
                                          "-setIncludeInArtboards:",
                                          "-setPreviewImage:",
                                          "-setReferenceID:",
                                          "-setDelegate:",
                                          ],
                    "MM3BezierPath": [
                                      "+pointsFromBezierPath:",
                                      "+bezierPathWithPoints:",
                                      "+bezierPathIsClockwise:",
                                      "+bezierPathReversed:",
                                      ],
                    "MM3Shape": [
                            "-setPath:",
                            "-setScale:",
                            "-setBounds:",
                            "-initWithBounds:path:",
                            "-realSize",
                            "-croppingRect",
                            "-normalizedPoints",
                            "-scaledCroppingRect",
                            "-scaledSize",
                            "+pointsAreClockwised:",
                            "+reversedPoints:",
                        ],
                    "MM3VersionChecker": [
                                          "+checkerWithIdentifier:name:",
                                          "-initWithIdentifier:name:",
                                          "-start",
                                          "-error",
                                          "-success",
                                          "-finished",
                                          "-result",
                                          "-isExpired",
                                          "-persist",
                                          "-expiredMessage",
                                          "-actionTitle",
                                          "-actionURL",
                                          "-setDelegate:",
                    ],
                    });

    }

    var checkVersion = function() {
         _versionChecker.start();
    }

    var self = {
        getLayerInfo: function(layer, symbol) {
            return getLayerInfo(layer, symbol);
        },
        getUserDefaultsInfo: function() {
            var allKeys = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation].allKeys()
            var relatedKeys = filter(allKeys, function(key) {
                                     var contains = key.containsString(_pluginIdentifier);
                                     return contains;
                                     });

            var defaults = [NSUserDefaults standardUserDefaults];
            var userInfo = [NSMutableDictionary dictionary];
            each(relatedKeys, function(key) {
                 var value = defaults.objectForKey(key);
                 userInfo.setObject_forKey_(value, key);
            });
            return userInfo;
        },
        resetUserDefaultsInfo: function() {
            var allKeys = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation].allKeys()
            var relatedKeys = filter(allKeys, function(key) {
                                     var contains = key.containsString(_pluginIdentifier);
                                     return contains;
                                     });

            var defaults = [NSUserDefaults standardUserDefaults];
            each(relatedKeys, function(key) {
                 defaults.removeObjectForKey(key);
                 });
            defaults.synchronize();
        },
        forgetMigrations: function() {
            [NSUserDefaults standardUserDefaults].removeObjectForKey("io.magicsketch.mirror.lastBuild");
            [NSUserDefaults standardUserDefaults].removeObjectForKey("io.magicsketch.mirror.lastMigration");
            [NSUserDefaults standardUserDefaults].synchronize();
        },
        doMigration: function() {
            var todo = toMigrate(migrations, lastSuccessfulMigrationBuild || lastBuild || currentBuild, currentBuild);
            log("should apply migrations: " + todo);

            if (todo) {
                log("before migration");
                var success = doMigration(todo);
                log("migration done! " + success ? "true" : "false");
                return success;
            }
            log("no migrations");
            return true;
        },
        onSuccess: function() {
             NSUserDefaults.standardUserDefaults().setObject_forKey_(currentBuild, _buildIdentifier)
             NSUserDefaults.standardUserDefaults().synchronize();
        },
        onRun: function(context) {
            _context = context;
            _document = dispatch_once_per_document("MMJSGetDocument", function() {
                                                   loadFramework();
                                                   return context.document;
                   });
            _command = context.command;
            loadDependancy();
        },
        onSelectionChanged: function(context) {
            _context = context;
            _document = dispatch_once_per_document("MMJSGetDocument", function() {
                   loadFramework();
                   var action = context.actionContext;
                   return action.document;
             });
            _command = context.command;
            loadDependancy();

        },
        onOpenDocument: function(context) {
            _context = context;
            _document = dispatch_once_per_document("MMJSGetDocument", function() {
                                                   loadFramework();
                                                   var action = context.actionContext;
                                                   return action.document;
                                                   });
            _command = context.command;
            loadDependancy();
        },
        env: function() {
            return _magicmirror.env();
        },
        pluginName: function() {
            return _magicmirror.pluginName();
        },
        load:function(context){
            loadFramework();
        },
        check: check,
        checkVersion: checkVersion,
        isExpired: function () { return _versionChecker.isExpired() },
        expiredMessage: function () { return _versionChecker.expiredMessage() },
        actionURL: function () { return _versionChecker.actionURL() },
        actionTitle: function () { return _versionChecker.actionTitle() },
        isBuildInSync: function () {
            return manifestForIdentifier(_pluginIdentifier).build == _runtimePluginBuild;
        },
        isPro: function() {
            log("licenseManager.isPro:" + _licenseManager);
            return _licenseManager.isPro();
        },
        isActivated: function() {
            log("licenseManager.isActivated:" + _licenseManager);
            return _licenseManager.isActivated();
        },
        areaOfLayer: function(layer) {
            return areaOfRectangle(self.getPointsFromLayer(layer));
        },
        getRatio: function(bounds, layer) {
            var width1 = bounds.size.width;
            var height1 = bounds.size.height;

            var points = self.getPointsFromLayer(layer);
//            log("getRatio: points " + points)
            var rotation = self.valueForLayer("rotation", layer) || 0;

//            log("getRatio: rotation " + rotation)
            var p0 = NSPointFromString(points[(0 + rotation) % 4]);
            var p1 = NSPointFromString(points[(1 + rotation) % 4]);
            var p2 = NSPointFromString(points[(2 + rotation) % 4]);
            var p3 = NSPointFromString(points[(3 + rotation) % 4]);

//            log("getRatio: p0 " + p0.toString());

            var top = distance(p0, p1);
            var bottom = distance(p2, p3);
            var width2 = Math.max(top, bottom);
            var left = distance(p1, p2);
            var right = distance(p3, p0);
            var height2 = Math.max(left, right);
//            log("getRatio: height2 " + height2);

            return Math.max(width2/width1, height2/height1)
        },
        selection: function(selection) {

            if (selection.count() == 1) {
                var layer = selection[0];
                return {
                    refresh: function() {
                        return this.refreshLayer(layer)
                    },
                    flip: function() {
                        return this.flipLayer(layer);
                    },
                    description: function() {
                        log("MM selection: " + getLayerInfo(layer));
                    }
                }
            } else {
                return {
                    refresh: function() {
                        log("refresh: " + selection);
                        for (var item in selection) {
                            log(item);
                            self.refreshLayer(item);
                        });
                        log("refresh end");
                    },
                    description: function() {
                        log("selections: " + selection);
                    }
                }
            }

        },
        valueForLayer:function(key, mslayer) {
            return _command.valueForKey_onLayer_forPluginIdentifier(key, mslayer, _pluginIdentifier);
        },
        setValueForKeyOnLayer:function(value, key, mslayer) {
            _command.setValue_forKey_onLayer_forPluginIdentifier(value, key, mslayer, _pluginIdentifier);
        },
        setImageQuality:function(layer, imageQuality) {
            if (layer.isKindOfClass(MSShapeGroup) || layer.isKindOfClass(MSSymbolInstance)) {
                this.setValueForKeyOnLayer(imageQuality, "imageQuality", layer);
                this.refreshLayer(layer);
            } else if (layer.isKindOfClass(MSArtboardGroup) || layer.isKindOfClass(MSLayerGroup)) {
                var layers = layer.layers()
                each(layers, function(layer) {
                    self.setImageQuality(layer, imageQuality);
                });
            } else {
                var layers = this.getEffectiveLayers(layer)
                each(layers, function(layer) {
                     self.setImageQuality(layer, imageQuality);
                     });
            }
        },
        imageQuality:function(layer) {
            if (layer.isKindOfClass(NSArray)) {
                return nil;
            }

            return this.valueForLayer("imageQuality", layer) || 0;
        },
        isIncluded: function(layer, last) {
            if ([layer isKindOfClass:NSArray]) {
                if ([layer count] == 1) {
                    layer = layer[0];
                } else {
                    return -1;
                }
            }
            return this.valueForLayer("included", layer) == "1" ? true : false;
        },
        setIncluded: function(layer, included) {

            if ( ! (layer.isKindOfClass(MSArtboardGroup) || layer.isKindOfClass(MSSymbolMaster) || layer.isKindOfClass(MSSliceLayer))) {
                return;
            }

            var linked = remind(_linkedArtboardsIdentifier);

            if (included == 1 || included == "1") {
                linked.addObject(layer.objectID());
            } else {
                linked.removeObject(layer.objectID());
            }

            this.setValueForKeyOnLayer(included, "included", layer);
        },
        findLayer: findLayer,
        getPotentiallyLinkedArtboardID: getPotentiallyLinkedArtboardID,
        getArtboards: function() {
            var linked = remind(_linkedArtboardsIdentifier);
            if ( ! linked) {
                linked = [NSMutableSet set];
                var allChildrens = document.valueForKeyPath("pages.layers.children");
                enumerate(allChildrens, function(layer) {
                          if (layer.isKindOfClass(MSArtboardGroup)) {
                              if (self.isIncluded(layer)) {
                                  linked.addObject(layer.objectID());
                              }
                          } else if (layer.isKindOfClass(MSSymbolInstance)) {

                          } else if (layer.isKindOfClass(MSBitmapLayer)) {

                          } else {
                              var artboardID = getPotentiallyLinkedArtboardID(layer);
                              if (artboardID) {
                                  linked.addObject(artboardID);
                              }
                          }
                });
                remember(linked, _linkedArtboardsIdentifier)
            }
            var enabledIDs = linked;
            var enabledArtboards = map([enabledIDs allObjects], function(id) {
                return _artboardsLookupByID[id];
            });
            return enabledArtboards
        },
        fillImageInSymbolOnLayer: function(image, symbol, layer) {

            var layerID = layer.objectID()
            log("MM: fillImageInSymbolOnLayer { layerID:" + layerID);

            var overrides = [NSMutableDictionary dictionary];
            if (image) {

                var data = [[MSImageData alloc] initWithImage:image convertColorSpace:false];

                var originalOverrides = symbol.overrides();
                log("original:");
                log(originalOverrides);

                if (symbol.overrides() && symbol.overrides().objectForKey(0)) {
                    overrides = symbol.overrides().objectForKey(0).mutableCopy()
                }
                overrides.setObject_forKey_(data, layerID);
            } else {
                overrides.removeObjectForKey(layerID);
            }

            var zero = [NSMutableDictionary dictionary];
            zero.setObject_forKey_(overrides, 0);

            symbol.overrides = zero;
            log("}");
        },
        linkLayerIDWithArtboardIDInSymbol: function(layerID, artboardID, symbolID) {
            var symbol = this.findLayer(symbolID);
            var overrides = (this.valueForLayer("overrides", symbol) || [NSDictionary dictionary]).mutableCopy();
            overrides[layerID] = { "artboardID": artboardID };
            this.setValueForKeyOnLayer(overrides, "overrides", symbol);
//            log(overrides);
            this.refreshLayerIDInSymbol(layerID, symbol);
        },
        linkLayerIDWithArtboardID: function(layerID, artboardID) {
            var layer = this.findLayer(layerID);
            this.setValueForKeyOnLayer(artboardID, "artboardID", layer);
            return this.refreshLayer(layer)
        },
        rotateLayer: function(mslayer) {
            log("MM: rotateLayer" + mslayer);
            var rotation = (this.valueForLayer("rotation", mslayer) || 0) + 1;
            rotation %= 4;
            this.setValueForKeyOnLayer(rotation, "rotation", mslayer);
            this.refreshLayer(mslayer);
        },
        flipLayer: function(mslayer) {
            log("MM: flipLayer");
            var flipped = (this.valueForLayer("flipped", mslayer) || 0) + 1;
            flipped %= 2;
            this.setValueForKeyOnLayer(flipped, "flipped", mslayer);
            this.refreshLayer(mslayer);
        },
        refreshAll:function () {
            log("MM: refresh All");

            var layers = _document.currentPage().layers();
            for(var i=0; i < layers.count(); i++) {
                this.refreshLayer(layers[i]);
            }
        },
        refreshArtboard: function(artboard) {

            var effective = artboard.layers();
            log("MM: refresh artboard: effective " + effective);
            for (var i = 0; i < effective.count(); i++) {
                var layer = effective[i];
                this.refreshLayer(layer);
            }
        },
        refreshLayer: function(mslayer) {
            // find artboard

            log("MM: refreshLayer: " + mslayer);

            if ( ! mslayer) {
                return;
            }

            if (typeof mslayer !== 'object') {
                return;
            }

            if (isNullOrNil(mslayer)) {
                return;
            }

            if (mslayer.isKindOfClass(MSSymbolInstance)) {
                log("MM: refreshLayer symbolInstance");
                this.refreshSymbol(mslayer);
                return;
            }

            if (mslayer.isKindOfClass(MSArtboardGroup)) {
                log("MM: refreshLayer artboard");

                this.refreshArtboard(mslayer);
                return;
            }

            if (mslayer.isKindOfClass(MSLayerGroup) && ! mslayer.isKindOfClass(MSShapeGroup)) {
                var layers = mslayer.layers();
                each(layers, function(layer) {
                     self.refreshLayer(layer);
                     });
                return;
            }

            if (mslayer.symbolInstanceID) {
                log("MM: refreshLayer mslayer.symbolInstanceId");

                this.refreshSymbol(this.findLayer(mslayer.symbolInstanceID));
                return;
            }

            var info = getLayerInfo(mslayer);
            var artboardID = info["artboardID"] || info["artboardID_mm2"];
            if (isNullOrNil(artboardID)) {
                log("MM: detach layer (" + mslayer.name() + ")");
                disableFillImageOnLayer(mslayer);
                return;
            }
//            log("MM: refreshLayer 2");

            var artboard = this.findLayer(artboardID);
            var placeholder = this.getPlaceholders(artboardID);


//            log("MM: refreshLayer 2.1");

//            log("MM: refreshLayer 2.2");

            var rotation = this.valueForLayer("rotation", mslayer);
//            log("MM: refreshLayer 2.3: " + rotation);

            var flipped = this.valueForLayer("flipped", mslayer);
//            log("MM: refreshLayer 2.4: " + flipped);

            var scale = Math.max(this.valueForLayer("imageQuality", mslayer), 1);
//            log("MM: refreshLayer 2.5: " + scale);

            var destinationPoints = this.getPointsFromLayer(mslayer);
//            log("MM: refreshLayer 2.6: " + destinationPoints);

            var bounds = mslayer.bounds();
//            log("MM: refreshLayer 3: " + NSStringFromRect(bounds));

            var sourceBounds;
            var image = nil;
            var ratio = 1;
            var targetScale;

            if (artboard) {
//                log("MM: refreshLayer 4 artboard");

                sourceBounds = artboard.bounds();
                ratio = self.getRatio(sourceBounds, mslayer);
                targetScale = ratio * scale;
                image = generateImage(artboard, targetScale);

            } else if (placeholder) {
//                log("MM: refreshLayer 4 placeholder" + placeholder);

                // is placeholder
                var imageName = placeholder.imageNamed;
                image = this.getImageAtResource(imageName);
                sourceBounds = CGRectMake(0, 0, image.size().width, image.size().height);
                ratio = self.getRatio(sourceBounds, mslayer);
                targetScale = ratio * scale;
//                log("MM: refreshLayer 4.3 " + NSStringFromRect(sourceBounds));

            }

//            log("MM: refreshLayer 5");

            
            _mmshape.scale = scale;
            _mmshape.bounds = bounds;
            _mmshape.path = destinationPoints;
            var points = _mmshape.normalizedPoints();
            
//            log("MM: refreshLayer 6");

            var info = {
                        "sourceBounds": NSStringFromRect(sourceBounds) || "missing",
                        "rotation": rotation || "missing",
                        "flipped": flipped || "missing",
                        "scale": scale || "missing",
                        "ratio":ratio || "missing",
                        "targetScale": targetScale || "missing",
                        "destinationPoints":destinationPoints || "missing",
                        "normalizedPoints":_mmshape.normalizedPoints() || "missing",
                        "bounds": NSStringFromRect(bounds) || "missing",
                        "mslayer": mslayer || "missing",
                        "artboard": artboard || "missing",
                        };

//            log("MM: refreshLayer 7");
//            log("MM: refreshLayer info: " +  NSDictionary.dictionaryWithDictionary(info));

            if (points.count() == 4) {

                _imageTransform.input = image;
                _imageTransform.tl = NSPointFromString(points[0]);
                _imageTransform.tr = NSPointFromString(points[1]);
                _imageTransform.br = NSPointFromString(points[2]);
                _imageTransform.bl = NSPointFromString(points[3]);
                _imageTransform.rotation = rotation;
                _imageTransform.flipped = flipped;
                _imageTransform.scale = scale;
                var output = _imageTransform.createOutput();
                info.output = NSStringFromSize(output.size())


                log("info: " + NSDictionary.dictionaryWithDictionary(info));
                this.fillImageOnLayerWithScale(mslayer, output, scale);

                return true;
            }
//            log("MM: refreshLayer done");

            return false;
        },
        refreshLayerIDInSymbol: function(layerID, mssymbol) {
            log("MM: refreshLayerIDInSymbol layerID: " + layerID);

            var overrides = this.valueForLayer("overrides", mssymbol);
            var artboardID = overrides[layerID]["artboardID"];
            var mslayer = this.findLayer(layerID);

            if (isNullOrNil(mslayer)) {
                return;
            }

            log("MM: refreshLayerIDInSymbol 2.0 mslayer " + mslayer);

            if (isNullOrNil(artboardID)) {
                log("MM: detach layer in symbol (" + mslayer.name() + ")");
                this.fillImageInSymbolOnLayer(nil, mssymbol, mslayer);
                return;
            }

            ///


            var artboard = this.findLayer(artboardID);
            var placeholder = this.getPlaceholders(artboardID);


            log("MM: refreshLayerIDInSymbol 2.1 artboard " + artboard);

            log("MM: refreshLayerIDInSymbol 2.2 placeholder " + placeholder);

            var rotation = this.valueForLayer("rotation", mslayer);
            log("MM: refreshLayerIDInSymbol 2.3: rotation " + rotation);

            var flipped = this.valueForLayer("flipped", mslayer);
            log("MM: refreshLayerIDInSymbol 2.4: flipped " + flipped);

            var scale = Math.max(this.valueForLayer("imageQuality", mssymbol), 1);
            log("MM: refreshLayerIDInSymbol 2.5: scale " + scale);

            var destinationPoints = this.getPointsFromLayer(mslayer);
            log("MM: refreshLayerIDInSymbol 2.6: points " + destinationPoints);

            var bounds = mslayer.bounds();
            log("MM: refreshLayerIDInSymbol 3: bounds " + NSStringFromRect(bounds));



            var sourceBounds;
            var image = nil;
            var ratio = 1;
            var targetScale;

            if (artboard) {
                log("MM: refreshLayerIDInSymbol 4 artboard");

                sourceBounds = artboard.bounds();
                ratio = self.getRatio(sourceBounds, mslayer);
                targetScale = ratio * scale;
                image = generateImage(artboard, targetScale);

            } else if (placeholder) {
                log("MM: refreshLayerIDInSymbol 4 placeholder " + placeholder);

                // is placeholder
                var imageName = placeholder.imageNamed;
                log("MM: refreshLayerIDInSymbol 4.1 imageName " + imageName);
                image = this.getImageAtResource(imageName);

                log("MM: refreshLayerIDInSymbol 4.2 image " + image);

                sourceBounds = CGRectMake(0, 0, image.size().width, image.size().height);
                log("MM: refreshLayerIDInSymbol 4.3 " + NSStringFromRect(sourceBounds));

                ratio = self.getRatio(sourceBounds, mslayer);

                log("MM: refreshLayerIDInSymbol 4.4 " + ratio);

                targetScale = ratio * scale;
                log("MM: refreshLayerIDInSymbol 4.5 " + targetScale);
                
            }


            log("MM: refreshLayerIDInSymbol 5");


            _mmshape.scale = scale;
            _mmshape.bounds = bounds;
            _mmshape.path = destinationPoints;
            var points = _mmshape.normalizedPoints();

            log("MM: refreshLayerIDInSymbol 6");

            var info = {
                "sourceBounds": NSStringFromRect(sourceBounds) || "missing",
                "rotation": rotation || "missing",
                "flipped": flipped || "missing",
                "scale": scale || "missing",
                "ratio":ratio || "missing",
                "targetScale": targetScale || "missing",
                "destinationPoints":destinationPoints || "missing",
                "normalizedPoints":_mmshape.normalizedPoints() || "missing",
                "bounds": NSStringFromRect(bounds) || "missing",
                "mslayer": mslayer || "missing",
                "artboard": artboard || "missing",
            };

            log("MM: refreshLayerIDInSymbol 7 info:" + info);

            if (points.count() == 4) {
//                var image = generateImage(artboard, scale);
                _imageTransform.input = image;
                _imageTransform.tl = NSPointFromString(points[0]);
                _imageTransform.tr = NSPointFromString(points[1]);
                _imageTransform.br = NSPointFromString(points[2]);
                _imageTransform.bl = NSPointFromString(points[3]);
                _imageTransform.rotation = rotation;
                _imageTransform.flipped = flipped;
                _imageTransform.scale = scale;

                var output = _imageTransform.createOutput();
                log("output created: " + output);
                var cropped = getCropped(mslayer, output, scale);
                var watermarked = addWatermarkIfNeeded(cropped, scale, getLayerInfo(mslayer, mssymbol)["needsPro"]);
                this.fillImageInSymbolOnLayer(watermarked, mssymbol, mslayer);
                return true;
            }
            return false;
        },
        refreshSymbol: function(mssymbol) {
            var overrides = this.valueForLayer("overrides", mssymbol);

            log("MM refreshSymbol: mssymbol " + mssymbol + " overrides " + overrides);

            if (isNullOrNil(overrides)) {
                log("MM refreshSymbol: nothing to refresh");
                return;
            }

            var allKeys = overrides.allKeys()

            log("MM refreshSymbol: allKeys " + allKeys);
            for (var i = 0; i < allKeys.count(); i++) {
                var layerID = allKeys[i];
                this.refreshLayerIDInSymbol(layerID, mssymbol);
            }
        },
        fillImageOnLayerWithScale: function(layer, image, scale) {

            log("fillImageOnLayerWithScale");

//            layer.layers().firstObject().didEdit() // refresh bounds since corner radius issues

            var cropped = getCropped(layer, image, scale);
            var watermarked = addWatermarkIfNeeded(cropped, scale, getLayerInfo(layer)["needsPro"]);
            fillImageOnLayer(layer, watermarked || image);
//            log("fillImageOnLayerWIthScale: 4");

//            fillImageOnLayer(layer, image);
        },
        getImage:function(layer, scale) {
            return generateImage(layer, scale || 1);
        },
        getImageData:function(layer) {
            var image = generateImage(layer, 1);
            return [[MSImageData alloc] initWithImage:image convertColorSpace:false];
        },
        getThumbnail: function(layer, size) {

            if ([layer isKindOfClass:NSArray]) {
                if (layer.count() == 1) {
                    layer = layer[0];
                } else {
                    return nil;
                }
            }

            var mocha = Mocha.sharedRuntime()
            var key = layer.objectID() + NSStringFromSize(size);
            var thumbnail = mocha.valueForKey(key);

            var snap = mocha.valueForKey(key + "_snap");

            var equal = isEqual(snap, layer.immutableModelObject());

            if ( ! thumbnail || ! equal) {
                var bounds = CGRectMake(0, 0, size.width, size.height);
                var ratio = 1 / self.getRatio(bounds, layer);
                var image = generateImage(layer, ratio);

                thumbnail = MM3Image.fillImage_insideBounds_scale_shouldTrimTransparent_shadow_(image, CGRectMake(0, 0, size.width, size.height), 1, false, CGSizeMake(0, -1));

                mocha.setValue_forKey_(thumbnail, key);
                mocha.setValue_forKey_(layer.immutableModelObject(), key + "_snap");
            } else {
//                log("MM: get thumbnails from cache");
            }

            return thumbnail;
        },
        getMasterSymbol: getMasterSymbol,
        getEffectiveLayers: function(selection, forceRecursive) {
            return getEffectiveLayers(selection, forceRecursive).reverseObjectEnumerator().allObjects();
        },
        getPointsFromLayer:getPointsFromLayer,
        getCurvePointsFromLayer: getCurvePointsFromLayer,
        getPlaceholders: function(identifier) {

            var thumbnail = function(image) {
                var size = CGSizeMake(24, 24);
                return MM3Image.fillImage_insideBounds_scale_shouldTrimTransparent_shadow_(image, CGRectMake(0, 0, size.width, size.height), 1, false, CGSizeMake(0, -1));
            };

            var list = [
                        {
                        identifier:"applewatch38",
                        title:"Apple Watch 38mm",
                        type:"resource",
                        image:thumbnail(this.getImageAtResource("Apple Watch 38mm-menu.png")),
                        imageNamed:"Apple Watch 38mm.png"
                        },
                        {
                        identifier:"applewatch42",
                        title:"Apple Watch 42mm",
                        type:"resource",
                        image:thumbnail(this.getImageAtResource("Apple Watch 42mm-menu.png")),
                        imageNamed:"Apple Watch 42mm.png"
                        },
                        {
                        identifier:"iphonese",
                        title:"iPhone SE",
                        type:"resource",
                        image:thumbnail(this.getImageAtResource("iPhone SE-menu.png")),
                        imageNamed:"iPhone SE.png"
                        },
                        {
                        identifier:"iphone7",
                        title:"iPhone 7",
                        type:"resource",
                        image:thumbnail(this.getImageAtResource("iPhone 7-menu.png")),
                        imageNamed:"iPhone 7.png"
                        },
                        {
                        identifier:"iphone7plus",
                        title:"iPhone 7 Plus",
                        type:"resource",
                        image:thumbnail(this.getImageAtResource("iPhone 7 Plus-menu.png")),
                        imageNamed:"iPhone 7 Plus.png"
                        },
                        {
                        identifier:"ipadlandscape",
                        title:"iPad Landscape",
                        type:"resource",
                        image:thumbnail(this.getImageAtResource("iPad Landscape-menu.png")),
                        imageNamed:"iPad Landscape.png"
                        },
                        {
                        identifier:"ipadportrait",
                        title:"iPad Portrait",
                        type:"resource",
                        image:thumbnail(this.getImageAtResource("iPad Portrait-menu.png")),
                        imageNamed:"iPad Portrait.png"
                        },
                        {
                        identifier:"ipadprolandscape",
                        title:"iPad Pro Landscape",
                        type:"resource",
                        image:thumbnail(this.getImageAtResource("iPad Pro Landscape-menu.png")),
                        imageNamed:"iPad Pro Landscape.png"
                        },
                        {
                        identifier:"ipadproportrait",
                        title:"iPad Pro Portrait",
                        type:"resource",
                        image:thumbnail(this.getImageAtResource("iPad Pro Portrait-menu.png")),
                        imageNamed:"iPad Pro Portrait.png"
                        },
                        ];

            if (identifier) {
                list = filter(list, function(item) {
                       return item.identifier == identifier
                       }).firstObject();
            }

            return list;
        },
        getImageAtResource: function(name) {
            var path = resourcePath() + "/" + name;
            var imageURL = NSURL.fileURLWithPath(path);
            return NSImage.alloc().initWithContentsOfURL(imageURL)
        },
        trackForEvent: function(event, properties){
            _magicmirror["trackForEvent:properties:"](event, properties);
        },
        loadServerNotification: function(){
            _magicmirror.loadServerNotification();
        },
    };



    return self;
}
