require 'spec_helper'
require 'capybara/rspec'

Capybara.app = Application

feature 'User registration' do
  scenario 'Successful registration' do
    visit '/'

    click_link 'Register'

    fill_in 'email', :with => 'user@example.com'
    fill_in 'password', :with => 'my_password'
    click_button 'Register'

    expect(page).to have_content 'user@example.com'
  end
end