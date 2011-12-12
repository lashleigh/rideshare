# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :request do
    origin "MyString"
    destination "MyString"
    title "MyString"
    summary "MyString"
  end
end
