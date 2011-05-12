class Game < ActiveRecord::Base
  belongs_to :scheduleable, :polymorphic => true
end
