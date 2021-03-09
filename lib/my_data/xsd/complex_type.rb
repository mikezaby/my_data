# frozen_string_literal: true

class MyData::Xsd::ComplexType
  attr_reader :doc, :namespace

  def initialize(doc, namespace:)
    @doc = doc
    @namespace = namespace
  end

  def name
    @name ||= doc.attributes["name"].value
  end

  def elements
    @elements ||= doc.xpath("xs:sequence/xs:element").map do |element|
      MyData::Xsd::Element.new(element)
    end
  end

  def inspect
    "ComplexType: { name: #{name.to_json}, elements: #{elements} }"
  end
end
