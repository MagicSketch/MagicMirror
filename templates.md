---
layout: page
title: Templates
permalink: /templates/
weight: 2
items:
- title: Expenses
  description: The expenses tracker I designed but never have time to work on
  image: expenses.jpg
  author: jamztang
  download_link: https://github.com/jamztang/MagicMirror/releases/download/templates/magicmirror-perspective-expenses.sketch
- title: MadeWithMagicMirror
  description: The hero image of the campaign
  image: madewithmagicmirror.jpg
  author: jamztang
  download_link: https://github.com/jamztang/MagicMirror/releases/download/templates/magicmirror-perspective-madewithmagicmirror.sketch
---

<div class="flex flex-wrap mxn2">

  {% for item in page.items %}
    <div class="flex sm-col-6 border-box p1 template">
      <div class="p1 border rounded">
        <img src="/images/templates/{{ item.image }}" height="auto" />
        <div class="mx-auto">
        <span class="flex flex-center">
	        <span class="flex-auto">
		        <h4 class="title mt1 mb1 bold">{{ item.title }}</h4>
		        <i class="meta m0">{{ item.description }}</i>
		    </span>
	    	<a href="{{ item.download_link }}" class="border-box center btn btn-outline green flex-none" width="100px" max-width="100px">FREE</a>
		</span>
		</div>
      </div>
    </div>
  {% endfor %}

</div>

