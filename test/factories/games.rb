Factory.define :game do |f|
  f.scheduleable {|a| a.association(:schedule) }
end
