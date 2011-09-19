class UserMailer < ActionMailer::Base
  helper :application

  def comment_email(comment, to, request)
    @request = request
    @comment = comment
    mail( :from => "no-reply@chess-talk.com",
          :to => to.map{|user| user.email},
          :subject => "#{comment.user.name} has commented on the game #{comment.game.description}")
  end
end
