[
  {title: 'BBC News Scotland', description: 'The latest stories from the Scotland section of the BBC News web site', url: 'http://feeds.bbci.co.uk/news/scotland/rss.xml'},
  {title: 'BBC Top UK Stories', description: 'The top stories from the UK', url: 'http://feeds.bbci.co.uk/news/rss.xml?edition=uk'},
  {title: 'The Telegraph Sport', description: 'Latest sport news, fixtures and match reports from columnists Henry Winter, Alan Hansen, Paul Hayward and more.', url: 'http://www.telegraph.co.uk/sport/rss'},
  {title: 'Simple Recipes', description: 'A family cooking and food blog with hundreds of healthy, whole-food recipes for the home cook. Photographs, easy-to-follow instructions, and reader comments.', url: 'http://feeds.feedburner.com/elise/simplyrecipes'},
  {title: 'Tales from Tech Support', description: 'A Subreddit dedicated to stories of tech woe, difficult clients, moral support and pure luck', url: 'http://www.reddit.com/r/talesfromtechsupport/hot.rss'},
  {title: 'University of Aberdeen Library News', description: "The latest news from the University of Aberdeen's Library, Special Collections and Museums", url: 'http://www.abdn.ac.uk/library/news-events/news/rss.xml'}
].each do |feed|
  feedAR = Feed.new(feed)
  
  puts "Adding Feed: #{feedAR.title}"
  
  feedAR.save
end
