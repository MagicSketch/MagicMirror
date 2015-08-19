---
layout: flex

showcases:
- author: Marko Vuletič, UI/UX Design Professional
  liner: The only time I open Photoshop nowadays is when I’m creating a presentation mockup of my designs. But this is about to change.
  avatar: /images/marko.jpg
  image: /images/marko-showcase.jpg
  link: http://markovuletic.com/blog/posts/perspective-mockups-in-sketch
- author: Jesse Kyle, Author of Design Tether
  liner: Magic Mirror is great for showing off my app designs. It's much more user-friendly than Photoshop with double the possibilities
  avatar: /images/jesse.jpg
  image: /images/jesse-showcase.jpg
  link: http://designtether.com/design/magic-mirror-sketch-plugin/
- author: Meng To, Author of Design+Code
  liner: Magic Mirror is the plugin we've been waiting for. No more switching to Photoshop for creating perspective mockups. It works that great.
  avatar: /images/meng.jpg
  image: /images/meng-showcase.jpg
  link: http://designcode.io
- author: Julie Bug, UI/UX Designer
  liner: Using Magic Mirror to create perspective mockups is amazingly easy and joyful.
  avatar: /images/julie.jpg
  image: /images/julie-showcase.jpg
  link: http://juliebug.xfym.info/post/mzzads-dashboard-redesign
- author: Arjen van Reeven, Product Design Lead at NGTI/Swisscom
  liner: Sketch plugin lets you perspective transform artboard to a shape. Great for product shots!
  avatar: /images/arjen.jpg
  image: /images/arjen-showcase.jpg

featured:
- title: TheNextWeb (03/08)
  image: /images/thenextweb.png
  link: http://thenextweb.com/dd/2015/08/03/magic-mirror-for-sketch-3-lets-you-quickly-create-hands-on-mockups-of-your-apps/
- title: Smashing Newsletter
  image: /images/smashingmagazine.png
  link: http://www.smashingmagazine.com/smashing-newsletter-issue-142/
- title: Sidebar.io (31/07)
  image: /images/sidebar.png
  link: http://sidebar.io/2015/7/31

backtracks:
- title: DesignerNews
  link: https://www.designernews.co/stories/53390-magic-mirror-for-sketch-3--plugin-to-create-perspective-designs
- title: Sketchtalk.io
  link: http://sketchtalk.io/discussion/1371/magic-mirror-perspective-3d-for-your-artboards
- title: HeyDesigner
  link: http://heydesigner.com/sketchapp/
- title: T3n
  link: http://t3n.de/news/magic-mirror-sketch-plugin-627330/
- title: Applech2
  link: http://applech2.com/archives/45794567.html
- title: Sketchcast #47
  link: http://www.sketchcasts.net/episodes/47
- title: LevelUpTuts
  link: https://www.youtube.com/watch?v=Gm5wPXOgVtM&list=PLXM9Shjg7jenAH19HHSWYPJ4EtB4RNDc1&index=3
- title: SketchAppTV
  link: https://www.youtube.com/watch?v=F7wOPtKjVps

---

# When Sketch Meets Perspective Mockups

<div class="wrapper">
<div class="clearfix">
<div class="sm-col sm-col-4 center btn orange">
	<a href="/campaign" class="">Get a free license campaign</a>
	<sup class="red">NEW (19/8-23/8)</sup>
</div>
<a href="/#features" class="sm-col sm-col-4 center btn orange">See all features</a>
<a href="/download" class="sm-col sm-col-4 center btn btn-outline orange"><i class="fa fa-arrow-circle-o-down"></i>    Free Download (v1.2)</a>
</div>
</div>


<div class="videoWrapper">
    <!-- Copy & Pasted from YouTube
    <iframe width="560" height="349" src="http://www.youtube.com/embed/YhdjuL5ju8Y?rel=0&hd=1" frameborder="0" allowfullscreen></iframe>
     -->
</div>

<div class="flex container">
<img src="/images/computer.png" class="flex-stretch col-12 m2"/>
</div>


<div class='wrapper' markdown='1'>

Magic Mirror for Sketch 3 is a Sketch Plugin can create perspective transformed image from an artboard and apply to corresponding shape.

You can consider it a simple version of Photoshop’s [Embeded Smart Objects](https://helpx.adobe.com/photoshop/using/create-smart-objects.html) for Sketch.

</div>

<section class="my2 py2 border-top">
<h1>Showcase</h1>

<div class="clearfix">
{% for showcase in page.showcases %}
<div class="sm-col sm-col-6 showcase">
	<img src="{{ showcase.image }}" />
	<a href="{{ showcase.link }}" class="overlay">
		<img src="/images/showcase-placeholder.png" />
		<div class="overlay flex flex-end">
			<div class="flex flex-end m2">
				<div class="flex-none mr2">
					<img src="{{ showcase.avatar }}" class="avatar">
				</div>
				<div class="flex flex-column">
					<div class="flex-auto liner">“{{ showcase.liner }}” </div>
					<div class="flex-auto author">- {{ showcase.author }}</div>
				</div>
			</div>
		</div>
	</a>
</div>
{% endfor %}
</div>

</section>


<a id="features"></a>
<section class="my2 py2 ">
<h1>Features</h1>

<div class="container sm-flex flex-wrap mxn1 px1 flex-center">

	<div class="sm-col-8 border-box p1">
		<img src="/images/magic-mirror-feature1.gif" />
	</div>

	<div class="sm-col-4 border-box p1" markdown="1">


## Magic Mirror! (⌃ ⇧ M)
1. Prepare a source artboard.
2. Draw a 4-point polygon
3. Rename the shape to match the artboard
4. Press the shortcut

</div>

<div class="sm-flex mt2">
<div class="sm-col-4 border-box p1 flex flex-column flex-center">
	<img src="/images/magic-mirror-feature2.gif" class="flex-grow"/>
	<p class="p1">Jump to Artboard (⌃ ⇧ J)</p>
</div>

<div class="sm-col-4 border-box p1 flex flex-column flex-center">
	<img src="/images/magic-mirror-feature3.gif" class="flex-grow"/>
	<p class="p1">Rotate Content (⌃ ⌘ ⇧ R)</p>
</div>

<div class="sm-col-4 border-box p1 flex flex-column flex-center">
	<img src="/images/magic-mirror-feature4.gif" class="flex-grow"/>
	<p class="p1">Flip Content (⌃ ⌘ ⇧ F)</p>
</div>
</div>

</div>

</section>


<section class="my2 py2 border-top">
<h1>Media</h1>

<div class="wrapper sm-flex flex-wrap mxn1 px1 flex-center">
	{% for site in page.featured %}
	<div class="sm-col-4 border-box p2 center">
	   <a href="{{ site.link }}"><img src="{{ site.image }}" class="grayscale animated"></a>
	</div>
	{% endfor %}

	<h2 class="sm-col-12">Backtracks</h2>
	{% for site in page.backtracks %}
	<a href="{{ site.link }}" class="px1 border-box flex-auto center">{{ site.title }}</a>
	{% endfor %}
</div>
</section>

<!--
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


-->
