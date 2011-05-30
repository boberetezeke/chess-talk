require "rexml/document"

ABBR = {
  "ARP" => "Alex Romero-Perez",
  "CE" => "Campbell Elder",
  "DJS" => "Darrik Spaude",
  "DTS" => "David Smith",
  "JM" => "Jerome Meyer",
  "KB" => "Kebbe Boayue",
  "ML" => "Mike Lynch",
  "PP" => "Patrick Petersen",
  "SB" => "Steve Bursaw",
  "SR" => "Stacy Rider",
  "ST" => "Steve Tuckner",
  "TT" => "Thanh Tran"
}

EMAILS = {
  "Daryl Dehmer" => "ddehmer@multitech.com",
  "Jerome Meyer" => "jmeyer@multitech.com", 
  "Thanh Tran" => "ttran@multitech.com",
  "Kebbe Boayue" => "kboayue@multitech.com",
  "Stacy Rider" => "srider@multitech.com",
  "Greg Thatcher" => "greg.thatcher@gmail.com",
  "Steve Tuckner" => "stevetuckner@stewdle.com",
  "Campbell Elder" => "celder@multitech.com",
  "Alex Romero-Perez" => "aromeroperez@multitech.com",
  "Darrik Spaude" => "dspaude@multitech.com",
  "Steve Bursaw" => "sbursaw@multitech.com",
  "Matt Mortenson" => "mmortenson@multitech.com",
  "Bill Konkol" => "bkonkol@multitech.com",
  "David Smith" => "dsmith@multitech.com",
  "Patrick Petersen" => "ppetersen@multitech.com",
  "Mike Lynch" => "mlynch@multitech.com"
}

CHESS_ALIAS = {
  "smitherino" => "David Smith",
  "mmortenson" => "Matt Mortenson",
  "Patrick Peterson" => "Patrick Petersen"
}

def first_and_last_initial(player_name)
  player_name.split(/ /).first + "[\-_]" + player_name.split(/ /).second[0..0]
end

def parse_pgn(filename, player1, player2)
  data = File.read(filename)
  if white_player_match = /\[White "(.*)"\]/.match(data) then
    white_player = white_player_match[1]
    if CHESS_ALIAS[white_player] then
      white_player = CHESS_ALIAS[white_player]
    end
  end
  if black_player_match = /\[Black "(.*)"\]/.match(data) then
    black_player = black_player_match[1]
    if CHESS_ALIAS[black_player] then
      black_player = CHESS_ALIAS[black_player]
    end
  end

  if pgn_result_match = /\[Result "(.*)"\]/.match(data) then
    pgn_result = pgn_result_match[1]
  end

  if player1 == white_player && player2 == black_player then
    return [data, "white", "black", pgn_result]
  elsif player1 == black_player && player2 == white_player then
    return [data, "black", "white", pgn_result]
  else
    raise "players in pgn(#{white_player}, #{black_player}) don't match players in table (#{player1}, #{player2}) in file #{filename}"
  end
end

namespace :schedule do
  desc "load in schedule"
  task :load => :delete do
    users = {}
    games = []
    game_files = Dir["lib/tasks/chess-games/*"]
    league = League.new(:name => "Multi-Tech Chess Tournament")
    schedule = Schedule.new(:name => "2010-2011", :league => league)

    doc = REXML::Document.new(File.read("lib/tasks/chess-schedule.htm"))
    round = 1
    doc.elements.each("html/body/div") do |rounds_tables|
    
    rounds_tables.elements.each("table") do |round_table|
      first_row = true
#puts "game_table = #{round_table}"
      round_table.elements.each("tr") do |game_row|
#puts "game_row = #{game_row}"
        if first_row then
          first_row = false
          next
        else
          details = []
          game_row.elements.each("td") do |game_col|
#puts "game_col = #{game_col}"
            if game_col.elements["a"] then
              details.push(game_col.elements["a"].text)
            else
              details.push(game_col.text)
            end
          end
          details = details.map{|d| d.blank? ? "" : d.strip}
          player1, player2, date, winner_abbr, game_name = details


          if m = /^(\d+)\/(\d+)\/(\d+)$/.match(date) then
            actual_start_date = Time.local(m[3].to_i, m[1].to_i, m[2].to_i, 10, 00)
          elsif date == "" && winner_abbr != "" then
            raise "invalid or missing date (#{date}) for game between #{player1} and #{player2} in round #{round}" 
          end

          if winner_abbr.nil? || winner_abbr == "" then
            winner = ""
          elsif winner_abbr == "TIE" then
            winner = "TIE"
          elsif !(winner = ABBR[winner_abbr]) then
            raise "abbr unknown #{winner_abbr}" 
          end

          puts "round #{round}: #{player1} vs #{player2}, winner = #{winner}, date = #{date}"

          if !users[player1] then
            users[player1] = User.new(:name => player1, :email => EMAILS[player1], :password => "changeme")
            users[player1].league = league
            users[player1].save
          end

          if !users[player2] then
            users[player2] = User.new(:name => player2, :email => EMAILS[player2], :password => "changeme")
            users[player2].league = league
            users[player2].save
          end

          player1_role = ""
          player2_role = ""
          pgn_data = ""
          if winner == "TIE" then
            result = "0.5-0.5"
          elsif winner == ""
            result = ""
            raise "pgn listed on game without result" if !game_name.blank?
          elsif winner == users[player1].name
            result = "1-0"
          else
            result = "0-1"
          end

          if result != "" then
            player1_role = "white"
            player2_role = "black"
            if !game_name.blank? then
              game_files.each do |game_file|
                if /#{first_and_last_initial(player1)}-vs-#{first_and_last_initial(player2)}/.match(game_file) ||
                   /#{first_and_last_initial(player2)}-vs-#{first_and_last_initial(player1)}/.match(game_file) then
                  puts "  FOUND GAME: #{game_file}"
                  pgn_data, player1_role, player2_role, result = parse_pgn(game_file, player1, player2)
                  break
                end
              end
            end
          end

          game = Game.new(:result => result, :pgn => pgn_data, :actual_start_datetime => actual_start_date, :round => round)
          GameRole.new(:user => users[player1], :role => player1_role, :game => game).save
          GameRole.new(:user => users[player2], :role => player2_role, :game => game).save

          schedule.games << game
        end
      end
    end
      round += 1
    end

    schedule.save
    league.save
  end

  desc "delete schedule"
  task :delete => :environment do
    League.all.each do |league|
      league.destroy
    end
    User.all.each do |user|
      user.destroy
    end
    Game.all.each do |game|
      game.destroy
    end

    puts "Leagues = #{League.count}"
    puts "Schedules = #{Schedule.count}"
    puts "Games = #{Game.count}"
    puts "Users = #{User.count}"
  end
end

