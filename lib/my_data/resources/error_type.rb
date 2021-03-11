# frozen_string_literal: true

class MyData::Resources::ErrorType
  include MyData::Resource

  attribute :message, :string
  attribute :code, :integer
end
