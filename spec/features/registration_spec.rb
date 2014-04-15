require 'spec_helper'
require 'capybara/rspec'

Capybara.app = Application

feature 'User registration' do
  scenario 'User can register, log out and log back in again' do
    visit '/'

    expect(page).to have_content 'You are not logged in'

    # Register
    click_link 'Register'

    fill_in 'email', :with => 'user@example.com'
    fill_in 'password', :with => 'my_password'
    fill_in 'password_confirmation', :with => 'my_password'
    click_button 'Register'

    expect(page).to have_content 'Welcome, user@example.com'

    # Log out
    click_link 'Log out'

    expect(page).to_not have_content 'Welcome, user@example.com'
    expect(page).to have_content 'You are not logged in'

    # Log in with invalid password
    click_link 'Log in'

    fill_in 'email', :with => 'user@example.com'
    fill_in 'password', :with => 'not_my_password'
    click_button 'Log in'

    expect(page).to_not have_content 'Welcome, user@example.com'
    expect(page).to have_content 'Email / password is invalid'

    # Log back in again
    visit '/'
    click_link 'Log in'

    fill_in 'email', :with => 'user@example.com'
    fill_in 'password', :with => 'my_password'
    click_button 'Log in'

    expect(page).to have_content 'Welcome, user@example.com'
  end

  scenario 'User can not log in if they have not registered' do
    visit '/'

    click_link 'Log in'

    fill_in 'email', :with => 'user_does_not_exist@example.com'
    fill_in 'password', :with => 'password'
    click_button 'Log in'

    expect(page).to have_content 'Email / password is invalid'
  end

  scenario 'User can not register if they password confirmation does not match' do
    visit '/'
    click_link 'Register'

    fill_in 'email', :with => 'user@example.com'
    fill_in 'password', :with => 'my_password'
    fill_in 'password_confirmation', :with => 'not_my_password'
    click_button 'Register'

    expect(page).to have_content 'Password and confirmation do not match'
  end

  scenario 'User can not register if password is less than three characters' do
    visit '/'
    click_link 'Register'

    fill_in 'email', :with => 'user@example.com'
    fill_in 'password', :with => '12'
    fill_in 'password_confirmation', :with => '12'
    click_button 'Register'

    expect(page).to have_content 'Password must be at least three characters'
  end

  scenario 'User can not register if password is blank' do
    visit '/'
    click_link 'Register'

    fill_in 'email', :with => 'user@example.com'
    fill_in 'password', :with => ''
    fill_in 'password_confirmation', :with => ''
    click_button 'Register'

    expect(page).to have_content 'Password must not be blank'
  end
end