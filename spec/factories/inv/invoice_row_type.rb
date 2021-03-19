# frozen_string_literal: true

FactoryBot.define do
  factory :invoice_row_type, class: "MyData::Resources::Inv::InvoiceRowType" do
    line_number { "1" }
    net_value { 100.00 }
    vat_category { 1 }
    vat_amount { 24.00 }
    income_classification { [association(:income_classification_type)] }
  end
end
