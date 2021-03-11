# frozen_string_literal: true

class MyData::Resources::ResponseType
  include MyData::Resource

  attribute :index, :integer

  attribute :invoice_uid, :string
  attribute :invoice_mark, :integer
  attribute :classification_mark, :integer
  attribute :cancellation_mark, :integer
  attribute :authentication_code, :string

  attribute :errors, :resource,
            class_name: "ErrorType",
            collection: true, collection_element_name: "error"

  attribute :status_code, :string
end
