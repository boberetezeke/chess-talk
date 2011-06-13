Factory.define :user do |f|
  f.name "user"
  f.rating 0.0
  f.sequence(:email) {|n| "foo#{n}@example.com"}
  f.password "testing"
  f.password_confirmation "testing"
end
