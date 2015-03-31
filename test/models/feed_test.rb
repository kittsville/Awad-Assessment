require 'test_helper'

class FeedTest < ActiveSupport::TestCase
  def setup
    @feed = Feed.new(title: 'Nerdverse Events', description: "Upcoming events of Aberdeen Uni's Sci Fi & Fantasy Society", url: 'http://nerdverse.co.uk/events/feed/', blacklisted: false)
  end
  
  test 'Feed title should not be blank' do
    @feed.title = '   '
    
    assert_not @feed.valid?, 'Feed with blank title was allowed'
  end
  
  test 'Feed description should not be blank' do
    @feed.description = '   '
    
    assert_not @feed.valid?, 'Feed with blank description was allowed'
  end
  
  test 'Feed URL should not be blank' do
    @feed.url = '    '
    
    assert_not @feed.valid?, 'Feed with blank URL was allowed'
  end
  
  test 'Feed title should not be longer than 150 characters' do
    @feed.title = 'a' * 150
    
    assert @feed.valid?, "Feed title with length #{@feed.title.length} rejected"
    
    @feed.title += 'a'
    
    assert_not @feed.valid?, "Feed title with length #{@feed.title.length} allowed"
  end

  test 'Feed description should not be longer than 1000 characters' do
    @feed.description = 'a' * 1000
    
    assert @feed.valid?, "Feed description with length #{@feed.description.length} rejected"
    
    @feed.title += 'a'
    
    assert_not @feed.valid?, "Feed description with length #{@feed.description.length} allowed"
  end

  test 'Feed URL should not be longer than 255 characters' do
    @feed.title = 'a' * 255
    
    assert @feed.valid?, "Feed URL with length #{@feed.url.length} rejected"
    
    @feed.title += 'a'
    
    assert_not @feed.valid?, "Feed URL with length #{@feed.url.length} allowed"
  end
  
  test 'Feed URL must be unique' do
    dup_feed = @feed.dup
    
    @feed.save
    
    assert_not dup_feed.valid?, "Duplicate feed URLs '#{@feed.url}' and '#{dup_feed.url}'  were allowed"
  end
  
  test 'Feed URLs must be case insensitive' do
    dup_feed = @feed.dup
    
    dup_feed.url	= 'derpurl.uk'
    @feed.url		= 'DERPurl.uk'
    
    @feed.save
    
    assert_not dup_feed.valid?, "Feed URL duplication check was case sensitive between '#{@feed.url}' and '#{dup_feed.url}'"
  end
end
