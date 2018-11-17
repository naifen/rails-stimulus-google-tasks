FactoryBot.define do
  factory :user do
    username { "john_doe" }
    email { "john.doe@mail.com" }
    phone_number { "1234567890" }
    password { "pw123456" }
    password_confirmation { "pw123456" }
  end

  factory :rand_user, class: User do
    username { Faker::Internet.unique.username }
    email { Faker::Internet.unique.email }
    phone_number { Faker::PhoneNumber.unique.phone_number }
    password { "Pw123456!" }
    password_confirmation { "Pw123456!" }
  end
end
