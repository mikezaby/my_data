# frozen_string_literal: true

FactoryBot.define do
  factory :income_classification_type, class: "MyData::Resources::Icls::IncomeClassificationType" do
    classification_type { "E3_561_003" }
    classification_category { "category1_3" }
    amount { 100.00 }
  end
end
