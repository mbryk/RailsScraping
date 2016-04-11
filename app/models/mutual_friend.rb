class MutualFriend < ActiveRecord::Base
  belongs_to :u1, :class_name => 'User'
  belongs_to :u2, :class_name => 'User'
end
