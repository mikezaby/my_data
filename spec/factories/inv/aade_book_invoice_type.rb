# frozen_string_literal: true

FactoryBot.define do
  factory :aade_book_invoice_type, class: "MyData::Resources::Inv::AadeBookInvoiceType" do
    issuer { association(:party_type) }
    invoice_header { association(:invoice_header_type) }
    invoice_details { [association(:invoice_row_type)] }
    invoice_summary { association(:invoice_summary_type) }
    payment_methods { [association(:payment_method_detail_type)] }
  end
end
