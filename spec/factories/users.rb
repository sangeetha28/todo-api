FactoryGirl.define do
  factory :user do
    name {Faker::Lorem.word}
    email_address { 'foobar@bar.com'}
    password_digest { 'passswordfoo'}
  end
end