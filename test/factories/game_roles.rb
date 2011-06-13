Factory.define :game_role do |f|
  f.game {|a| a.association(:game)}
  f.user {|a| a.association(:user)}
  f.role "white"
end
