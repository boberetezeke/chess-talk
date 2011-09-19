class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  default_scope :order => "id desc"
end
