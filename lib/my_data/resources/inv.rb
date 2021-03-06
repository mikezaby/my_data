# frozen_string_literal: true

module MyData::Resources::Inv
  autoload :AadeBookInvoiceType, "my_data/resources/inv/aade_book_invoice_type"
  autoload :AddressType, "my_data/resources/inv/address_type"
  autoload :InvoiceHeaderType, "my_data/resources/inv/invoice_header_type"
  autoload :InvoiceRowType, "my_data/resources/inv/invoice_row_type"
  autoload :InvoiceSummaryType, "my_data/resources/inv/invoice_summary_type"
  autoload :PartyType, "my_data/resources/inv/party_type"
  autoload :PaymentMethodDetailType, "my_data/resources/inv/payment_method_detail_type"
  autoload :ShipType, "my_data/resources/inv/ship_type"
  autoload :TaxTotalsType, "my_data/resources/inv/tax_totals_type"
end
