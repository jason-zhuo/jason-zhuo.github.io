{% if site.duoshuo %}
	{% if page.thread %}
	<div class="ds-thread" data-thread-key="{{ page.thread }}" data-url="{{ site.url }}{{ page.url }}" data-title="{{ page.title }}" />
	{% else %}
	<div class="ds-thread" />
	{% endif %}	
	<script type="text/javascript">
	var duoshuoQuery = {short_name:"{{ site.duoshuo }}"};
	(function() {
		var ds = document.createElement('script');
		ds.type = 'text/javascript';ds.async = true;
		ds.src = 'http://static.duoshuo.com/embed.js';
		ds.charset = 'UTF-8';
		(document.getElementsByTagName('head')[0] 
		|| document.getElementsByTagName('body')[0]).appendChild(ds);
	})();
	</script>
{% endif %}
{% if site.disqus %}
	{% if page.thread %}
	<div class="ds-thread" data-thread-key="{{ page.thread }}" data-url="{{ site.url }}{{ page.url }}" data-title="{{ page.title }}" />
	{% else %}
	<div class="ds-thread" />
	{% endif %}	
	<div id="disqus_thread"></div>
    <script type="text/javascript">
        /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
        var disqus_shortname = 'cubernet'; // required: replace example with your forum shortname

        /* * * DON'T EDIT BELOW THIS LINE * * */
        (function() {
            var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
            dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
            (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
        })();
    </script>
    <noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
    <a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>
    <script type="text/javascript">
    var disqus_shortname = 'cubernet';

    (function () {
        var s = document.createElement('script'); s.async = true;
        s.type = 'text/javascript';
        s.src = '//' + disqus_shortname + '.disqus.com/count.js';
        (document.getElementsByTagName('HEAD')[0] || document.getElementsByTagName('BODY')[0]).appendChild(s);
    }());
    </script>
{% endif%}
{% if site.youyan %}
	{% if page.thread %}
	<div class="ds-thread" data-thread-key="{{ page.thread }}" data-url="{{ site.url }}{{ page.url }}" data-title="{{ page.title }}" />
	{% else %}
	<section id="comment">
  		<h1 class="title">评论</h1>
	{% endif %}	
	<!-- UY BEGIN -->
	<div id="uyan_frame"></div>
	<script type="text/javascript" src="http://v2.uyan.cc/code/uyan.js?uid=1954501"></script>
	<!-- UY END -->
	</section>
{% endif %}
