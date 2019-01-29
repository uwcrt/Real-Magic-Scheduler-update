FactoryBot.define do
  factory :user do
    first_name            { "Justin" }
    last_name             { "Vanderheide" }
    username              { "jvand" }
  end

  factory :shift do 
    name      { "Example Shift" }
    start     { DateTime.now }
    finish    { DateTime.now + 5.hours }
    location  { "Student Life Center" }
    shift_type_id { 1 }
  end

  factory :shift_type do 
    name                  { "regular" }
    primary_requirement   { 10 }
    secondary_requirement { 12 }
  end

  factory :email do |n|
    "person-#{n}@example.com"
  end
end
