# frozen_string_literal: true

class MyData::Xsd::Element
  attr_reader :element, :namespace

  def initialize(element, namespace: nil)
    @element = element
    @namespace = namespace
  end

  def name
    @name ||= element.attributes["name"].value
  end

  def type
    @type =
      if element.attributes["type"].present?
        element.attributes["type"]
      elsif element.xpath(".//xs:restriction[@base]").any?
        element.xpath(".//xs:restriction[@base]").first.attributes["base"]
      elsif element.xpath(".//xs:element[@type]").any?
        element.xpath(".//xs:element[@type]").first.attributes["type"]
      end.value
  end

  def collection?
    return @collection if defined? @collection

    @collection = element.to_s.include? "maxOccurs"
  end

  def inspect
    "Element: { name: #{name.to_json}, type: #{type.to_json}, collection: #{collection?} }"
  end
end
