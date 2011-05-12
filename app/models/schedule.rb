class Schedule < ActiveRecord::Base
  has_many :games, :as => :scheduleable, :dependent => :destroy
end
