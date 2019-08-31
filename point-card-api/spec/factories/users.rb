FactoryBot.define do
  factory :user do
    admin { "MyString" }
    uid { "MyString" }
    email { "MyString" }
    password_digest { "MyString" }
    name { "MyString" }
    gender { "MyString" }
    date_of_birth { "2019-06-09" }
  end
end
