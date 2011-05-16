class Schedule < ActiveRecord::Base
  has_many :games, :as => :scheduleable, :dependent => :destroy
  belongs_to :league
end
