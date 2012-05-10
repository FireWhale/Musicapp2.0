class Unit < ActiveRecord::Base
  attr_accessible :unit_id
  attr_accessible :member_id
  
  belongs_to :unit, :class_name => "Artist"
  belongs_to :member, :class_name => "Artist"  
end
