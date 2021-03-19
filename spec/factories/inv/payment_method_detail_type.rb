# frozen_string_literal: true

FactoryBot.define do
  factory :payment_method_detail_type, class: "MyData::Resources::Inv::PaymentMethodDetailType" do
    type { 3 }
    amount { 124.00 }
  end
end
