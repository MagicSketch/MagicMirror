@import 'SKCheck.js'
@import 'Skinject.framework/Skinject.js'
@import 'MagicMirror3.framework/MagicMirror.js'

var onCurrentSelection = function(context, isOnRun) {

  try {


    var identifier = context.plugin.valueForKey("_identifier");
    var disabledIdentifier = identifier + ".disabled";
    var isDisabled = NSUserDefaults.standardUserDefaults().boolForKey(disabledIdentifier);

    if (isDisabled && ! isOnRun){
      return false;
    }

    COScript.currentCOScript().setShouldKeepAround_(true);

    var timers = [];

    var startTimer = timer("startTimer");
    var createMenuTimer = timer("createMenuTimer");
    var getSelectionTimer = timer("getSelectionTimer");
    var createUITimer = timer("createUITimer");
    var generateThumbnailTimer = timer("generateThumbnailTimer");
    var reloadUITimer = timer("reloadUITimer");
    var printSelectionTimer = timer("printSelectionTimer");
    timers.push(startTimer);
    timers.push(getSelectionTimer);
    timers.push(printSelectionTimer);
    timers.push(createUITimer);
    timers.push(createMenuTimer);
    timers.push(generateThumbnailTimer);
    timers.push(reloadUITimer);
    startTimer.start()


      startTimer.lab("before skinject loaded");

    // 0.0001

      var skinject = Skinject(identifier);
      var magicmirror = MagicMirrorJS(identifier);

      if (context.action) {
          skinject.onSelectionChanged(context);
          action = context.actionContext;
          document = action.document;

          startTimer.lab("after skinject loaded");
        // 0.14
        magicmirror.onSelectionChanged(context);

      } else {
          skinject.onRun(context);
          document = context.document;

          startTimer.lab("after skinject loaded");
          // 0.14
          magicmirror.onRun(context);
      }

      if (isDisabled && isOnRun){
          skinject.reloadData();
          return false;
      }

    startTimer.lab("after magicmirror loaded");

    // 0.14

    dispatch_once("MM3_initialization", function() {
        magicmirror.check()
        magicmirror.checkVersion();
    });


    var migrationFailed = false;
    if ( ! magicmirror.doMigration()) {
        log("MagicMirror3: failed to do migration");
        migrationFailed = true;
    }

    startTimer.lab("after check");


    // 0.15

    if (document.respondsToSelector("selectedLayers")) {
        selection = document.selectedLayers();   // Sketch 41 is NSArray, Sketch 42 returns MSLayerArray
        if (selection.respondsToSelector("layers")) {
            selection = selection.layers()
        };
    } else {
       selection = document.selectedLayersA().layers();
    }

    // 0.8

//    startTimer.lab("after getSelection");

      var runCount = Mocha.sharedRuntime().valueForKey("io.magicsketch.mirror.runcount") || 0;
      Mocha.sharedRuntime().setValue_forKey_(++runCount, "io.magicsketch.mirror.runcount");

      if (runCount == 1) {
          var env = magicmirror.env();
          Mocha.sharedRuntime().setValue_forKey_(env, "io.magicsketch.mirror.env");
          document.showMessage(magicmirror.pluginName() + ": " + env);
      }

    startTimer.lab("before getEffectiveLayers");

    getSelectionTimer.start()
//    effectiveLayers = [NSArray array];
    effectiveLayers = magicmirror.getEffectiveLayers(selection, true);
    getSelectionTimer.stop();

    startTimer.lab("after getEffectiveLayers");

    var MM3SelectionController = function(selection) {
//        var effectiveLayers = magicmirror.getEffectiveLayers(selection);
        var commonHandler = {
            configureHeader: function(section) {

            },
            configureCell: function(section) {

            },
            refresh: function() {
                each(effectiveLayers, function(layer) {
                    magicmirror.refreshLayer(layer);
                });
            },
            flip: function() {
                each(effectiveLayers, function(layer) {
                    magicmirror.flipLayer(layer);
                });
            },
            rotate: function() {
                each(effectiveLayers, function(layer) {
                    magicmirror.rotateLayer(layer);
                });
            },
            imageQuality: function() {
                each(effectiveLayers, function(layer) {
                    
                });
            },
            setImageQuality: function(value) {
                each(selection, function(layer) {
                    magicmirror.setImageQuality(layer, value);
                });
            },
        };
        return commonHandler;
    }

    var mmhandler = Class("MM3ViewControllerDelegate", NSObject, {
                          "controller:didSelectImageQuality:":function(viewController, option) {
                              log("imageQualityDidSelect: " + option);
                              magicmirror.trackForEvent("Picked ImageQuality", {"Image Quality":option, "Layer Type": selection[0].className()});
                              var controller = MM3SelectionController(selection);
                              controller.setImageQuality(option);
                          },
                          "controllerDidPressRotateLayer:": function(viewController) {
                              log("rotateLayer");
                              magicmirror.trackForEvent("Rotated Layer", {"Layer Type":selection[0].className()});
                              var controller = MM3SelectionController(selection);
                              controller.rotate();
                          },
                          "controllerDidPressFlipLayer:": function(viewController) {
                              log("flipLayer");
                              magicmirror.trackForEvent("Flipped Layer", {"Layer Type":selection[0].className()});
                              var controller = MM3SelectionController(selection);
                              controller.flip();
                          },
                          "controllerDidPressRefreshLayer:": function(viewController) {
                              log("refreshLayer");
                              magicmirror.trackForEvent("Refreshed Layer", {"Layer Type": selection[0].className(), "Image Quality": magicmirror.imageQuality(selection[0])});
                              var controller = MM3SelectionController(selection);
                              controller.refresh();
                          },
                          "controller:didToggleIncludeInArtboards:":function(viewController, option) {
                              log("setIncluded: " + option);
                              magicmirror.trackForEvent("Picked IncludeInArtboards", {"Set Include": (option==0?"NO":"YES")});
                              var layer = magicmirror.findLayer(viewController.identifier());
                              magicmirror.setIncluded(layer, option);
                          },
                          "controllerDidPressProButton:": function(viewController) {
                              log("didPressProButton:");
                              magicmirror.trackForEvent("Clicked SettingsButton", {});
                          },
                          "controllerDidPressActivateButton:": function(viewController) {
                              log("didPressActivateButton:");
                              magicmirror.trackForEvent("Clicked ActivateButton", {});
                          },
                          "controllerDidPressActionButton:": function(viewController) {
                              log("didPressActionButton:");
                              magicmirror.trackForEvent("Clicked ActionButton", {});
                          }
                          }).alloc().init();

    startTimer.lab("before printSelectionTimer");
    printSelectionTimer.start()
    magicmirror.selection(selection).description();
    printSelectionTimer.stop();
    startTimer.lab("after printSelectionTimer");
    // 0.8

    startTimer.lab("before createHeader");

    createUITimer.start();
    var header = skinject.dequeueCell("header");
    if ( ! header) {
        header = [[MM3ViewController alloc] initWithNibName:"MM3InspectorHeader" bundle:[NSBundle bundleForClass:MM3ViewController]];
        header.reuseIdentifier = "header";
    } else {
//        log("cell dequeued (" + header.reuseIdentifier() + ")");
    }
    header.delegate = mmhandler;
    Mocha.sharedRuntime().setValue_forKey_(mmhandler, "MM3ViewControllerDelegate");

    startTimer.lab("after createHeader");

    if ( ! magicmirror.isBuildInSync()) {
        var section = skinject.addCustomSection(header);
        log("magicmirror is not in sync");
        var avc = skinject.dequeueCell("outofsync");
        if ( ! avc) {
            avc = [[MM3ViewController alloc] initWithNibName:"MM3ActivationCell" bundle:[NSBundle bundleForClass:MM3ViewController]];
            avc.reuseIdentifier = "outofsync";
        } else {
//            log("cell dequeued (" + avc.reuseIdentifier() + ")");
        }
        avc.delegate = mmhandler;
        avc.message = "Plugin is out of sync, please save your work and restart Sketch to continue using.";
        avc.actionTitle = "Close";
        avc.actionURL = nil;
        avc.action = [MM3BashAction nothing];
        avc.reloadData();
        section.addCustomCell(avc);
    } else if (magicmirror.isExpired()) {
        var section = skinject.addCustomSection(header);
        log("magicmirror is expired");
        var avc = skinject.dequeueCell("expired");
        if ( ! avc) {
            avc = [[MM3ViewController alloc] initWithNibName:"MM3ActivationCell" bundle:[NSBundle bundleForClass:MM3ViewController]];
            avc.reuseIdentifier = "activation";
        } else {
//            log("cell dequeued (" + avc.reuseIdentifier() + ")");
        }
        avc.delegate = mmhandler;
        avc.message = magicmirror.expiredMessage();
        avc.actionTitle = magicmirror.actionTitle();
        avc.actionURL = magicmirror.actionURL();
        avc.reloadData();
        section.addCustomCell(avc);
    } else if (migrationFailed) {
        var section = skinject.addCustomSection(header);
        var avc = skinject.dequeueCell("migrationFailed");
        if ( ! avc) {
            avc = [[MM3ViewController alloc] initWithNibName:"MM3ActivationCell" bundle:[NSBundle bundleForClass:MM3ViewController]];
            avc.reuseIdentifier = "migration";
        } else {
//            log("cell dequeued (" + avc.reuseIdentifier() + ")");
        }
        avc.delegate = mmhandler;
        avc.message = "Migration failed, please contact support!"
        avc.actionTitle = "Support";
        avc.actionURL = NSURL.URLWithString("mailto:support@magicsketch.io");
        avc.reloadData();
        section.addCustomCell(avc);
    } else if ( ! magicmirror.isActivated()) {
       var section = skinject.addCustomSection(header);
       log("magicmirror not activated");

        var avc = skinject.dequeueCell("notActivated");
        if ( ! avc) {
            avc = [[MM3ViewController alloc] initWithNibName:"MM3ActivationCell" bundle:[NSBundle bundleForClass:MM3ViewController]];
            avc.reuseIdentifier = "notActivated";
        } else {
//            log("cell dequeue (" + avc.reuseIdentifier() + ")");
        }
        avc.delegate = mmhandler;
        avc.reloadData();
        section.addCustomCell(avc);

    } else if (selection.count() == 1 && (selection.firstObject().isKindOfClass(MSSymbolMaster) || selection.firstObject().isKindOfClass(MSSliceLayer)))) {
        var section = skinject.addCustomSection(header);
        var avc = skinject.dequeueCell("artboardToolbar");
        if ( ! avc) {
            avc = [[MM3ViewController alloc] initWithNibName:"MM3ArtboardToolbar" bundle:[NSBundle bundleForClass:MM3ViewController]];
            avc.reuseIdentifier = "artboardToolbar";
        } else {
//            log("cell dequeue (" + avc.reuseIdentifier() + ")");
        }
        avc.delegate = mmhandler;
        avc.identifier = selection.firstObject().objectID()
        avc.includeInArtboards = magicmirror.isIncluded(selection.firstObject());
        avc.previewImage = magicmirror.getThumbnail(selection.firstObject(), CGSizeMake(36, 24));
        avc.reloadData();
        section.addCustomCell(avc);
    } else if (selection.count() == 0) {

        // If nothing is selected, we just want to hide any previous message that might have been shown.
        document.hideMessage();

    } else {

        var section = skinject.addCustomSection(header);

        startTimer.lab("before getArtboards");
        var lastArtboardLookup = remind("lastArtboardLookup") || [NSDictionary dictionary];
        var artboards = magicmirror.getArtboards()
        {
            var immutableArtboards = artboards.valueForKeyPath("immutableModelObject");
            var artboardIDs = artboards.valueForKeyPath("objectID");
            var dict = [NSDictionary dictionaryWithObjects:immutableArtboards forKeys:artboardIDs];
            remember(dict, "lastArtboardLookup");
        }
        startTimer.lab("after getArtboards");
        var descriptor =  NSSortDescriptor.alloc().initWithKey_ascending_("name", true);
        // log(descriptor)
        artboards = artboards.sortedArrayUsingDescriptors([descriptor]);
        startTimer.lab("after sortArtboards");

        function createMenu(artboards, magicmirror) {
            createMenuTimer.start()
            var menu = [];
            menu.push({
                    identifier: nil,
                    title: "No Artboard",
                    image: nil,
                    });
    
            menu.push({
                    type:"separator",
                    });

            for (var i = 0; i < artboards.count(); i++) {
                var artboard = artboards.objectAtIndex(i);
//                if (magicmirror.isIncluded(artboard) == 1) {

                    createUITimer.stop();
                    generateThumbnailTimer.start();

                    var lastArtboard = lastArtboardLookup.objectForKey(artboard.objectID());
                    var same = isEqual(lastArtboard, artboard.immutableModelObject());
                    if ( ! same) {
//                        log("artboard changed, needed regenerate: ");

                        if ( ! lastArtboard) {
                            log("artboard not exists, generating cache now: " + artboard.name());
                        } else {
                            log("artboard " + artboard.name() + " changed, needed regenerate: " + diffs(lastArtboard, artboard.immutableModelObject()));
                        }

                    }
                    var image = magicmirror.getThumbnail(artboard, CGSizeMake(24, 24), same);

                    createUITimer.start();
                    generateThumbnailTimer.stop();
                    menu.push({
                            identifier: artboard.objectID(),
                            title: artboard.name(),
    //                          image: nil,
                            image: image,
                            });
//                }
            }
    
            menu.push({
                    type:"separator",
                    });
    
            each(magicmirror.getPlaceholders(), function(placeholder) {
                menu.push(placeholder)
                });

            menu.push({
                      type:"separator",
                      });

            menu.push({
                      identifier: "manageArtboards",
                      title: "Manage Artboards...",
                      type: "action",
                      image: nil,
                      });

            createMenuTimer.stop();
            return menu;
        }

        if (selection.count() == 1) {
            var selected = selection[0];
            if ([selected isKindOfClass:MSArtboardGroup]) {
                var avc = skinject.dequeueCell("artboardToolbar");
                if ( ! avc) {
                    avc = [[MM3ViewController alloc] initWithNibName:"MM3ArtboardToolbar" bundle:[NSBundle bundleForClass:MM3ViewController]];
                    avc.reuseIdentifier = "artboardToolbar";
                } else {
//                    log("cell dequeue (" + avc.reuseIdentifier() + ")");
                }
                avc.delegate = mmhandler;
                avc.identifier = selection.firstObject().objectID()
                avc.includeInArtboards = magicmirror.isIncluded(selected);
                avc.previewImage = magicmirror.getThumbnail(selected, CGSizeMake(36, 24));
                avc.imageQuality = magicmirror.imageQuality(selected);
                avc.reloadData();
//                log("included: " + magicmirror.isIncluded(selected));
                section.addCustomCell(avc);


                startTimer.lab("after createArtboardToolbar");
            }
        }

        if (effectiveLayers.count() >= 1) {
            
            createUITimer.stop();
            startTimer.lab("before createMenu");
            var menu = createMenu(artboards, magicmirror);
            startTimer.lab("after createMenu");
            createUITimer.start();
        
            var selected = selection[0];
            var lvc = skinject.dequeueCell("layerToolbar");
            if ( ! lvc) {
                lvc = [[MM3ViewController alloc] initWithNibName:"MM3LayerToolbar" bundle:[NSBundle bundleForClass:MM3ViewController]];
                lvc.reuseIdentifier = "layerToolbar";
            } else {
//                log("cell dequeue (" + lvc.reuseIdentifier() + ")");
            }
            lvc.delegate = mmhandler;
            lvc.imageQuality = selection.count() > 1 ? -1 : magicmirror.imageQuality(selected);
            lvc.identifier = selection.firstObject().objectID()
            lvc.reloadData();
            section.addCustomCell(lvc);

        }

        var nsmenu = menu ? [MM3Menu menuWithItems:menu] : nil;

        startTimer.lab("before createCells");

        var menuCellDelegate = dispatch_once_per_document("MM3MenuCellDelegate", function() {

                                                          var delegate = Class("MM3MenuCellDelegate", NSObject, (function() {

                                                                                                                 var self = {

                                                                                                                     "popupCellSelectedDidChange:":function(cell) {

                                                                                                                         log("popupCellSelectedDidChange:");

                                                                                                                         var identifier = NSString.stringWithString(cell.layerID());
                                                                                                                         var selectedIdentifier = cell.selectedIdentifier();
                                                                                                                         var representedObject = cell.representedObject();


                                                                                                                         var splitted = identifier.componentsSeparatedByString(".");
                                                                                                                         var layerID = splitted.firstObject();
                                                                                                                         var symbolInstanceID;
                                                                                                                         if (splitted.count() > 1) {
                                                                                                                            symbolInstanceID = splitted.lastObject();
                                                                                                                         }


                                                                                                                         var type = representedObject["type"];
                                                                                                                         log("type: " + type);
                                                                                                                         log("selectedIdentifier: " + selectedIdentifier);
                                                                                                                         log(representedObject);

                                                                                                                         if (type == "action") {
                                                                                                                             var identifier = selectedIdentifier;
                                                                                                                             if (identifier == "manageArtboards") {

                                                                                                                 log("manage artboards");
                                                                                                                 var controller = dispatch_once_per_document("MM3ManageArtboardWindow", function() {
                                                                                                                                                             var storyboard = [NSStoryboard storyboardWithName:@"MM3Storyboard" bundle:[NSBundle bundleForClass:MM3PopupCell]];
                                                                                                                                                             log("storyboard: " + storyboard);
                                                                                                                      var windowController = [storyboard instantiateControllerWithIdentifier:"MM3ManageArtboardWindow"];

                                                                                                                                                             log("windowController: " + windowController);
                                                                                                                                                             return windowController;
                                                                                                                                                             });

                                                                                                                 controller.showWindow(controller.window());


                                                                                                                                    
                                                                                                                             }
                                                                                                                         } else {
                                                                                                                                 var artboardID = selectedIdentifier;
                                                                                                                                 var layer = magicmirror.findLayer(layerID);
                                                                                                                                 log("layerID: " + layerID + " artboardID: " + artboardID + " symbolID: " + symbolInstanceID);

                                                                                                                                 if (symbolInstanceID) {
                                                                                                                                    magicmirror.trackForEvent("Picked Artboard", {"Artboard Type": "Symbol"});
                                                                                                                                    magicmirror.linkLayerIDWithArtboardIDInSymbol(layerID, artboardID, symbolInstanceID);
                                                                                                                                 } else {
                                                                                                                                    magicmirror.trackForEvent("Picked Artboard", {"Artboard Type": "Artboard"});
                                                                                                                                    magicmirror.linkLayerIDWithArtboardID(layerID, artboardID);
                                                                                                                                 }
                                                                                                                         }
                                                                                                                     },

                                                                                                                 }

                                                                                                                 return self;
                                                                                                                 })()).alloc().init();

                                                          return delegate;
             });

        for (var i = 0; i < effectiveLayers.count(); i++) {
            var layer = effectiveLayers[i];
            var image = layer.previewImages().LayerListPreviewUnfocusedImage;

            var layerID = layer.objectID();
            var symbolInstanceID = layer.symbolInstanceID || nil;

            var info = nil;

            var mslayer = magicmirror.findLayer(layerID);
            var artboardID = nil;
            if (symbolInstanceID) {

                var symbol = magicmirror.findLayer(symbolInstanceID);
                var overrides = (magicmirror.valueForLayer("overrides", symbol) || [NSDictionary dictionary]);
                artboardID = (overrides[layerID] || {})["artboardID"];
                if (isNullOrNil(artboardID)) artboardID = nil;

                layerID = layerID + "." + symbolInstanceID;     // tedious hack to store more than one id in a single string
            } else {
                artboardID = magicmirror.getPotentiallyLinkedArtboardID(layer);
            }

            var selected = artboardID;
            var cell = skinject.dequeueCell("popupCell");
            if ( ! cell) {
                cell = [[MM3PopupCell alloc] initWithNibName:"MM3PopupCell" bundle:[NSBundle bundleForClass:MM3PopupCell]];
                cell.reuseIdentifier = "popupCell";
                cell.delegate = menuCellDelegate;
            } else {
//                log("cell dequeue (" + cell.reuseIdentifier() + ")");
            }

            cell.name = layer.name();
            cell.image = image;
            cell.popupMenu = nsmenu;
            cell.selectedIdentifier = selected;
            cell.layerID = layerID;
            cell.reloadData();
            section.addCustomCell(cell);
        }

        startTimer.lab("after createCells");

    }

    startTimer.lab("before reloadUI");
    createUITimer.stop();
    reloadUITimer.start();
    skinject.reloadData();
    reloadUITimer.stop();
    startTimer.lab("after reloadUI");

    startTimer.lab("before startTimer.stop");
    var timeElasped = startTimer.stop();

    if (runCount >= 1 && selection.count() >= 1) {
//        if (runCount > 1) {
        log("timers: " + dictify(timers));
        message = "MagicMirror: " + effectiveLayers.count() + " layers selected. (" + timeElasped + "s): " + dictify({
                                                                                                                     "initialize": startTimer.getLap("after check").mark,
                                                                                                                     "Get Effective Layers": startTimer.getLap("after getEffectiveLayers").elapsed,
                                                                                                                     "Create Menu": startTimer.getLap("after createMenu").elapsed,
                                                                                                                     "Create Cells": startTimer.getLap("after createCells").elapsed,
                                                                                                                     "Reload UI": startTimer.getLap("after reloadUI").elapsed

        });
//        each(timers, function(t) {
//                log("timers:" + t); 
//             t.print();
//        });
        log(message);
//        document.showMessage(message);

        if ( ! migrationFailed) {
            magicmirror.onSuccess();
        }
    }

  } catch (exception) {
    log("❌ MagicMirror3 exception: " + exception);
    document.showMessage("exception: " + exception);
  }

};

var onSelectionChanged = function(context) {
    onCurrentSelection(context);
};

var onArtboardChanged = function(context) {
    log("artboard changed");
}

var onLayersMoved = function(context) {
    log("layers moved");
}

var onAddFill = function(context) {
    log("fill added");
}

var onEdit = function(context) {
    log("edit");
}

var onToggleSelection = function(context) {
    log("toggle selection");
}

var onAction = function(context) {
    log("action: " + context.action);
}

