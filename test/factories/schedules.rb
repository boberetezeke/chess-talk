Factory.define :schedule do |f|
  f.league {|a| a.association(:league) }
  f.name "Schedule"
end
