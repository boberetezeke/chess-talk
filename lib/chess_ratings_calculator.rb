class Stats
	WIN = 1.0
	TIE = 0.0
	LOSS = -1.0

	OPPOSITE = { WIN => LOSS, LOSS => WIN, TIE => TIE}
	RESULT_HASH = { WIN => "win", LOSS => "loss", "TIE" => "tie"}
	
	attr_accessor :ar_player, :wins, :losses, :ties, :people_beat, :people_lost_to, :people_tied, :power, :rating, :order
	attr_accessor :games_played

  def self.calc_rating(rating, other_player_rating, result)
		if (rating - other_player_rating).abs > 150 then
			scalar = (other_player_rating - rating) / 1600
		else
			scalar = 0
		end
		win_expectency = 1.0 / (10.0 ** ((-(other_player_rating - rating).abs / 400.0) + 1)).to_f
		if rating < other_player_rating || (result == LOSS && rating == other_player_rating) then
			win_expectency = -win_expectency
		end
		
		rating + (32 * (result + scalar - win_expectency))
  end

	def initialize(ar_player)
		@ar_player = ar_player
		@wins = 0
		@losses = 0
		@ties = 0
    @order = 0
		@games_played = 0
		@people_beat = []
		@people_lost_to = []
		@people_tied = []
		@power = 0.0
		@rating = 1600.0
	end

	def beat(other_player)
		self.wins += 1
		other_player.losses += 1
		self.games_played += 1
		other_player.games_played += 1

		#value = other_player.winning_percentage - self.winnning_percentage
		#self.power += value
		self.people_beat += [[self.games_played, self.rating, other_player.ar_player, other_player.rating]]
		other_player.people_lost_to += [[other_player.games_played, other_player.rating, self.ar_player, self.rating]]
		
		set_rating(other_player, WIN)
		#other_player.power += self.winning_percentage
	end

	def tied(other_player)
		self.ties += 1
		other_player.ties += 1
		self.games_played += 1
		other_player.games_played += 1
		
		self.people_tied += [[self.games_played, self.rating, other_player.ar_player, other_player.rating]]
		other_player.people_tied += [[other_player.games_played, other_player.rating, self.ar_player, self.rating]]

		set_rating(other_player, TIE)

		#self.people_tied += [[other_player.name, other_player.winning_percentage / 2.0]]	#/
		#self.power += other_player.winning_percentage / 2.0		#/

		#other_player.people_tied += [[self.name, self.winning_percentage / 2.0]]	#/
		#other_player.power += self.winning_percentage / 2.0 #/
	end

	def set_rating(other_player, result)
		#$TRACE.debug 5, "--------- #{self.name} vs #{other_player.name} --- #{RESULT_HASH[result]} -------------------"
		new_rating = calc_rating(other_player, result)
		other_player_new_rating = other_player.calc_rating(self, OPPOSITE[result])
		#$TRACE.debug(5, ("result: #{result}, old (%.2f,%.2f), new(%.2f,%.2f)" % [@rating, other_player.rating, new_rating, other_player_new_rating]))
		#puts ("result: #{result}, (#{self.ar_player.name}, #{other_player.ar_player.name}) old (%.2f,%.2f), new(%.2f,%.2f)" % [@rating, other_player.rating, new_rating, other_player_new_rating])

		self.rating = new_rating
		other_player.rating = other_player_new_rating
	end

	def calc_rating(other_player, result)
    Stats.calc_rating(@rating, other_player.rating, result)
=begin
		if (@rating - other_player.rating).abs > 150 then
			scalar = (other_player.rating - @rating) / 1600		#/
		else
			scalar = 0
		end
		win_expectency = 1.0 / (10.0 ** ((-(other_player.rating - @rating).abs / 400.0) + 1)).to_f	# /
		if @rating < other_player.rating || (result == LOSS && @rating == other_player.rating) then
			win_expectency = -win_expectency
		end
		#$TRACE.debug 5, ("my rating = %.2f, other rating = %.2f" % [@rating, other_player.rating])
		#$TRACE.debug 5, "result(#{result}), scalar(#{scalar}), win_expectency(#{'%.2f' % [win_expectency]})"
		#$TRACE.debug 5, "added together = #{result + scalar - win_expectency}"
		#$TRACE.debug 5, "game adjustment = #{32 * (result + scalar - win_expectency)}"
		
		@rating + (32 * (result + scalar - win_expectency))
=end
	end
	
	def winning_percentage
		@wins.to_f / (@wins + @losses + @ties).to_f		#/
	end
end

class ChessRatingsCalculator

  def initialize(schedule)
    @schedule = schedule
  end

  def calculate
    people_stats = {}
    @schedule.games.where("result is not null and result <> '' and (bye is null or bye = false)").order(:actual_start_datetime).each do |game|
      player_1_role = game.game_roles.first
      player_1 = player_1_role.user
      player_2_role = game.game_roles.second
      player_2 = player_2_role.user

      #puts "#{player_1.name} vs #{player_2.name} result = #{game.result}"
      #$TRACE.debug 5, "player_1 = #{player_1}, player 2 = #{player_2}, winner = #{game.winner}"
      people_stats[player_1.id] = Stats.new(player_1) unless people_stats.has_key?(player_1.id)
      people_stats[player_2.id] = Stats.new(player_2) unless people_stats.has_key?(player_2.id)
      player_1_role.rating_before = people_stats[player_1.id].rating
      player_2_role.rating_before = people_stats[player_2.id].rating

      if game.winner == player_1 then
        people_stats[player_1.id].beat(people_stats[player_2.id])
      elsif game.winner == player_2 then
        people_stats[player_2.id].beat(people_stats[player_1.id])
      elsif game.result == "0.5-0.5" then
        people_stats[player_1.id].tied(people_stats[player_2.id])
      end

      player_1_role.rating_after = people_stats[player_1.id].rating
      player_2_role.rating_after = people_stats[player_2.id].rating
    end

    @schedule.schedule_results.each{|sr| sr.destroy}
    @schedule.league.users.each do |user|
      people_stats[user.id] = Stats.new(user) unless people_stats.has_key?(user.id)
    end
 
    #puts "people_stats = #{people_stats.inspect}"
    people_stats.values.sort do |x,y| 
      if (x.wins != y.wins) then
        (x.wins <=> y.wins) 
      elsif x.losses != y.losses then
        y.losses <=> x.losses
      elsif x.ties != y.ties
        x.ties <=> y.ties
      else
        x.rating <=> y.rating
      end
    end.reverse.each_with_index do |stat, index|
      stat.order = index
    end

    people_stats.each do |user_id, stat|
      schedule_result = ScheduleResult.new(:wins => stat.wins, :losses => stat.losses, :ties => stat.ties, :order => stat.order)
      schedule_result.user = stat.ar_player
      @schedule.schedule_results << schedule_result

      # update the player's rating
      stat.ar_player.rating = stat.rating
      stat.ar_player.save
    end
	
    #people.values.each do |stat|
    #	stat.power =  (stat.people_beat.map{|name| people[name].wins.to_f} +
    #			  			stat.people_lost_to.map{|name| people[name].wins.to_f} +
    #			  			stat.people_tied.map{|name| people[name].wins/2.0}).inject(0) {|n, sum| sum + n}		#/
    #end

    #$TRACE.set_level 5
    #people.values.each do |stat|
      #$TRACE.debug 5, "#{stat.name}: #{stat.inspect}"
    #end
  end
end
