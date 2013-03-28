class Project < ActiveRecord::Base
  attr_accessible :name, :provider, :size
end
