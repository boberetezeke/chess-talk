class User < ActiveRecord::Base
  DEFAULT_START_RATING = 1600.0

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  
  has_many :comments
  has_many :game_roles
  has_many :games, :through => :game_roles
  has_many :schedule_results
  belongs_to :league
  serialize :roles, Array

  def record
    if self.league then
      schedule_result = self.league.schedules.first.schedule_results.where(:user_id => self).first
    end

    if (schedule_result)
      "#{schedule_result.wins}-#{schedule_result.losses}-#{schedule_result.ties}"
    else
      "0-0-0"
    end
  end

  def rating
    saved_rating = read_attribute(:rating)
    (saved_rating == 0.0) ? DEFAULT_START_RATING : saved_rating
  end

  def admin?
    roles && roles.include?("admin")
  end
end
