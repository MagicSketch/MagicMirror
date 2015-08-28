---
layout: page
title: Templates
permalink: /templates/
weight: 1
---

<div class="flex flex-wrap mxn2 templates">

  {% for item in site.templates %}

    {% if item.hidden %}

    {% else %}

    {% if item.members %}
    <div class="flex sm-col-6 border-box p1 template members">
    {% else %}
    <div class="flex sm-col-6 border-box p1 template free">
    {% endif %}


      <div class="p1 border rounded">
        <a href="{{ item.url }}">
          <img src="/images/templates/{{ item.image }}" height="auto" />
        </a>
        <div class="mx-auto">
          <span class="flex">
  	        <span class="flex-auto">
  		        <h4 class="title mt1 mb1 bold">{{ item.title }}</h4>
  		        <i class="meta m0">{{ item.description }}</i>
              {% assign author = site.data.authors[item.author] %}
              <p class="author"><a href="{{ author.link }}" class="name"><img src="{{ author.avatar }}" class="avatar"/> {{ item.author }}</a></p>
  		      </span>

        <!--
          {% if item.members %}
          <a href="{{ item.download_link }}" class="members-btn border-box center btn btn-outline gray flex-none" width="100px" max-width="100px">MEMBERS</a>
          {% else %}
          <a href="{{ item.download_link }}" class="border-box center btn btn-outline green flex-none" width="100px" max-width="100px">FREE</a>
          {% endif %}
        -->

            <div class="flex-none p1 right-align">

              <p class="status">
              {% if item.members %}
                MEMBERS
              {% else %}
                FREE
              {% endif %}
              </p>
            </div>
          </span>
    		</div>
      </div>
    </div>
    {% endif %}
  {% endfor %}


</div>
<div class="center wrapper mt4" markdown="1">

Magic Mirror Templates is still in beta. If you want to help or want to have your own templates show up please [contact me](mailto:{{ site.email }}) :)

</div>