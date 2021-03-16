# frozen_string_literal: true

class MyData::Xsd::ComplexType
  attr_reader :doc, :namespace

  def initialize(doc, namespace: nil)
    @doc = doc
    @namespace = namespace
  end

  def name
    @name ||= doc.attributes["name"].value.camelize
  end

  def elements
    @elements ||= extract_elements(doc).flatten.map do |element|
      MyData::Xsd::Element.new(element)
    end
  end

  def inspect
    "ComplexType: { name: #{name.to_json}, elements: #{elements} }"
  end

  private

  def extract_elements(node)
    return node if node.name == "element"

    node.element_children.map { |child| extract_elements(child) }
  end
end
