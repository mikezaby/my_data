# frozen_string_literal: true

FactoryBot.define do
  factory :invoice_summary_type, class: "MyData::Resources::Inv::InvoiceSummaryType" do
    total_net_value { 100.00 }
    total_vat_amount { 24.00 }
    total_withheld_amount { 0.0 }
    total_fees_amount { 0.0 }
    total_stamp_duty_amount { 0.0 }
    total_other_taxes_amount { 0.0 }
    total_deductions_amount { 0.0 }
    total_gross_value { 124.00 }
    income_classification { [association(:income_classification_type)] }
  end
end
