# frozen_string_literal: true

class MyData::Resources::Inv::InvoicesDoc
  include MyData::Resource

  container_tag "InvoicesDoc", {
    xmlns: "http://www.aade.gr/myDATA/invoice/v1.0",
    "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
    "xsi:schemaLocation": "http://www.aade.gr/myDATA/invoice/v1.0 schema.xsd",
    "xmlns:icls": "https://www.aade.gr/myDATA/incomeClassificaton/v1.0"
  }

  attribute :invoice, :resource,
            class_name: "Inv::AadeBookInvoiceType", collection: true

  validates_presence_of :invoice
end
