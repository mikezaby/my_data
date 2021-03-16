# frozen_string_literal: true

class MyData::Xsd::Doc
  attr_reader :doc

  DEFAULT_ATTRS = {
    "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance"
  }

  def initialize(doc)
    @doc = doc
  end

  def target_namespace
    return @target_namespace if defined? @target_namespace

    @target_namespace =
      if target_namespace_value
        doc.namespaces.find { |k,v| v == target_namespace_value }.first.split(":").last
      end
  end

  def attributes
    @attributes ||= DEFAULT_ATTRS
      .merge(target_namespace_attributes)
      .merge(namespace_attributes)
  end

  def elements
    @elements ||=
      begin
        sequence = doc.child.xpath("xs:element/xs:complexType/xs:sequence").first
        elements = sequence.xpath("xs:element")
        collection = elements.count == 1 && sequence.attributes["maxOccurs"].present?

        sequence.xpath("xs:element").map do |element|
          MyData::Xsd::Element.new(element, force_collection: collection)
        end
      end
  end

  def complex_types
    @complex_types ||= doc.xpath("//xs:schema/xs:complexType").map do |node|
      MyData::Xsd::ComplexType.new(node, namespace: target_namespace)
    end
  end

  def simple_types
    @simple_types ||= doc.xpath("//xs:schema/xs:simpleType").map do |node|
      MyData::Xsd::Element.new(node, namespace: target_namespace)
    end
  end

  def inspect
    "<Schema target_namespace: #{target_namespace.to_json}, attributes: #{attributes}>"
  end

  private

  def target_namespace_value
    doc.child.attributes["targetNamespace"]&.value
  end

  def target_namespace_attributes
    return {} if !target_namespace_value

    {
      "xmlns" => target_namespace_value,
      "xmlns:schema" => "#{target_namespace_value} schemaLocation.xsd"
    }
  end

  def namespace_attributes
    @namespace_attributes ||= doc
      .namespaces
      .reject { |k, _| k == "xmlns:xs" }
      .reject { |_, v| v == target_namespace }
  end
end
