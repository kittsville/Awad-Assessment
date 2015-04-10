function feed(feedObj, parentElement) {
	var rawFeed    = feedObj[1];
  var subscribed = feedObj[0];
	var anchor     = parentElement;
	var gFeed      = new google.feeds.Feed(rawFeed.url);
  var blacklisted= feedObj[2];
  
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
            'class'  : 'feed-icons',
            'html'   : [
              $('<span/>',{
                'class'      : 'glyphicon glyphicon-heart subscribe-icon sub-icon',
                'title'      : 'Subscribe to this feed',
                'aria-hidden': 'true'
              }),
              $('<span/>',{
                'class'      : 'glyphicon glyphicon-remove unsubscribe-icon sub-icon',
                'title'      : 'Unsubscribe from this feed',
                'aria-hidden': 'true'
              }),
              $('<span/>',{
                'class'      : 'glyphicon glyphicon-ban-circle ban-icon blacklist-icon',
                'title'      : 'Blacklist this feed',
                'aria-hidden': 'true'
              }),
              $('<span/>',{
                'class'      : 'glyphicon glyphicon-ok-circle unban-icon blacklist-icon',
                'title'      : 'Un-blacklist this feed',
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
  var unsubscribeIcon  = feedElement.find('span.unsubscribe-icon');
  var banIcon          = feedElement.find('span.ban-icon');
  var unbanIcon        = feedElement.find('span.unban-icon');
  
  // Stops non-admins from seeing icon to blacklist feeds.
  // Obvious doesn't matter if they could as admin-validation is done server-side
  if ( !user_is_admin ) {
    banIcon.hide();
  }
  
  // Subscribes/unsubscribes user to/from feed when a subscription modifying button is clicked
  feedElement.on('click','div.feed-icons span.sub-icon', function(e){
    var subAction = '';
    
    if ($(e.target).hasClass('subscribe-icon')) {
      subAction = 'sub';
    } else {
      subAction = 'unsub';
    }
    
    $.ajax({
      type     : 'POST',
      url      : '/modify_subscriptions',
      dataType : 'json',
      data     : {
        feed_id  : rawFeed.id,
        change   : subAction
      }
    }).success(function(data){
      if ( data ) {
        // Toggles subscription state of feed
        subscribed = !subscribed;
        
        changeDisplayedIcon();
      } else {
        alert('Already subscribed/unsubscribed from feed');
      }
    });
  });
  
  // Blacklisted or unblacklists a feed
  feedElement.on('click','div.feed-icons span.blacklist-icon', function(e){
    var blacklistFeed = $(e.target).hasClass('ban-icon');
    
    $.ajax({
      type     : 'POST',
      url      : '/modify_blacklisted',
      dataType : 'json',
      data     : {
        feed_id  : rawFeed.id,
        bfeed    : blacklistFeed
      }
    }).success(function(data){
      if ( data ) {
        // Toggles blacklisted state of feed
        blacklisted = !blacklisted;
        
        toggleBlacklisted();
      } else {
        alert('Something went wrong :/');
      }
    });
  });
  
	
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
  
  // Toggles whether the feed shows as red to admins who can see it, showing that the feed is blacklisted
  // Also affects which of the blacklist/unblacklist buttons appear
  function toggleBlacklisted() {
    feedElement.toggleClass('blacklisted', blacklisted);
    
    if (blacklisted == true) {
      banIcon.hide();
      unbanIcon.show();
    } else if ( user_is_admin ) {
      banIcon.show();
      unbanIcon.hide();
    } else {
      banIcon.hide();
      unbanIcon.hide();
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
  toggleBlacklisted();
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
    user_is_admin  = data[2];
    
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

$(function() {
  $('form#search-feeds').on('submit', function(e){
    $.ajax({
      type	: 'POST',
      url	: '/search_feeds',
      dataType: 'json',
      data	: {feed_title : $('input#search_feeds').val()}
    }).success(function(data){
      parentElement	= $('div.feed-bin');
      parentElement.html('');
      if (data.length == 0) {
        parentElement.html('<p>No Feeds Found</p>');
      } else {
        data.forEach(function(feedObj, i){
          new feed(feedObj, parentElement)
        });
      }
    });

    e.preventDefault();
  });
});