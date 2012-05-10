class Album < ActiveRecord::Base
  attr_accessible :albumobtained, :genre, :name, :publisher, :releasedate, :reference, :catalognumber
  
  has_and_belongs_to_many :artists
  has_and_belongs_to_many :sources
  
  validates :name, :presence => true 
end
