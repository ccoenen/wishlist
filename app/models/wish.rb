class Wish < ActiveRecord::Base
  attr_accessible :notes, :secret, :taken_by, :title, :url
end
