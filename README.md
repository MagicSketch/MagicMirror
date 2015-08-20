# Magic Mirror for Sketch 3

![](http://cl.ly/image/1J0d3W1D0q3x/magic-mirror-banner.gif)

Magic Mirror for Sketch 3 is a Sketch Plugin can create perspective transformed image from an artboard and apply to corresponding shape.

You might also refer it as a simple version of [Photoshop’s Embeded Smart Objects](https://helpx.adobe.com/photoshop/using/create-smart-objects.html) for Sketch.

To see it in action, please visit [homepage](http://magicmirror.design).

## Contributions

1. Clone the repository
`git clone https://github.com/jamztang/MagicMirror.git`
2. Locate `Magic Mirror.sketchplugin`, double click to install the plugin, if you’ve multiple versions of Sketch, you can drag the plugin into the specific Sketch dock icon.
3. Check that it’s available in the `Plugins` menu.

![](http://cl.ly/image/2z0l023u0O2f/magic-mirror-menu.png)

### Troubleshoot (if mirroring fails)

1. Make sure the Artboard is in the same page as your shape layer is.
2. Check that the `Fill` layer is on, especially when you’re using the tool.

### Limitations

1. No live resizing, if you are Sketch plugin developer and aware how to, send a pull request or let me know!
2. Using Pattern fill means that you may want to be more careful with using Shared Styles on those layers.
3. Updating either the layer’s name or the Artboard’s name is currently the only way to opt out from the magic mirroring.

### Future Plans

1. Eliminate limitations!
2. Highlighting active magic layer?
3. Support mirroring Symbols?
4. Shortcut to toggle between Artboard and selected layer?
5. Better layer opt-out mechanism?

As long as the project lives, pull requests for features and bug fixes will be highly appreciated!

## Support this project

Consider [purchasing](http://magicmirror.design/purchase/?ref=github) the plugin.

### Credits

Special thanks to [Simon Pang](http://twitter.com/@simonpang) to help point me back to the right direction when I was lost in reverse engineering Sketch header files without an obvious answer and attempted to manually apply the 3D transformation matrix to the image.

Without him this would likely took me few more nights, or might at worst not possible due to some [complications of expressing certain language syntax in the scripting bridge](https://github.com/ccgus/CocoaScript/issues/30).

## License

This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.
A more permissive license for commercial use can be optained through [purchasing](http://magicmirror.design/purchase/?ref=github)

