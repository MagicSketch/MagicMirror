@import 'Skinject.framework/Skinject.js'
@import 'MagicMirror3.framework/MagicMirror.js'
@import 'dlog.js'

var configureSectionHeader = function(magicmirror, skinject) {

    var header = skinject.dequeueCell("header");
    if ( ! header) {
        header = [[MM3ViewController alloc] initWithNibName:"MM3InspectorHeader" bundle:[NSBundle bundleForClass:MM3ViewController]];
        header.reuseIdentifier = "header";
    } else {
    }

    var section = skinject.addCustomSection(header);
    skinject.reloadData();

    return section
}

var configureLayerToolbar = function(magicmirror, skinject, section) {

    var lvc = skinject.dequeueCell("layerToolbar");
    if ( ! lvc) {
        lvc = [[MM3ViewController alloc] initWithNibName:"MM3LayerToolbar" bundle:[NSBundle bundleForClass:MM3ViewController]];
        lvc.reuseIdentifier = "layerToolbar";
    } else {
        //                dlog("cell dequeue (" + lvc.reuseIdentifier() + ")");
    }
//    lvc.delegate = mmhandler;
    lvc.imageQuality = -1;
    lvc.reloadData();
    lvc.disableLayerButton();
    section.addCustomCell(lvc);

    skinject.reloadData();

}

var configureMenu = function(magicmirror, skinject, section) {

}
