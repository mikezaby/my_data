# frozen_string_literal: true

class MyData::Resources::ResponsesDoc
  include MyData::Resource

  attribute :response, :resource, class_name: "ResponseType", collection: true
end

