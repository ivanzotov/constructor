FactoryGirl.define do
  factory :pages, :class => ConstructorPages::Page do
    sequence(:name, "a") {|n| "Test title #{n}" }
  end
end