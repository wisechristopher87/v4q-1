# command to run this test
#      rspec -fd --dry-run edit_an_address_spec.rb
#      rspec -fd edit_an_address_spec.rb

require 'watir'
require 'rspec'

describe "A user can edit an address" do
			browser = nil

	    it 'Given I login to the address book' do
				browser = Watir::Browser.new

				# Navigate to Page
				browser.goto 'a.testaddressbook.com'

				# Sign in
				browser.link(id: 'sign-in').click

				# TONY: This is a common problem with automation. Here we see
				#       credentials in clear text in a program. Depending on
				#       the application under test, this is a big NO NO.
				browser.text_field(data_test: 'email').set 'watir_example@example.com'
				browser.text_field(data_test: 'password').set 'password'

				browser.button(data_test: 'submit').click
				# do I need to wait?
				# browser.wait_until()
	    end

	    it 'and I find an address to edit' do
				browser.link(data_test: 'addresses').click
				browser.wait_until(timeout: 5) {browser.link(data_test: 'create').present?}

				rows = browser.table(class: 'table').trs
				puts "page has #{rows.length} addresses"
				random_record = Random.rand(0..(rows.length-1))
				puts "editing address #{random_record}"
				row = rows[random_record]

				# we send javascript to the browser
				browser.execute_script('arguments[0].scrollIntoView();', row)

				# the edit link in the 5th column in a row
				row[5].click

				browser.wait_until(timeout: 5) {browser.button(data_test: 'submit').present?}
	    end

	    it 'When I change the information' do
				browser.text_field(id: 'address_first_name').set 'Betty'
				browser.text_field(id: 'address_last_name').set 'Boop'
				browser.text_field(id: 'address_city').set 'Los Angeles'
				browser.select_list(id: 'address_state').select 'CA'
				browser.text_field(id: 'address_website').set 'https://en.wikipedia.org/wiki/Betty_Boop'
				browser.textarea(id: 'address_note').set 'This address has been edited for testing'

				sleep 10
	    end

			it 'and I save the record' do
				browser.button(data_test: 'submit').click
				# do I need to wait?
				# browser.wait_until()
			end

			it 'Then I see a confirmation' do
				expect(browser.div(data_test: 'notice').text).to eql('Address was successfully updated.')
			end

	    it 'and I see the new information' do
				expect(browser.span(data_test: 'first_name').text).to match /betty/i
				expect(browser.span(data_test: 'last_name').text).to be == 'Boop'
				expect(browser.span(data_test: 'website').text).to include('Betty_Boop')

				expect(browser.span(data_test: 'note').text).to eql('This address has been edited for testing')

				# logout
				browser.link(data_test: 'sign-out').click
	    end
end
