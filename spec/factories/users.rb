FactoryGirl.define do
  factory :user do
    name {Faker::Lorem.word}
    email_address  'foobar@bar.com'
    password 'passswordfoo'
  end
end