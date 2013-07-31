require 'spec_helper'

feature 'Chimpy', js: true do
  stub_authorization!

  background do
    visit '/signup'
  end

  scenario 'guest subscription deface data-hook confirmation' do
    pending 'hook not found, what hook are we looking for here?'
    page.find('#footer-right')
  end

  scenario 'user subscription with opt_in' do
    pending 'seems to be a bug or just fails because no api key is set so its unable to deliver'
    subscribe

    expect(current_path).to eq '/'
    expect(page).to have_selector '.notice', text: 'Welcome! You have signed up successfully.'
    expect(Spree::User.first.subscribed).to be_true
  end

  scenario 'user subscription with opt_out' do
    pending 'is opt_out not unsubscribe for spree_current_user?'
    subscribe

    expect(current_path).to eq '/'
    expect(page).to have_selector '.notice', text: 'Welcome! You have signed up successfully.'
    expect(Spree::User.first.subscribed).to be_false
  end

  def subscribe
    expect(page).to have_text 'Sign me up to the newsletter'

    fill_in 'Email', with: 'ryan@spree.com'
    fill_in 'Password', with: 'test123456'
    fill_in 'Password Confirmation', with: 'test123456'

    check 'Sign me up to the newsletter'
    click_button 'Create'
  end
end
