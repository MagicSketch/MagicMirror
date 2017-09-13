
var enable = function(context) {
    context.command.setValue_forKey_onDocument_(1, "enable", context.document.documentData());
    context.document.showMessage("Enabled");
};

var disable = function(context) {
    context.command.setValue_forKey_onDocument_(0, "enable", context.document.documentData());
    context.document.showMessage("Disabled");
};

var isEnabled = function(context) {
    return true;
}

// Helper

var Class = function(className, BaseClass, selectorHandlerDict){
    var uniqueClassName = className + NSUUID.UUID().UUIDString();
    var delegateClassDesc = MOClassDescription.allocateDescriptionForClassWithName_superclass_(uniqueClassName, BaseClass);

    for (var selectorString in selectorHandlerDict) {
        delegateClassDesc.addInstanceMethodWithSelector_function_(selectorString, selectorHandlerDict[selectorString]);
    }
    delegateClassDesc.registerClass();

    return NSClassFromString(uniqueClassName);
};

var dispatch_once = function(identifier, handler) {
    var info = Mocha.sharedRuntime().valueForKey(identifier);
    if ( ! info) {
        info = handler() || true;
        Mocha.sharedRuntime().setValue_forKey_(info, identifier);
    }
    return info;
}

var dispatch_once_per_document = function(identifier, handler) {
    var app = [MSDocument currentDocument];
    var perDocId = app + "-" + identifier;
    var info = Mocha.sharedRuntime().valueForKey(perDocId);
    if ( ! info) {
        info = handler() || true;
        Mocha.sharedRuntime().setValue_forKey_(info, perDocId);
    }
    return info;
}

var remember = function(something, key) {
    Mocha.sharedRuntime().setValue_forKey_(something, key);
}

var remind = function(key) {
    return Mocha.sharedRuntime().valueForKey(key)
}

// End of Helper

var Skinject = function(identifier) {

    // Variables
    var _context, _inspector, _document, _view, _c;

    // Private Methods

    var slog = function(message) {
        log("Skinject ("+ identifier +"): " + message);
    };

    var loadFramework = function(context, name) {

        var resourcesPath = function(context) {
            var _application = NSApplication.sharedApplication();
            var _delegate = _application.delegate();
            var _plugins = _delegate.pluginManager().plugins();
            var _plugin = _plugins[identifier];
            var _path = _plugin.url().copy().path() + "/Contents/Sketch";
            return _path;
        };

        var mocha = Mocha.sharedRuntime();
        var frameworkName = name || "Skinject";
        var directory = resourcesPath(context);
        if ([mocha loadFrameworkWithName:frameworkName inDirectory:directory]) {
            slog("loadFramework: `" + frameworkName + "` success!", context);
            return true;
        } else {
            slog("❌  loadFramework: `" + frameworkName + "` failed!", context);
            slog(directory, context);
            return false;
        }
    };

    var viewsWithClassNameInView = function(className, view) {

        var array = NSMutableArray.array();

        for (var i = 0; i < view.subviews().count(); i++) {
            var subview = view.subviews()[i];
            if (subview.className() == className) {
                array.addObject(subview);
            }
            array.addObjectsFromArray(viewsWithClassNameInView(className, subview));
        }
        return array;
    };


    var createInspector = function(context) {
        return {
            addObject:function(obj) {
                _c.addObject(obj);
            },
            reloadData: function() {
                _stackView.reloadWithViewControllers(_controllers);
            }
        };
    };

    // Life Cycle


    return {
        viewsWithClassNameInView: viewsWithClassNameInView,
        load: function(context){
            loadFramework(context);
        },
        loadFramework: function(name) {
            loadFramework(_context, name);
        },
        reloadData: function() {
            _inspector.reloadData();
        },
        dequeueCell: function(reuseIdentifier) {
            return _c.dequeueObjectForReuseIdentifier(reuseIdentifier);
        },
        onRun: function(context) {

            _context = context;

            if ( ! isEnabled(context)) {

                var disabledMessage = function(context) {
                    slog("Skinject framework is not yet enabled. Run enable(context) in Skinject.js");
                };

                this.addInspectorSection = disabledMessage;
                this.addCell = disabledMessage;
                this.createCell = disabledMessage;
                return this;
            }

            dispatch_once("loadSkinject", function() {
                          loadFramework(context);
                          });

            _inspector = createInspector(context);
            _document = _context.document
            _view = _document.window().contentView()

            _stackView = _document.inspectorController().normalInspector().stackView();   // save 300ms instead of searching through _view


            _controllers = _stackView.sectionViewControllers().mutableCopy();

            _c = dispatch_once_per_document("SKInspectorController", function() { return NSClassFromString("SKInspectorController").alloc().init() });
            _c.removeAllObjects();
            _controllers.addObject(_c);
        },
        onSelectionChanged:function(context){

            _context = context;

            if ( ! isEnabled(context)) {

                var disabledMessage = function(context) {
                    slog("Skinject framework is not yet enabled. Run enable(context) in Skinject.js");
                };

                this.addInspectorSection = disabledMessage;
                this.addCell = disabledMessage;
                this.createCell = disabledMessage;
                return this;
            }

            dispatch_once("loadSkinject", function() {
                loadFramework(context);
            });

            _inspector = createInspector(context);
            _document = _context.actionContext.document
            _view = _document.window().contentView()

            _stackView = _document.inspectorController().normalInspector().stackView()

            _controllers = _stackView.sectionViewControllers().mutableCopy();

            _c = dispatch_once_per_document("SKInspectorController", function() { return NSClassFromString("SKInspectorController").alloc().init() });
            _c.removeAllObjects();
            _controllers.addObject(_c);

            return this;
        },
        addInspectorSection:function(title) {
            var cls = NSClassFromString("SKViewController");
            var header = cls.loadNibNamed("SKInspectorHeader");
            header.title = title;
            return this.addCustomSection(header);
        },
        addCustomSection:function(viewController) {
            _inspector.addObject(viewController);

            return {
                createCell:function(reuseIdentifier) {
                    return {
                        default:function(title, image) {
                            return {
                                title: title,
                                image: image,
                                nibName: "SKInspectorCell",
                            }
                        },
                        popup:function(identifier,
                                       title,
                                       image,
                                       menu,
                                       selected,
                                       callback) {


                            COScript.currentCOScript().setShouldKeepAround_(true);

                            // callback: function(identifier)
                            // menu: [{identifier, title, image}]
                            return {
                                identifier: identifier,
                                reuseIdentifier: reuseIdentifier,
                                title: title,
                                image: image,
                                menu: menu,
                                selected: selected,
                                callback: callback,
                                nibName: "SKInspectorCellPopup"
                            };
                        },
                    };
                },
                addCustomCell:function(viewController) {
                    _inspector.addObject(viewController);
                },
                addCell:function(cellInfo) {
                    // cellInfo should be created by createCell.

                    // Get all variables
                    var identifier = cellInfo.identifier || "";
                    var reuseIdentifier = cellInfo.reuseIdentifier;
                    var title = cellInfo.title || "";
                    var image = cellInfo.image || nil;
                    var nibName = cellInfo.nibName || "SKInspectorCell";
                    var baseClass = cellInfo.baseClass || NSClassFromString("SKViewController");

                    // Default
                    var cell = _c.dequeueObjectForReuseIdentifier(reuseIdentifier);

                    if ( ! cell) {
                        log("creating cell (" + reuseIdentifier + ")");
                        cell = baseClass.loadNibNamed(nibName);
                    } else {
                        log("cell dequeued (" + reuseIdentifier + ")");
                    }

                    cell.identifier = identifier;
                    cell.reuseIdentifier = reuseIdentifier;
                    cell.title = title;
                    cell.image = image;
                    // End of Default Configuration

                    if (cellInfo.menu) {
                      // Popup
                      var menu = cellInfo.menu || [
                           { "title": "0", identifier: "0", image:nil },
                           { "type": "separator" },
                           { "title": "1", identifier: "1", image:nil },
                           { "title": "2", identifier: "2", image:nil },
                           { "title": "3", identifier: "3", image:nil },
                      ];
                      var onSelect = cellInfo.callback;
                      var selected = cellInfo.selected;
                      var array = menu.map(function (item) {
                                           if (item.type == "separator") {
                                               return [SKMenuItem separatorItem];
                                           }
                                           return [SKMenuItem itemWithIdentifier:item.identifier
                                                                           title:item.title
                                                                           image:item.image];
                                           });
                      cell.options = NSArray.arrayWithArray(array);
                      var delegate1 = Class("Delegate", NSObject, {
                                            "controller:optionDidSelect:": function(cell, item) {
                                            slog("controller:optionDidSelect:");
                                                if (onSelect) {
                                                    var itemInfo = {
                                                        "identifier": item.identifier(),
                                                        "title": item.title()
                                                    };
                                                    onSelect(cellInfo, itemInfo);
                                                }
                                            }
                                            }).alloc().init();
                      cell.delegate = delegate1;
                      cell.selectedIdentifier = selected;
                    } // End of Popup

                    cell.reloadData();
                    _inspector.addObject(cell);

                },
            }
        },
    }
};

