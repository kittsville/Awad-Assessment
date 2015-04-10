# Seeds Feeds (heh)
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

# Seeds Users
[
  {username: 'kittsville', email: 'kittsville@googlemail.com', password: 'swordfish', password_confirmation: 'swordfish'},
  {username: 'neo', email: 'neo@nebuchadnezzar.com', password: 'keymaster', password_confirmation: 'keymaster', admin: 1}
].each do |user|
  userObj = User.new(user)
  
  if userObj.valid?
    puts "Creating default user #{userObj.username}"
    userObj.save
  else
    puts "Unable to create default user #{userObj.username} because:"
    puts userObj.errors.full_messages
  end
end