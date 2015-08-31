---
layout: post
title:  The Magic Behind The Mirror
date:   2015-09-01 09:00
categories: magicmirror
---

Over the years, designers had been switching from Photoshop to Sketch for web and mobile UI design, desite a a few things that we still need to use Photoshop, we now might just have one less reason to look back.

Photoshop was the only way for creating perspective mockups, simply because no others were on par.

## _The Broken Boat_

If you have a screen and you wanted to put it inside a mobile device that was slightly tilted? Symbols are not gonna help because it doesn't allow copies to be in different sizes. Fill layers are not responsive to the non rectangular shapes, and it'd always be drawing proportionally. Your remaining best bet would be flattening the layers to a Bitmap, then using the Transform tool or Edit tool to adjust the 4 corners to match the shape in your mobile device.

There are several painful gotchas for this:

- Transforming Bitmap layers were destructive in Sketch. The transforming path will be reset to a rectangular bounds everytime after you commit a change, it'd be disgusting if you were to adjust the path even just a bit.

- Non responsive to your screen design. Since you were asked to flatten your screen layer, every changes in your original screen design will have to start the flattening and transforming procedure all over again.

## _Fixing The Leakage_

Bitmap layers are not the way to go. Inspired by how [Content Generator](https://github.com/timuric/Content-generator-sketch-plugin) and [AppStoreSketch](https://github.com/MengTo/AppStoreSketch) uses Shape layers and Layer Fill for avatars and screen placeholders, our trick is to have a pre-process transformed version of our image before applying to the fill.



## _One Month Of Sailing_