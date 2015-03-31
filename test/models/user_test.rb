require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(username: 'kittsville', email: 'kittsville@sci1.uk', password: 'examplepassword', userlevel: 1)
  end
  
  test 'Should be a valid user' do
    assert @user.valid?, "User with username #{@user.username} and email #{@user.email} failed"
  end
  
  test 'Username should not be blank' do
    @user.username = '  '
    
    assert_not @user.valid?, "Allowed user with blank username '#{@user.username}'"
  end
  
  test 'Username should not be too long' do # No longer than 40 characters
    @user.username = 'kitty' * 8
    
    assert @user.valid?, "Didn't allow username of length #{@user.username.length}"
    
    @user.username += 'a'
    
    assert_not @user.valid?, "Allowed username of length #{@user.username.length}"
  end
  
  test 'Usernames and emails should be unique' do
    dup_user = @user.dup
    
    @user.save
    
    assert_not dup_user.valid?, "Allowed duplicate users to exist"
  end
  
  test 'Usernames should not be case sensitive' do
    dup_user = @user.dup
    
    dup_user.email += '.uk' # Stops email unique rule interfearing with test
    dup_user.username.upcase!
    
    assert_not dup_user.valid?, "Usernames '#{@user.username}' and '#{dup_user.username}' were created as the same"
  end
  
  test 'Email should not be blank' do
    @user.email = '  '
    
    assert_not @user.valid?, "Allowed user with blank email '#{@user.email}'"
  end
  
  test 'Email should not be too long' do
    @user.email = 'kitty' * 49 + '@derpy.uk'
    
    assert @user.valid?, "Didn't allow valid email of length #{@user.email.length}"
    
    @user.email += '.ohno.whyfail'
    
    assert_not @user.valid?, "Allowed invalid email of length #{@user.email.length}"
  end
  
  test 'Email should allow valid email addresses' do
    [
      'herp@derp.co',
      'derp_de+derp@merp.co',
      'merp@derp.merp.derp',
    ].each do |email|
      @user.email = email
      
      assert @user.valid?, "Valid email address '#{@user.email}' was not allowed"
    end
  end
  
  test 'Email should not allow invalid email addresses' do
    [
      'herpatderp.com',
      'herp@derp,come',
      'herp@derp@derp.com',
      'herp@derp.@',
      'herp@derp+derp.derp',
    ].each do |email|
      @user.email = email
      
      assert_not @user.valid?, "Invalid email address '#{@user.email}' was allowed"
    end
  end
end
