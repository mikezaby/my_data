# frozen_string_literal: true

class MyData::ResponseParser
  def initialize(response, resource: nil, root: nil)
    @original_response = response
    @resource = resource
    @root = root
  end

  def success?
    original_response.status == 200 &&
      (!response_type? || response.response.all? { |r| r.status_code == "Success" })
  end

  def errors
    @errors ||=
      if success?
        []
      elsif response_type?
        response.response.map(&:errors).flatten
      else
        [MyData::Resources::ErrorType.new(JSON.parse(original_response.body))]
      end
  end

  def response
    return @response if defined? @response

    @response =
      if original_response.status == 200
        MyData::XmlParser.xml_to_resource(xml: original_response.body, resource: resource, root: root)
      end
  end

  private

  def response_type?
    response&.is_a?(MyData::Resources::Response)
  end

  attr_reader :original_response, :resource, :root
end
