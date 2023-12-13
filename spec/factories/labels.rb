FactoryBot.define do
  factory :label do
    name { 'LabelTest' }
    association :user
  end
end