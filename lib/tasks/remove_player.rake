namespace :league do
  desc "remove a player"
  task :remove_player => :environment do 
    remove_player("Greg Thatcher")
    remove_player("Daryl Dehmer")
    remove_player("Bill Konkol")
  end
end

def remove_player(player_name)
  user = User.where(:name => player_name).first
  puts "removing user = #{user.name}"
  user.games.each do |game|
    game.bye = true
    game.save
  end
  user.league = nil
  user.save
  user.schedule_results.each do |sr|
    sr.destroy
  end
end
