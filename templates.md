---
layout: page
title: Templates
permalink: /templates/
weight: 1
items:
- title: Three Cards Layout
  description: Made for the expenses tracker I never had time to work on
  image: expenses.jpg
  author: jamztang
  download_link: https://github.com/jamztang/MagicMirror/releases/download/templates/magicmirror-perspective-expenses.sketch
- title: MadeWithMagicMirror
  description: The hero image of the campaign
  image: madewithmagicmirror.jpg
  author: jamztang
  download_link: https://github.com/jamztang/MagicMirror/releases/download/templates/magicmirror-perspective-madewithmagicmirror.sketch
- title: AppIcon
  description: iOS App Icon template
  image: appicon.jpg
  author: FradSer
  download_link: https://github.com/jamztang/MagicMirror/releases/download/templates/app-icon-by-fradser.sketch
---

<div class="flex flex-wrap mxn2 templates">

  {% for item in page.items %}
    <div class="flex sm-col-6 border-box p1 template">
      <div class="p1 border rounded">
        <img src="/images/templates/{{ item.image }}" height="auto" />
        <div class="mx-auto">
        <span class="flex flex-center">
	        <span class="flex-auto">
		        <h4 class="title mt1 mb1 bold">{{ item.title }}</h4>
		        <i class="meta m0">{{ item.description }}</i>
            {% assign author = site.data.authors[item.author] %}
            <p class="author"><img src="{{ author.avatar }}" class="avatar"/><a href="{{ author.link }}" class="name">{{ item.author }}</a></p>
		    </span>
	    	<a href="{{ item.download_link }}" class="border-box center btn btn-outline green flex-none" width="100px" max-width="100px">FREE</a>

		</span>
		</div>
      </div>
    </div>
  {% endfor %}

</div>


<div class="center wrapper mt4" markdown="1">

Magic Mirror Templates is still in beta. If you want to help or want to have your own templates show up please [contact me](mailto:{{ site.email }}) :)

</div>
