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
end