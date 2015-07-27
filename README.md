# Introducing Magic Mirror for Sketch 3

![](http://cl.ly/image/1J0d3W1D0q3x/magic-mirror-banner.gif)

Magic Mirror for Sketch 3 is a Sketch Plugin can create perspective transformed image from an artboard and apply to corresponding shape.

![](http://cl.ly/image/243S012T201L/magic-mirror-intro.gif)

You might also refer it as a simple version of [Photoshop’s Embeded Smart Objects](https://helpx.adobe.com/photoshop/using/create-smart-objects.html) for Sketch.

Unlike [Symbols](http://bohemiancoding.com/sketch/support/documentation/07-symbols/), Magic Mirror uses Pattern Fill to create the mirroring. It can mirror any number of Artboards to any number of shape layers in any size, any angle, but ALSO responds to the shape’s distortion (perspective transformation).

Unlike editing Bitmaps in Sketch, Magic Mirror does not modify the original bitmap in a distructive manner (since we’re sourcing from an Artboard). Using Shape layers instead of Bitmap layers, edited paths are also preserved and can be easily updated.

[![](http://cl.ly/image/0B1O3J021S44/magic-mirror-download.png)](https://github.com/jamztang/MagicMirror.sketchplugin/archive/master.zip)


## Installation

1. Download the package, unzip it and locate `Magic Mirror.sketchplugin`.
2. Double click to install the plugin, if you’ve multiple versions of Sketch, you can drag the plugin into the specific Sketch dock icon.
3. Check that it’s available in the `Plugins` menu.

![](http://cl.ly/image/2z0l023u0O2f/magic-mirror-menu.png)

## Usage

Magic Mirror currently offer three handy methods.

### 1. Magic Mirror! (⌃ ⇧ M)

Apply perpective transform to all layers that can be associated with an artboard with the same name.

[![](http://cl.ly/image/3K0X2m2e0X04/magic-mirror-feature1.gif)](https://youtu.be/aLoqCxshf4s)

1. Prepare an artboard as the source
2. Use the `Rectangle (R)`  or `Vector (V)` tool to draw a 4 point polygon. It’s important NOT to use the `Round Rect` tool because in order for Magic Mirror to work is to have **exactly 4 control points**.
3. Rename your shape layer to **exactly match the Artboard’s name** you want to mirror.
4. Press `⌃ ⇧ M` or go to `Plugin > Magic Mirror > Magic Mirror!` to see the results!

### 2. Jump to Artboard (⌃ ⇧ J)

Quickly jump to the layer’s associated artboard.

![](http://cl.ly/image/2f3o0s1T3L2W/magic-mirror-feature2.gif)

1. Select the magic shape layer you’re currently working on.
2. Press `⌃ ⇧ J` or use `Plugin > Magic Mirror > Jump to Artboard`.

### 3. Rotate Points (⌃ ⌘ ⇧ R)

![](http://cl.ly/image/1w3y3O0P0F0t/magic-mirror-feature3.gif)

Rotate the content orientation of the layer fill.

1. Select the layer
2. Press `⌃ ⌘ ⇧ R` or use `Plugin > Magic Mirror > Rotate Points`.

## So how does it work? (In short)

Magic Mirror operation iterates through all the “Shape” layers (MSShapeGroup) in current page and find out the Artboard-Layer pair that shares the exact same name.

Look into the path (NSBezierPath) and extract the 4 corner points.

Hand it over to ([Core Image](https://developer.apple.com/library/mac/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_intro/ci_intro.html)) to do `Perspective Transformation`, and apply the transformed image using Pattern Fill.

## Quick Tips

1. You’ll want to reapply the mirroring whenever you change the size of your magic shape layer, that will help regenerate the optimized bitmap resolution and corresponding perspective.
2. It’ll only update (or create if not exists) for the bottomost `Fill` layer. So you can put overlays and filters on top of the first layer.

## Troubleshoot (if mirroring fails)

1. Make sure the Artboard is in the same page as your shape layer is.
2. Check that the `Fill` layer is on, especially when you’re using the tool.

## Limitations

1. No live resizing, if you are Sketch plugin developer and aware how to, send a pull request or let me know!
2. Using Pattern fill means that you may want to be more careful with using Shared Styles on those layers.
3. Updating either the layer’s name or the Artboard’s name is currently the only way to opt out from the magic mirroring.

## Future Enhancement

1. Eliminate limitations!
2. Highlighting active magic layer?
3. Support mirroring Symbols?
4. Shortcut to toggle between Artboard and selected layer?
5. Better layer opt-out mechanism?

As long as the project lives, pull requests for features and bug fixes will be highly appreciated!

## Support this project

If you find it useful, you can always refer or contribute to this project.

> **[Send me a coffee ($5 USD)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=RUERV9YM2RT6U)** :)


## Credits

Special thanks to [Simon Pang](http://twitter.com/@simonpang) to help point me back to the right direction when I was lost in reverse engineering Sketch header files without an obvious answer and attempted to manually apply the 3D transformation matrix to the image.

Without him this would likely took me few more nights, or might at worst not possible due to some [complications of expressing certain language syntax in the scripting bridge](https://github.com/ccgus/CocoaScript/issues/30).
