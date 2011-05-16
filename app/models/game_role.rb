class GameRole < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  [:name, :record, :rating].each {|sym| delegate sym, :to => :user}
end
