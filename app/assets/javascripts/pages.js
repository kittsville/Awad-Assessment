function feed(feedObj, parentElement) {
	rawFeed	= feedObj;
	achor	= parentElement;
	gFeed	= new google.feeds.Feed(rawFeed.url);
	
	feedElement = $('<div/>',{
		'class'	: 'panel panel-default single-feed',
		'id'	: 'feed-'+rawFeed.id,
		'html'	: [
			$('<div/>',{
				'class'	: 'panel-heading',
				'html'	: $('<h3/>',{
					'class'	: 'panel-title',
					'html'	: rawFeed.title
				})
			}),
			$('<div/>',{
				'class'	: 'panel-body',
				'html'	: $('<p/>',{
					'class'	: 'loading-feed',
					'html'	: 'Loading...'
				})
			}),
			$('<div/>',{
				'class'	:  'panel-footer',
				'html'	: rawFeed.url
			})
		]
	}).appendTo(achor);
	
	var body = feedElement.find('div.panel-body');
	
	function renderPosts(data){
		posts = [];
		console.log(body);
		data.feed.entries.forEach(function(post,p){
			postTitle = $('<h4/>',{html:post.title});
			
			if (post.hasOwnProperty('link') && post.link !== '') {
				postTitle = $('<a/>',{
					href	: post.link,
					html	: postTitle
				});
			}
			
			postAuthor = []
			
			if (post.hasOwnProperty('author') && post.author !== '') {
				postAuthor.push($('<p/>',{
					'class'	: 'author',
					'html'	: post.author
				}));
			}
			
			posts.push($('<div/>',{
				'class'	: 'feed-post',
				'html'	: [].concat(
					[postTitle],
					postAuthor,
					[$('<p/>',{
						'class'	: 'content-full',
						'html'	: strip(post.content)
					})]
				)
			}));
		});
		
		body.html(posts);
	}
	
	gFeed.load(renderPosts);
}

function feedEngine() {
	feeds		= []
		
	$.ajax({
		type	: 'GET',
		url	: '/feeds.json',
		dataType: 'json'
	}).success(function(data){
		parentElement	= $('div.feed-bin');
		
		data.forEach(function(feedObj,i){
			feeds.push(new feed(feedObj, parentElement));
		});
	}).fail(function(){
		
	});
}

function strip(html)
{
   var tmp = document.createElement("DIV");
   tmp.innerHTML = html;
   return tmp.textContent || tmp.innerText || "";
}

$(function() {
	fEngine = new feedEngine();
});
