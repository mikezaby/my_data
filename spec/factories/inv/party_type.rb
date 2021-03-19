# frozen_string_literal: true

FactoryBot.define do
  factory :party_type, class: "MyData::Resources::Inv::PartyType" do
    vat_number { "111111111" }
    country  { "GR" }
    branch { 0 }
  end
end
