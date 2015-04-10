function feed(feedObj, parentElement) {
	var rawFeed    = feedObj[1];
  var subscribed = feedObj[0];
	var anchor     = parentElement;
	var gFeed      = new google.feeds.Feed(rawFeed.url);
  
	var feedElement = $('<div/>',{
		'class'	: 'panel panel-default single-feed',
		'id'	: 'feed-'+rawFeed.id,
		'html'	: [
			$('<div/>',{
				'class'	: 'panel-heading',
				'html'	: [
          $('<h3/>',{
					  'class'	: 'panel-title',
					  'html'	: rawFeed.title
				  }),
          $('<div/>',{
            'class'  : 'sub-icons',
            'html'   : [
              $('<span/>',{
                'class'      : 'glyphicon glyphicon-heart subscribe-icon',
                'aria-hidden': 'true'
              }),
              $('<span/>',{
                'class'      : 'glyphicon glyphicon-remove unsubscribe-icon',
                'aria-hidden': 'true'
              })
            ] 
          })
        ]
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
	}).appendTo(anchor);
  
  var subscribeIcon    = feedElement.find('span.subscribe-icon');
  var unsubscribeIcon  =  feedElement.find('span.unsubscribe-icon');
	
	var body = feedElement.find('div.panel-body');
  
  // Switches which icon is displayed depending on whether the user is subscribed to a feed
  function changeDisplayedIcon(){
    if ( subscribed === true ) {
      subscribeIcon.hide();
      unsubscribeIcon.show();
    } else if ( subscribed === false ) {
      subscribeIcon.show();
      unsubscribeIcon.hide();
    } else {
      subscribeIcon.hide();
      unsubscribeIcon.hide();
    }
  }
	
	function renderPosts(data){
		var posts = [];
		
		data.feed.entries.forEach(function(post,p){
			var postTitle = $('<h4/>',{html:post.title});
			
			if (post.hasOwnProperty('link') && post.link !== '') {
				var postTitle = $('<a/>',{
					href	: post.link,
					html	: postTitle
				});
			}
			
			var postAuthor = []
			
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
	
  changeDisplayedIcon();
	gFeed.load(renderPosts);
}

function feedEngine(requestType) {
	var feeds		= []
		
	$.ajax({
		type	: 'GET',
		url	: '/feeds.json',
		dataType: 'json',
		data	: {type : requestType}
	}).success(function(data){
		parentElement	= $('div.feed-bin');
		
    user_signed_in = data[0];
    
		data[1].forEach(function(feedObj,i){
			feeds.push(new feed(feedObj, parentElement));
		});
	}).fail(function(){
		
	});
}

function strip(html) {
   var tmp = document.createElement("DIV");
   tmp.innerHTML = html;
   return tmp.textContent || tmp.innerText || "";
}