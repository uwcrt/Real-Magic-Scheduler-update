Factory.define :user do |user|
  user.first_name            "Justin"
  user.last_name             "Vanderheide"
  user.email                 "jtvander@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.define :shift do |shift|
  shift.name      "Example Shift"
  shift.start     DateTime.now
  shift.finish    DateTime.now + 5.hours
  shift.location  "Student Life Center"
  shift.note      "Alcohol Served"
  shift.shift_type_id 1
end

Factory.define :shift_type do |shift|
  shift.name                  "regular"
  shift.primary_requirement   10
  shift.secondary_requirement 12
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end
