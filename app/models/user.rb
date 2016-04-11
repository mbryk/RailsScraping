class User < ActiveRecord::Base
  has_many :u1s, :class_name => 'MutualFriend', :foreign_key => 'u1_id'
  has_many :u2s, :class_name => 'MutualFriend', :foreign_key => 'u2_id'

  def mutual_friends
  	mutual_friends = u1s.map { |u| {"id" => u.id, "user" => u.u2, "count" => u.count} }
  	mutual_friends.concat( u2s.map { |u| {"id" => u.id, "user" => u.u1, "count" => u.count} } )
  end


  def influence
  	mutual_friends.inject(0) { |influence, mf| influence + mf["count"] }
  end


  def new_counts
  	fb_login

  	# Just in case he is not a new user -> Delete all old friend counts
  	u1s.delete_all
  	u2s.delete_all

  	# Create friend counts, comparing him and every existing user
  	other_users = User.where.not(id: id)
  	other_users.each do |user|
  		@a.get("https://www.facebook.com/friendship/#{uname}/#{user.uname}")
  		#If you're friends with both of them, there is automatically at least 1 mutual...
  		count = @a.page.link_with(:href => /mutual/).text[/[0-9]+*/]
  		mf = MutualFriend.new(:u1_id => id, :u2_id => user.id, :count => count)
  		mf.save
  	end
  end


  def refresh_counts
  	fb_login
  	
  	# Update each of the user's mutual friend counts
  	mutual_friends.each do |mf_hash|
  		mf = MutualFriend.find(mf_hash["id"])
  		@a.get("https://www.facebook.com/friendship/#{uname}/#{mf_hash["user"].uname}")
  		count = @a.page.link_with(:href => /mutual/).text[/[0-9]+*/]
  		mf.update(:count => count)
  	end
  end


  def fb_login
  	# Login using Mobile page, because of cookies
  	@a = Mechanize.new
  	@a.get("https://m.facebook.com")
  	login = @a.page.forms.first
  	login.email = ""
  	login.pass = ""
  	login.submit
  end
end
