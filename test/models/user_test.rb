require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(username: 'kittsville', email: 'kittsville@sci1.uk', password: 'examplepassword', userlevel: 1)
  end
  
  test 'Should be a valid user' do
    assert @user.valid?
  end
  
  test 'Username should not be blank' do
    @user.name = '  '
    
    assert_not @user.valid?
  end
  
  test 'Username should not be too long' do # No longer than 40 characters
    @user.name = 'kitty' * 8
    
    assert @user.valid?
    
    @user.name += 'a'
    
    assert_not @user.valid?
  end
  
  test 'Email should not be blank' do
    @user.email = '  '
    
    assert_not @user.valid?
  end
  
  test 'Email should not be too long' do
    @user.email = 'kitty' * 49 + '@derpy.uk'
    
    assert @user.valid?
    
    @user.email += '.ohno.whyfail'
    
    assert_not @user.valid?
  end
  
  test 'Email should allow valid email addresses' do
    [
      'herp@derp.co',
      'derp_de+derp@merp.co',
      'merp@derp.merp.derp',
    ].each do |email|
      @user.email = email
      
      assert @user.valid?
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
      
      assert_not @user.valid?
  end
end
