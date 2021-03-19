# frozen_string_literal: true

FactoryBot.define do
  factory :invoice_header_type, class: "MyData::Resources::Inv::InvoiceHeaderType" do
    series { "A" }
    aa { "1" }
    issue_date { "2021-02-21" }
    invoice_type { "11.2" }
    currency { "EUR" }
  end
end
