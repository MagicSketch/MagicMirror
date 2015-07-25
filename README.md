# Introducing Magic Mirror for Sketch 3

![](http://cl.ly/image/1J0d3W1D0q3x/magic-mirror-banner.gif)

Magic Mirror for Sketch 3 is a Plugin that can mirror content from an Artboard to a corresponding shape layer.

You might also refer it as a simple version of [Photoshop’s Embeded Smart Objects](https://helpx.adobe.com/photoshop/using/create-smart-objects.html) for Sketch.

Unlike [Symbols](http://bohemiancoding.com/sketch/support/documentation/07-symbols/), Magic Mirror uses Pattern Fill to create the mirroring. It can mirror any number of Artboards to any number of shape layers in any size, any angle, but ALSO responds to the shape’s distortion (perspective transformation).

Unlike editing Bitmaps in Sketch, Magic Mirror does not modify the original bitmap in a distructive manner (since we’re sourcing from an Artboard). Using Shape layers instead of Bitmap layers, edited paths are also preserved and can be easily updated.

Download `Magic Mirror.sketchplugin`

## Demo


As seen in the video, we’re able to simutaneously fill up certain shape layers with our screenshot, and creating new shapes that mirrors the content are as easy as well.

## So how does it work? (In short)

Magic Mirror operation iterates through all the “Shape” layers (MSShapeGroup) in current page and find out the Artboard-Layer pair that shares the exact same name.

Look into the path (NSBezierPath) and extract the 4 corner points.

Hand it over to ([Core Image](https://developer.apple.com/library/mac/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_intro/ci_intro.html)) to do `Perspective Transformation`, and apply the transformed image using Pattern Fill.

## Usage

### Magic Mirror! (⌃ ⇧ M)

Apply perpective transform to all layers that can be associated with an artboard with the same name.

1. Use the `Rectangle (R)`  or `Vector (V)` tool to draw a 4 point polygon. It’s important NOT to use the `Round Rect` tool because in order for Magic Mirror to work is to have **exactly 4 control points** in the corresponding order (Top Left, Top Right, Bottom Right, Bottom Left).
2. Rename your shape layer to **exactly match the Artboard’s name** you want to mirror.
3. Press `⌃ ⇧ M` or go to `Plugin > Magic Mirror > Magic Mirror!` to see the results!

### Jump to Artboard (⌃ ⇧ J)

Quickly jump to the layer’s associated artboard.

1. Select the magic shape layer you’re currently working on.
2. Press `⌃ ⇧ J` or use `Plugin > Magic Mirror > Jump to Artboard`.

### Rotate Points (⌃ ⌘ ⇧ R)

Rotate the content orientation of the layer fill.

1. Select the layer
2. Press `⌃ ⌘ ⇧ R` or use `Plugin > Magic Mirror > Rotate Points`.

### Quick Tip

1. You’ll want to reapply the mirroring whenever you change the size of your magic shape layer, that will help regenerate the optimized bitmap resolution and corresponding perspective.
2. It’ll only update (or create if not exists) for the bottomost `Fill` layer. So you can put overlays and filters on top of the first layer.

## Installation

1. Download the package, unzip it and locate `Magic Mirror.sketchplugin`.
2. Double click to install the plugin, if you’ve multiple versions of Sketch, you can drag the plugin into the specific Sketch dock icon.
3. Check that it’s available in the `Plugins` menu.
![](http://cl.ly/image/3E2R1H0n0G3S/magic-mirror-menu.png)

## Troubleshoot (if mirroring fails)

1. Make sure the Artboard is in the same page as your shape layer is.
2. Check that the `Fill` layer is on, especially when you’re using the tool.
3. If your shape doesn’t seemed to appear in the `Fill` thumbnail, you might have a wrong ordering of the 4 points. You should delete it and redraw in this order: TopLeft, TopRight, BottomRight, BottomLeft.

## Limitations

1. No live resizing, if you are Sketch plugin developer and aware how to, send a pull request or let me know!
2. Using Pattern fill means that you may not want to be a bit more careful about Shared Styles.
3. Updating the layer’s name or the Artboard’s name is currently the only way to opt out from the magic mirroring.

## Future Enhancement

1. Fixing limitations!
2. Highlighting active magic layer?
3. Support mirroring Symbols?
2. Shortcut to toggle between Artboard and selected layer?

As long as the project lives, pull requests for features and bug fixes will be highly appreciated!

## Support this project

If you find it useful, you can always refer or contribute to this project.

### Today for iOS | Pomodoro Timer + Daily Target List
![](http://cl.ly/image/0k1j003a342B/03.jpg)
The sparkling behind this idea was because I went solely independant for the past 4 months to work on this app. You can always support me by downloading and purchasing a few features in the app :)

[Download Today on AppStore](https://itunes.apple.com/app/today-plan-focus-review-to/id991615593?ls=1&mt=8) | [Homepage](http://today.gd)

## Credits

Special thanks to [Simon Pang](http://twitter.com/@simonpang) to help point me back to the right direction when I was lost in reverse engineering Sketch header files without an obvious answer and attempted to manually apply the 3D transformation matrix to the image.

Without him this would likely took me few more nights, or might at worst not possible due to some [complications of expressing certain language syntax in the scripting bridge](https://github.com/ccgus/CocoaScript/issues/30).