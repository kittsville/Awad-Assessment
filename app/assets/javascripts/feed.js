function newFeedForm() {
	form = $('div.feed-panel form');
	validate = form.find('button#validate_feed');
	submit = form.find('input[type="submit"]');
	feedInput = form.find('input[type="text"]');
	feedError = $('div#feed-error');
	feedValidating = $('div#feed-processing');
	
	submit.hide();
	feedError.hide();
	feedValidating.hide();
	
	validate.click(function(){
		url = feedInput.val();

		feedError.hide();
		feedValidating.show(100);
		
		gFeed = new google.feeds.Feed(url);
		
		gFeed.load(function(data){
			feedValidating.hide(200);

			if ( data.hasOwnProperty('error')) {
				feedError.show(200);
			} else {
				validate.hide(200);
				$('div.field').hide(200);
			console.log(feedValidating);	
				submit.show(200);
				$('<h3/>',{html:data.feed.title}).insertAfter(feedValidating);
			}
		});
	});
}
