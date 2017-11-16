@import 'SKCheck.js'
@import 'Skinject.framework/Skinject.js'
@import 'MagicMirror3.framework/MagicMirror.js'
@import 'SketchAsync.framework/SketchAsync.js'
@import 'MagicMirrorUI.js'

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

//      var skinject = Skinject(identifier);
//      var magicmirror = MagicMirrorJS(identifier);
      var magicmirror = dispatch_once_per_document("MagicMirrorJS", function() { return MagicMirrorJS(identifier) });
//      magicmirror.onSelectionChanged(context);

      var skinject = dispatch_once_per_document("Skinject", function() { return Skinject(identifier) });

      var async = SketchAsync.alloc().init();

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
        dlog("MagicMirror3: failed to do migration");
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

          // v3.1: background timer to check server notification. (3600sec)
          var softCheck = function checkAgain(sk, mm, interval){
              var identifier = context.plugin.valueForKey("_identifier");
              var disabledIdentifier = identifier + ".disabled";
              var isDisabled = NSUserDefaults.standardUserDefaults().boolForKey(disabledIdentifier);

              // update user default cached message array
              mm.loadServerNotification();

              if(!isDisabled){
                  // repeat update
                  COScript.currentCOScript().scheduleWithInterval_jsFunction(60*60, function(iv){
                                                                             checkAgain(sk, mm, iv);
                                                                             });
              }

          }

          // register interval refresh soft banner here
          COScript.currentCOScript().scheduleWithInterval_jsFunction(5, function(iv){
                                                                     softCheck(skinject, magicmirror, iv);
                                                                     });
      }

    startTimer.lab("before getEffectiveLayers");

    getSelectionTimer.start()
//    effectiveLayers = [NSArray array];
      var section = configureSectionHeader(magicmirror, skinject);
      remember(section, "section")
      dlog("onchange.js 1 before getEffectiveLayers ");

    var effectiveLayers = magicmirror.getEffectiveLayers(selection);

      dlog("onchange.js 2 after getEffectiveLayers " + effectiveLayers);
    var async = dispatch_once_per_document("async", function() { return SketchAsync.alloc().init() })
    async.runInBackground_onCompletion_withIdentifier_(function(identifier) {
                                             dlog("gettingEffectiveLayers " + identifier);
                                            var effectiveLayers = [];//magicmirror.getEffectiveLayers(selection);
                                             remember(identifier, "getEffectiveLayer");

                                            dlog("section: " + section);

                                             return effectiveLayers;
                                         },
                                         function(result, identifier) {
                                             if (remind("getEffectiveLayer") == identifier) {
                                                 dlog("finish " + identifier);
                                                var section = remind("section")
                                                dlog("section: " + section);
                                             } else {
                                                 dlog("ignore this " + identifier)
                                                 return
                                             }

    startTimer.lab("after getEffectiveLayers: ");
    getSelectionTimer.stop();

    var MM3SelectionController = function(selection) {
//        var effectiveLayers = magicmirror.getEffectiveLayers(selection);
        var commonHandler = {
            configureHeader: function(section) {

            },
            configureCell: function(section) {

            },
            refresh: function() {
                dlog("MM3: selectionController: refresh: selection " + selection);
                each(selection, function(layer) {
                    magicmirror.refreshLayer(layer);
                });
            },
            refreshAll: function() {
                magicmirror.refreshAll();
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
            setIncluded: function(value) {
                each(selection, function(layer) {
                     magicmirror.setIncluded(layer, value);
                });
            },
            setAutoRefresh: function(value){
                magicmirror.setAutoUpdate(value);
            },
        };
        return commonHandler;
    }

    dlog("onchange.js 3");

    var MM3NoneSelectionController = function() {
        var commonHandler = {
            refreshAll: function() {
                magicmirror.refreshAll();
            },
        };
        return commonHandler;
    }
                                                       dlog("onchange.js 4");

    var mmhandler = Class("MM3ViewControllerDelegate", NSObject, {
                          "controller:didSelectImageQuality:":function(viewController, option) {
                              dlog("imageQualityDidSelect: " + option);
                              magicmirror.trackForEvent("Picked ImageQuality", {"Image Quality":option, "Layer Type": selection[0].className()});
                              var controller = MM3SelectionController(selection);
                              controller.setImageQuality(option);
                          },
                          "controllerDidPressRotateLayer:": function(viewController) {
                              dlog("rotateLayer");
                              magicmirror.trackForEvent("Rotated Layer", {"Layer Type":selection[0].className()});
                              var controller = MM3SelectionController(selection);
                              controller.rotate();
                          },
                          "controllerDidPressFlipLayer:": function(viewController) {
                              dlog("flipLayer");
                              magicmirror.trackForEvent("Flipped Layer", {"Layer Type":selection[0].className()});
                              var controller = MM3SelectionController(selection);
                              controller.flip();
                          },
                          "controllerDidPressRefreshLayer:": function(viewController) {
                              dlog("refreshLayer");

                              if (selection.length > 0){
                                magicmirror.trackForEvent("Refreshed Layer", {"Layer Type": selection[0].className(), "Image Quality": magicmirror.imageQuality(selection[0])});
                                var controller = MM3SelectionController(selection);
                                controller.refresh();
                              }else{
                                magicmirror.trackForEvent("Refreshed All Layer", {});
                                var controller = MM3NoneSelectionController();
                                controller.refreshAll();
                              }

                          },
                          "controller:didToggleAutoRefresh:": function(viewController, option) {
                          dlog("autoRefreshToggle");
                          magicmirror.trackForEvent("Toggle refresh", {"Set State":(option==0?"NO":"YES")});
                          
                          var controller = MM3SelectionController(selection);
                          controller.setAutoRefresh(option)
                          viewController.autoRefresh = option;
                          viewController.reloadData();
                          },
                          "controller:didToggleIncludeInArtboards:":function(viewController, option) {
                              dlog("setIncluded: " + option);
                              magicmirror.trackForEvent("Picked IncludeInArtboards", {"Set Include": (option==0?"NO":"YES")});
//                              var layer = magicmirror.findLayer(viewController.identifier());
                              var controller = MM3SelectionController(selection);
                              controller.setIncluded(option)
                              viewController.includeInArtboards = option;
                              viewController.reloadData();
//                              magicmirror.setIncluded(layer, option);
                          },
                          "controllerDidPressProButton:": function(viewController) {
                              dlog("didPressProButton:");
                              magicmirror.trackForEvent("Clicked SettingsButton", {});
                          },
                          "controllerDidPressActivateButton:": function(viewController) {
                              dlog("didPressActivateButton:");
                              magicmirror.trackForEvent("Clicked ActivateButton", {});
                          },
                          "controllerDidPressActionButton:": function(viewController) {
                              dlog("didPressActionButton:");
                              magicmirror.trackForEvent("Clicked ActionButton", {});
                          },
                          "controllerDidPressReadMessageButton:messageId:": function(viewController, messageId) {
                              dlog("didPressReadMessageButton:");
                              magicmirror.trackForEvent("Clicked ReadMessageButton", {"Message ID":messageId});
                          },
                          "controllerDidPressSoftBannerActionButton:messageId:": function(viewController, messageId) {
                              dlog("didPressSoftBannerActionButton:");
                              magicmirror.trackForEvent("Clicked SoftBannerActionButton", {"Message ID":messageId});
                          },
                          "controllerNeedToUpdateLayout:": function(viewController){
                              skinject.reloadData();
                          }
                          }).alloc().init();
                                                       dlog("onchange.js 5");

    startTimer.lab("before printSelectionTimer");
    printSelectionTimer.start()
//    magicmirror.selection(selection).description();
    printSelectionTimer.stop();
    startTimer.lab("after printSelectionTimer");
    // 0.8
                                                       dlog("onchange.js 6");

    startTimer.lab("before createHeader");

    createUITimer.start();
//    var header = skinject.dequeueCell("header");
//    if ( ! header) {
//        header = [[MM3ViewController alloc] initWithNibName:"MM3InspectorHeader" bundle:[NSBundle bundleForClass:MM3ViewController]];
//        header.reuseIdentifier = "header";
//    } else {
////        dlog("cell dequeued (" + header.reuseIdentifier() + ")");
//    }
//    header.delegate = mmhandler;

//                                                       dlog("onchange.js 7 mmhandler: " + mmhandler );
  //                                                     Mocha.sharedRuntime().setValue_forKey_(1, "1");

                                                       dlog("onchange.js 7 mmhandler: " + mmhandler );

    Mocha.sharedRuntime().setValue_forKey_(mmhandler, "MM3ViewControllerDelegate");

    startTimer.lab("after createHeader");


    if ( ! magicmirror.isBuildInSync()) {
        dlog("magicmirror is not in sync");
        var avc = skinject.dequeueCell("outofsync");
        if ( ! avc) {
            avc = [[MM3ViewController alloc] initWithNibName:"MM3ActivationCell" bundle:[NSBundle bundleForClass:MM3ViewController]];
            avc.reuseIdentifier = "outofsync";
        } else {
//            dlog("cell dequeued (" + avc.reuseIdentifier() + ")");
        }
        avc.delegate = mmhandler;
        avc.message = "Plugin is out of sync, please save your work and restart Sketch to continue using.";
        avc.actionTitle = "Close";
        avc.actionURL = nil;
        avc.action = [MM3BashAction nothing];
        avc.reloadData();
        section.addCustomCell(avc);
    } else if (magicmirror.isExpired()) {
        dlog("magicmirror is expired");
        var avc = skinject.dequeueCell("expired");
        if ( ! avc) {
            avc = [[MM3ViewController alloc] initWithNibName:"MM3ActivationCell" bundle:[NSBundle bundleForClass:MM3ViewController]];
            avc.reuseIdentifier = "activation";
        } else {
//            dlog("cell dequeued (" + avc.reuseIdentifier() + ")");
        }
        avc.delegate = mmhandler;
        avc.message = magicmirror.expiredMessage();
        avc.actionTitle = magicmirror.actionTitle();
        avc.actionURL = magicmirror.actionURL();
        avc.reloadData();
        section.addCustomCell(avc);
    } else if (migrationFailed) {
        var avc = skinject.dequeueCell("migrationFailed");
        if ( ! avc) {
            avc = [[MM3ViewController alloc] initWithNibName:"MM3ActivationCell" bundle:[NSBundle bundleForClass:MM3ViewController]];
            avc.reuseIdentifier = "migration";
        } else {
//            dlog("cell dequeued (" + avc.reuseIdentifier() + ")");
        }
        avc.delegate = mmhandler;
        avc.message = "Migration failed, please contact support!"
        avc.actionTitle = "Support";
        avc.actionURL = NSURL.URLWithString("mailto:support@magicsketch.io");
        avc.reloadData();
        section.addCustomCell(avc);
    } else if ( ! magicmirror.isActivated()) {
       dlog("magicmirror not activated");

        var avc = skinject.dequeueCell("notActivated");
        if ( ! avc) {
            avc = [[MM3ViewController alloc] initWithNibName:"MM3ActivationCell" bundle:[NSBundle bundleForClass:MM3ViewController]];
            avc.reuseIdentifier = "notActivated";
        } else {
//            dlog("cell dequeue (" + avc.reuseIdentifier() + ")");
        }
        avc.delegate = mmhandler;
        avc.reloadData();
        section.addCustomCell(avc);

    } else if (selection.count() == 0) {

                                                       dlog("onchange.js 8 selection.count() == 0");
        // If nothing is selected, we just want to hide any previous message that might have been shown.
//        document.hideMessage();

        // 3.0.2: Always make mirror panel visible:
        var lvc = skinject.dequeueCell("layerToolbar");
        if ( ! lvc) {
            lvc = [[MM3ViewController alloc] initWithNibName:"MM3LayerToolbar" bundle:[NSBundle bundleForClass:MM3ViewController]];
            lvc.reuseIdentifier = "layerToolbar";
        } else {
            //                dlog("cell dequeue (" + lvc.reuseIdentifier() + ")");
        }
        lvc.delegate = mmhandler;
        lvc.imageQuality = -1;
        lvc.autoRefresh = magicmirror.isAutoUpdate();
        lvc.reloadData();
        lvc.disableLayerButton();
        section.addCustomCell(lvc);
         
         // 3.0.8: Auto update: Check all artboards for snapshot & export quality difference.
         var allArtboards = document.documentData().allArtboards();
         each(allArtboards, function(ab){
              var artboardQuality = magicmirror.valueForLayer("highestQuality", ab);
              var artboardSnapshot = remind(ab.objectID()+".fastcheck.snapshot");
              if(artboardQuality && artboardSnapshot && artboardQuality != -1){
                dlog("3.0.8: check "+magicmirror.checkEqual(artboardSnapshot, ab.immutableModelObject()))
                if(!magicmirror.checkEqual(artboardSnapshot, ab.immutableModelObject()) || artboardQuality != magicmirror.autoImageQuality(ab)){
                  dlog("3.0.8: artboard has changed. should mark linked layer to be dirty. :"+ab);
                  var linkedLayers = magicmirror.valueForLayer("linkedLayers", ab);

                  dlog("3.0.8: refresh linked layers: "+linkedLayers);

                  if(linkedLayers && linkedLayers.length > 0){
                    if(magicmirror.isAutoUpdate()){
                      dlog("3.0.8: should perform refresh to these layers");
                      each(linkedLayers, function(layerID){
                        magicmirror.refreshLayer(magicmirror.findLayer(layerID));
                      });
                    }else{
                      // TODO: mark as dirty only
                      dlog("3.0.8: should set dirty to these layers");
                    }
                    
                  }

                  // magicmirror.setValueForKeyOnLayer(null, "snapshot", ab);
                  remember("", ab.objectID()+".fastcheck.snapshot");
                  magicmirror.setValueForKeyOnLayer(-1, "highestQuality", ab);
                }
              }
              });

    } else {


        var includable = [NSMutableArray array];
                                                       dlog("onchange.js 8 else selection " + selection);

        if (selection.count() > 0) {

            for (var i = 0; i < selection.count(); i++) {
                var layer = selection[i];
                if ([layer isKindOfClass:MSArtboardGroup] || [layer isKindOfClass:MSSymbolMaster] || [layer isKindOfClass:MSSliceLayer]) {
                    includable.addObject(layer);
                }
            }
                                                       dlog("onchange.js 8.1 includable " + includable);

            if (includable.count() > 0) {
                startTimer.lab("before createArtboardToolbar");

                var avc = skinject.dequeueCell("artboardToolbar");
                if ( ! avc) {
                    avc = [[MM3ViewController alloc] initWithNibName:"MM3ArtboardToolbar" bundle:[NSBundle bundleForClass:MM3ViewController]];
                    avc.reuseIdentifier = "artboardToolbar";
                } else {
                    //                    dlog("cell dequeue (" + avc.reuseIdentifier() + ")");
                }
                avc.delegate = mmhandler;
                avc.identifier = selection.firstObject().objectID()
                avc.includeInArtboards = magicmirror.isIncluded(includable);
                startTimer.lab("-- before getThumbnail");
                avc.previewImage = magicmirror.getThumbnail(includable, CGSizeMake(36, 24));
                startTimer.lab("-- after getThumbnail");
                avc.imageQuality = magicmirror.imageQuality(includable);
                avc.reloadData();
                //                dlog("included: " + magicmirror.isIncluded(selected));
                section.addCustomCell(avc);

                startTimer.lab("after createArtboardToolbar");
            }
                                                       
             // 3.0.8: Save snapshot to artboard when selected for later checking
             if(selection[0].parentArtboard()){
                dlog("3.0.8: auto update: before save snapshot here");
               var pArtboard = selection[0].parentArtboard();

               if([pArtboard isKindOfClass:MSArtboardGroup]){
                dlog("3.0.8: save snapshot "+pArtboard.immutableModelObject());
                dlog("3.0.8: save quality "+magicmirror.autoImageQuality(pArtboard));
                remember(pArtboard.immutableModelObject(), pArtboard.objectID()+".fastcheck.snapshot");
                // magicmirror.setValueForKeyOnLayer(pArtboard.immutableModelObject(), "snapshot", pArtboard);
                magicmirror.setValueForKeyOnLayer(magicmirror.autoImageQuality(pArtboard), "highestQuality", pArtboard);
               }
             }
        }

                                                       dlog("onchange.js 8.2 before getArtboards");

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
        // dlog(descriptor)
        artboards = artboards.sortedArrayUsingDescriptors([descriptor]);
        startTimer.lab("after sortArtboards");

        function createMenu(artboards, magicmirror) {

                                                       dlog("onchange.js createMenu 0");
            createMenuTimer.start()
            var menu = [];

                                                       dlog("onchange.js createMenu 1");
            menu.push({
                    identifier: nil,
                    title: "No Artboard",
                    image: nil,
                    });

            menu.push({
                    type:"separator",
                    });

                                                       dlog("onchange.js createMenu 2");
            for (var i = 0; i < artboards.count(); i++) {
                var artboard = artboards.objectAtIndex(i);
//                if (magicmirror.isIncluded(artboard) == 1) {

                                                       dlog("onchange.js createMenu 3 artboard: " + artboard);
                    createUITimer.stop();
                    generateThumbnailTimer.start();

                    var image = magicmirror.getThumbnail(artboard, CGSizeMake(24, 24));

                                                       dlog("onchange.js createMenu 3 image: " + image);
                    createUITimer.start();
                    generateThumbnailTimer.stop();
                    menu.push({
                            identifier: artboard.objectID(),
                            title: artboard.name(),
    //                          image: nil,
                            image: image,
                            });
//                }

                                                       dlog("onchange.js createMenu 3 after ");
            }

//            menu.push({
//                    type:"separator",
//                    });
//
//            each(magicmirror.getPlaceholders(), function(placeholder) {
//                menu.push(placeholder)
//                });
//
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


                                                       dlog("onchange.js createMenu 4");
            return menu;
        }

                                                       dlog("onchange.js 8.3 after getArtboards");


        // Create Layer Toolbar
        createUITimer.stop();
        startTimer.lab("before createMenu");

                                                       dlog("onchange.js 8.4 before create menu");

        var menu = createMenu(artboards, magicmirror);
        startTimer.lab("after createMenu");


                                                       dlog("onchange.js 8.4 after create menu");
        createUITimer.start();

        var selected = selection[0];
        var lvc = skinject.dequeueCell("layerToolbar");
        if ( ! lvc) {
            lvc = [[MM3ViewController alloc] initWithNibName:"MM3LayerToolbar" bundle:[NSBundle bundleForClass:MM3ViewController]];
            lvc.reuseIdentifier = "layerToolbar";
        } else {
//                dlog("cell dequeue (" + lvc.reuseIdentifier() + ")");
        }
        lvc.delegate = mmhandler;
        lvc.imageQuality = selection.count() > 1 ? -1 : magicmirror.imageQuality(selected);
        lvc.autoRefresh = magicmirror.isAutoUpdate();
        lvc.parentArtboardHighestQuality = magicmirror.autoImageQuality(selected);
        lvc.identifier = selection.firstObject().objectID()
        lvc.reloadData();
        section.addCustomCell(lvc);
        // End creating Layer Toolbar
                                                       dlog("onchange.js 8.4 after layer toolbar");

        var nsmenu = menu ? [MM3Menu menuWithItems:menu] : nil;

        startTimer.lab("before createCells");

        var menuCellDelegate = dispatch_once_per_document("MM3MenuCellDelegate", function() {

                                                          var delegate = Class("MM3MenuCellDelegate", NSObject, (function() {

                                                                                                                 var self = {

                                                                                                                     "popupCellSelectedDidChange:":function(cell) {

                                                                                                                         dlog("popupCellSelectedDidChange:");

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
                                                                                                                         dlog("type: " + type);
                                                                                                                         dlog("selectedIdentifier: " + selectedIdentifier);
                                                                                                                         dlog(representedObject);

                                                                                                                         if (type == "action") {
                                                                                                                             var identifier = selectedIdentifier;
                                                                                                                             if (identifier == "manageArtboards") {

                                                                                                                 dlog("manage artboards");
                                                                                                                 var controller = dispatch_once_per_document("MM3ManageArtboardWindow", function() {
                                                                                                                                                             var storyboard = [NSStoryboard storyboardWithName:@"MM3Storyboard" bundle:[NSBundle bundleForClass:MM3PopupCell]];
                                                                                                                                                             dlog("storyboard: " + storyboard);
                                                                                                                      var windowController = [storyboard instantiateControllerWithIdentifier:"MM3ManageArtboardWindow"];

                                                                                                                                                             dlog("windowController: " + windowController);
                                                                                                                                                             return windowController;
                                                                                                                                                             });

                                                                                                                 controller.showWindow(controller.window());



                                                                                                                             }
                                                                                                                         } else {
                                                                                                                                 var artboardID = selectedIdentifier;
                                                                                                                                 var layer = magicmirror.findLayer(layerID);
                                                                                                                                 dlog("layerID: " + layerID + " artboardID: " + artboardID + " symbolID: " + symbolInstanceID);

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

                                                       dlog("onchange 8.5 effectiveLayers: " + effectiveLayers);
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
//                dlog("cell dequeue (" + cell.reuseIdentifier() + ")");
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

    // 3.1: show banner if user default message array is not empty
      var serverMessages = NSUserDefaults.standardUserDefaults().valueForKey('io.magicsketch.mirror.servermessage');
    if (serverMessages && serverMessages.length > 0){
        var displayMessage = {"message": "", "action": "", "id": -1};
//        function randomString(length, chars) {
//            var result = '';
//            for (var i = length; i > 0; --i) result += chars[Math.floor(Math.random() * chars.length)];
//            return result;
//        }
//        var rString = randomString(parseInt(Math.random()*64)+1, '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ');
//        var displayMessage = {"message": rString, "action": "", "id": 999};

        for(var i=serverMessages.length-1; i>=0; i--){
            if(serverMessages[i].read == 0){
                displayMessage = serverMessages[i];
                break;
            }
        }

        if(displayMessage.id != -1){
            var banner = skinject.dequeueCell("softBanner");
            if ( ! banner) {
                banner = [[MM3ResizeViewController alloc] initWithNibName:"MM3SoftBannerCell" bundle:[NSBundle bundleForClass:MM3ViewController]];
                banner.reuseIdentifier = "softBanner";
            } else {
                //        dlog("cell dequeued (" + header.reuseIdentifier() + ")");
            }

            banner.delegate = mmhandler;
            banner.showSoftMessage_action_messageId(displayMessage.message, displayMessage.action, displayMessage.id);

            var section = skinject.addCustomSection(banner);
        }

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
        dlog("timers: " + dictify(timers));
        message = "MagicMirror: " + effectiveLayers.count() + " layers selected. (" + timeElasped + "s): " + dictify({
                                                                                                                     "initialize": startTimer.getLap("after check").mark,
                                                                                                                     "Get Effective Layers": startTimer.getLap("after getEffectiveLayers").elapsed,
                                                                                                                     "Create Menu": startTimer.getLap("after createMenu").elapsed,
                                                                                                                     "Create Cells": startTimer.getLap("after createCells").elapsed,
                                                                                                                     "Reload UI": startTimer.getLap("after reloadUI").elapsed

        });
//        each(timers, function(t) {
//                dlog("timers:" + t);
//             t.print();
//        });
        dlog(message);
//        document.showMessage(message);

        if ( ! migrationFailed) {
            magicmirror.onSuccess();
        }
    }

   }, "getEffectiveLayers" + [[[NSUUID alloc] init] UUIDString]); // async.runInBackground


  } catch (exception) {
    log("❌ MagicMirror3 exception: " + exception);
    document.showMessage("exception: " + exception);
  }

};

var onSelectionChanged = function(context) {

    onCurrentSelection(context);

    return;

};

var onArtboardChanged = function(context) {
    dlog("artboard changed");
}

var onLayersMoved = function(context) {
    dlog("layers moved");
}

var onAddFill = function(context) {
    dlog("fill added");
}

var onEdit = function(context) {
    dlog("edit");
}

var onToggleSelection = function(context) {
    dlog("toggle selection");
}

var onAction = function(context) {
    dlog("action: " + context.action);
}
