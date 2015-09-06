---
layout: flex
title: Create Perspective Mockups in Sketch
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
  link: http://twitter.com/@arjenvr

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
- title: Applech2
  link: http://applech2.com/archives/45794567.html
- title: DesignerNews
  link: https://www.designernews.co/stories/53390-magic-mirror-for-sketch-3--plugin-to-create-perspective-designs
- title: Design+Code
  link: https://designcode.io/learn
- title: HeyDesigner
  link: http://heydesigner.com/sketchapp/
- title: iOSDevWeekly
  link: https://iosdevweekly.com/issues/209
- title: LevelUpTuts
  link: https://www.youtube.com/watch?v=Gm5wPXOgVtM&list=PLXM9Shjg7jenAH19HHSWYPJ4EtB4RNDc1&index=3
- title: Sketch App Sources
  link: http://www.sketchappsources.com/plugins-for-sketch.html
- title: SketchAppTV
  link: https://www.youtube.com/watch?v=F7wOPtKjVps
- title: SketchCasts
  link: http://www.sketchcasts.net/episodes/47
- title: SketchHunt
  link: http://sketchhunt.com/?s=magic+mirror
- title: Sketchtalk.io
  link: http://sketchtalk.io/discussion/1371/magic-mirror-perspective-3d-for-your-artboards
- title: T3n
  link: http://t3n.de/news/magic-mirror-sketch-plugin-627330/

---

# Create Perspective Mockups in Sketch

<div class="wrapper">
<div class="flex flex-wrap mxn1 px1 flex-center flex-start nav">
<div class="col-4 border-box center btn orange">
	<a href="/beta/v1.3" identifier="Beta-2-v1.3" class="clearfix">v1.3 Beta 2 + Corner Radius</a>
	<sup class="red">UPDATED (05/09)</sup>
</div>
<div class="col-4 center btn orange border-box">
	<a href="/madewithmagicmirror" identifier="Get-License-Free" class="clearfix">Get a license for free</a>
	<sup class="gray">ENDED (20/8-24/8)</sup>
</div>
<a href="{{ site.downloadurl }}/latest" identifier="Free-Download" class="col-4 border-box center btn btn-outline orange"><i class="fa fa-arrow-circle-o-down"></i>    Free Download (v1.2)</a>
</div>
</div>



<div class="flex container">
	<div id="computer" class="flex-stretch col-12 m2">
		<img src="/images/computer.png" class="flow flex-stretch col-12"/>

		<div class="videodom flex">

		<!-- <div class="left"> </div> -->

		<div class="screen flex flex-center">

			<div class="videoWrapper">
			    <!-- Copy & Pasted from YouTube -->
			    <iframe width="560" height="349" src="https://www.youtube.com/embed/b2bwysoKWgU?rel=0&hd=1" frameborder="0" allowfullscreen></iframe>
			</div>

		</div>

		<!-- <div class="right"></div> -->


		</div>
	</div>
</div>

{% include showstart.html class="wrapper" %}

Magic Mirror for Sketch 3 is a Sketch Plugin that can create perspective transformed image from an artboard and apply to corresponding shape.

You can consider it a simple version of Photoshop’s [Embeded Smart Objects](https://helpx.adobe.com/photoshop/using/create-smart-objects.html) for Sketch.

{% include showhidden.html %}

## What's different?

Unlike [Symbols](http://bohemiancoding.com/sketch/support/documentation/07-symbols/), Magic Mirror uses [Pattern Fill](http://bohemiancoding.com/sketch/support/documentation/08-styling/1-fills.html) to preform the mirroring. It can mirror any number of Artboards to any number of shape layers in any size, any angle, but <em>also</em> responds to the shape’s distortion (perspective transformation).

Unlike when editing Bitmaps in Sketch, Magic Mirror does not modify the original bitmap in a destructive way (since we’re sourcing from an Artboard). Using Shape layers instead of Bitmap layers, editable paths are preserved and can be easily updated.


## So how does it work?

In short, Magic Mirror iterates through all the “Shape” layers (MSShapeGroup) in the current page, and finds all the Artboard-Layer pairs that share the exact same name.

Then it looks into the path (NSBezierPath) and extracts the 4 corner points.

It then hands the content over to [Core Image](https://developer.apple.com/library/mac/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_intro/ci_intro.html) to do Perspective Transformation, and apply the transformed image using Pattern Fill.

{% include showend.html %}

<section class="my2 py2 border-top" style='background-color:black'>
<h1>Showcase</h1>

<div class="clearfix">
{% for showcase in page.showcases %}
<div class="sm-col sm-col-6 showcase">
	<img src="{{ showcase.image }}" />
	<a href="{{ showcase.link }}" identifier="{{ showcase.author }}" class="overlay">
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


<section class="my2 py2">
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

<div class="sm-flex mt2 flex-wrap">
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

<div class="sm-col-4 border-box p1 flex flex-column flex-center">
	<img src="/images/magic-mirror-feature-retina.png" class="flex-grow"/>
	<p class="p1">Retina Image Support <sup class="red">NEW</sup></p>
</div>

<div class="sm-col-4 border-box p1 flex flex-column flex-center">
	<img src="/images/magic-mirror-feature-crosspage-mirroring.gif" class="flex-grow"/>
	<p class="p1">Cross Page Screen Mirroring<sup class="red">NEW</sup></p>
</div>
</div>

</div>
</section>


<section class="py3 border-top border-bottom" style='background-color:#EEE'>
<h1>Media</h1>

<div class="wrapper sm-flex flex-wrap mxn1 px1 flex-center">
	{% for site in page.featured %}
	<div class="sm-col-4 border-box p2 center">
	   <a href="{{ site.link }}"><img src="{{ site.image }}" class="grayscale animated"></a>
	</div>
	{% endfor %}

	<!-- <h2 class="sm-col-12">Backtracks</h2> -->
	{% for site in page.backtracks %}
	<a href="{{ site.link }}" class="px1 border-box flex-auto center">{{ site.title }}</a>
	{% endfor %}
</div>
</section>

