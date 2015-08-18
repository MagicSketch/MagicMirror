---
layout: page
---

![](/images/magic-mirror-trimmed.gif)

Magic Mirror for Sketch 3 is a Sketch Plugin can create perspective transformed image from an artboard and apply to corresponding shape.

You can consider it a simple version of Photoshop’s [Embeded Smart Objects](https://helpx.adobe.com/photoshop/using/create-smart-objects.html) for Sketch.

Here's what Magic Mirror can do:

<div class="videoWrapper">
    <!-- Copy & Pasted from YouTube -->
    <iframe width="560" height="349" src="http://www.youtube.com/embed/YhdjuL5ju8Y?rel=0&hd=1" frameborder="0" allowfullscreen></iframe>
</div>


## What's different?

Unlike [Symbols](http://bohemiancoding.com/sketch/support/documentation/07-symbols/), Magic Mirror uses [Pattern Fill](http://bohemiancoding.com/sketch/support/documentation/08-styling/1-fills.html) to preform the mirroring. It can mirror any number of Artboards to any number of shape layers in any size, any angle, but <em>also</em> responds to the shape’s distortion (perspective transformation).

Unlike when editing Bitmaps in Sketch, Magic Mirror does not modify the original bitmap in a destructive way (since we’re sourcing from an Artboard). Using Shape layers instead of Bitmap layers, editable paths are preserved and can be easily updated.

## Installation

<p class="center"><a href="javascript:void(0);" onclick="downloadPluginClicked()"><img src="/images/download-plugin.png"></img></a></p>

1. Download the package, unzip it and locate `Magic Mirror.sketchplugin`.
2. Double click to install the plugin, if you’ve multiple versions of Sketch, you can drag the plugin into the specific Sketch dock icon.
3. Check that it’s available in the `Plugins` menu.

![](/images/magic-mirror-menu.png)

4. Consider [donating](#donating) to the project :)


## Usage

<p class="center"><a href="https://github.com/jamztang/MagicMirror/releases/download/v1.0/magicmirror-sample.sketch"><img src="/images/download-sketch.png"></img></a></p>

Magic Mirror currently offers three handy methods.


### 1. Magic Mirror! (&#x2303; &#x21E7; M)

Apply perpective transform to all layers that can be associated with an artboard with the same name.

![](/images/magic-mirror-feature1.gif)

1. Prepare an artboard as the source
2. Use the `Rectangle (R)`  or `Vector (V)` tool to draw a 4 point polygon. It’s important NOT to use the `Round Rect` tool because in order for Magic Mirror to work is to have **exactly 4 control points**.
3. Rename your shape layer to **exactly match the Artboard’s name** you want to mirror.
4. Press `⌃ ⇧ M` or go to `Plugin > Magic Mirror > Magic Mirror!` to see the results!


### 2. Jump to Artboard (&#x2303; &#x21E7; J)

Quickly jump to the layer’s associated artboard.

![](/images/magic-mirror-feature2.gif)

1. Select the magic shape layer you’re currently working on.
2. Press `⌃ ⇧ J` or use `Plugin > Magic Mirror > Jump to Artboard`.


### 3. Rotate Content (&#x2303; &#x2318; &#x21E7; R)

![](/images/magic-mirror-feature3.gif)

Rotate the content orientation of the layer fill.

1. Select the layer
2. Press `⌃ ⌘ ⇧ R` or use `Plugin > Magic Mirror > Rotate Points`.


### 4. Flip Content (&#x2303; &#x2318; &#x21E7; F)

![](/images/magic-mirror-feature4.gif)

Flip the content of the layer fill while preserving the points.

1. Select the layer.
2. Press `⌃ ⌘ ⇧ F` or use `Plugin > Magic Mirror > Flip Content`.


## So how does it work?

In short, Magic Mirror iterates through all the “Shape” layers (MSShapeGroup) in the current page, and finds all the Artboard-Layer pairs that share the exact same name.

Then it looks into the path (NSBezierPath) and extracts the 4 corner points.

It then hands the content over to [Core Image](https://developer.apple.com/library/mac/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_intro/ci_intro.html) to do Perspective Transformation, and apply the transformed image using Pattern Fill.



## Donation

Magic Mirror is an open source project on GitHub. You can freely checkout the source code (and contribute to the project!) However, if you decide to donate to the project, you'll get a special package: ;)

![](/images/donate-dark.jpg)

You've probably seen similar perspective mockup templates like this before, but they're all for Photoshop. I wanted to recreate this entirely in Sketch, and ensure your work remains adjustable and scalable.


## Why should I donate?

First, because I would like to continue developing the product and keep helping the community to better utilize our tools. I believe good ideas, and proper execution of those ideas, requires dedicated time and effort. The only way for us to produce things like that is to have sustainable revenue from the things we work on.

Second, this represents a new era of design possibilites within Sketch. I hope from now on we'll see more and more perspective mockups dedicated for Sketch, which we all love! :)


## Backtrack

[TheNextWeb](http://thenextweb.com/dd/2015/08/03/magic-mirror-for-sketch-3-lets-you-quickly-create-hands-on-mockups-of-your-apps/)

[DesignerNews](https://www.designernews.co/stories/53390-magic-mirror-for-sketch-3--plugin-to-create-perspective-designs)

[iOS Dev Weekly 209](https://iosdevweekly.com/issues/209)

[SketchAppResource](http://www.sketchappsources.com/plugins-for-sketch.html)

[Sidebar.io](http://sidebar.io/2015/7/31)

[SketchTalk.io](http://sketchtalk.io/discussion/1371/magic-mirror-perspective-3d-for-your-artboards)

[T3n (German)](http://t3n.de/news/magic-mirror-sketch-plugin-627330/)

[Applech2 (Japanese)](http://applech2.com/archives/45794567.html)

[ProductHunt](http://www.producthunt.com/tech/magic-mirror-for-sketch-3)

[Hackernews](https://news.ycombinator.com/item?id=9973827)

## Videos

[SketchCast #47](http://www.sketchcasts.net/episodes/47)

[SketchAppTV](https://www.youtube.com/watch?v=F7wOPtKjVps)

[LevelUpTut](https://www.youtube.com/watch?v=Gm5wPXOgVtM&list=PLXM9Shjg7jenAH19HHSWYPJ4EtB4RNDc1&index=3)



