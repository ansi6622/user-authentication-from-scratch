require 'spec_helper'
require 'capybara/rspec'

Capybara.app = Application

feature 'Administrator access' do
  scenario 'Non admin user can not list users' do
    password = BCrypt::Password.create('password')
    DB[:users].insert(email: 'non_admin@example.com', password: password)

    visit '/'
    click_link 'Log in'

    fill_in :email, :with => 'non_admin@example.com'
    fill_in :password, :with => 'password'
    click_button 'Log in'

    expect(page).to_not have_link 'View all users'

    visit '/users'

    expect(page).to_not have_content 'non_admin@example.com'
    expect(page).to have_content 'You are not authorized to access that page.'
  end

  scenario 'Admin user can list users' do
    password = BCrypt::Password.create('password')
    DB[:users].insert(email: 'admin@example.com', password: password, administrator: true)

    password = BCrypt::Password.create('another_password')
    DB[:users].insert(email: 'another_user@example.com', password: password)

    visit '/'
    click_link 'Log in'

    fill_in :email, :with => 'admin@example.com'
    fill_in :password, :with => 'password'
    click_button 'Log in'

    click_link 'View all users'

    within('.people') do
      expect(page).to have_content('admin@example.com')
      expect(page).to have_content('another_user@example.com')
    end
  end
end