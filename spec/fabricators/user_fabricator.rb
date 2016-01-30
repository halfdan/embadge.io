Fabricator(:user) do
  name { Faker::Name.name }
  provider "github"
  uid { Faker::Number.number(6) }
  handle { Faker::Internet.user_name }
  email { Faker::Internet.safe_email }
end
