class CommentsController < ApplicationController
  actions :create, :update
  belongs_to :game

  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    @comment.game = Game.find(params[:game_id])
puts "**********  = #{request.host}"
puts "**********  = #{request.port}"
puts "**********  = #{request.protocol}"
    UserMailer.comment_email(@comment, @comment.game.players_and_commenters - [@comment.user], request).deliver
    create! do |format|
      format.html {redirect_to game_path(@comment.game)}
    end
  end
end
