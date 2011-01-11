Factory.define :user do |user|
  user.first_name            "Justin"
  user.last_name             "Vanderheide"
  user.email                 "jtvander@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.define :shifttype do |shift|
  shift.name                  "regular"
  shift.primary_requirement   10
  shift.secondary_requirement 12
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end
