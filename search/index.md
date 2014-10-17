---
layout: page
title: 搜索
---


<script src="/media/js/jekyll-search.js" type="text/javascript" charset="utf-8"></script>

<div id="search">
  <form action="/search" method="get">
    <input type="text" id="search-this-page" name="q" placeholder="  Search.." autocomplete="off">
  </form>
</div>
<div class="archive searcharchive" id="search-results"></div>

<script type="text/javascript">
        JekyllSearch.init({
          searchInput: document.getElementById("search-this-page"),
          jsonFile : '/search.json',
          searchResults : document.getElementById("search-results"),
          template : '<article class="post"><div class="post-content"><header><h1 class="title"><a href="{url}">{title}</a></h1><time datetime="{date}"><a href="{url}">{date}</a></time></header></div></article>',
          fuzzy: true
        });
</script>
