---
layout: page
title: Videos
permalink: /videos/
weight: 2
items:
- title: Creating Screen Edges
  description: Utilizing Transform Tool, Rotate Content, Flip Content, Masks, and Gradient Fills for Shading
  image: placeholder.png
  sketch: https://github.com/jamztang/MagicMirror/releases/download/templates/magicmirror-screen-edge-demo.sketch
  author: jamztang
  link: https://youtu.be/ORzAM5Qjpmw?list=PLXM9Shjg7jenAH19HHSWYPJ4EtB4RNDc1
---



<div class="flex flex-wrap mxn2 templates">

  {% for item in page.items %}
    <div class="flex sm-col-12 border-box p1 template">
      <div class="p1 border rounded">
          <div style="position:relative">
          <img src="/images/videos/{{ item.image }}" />
          <div class="overlay flex flex-center">
            <div style="width: 100%; height: 100%">
              <div class="videoWrapper video-16-9">
                  <iframe width="1920" height="1200" src="https://www.youtube.com/embed/ORzAM5Qjpmw" frameborder="0" allowfullscreen></iframe>
              </div>
            </div>
          </div>
    </div>
        <div class="mx-auto">
        <span class="flex flex-center">
          <span class="flex-auto">
            <h4 class="title mt1 mb1 bold">{{ item.title }}</h4>
            <i class="meta m0">{{ item.description }}</i>
            <div><i class="fa fa-download"></i><a href="{{ item.sketch }}"> .sketch file</a></div>
            {% assign author = site.data.authors[item.author] %}
            <p class="author"><img src="{{ author.avatar }}" class="avatar"/><a href="{{ author.link }}" class="name">{{ item.author }}</a></p>
        </span>
    </span>
    </div>
      </div>
    </div>
  {% endfor %}

</div>
