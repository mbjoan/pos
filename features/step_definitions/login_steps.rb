require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

# test the cashier page
#===========================================
Given(/^they fill in the login form$/) do
  visit users_path
  fill_in('username', :with => "joan")
  fill_in('password', :with => "zxcvbnm")
  click_button "Log in"
end

# test the cashier page
#===========================================

Given(/^I fill in the item form$/) do
  visit items_path
  	Items.reindex


  fill_in('text', :with => "soda")
  fill_in('quantity', :with => 2)
  click_button "Search"	
end

#add new user by admin
#===========================================

Given(/^I fill in the new user form$/) do
  visit new_admin_path
  fill_in('user_username', :with => "louise")
  select("Cashier", :from => 'user[role]')
  fill_in('user_password', :with => "qazxswedc")
  fill_in('user_password_confirmation', :with => "qazxswedc")
  click_button "Create User"	
end

#add new items by admin
#===========================================

Given(/^I fill in the new stock form$/) do
  visit new_item_path
  fill_in('items_name', :with => "apple")
  fill_in('items_price', :with => 700)
  fill_in('items_quantity', :with => 25)
  click_button "Add Item"	
end

#view users by admin
#===========================================

Given(/^I click the view users button$/) do
  visit admin_index_path
  click_button "View Registered users"	
end

#view stock by admin
#===========================================

Given(/^I click the view stock button$/) do
  visit admin_index_path
  click_button "View Available Stock"	
end

#help
#===========================================

Given(/^I click the help link$/) do
  visit items_path
  #click_link "user_help"	
end

#help
#===========================================

Given(/^I click the clear cart link$/) do
  visit items_path
  click_link "new_sale"  
end