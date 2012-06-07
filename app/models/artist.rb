class Artist < ActiveRecord::Base
  attr_accessible :name, :activity, :obtained, :reference, :database_activity
  
  has_and_belongs_to_many :albums
  has_many :aliases, :foreign_key => "parent_id", :dependent => :destroy
  has_many :alias, :through => :aliases, :source => :parent
  has_many :units, :foreign_key => "unit_id", :dependent => :destroy
  has_many :members, :through => :units, :source => :unit
  
  validates:name, :presence => true, :uniqueness => true
end
