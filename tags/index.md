---
title: 标签
layout: page
---


{% for tag in site.tags %}
<h2 class="archive-title" id="{{ tag[0] }}">{{ tag[0] }}</h2>
<div class="archive">
{% for post in tag[1] %}
<article class="post">
<div class="post-content">
<header>
<h1 class="title">
<a href="{{ post.url }}">{{ post.title }}</a>
</h1>
<time datetime="{{ post.date | date:"%Y-%m-%d" }}">
<a href="{{ post.url }}">{{ post.date | date:"%Y-%m-%d" }}</a>
</time>
</header>
</div>
</article>
{% endfor %}
</div>
{% endfor %}
