# frozen_string_literal: true

class MyData::Xsd::Element
  attr_reader :element, :namespace

  def initialize(element, namespace: nil, force_collection: nil)
    @element = element
    @namespace = namespace
    force_collection && @collection = force_collection
  end

  def name
    @name ||= element.attributes["name"].value
  end

  def type
    @type =
      begin
        extracted_type =
          element.attributes["type"] ||
          element.at_xpath(".//xs:element[@type]")&.attributes.try(:[], "type") ||
          element.at_xpath(".//xs:restriction[@base]")&.attributes.try(:[], "base")

        camelize_type(extracted_type.value)
      end
  end

  def collection?
    return @collection if defined? @collection

    @collection = element.to_s.include? "maxOccurs"
  end

  def collection_element_name
    return @collection_element_name if defined? @collection_element_name

    @collection_element_name =
      if collection?
        nested_element = element.at_xpath(".//xs:element")
        nested_element ? nested_element.attributes["name"].value : nil
      end
  end

  def required?
    element.attributes["minOccurs"]&.value != "0"
  end

  def inspect
    "Element: { name: #{name.to_json}, type: #{type.to_json}, collection: #{collection?} }"
  end

  private

  def camelize_type(extracted_type)
    return extracted_type if extracted_type.starts_with?("xs:")

    ns, name = extracted_type.split(":")

    [ns, name.camelize].join(":")
  end
end
