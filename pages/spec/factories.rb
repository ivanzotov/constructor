FactoryGirl.define do
  factory :page do
    sequence(:title) {|n| "Page title #{n}" }
    sequence(:url) {|n| "/page-#{n}" }
    content ""
  end
end