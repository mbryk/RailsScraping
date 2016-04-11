desc "Grab mutual friend count"
task :scrape_friends => :environment do
	require 'mechanize'

	# Login using Mobile page, because of cookies
	a = Mechanize.new
	a.get('https://m.facebook.com')
	login = a.page.forms.first
	login.email = ""
	login.pass = ""
	login.submit

	# Redirect to Mutual Friends page and scrape the number
	u1 = Users.find(1)
	a.get('https://www.facebook.com/friendship/')
	friends = a.page.link_with(:href => /mutual/).text[/[0-9]/]

end