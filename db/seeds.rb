[
  {title: 'BBC News Scotland', url: 'http://feeds.bbci.co.uk/news/scotland/rss.xml'},
  {title: 'BBC Top UK Stories', url: 'http://feeds.bbci.co.uk/news/rss.xml?edition=uk'},
  {title: 'The Telegraph Sport', url: 'http://www.telegraph.co.uk/sport/rss'},
  {title: 'Simple Recipes', url: 'http://feeds.feedburner.com/elise/simplyrecipes'},
  {title: 'Tales from Tech Support', url: 'http://www.reddit.com/r/talesfromtechsupport/hot.rss'},
  {title: 'University of Aberdeen Library News', url: 'http://www.abdn.ac.uk/library/news-events/news/rss.xml'}
].each do |feed|
  feedAR = Feed.new(feed)
  
  puts "Adding Feed: #{feedAR.title}"
  
  feedAR.save
end
