
var _document = [MSDocument currentDocument];
var _command = [MagicMirror3Panel sharedCommand];
var _pluginIdentifier = "io.magicsketch.MagicMirror3c";

var valueForLayer = function(key, mslayer) {
        return _command.valueForKey_onLayer_forPluginIdentifier(key, mslayer, _pluginIdentifier);
    }
var setValueForKeyOnLayer = function(value, key, mslayer) {
        _command.setValue_forKey_onLayer_forPluginIdentifier(value, key, mslayer, _pluginIdentifier);
    }

var remember = function(something, key) {
    Mocha.sharedRuntime().setValue_forKey_(something, key);
}

var remind = function(key) {
    return Mocha.sharedRuntime().valueForKey(key)
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

var isEqual = function (first, second) {
    if (typeof first !== typeof second) {
        return false
    }
    var tree = MSTreeDiff.alloc().initWithFirstObject_secondObject_(first, second);
    return tree.diffs().count() == 0
}


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

        var symbolLayer = MagicMirror3SketchSymbolLayer.alloc().init()
        symbolLayer.symbolInstanceID = symbolInstance.objectID()
        symbolLayer.objectID = layer.objectID()
        symbolLayer.previewImages = layer.previewImages()
        symbolLayer.name = layer.name()
        symbolLayer.bounds = layer.bounds();
        symbolLayer.layer = layer;
        symbolLayer.symbolInstance = symbolInstance;
        layers.addObject(symbolLayer);

//        var dict = {}
//        dict.symbolInstanceID = symbolInstance.objectID()
//        dict.objectID = layer.objectID
//        dict.previewImages = layer.previewImages
//        dict.name = layer.name
//        dict.bounds = layer.bounds;
//        layers.addObject(dict);
    }
    return layers;
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

var getPotentiallyLinkedArtboardID = function(layer) {
    var artboardID_mm2_name = _command.valueForKey_onLayer_forPluginIdentifier("source", layer, "design.magicmirror") // mm1;
    var artboardID = valueForLayer("artboardID", layer);
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

    info["artboardID"] = valueForLayer("artboardID", layer);

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
        var overrides = valueForLayer("overrides", layer);
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


var getEffectiveLayers = function(selection, forceRecursive) {
    var mslayer = selection;
    if (selection && [selection isKindOfClass:NSArray]) {
        log("getEffectiveLayers: array selection " + selection);
        var all = [NSMutableArray array];
        for (var i = 0; i < selection.count(); i++) {
            var layer = selection[i];
            var effective = nil;
            log("layer: " + layer);
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
