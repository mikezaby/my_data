# frozen_string_literal: true

FactoryBot.define do
  factory :invoices_doc, class: "MyData::Resources::Inv::InvoicesDoc" do
    invoice { [association(:aade_book_invoice_type)] }
  end
end
