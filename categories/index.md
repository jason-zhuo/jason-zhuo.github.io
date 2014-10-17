---
title: 分类
layout: page
---


{% for cat in site.categories %}
<h2 class="archive-title">{{ cat[0] }}</h2>
<div class="archive">
{% for post in cat[1] %}
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

