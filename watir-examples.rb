# TONY: This code comes from: http://watir.com/guides/form-example/

require 'watir'
# This uses the Faker gem to give us Random Data.
# Read more about Faker gem here: https://github.com/stympy/faker#readme
require 'faker'

# Initalize the Browser
browser = Watir::Browser.new

# Navigate to Page
browser.goto 'a.testaddressbook.com'

# Authenticate and Navigate to the Form
browser.link(id: 'sign-in').click

# TONY: This is a common problem with automation. Here we see
#       credentials in clear text in a program. Depending on
#       the application under test, this is a big NO NO.
browser.text_field(data_test: 'email').set 'watir_example@example.com'
browser.text_field(data_test: 'password').set 'password'

browser.button(data_test: 'submit').click
sleep 5

browser.link(data_test: 'addresses').click
browser.link(data_test: 'create').click

sleep 5

# TONY: Here you see the code using the "Faker" library (aka gem)
#       to generate ramdom fake data. This concept is oftern found
#       in testing.
browser.text_field(id: 'address_first_name').set Faker::Name.first_name
browser.text_field(id: 'address_last_name').set Faker::Name.last_name
browser.text_field(id: 'address_street_address').set Faker::Address.street_address
browser.text_field(id: 'address_secondary_address').set Faker::Address.secondary_address
browser.text_field(id: 'address_city').set Faker::Address.city
browser.select_list(id: 'address_state').select Faker::Address.state
browser.text_field(id: 'address_zip_code').set Faker::Address.zip_code

# radio buttons can be selected with `text` or `label` locators
browser.radio(text: 'Canada').set

# Date Field elements accept Date objects
birthday = Faker::Date.birthday
browser.date_field.set birthday

# TONY: To keep the "fake" person honest, we write 
#       some code to calculate their age.
age = Date.today.year - birthday.year
browser.text_field(id: 'address_age').set age

browser.text_field(id: 'address_website').set Faker::Internet.url
browser.text_field(id: 'address_phone').set Faker::PhoneNumber.phone_number

# TONY: As far as I can see this example is not working. When a browser 
#       wants to interact with a file, doing an upload or download, it
#       can get complex. I have "commented out" this code to Keep It 
#       Simple Sally (KISS)
# File Field elements upload files with the `#set` method, but require the full system path
# file_name = 'watir_example.text'
# File.write(file_name, '')
# path = File.expand_path(file_name)
# browser.file_field(id: 'address_picture').set path


# Checkboxes can be selected by `label` or `text` locators
browser.checkbox(label: 'Dancing').set

browser.textarea(id: 'address_note').set 'See, filling out a form with Watir is easy!'
sleep 5

browser.button(data_test: 'submit').click
sleep 5

browser.close