# frozen_string_literal: true

module MyData::Xsd::Structure
  extend self

  PATH = File.join(MyData.root, "lib/my_data/xsd/docs")

  def resource_attributes(class_name)
    namespace, name = class_name.split("::").last(2)

    complex_types["#{namespace.downcase}:#{name}"].elements.map do |element|
      type = type_mapping(element.type)

      [
        element.name.underscore,
        type,
        {
          collection: element.collection?,
          collection_element_name: element.collection_element_name,
          class_name: type == :resource ? classify(element.type) : nil,
          required: element.required?
        }
      ]
    end
  end

  def complex_types
    @complex_types ||= docs.each_with_object({}) do |(namespace, doc), types|
      doc.xpath("//xs:schema/xs:complexType").each do |node|
        type = MyData::Xsd::ComplexType.new(node, namespace: namespace)

        types["#{type.namespace}:#{type.name}"] = type
      end
    end
  end

  def simple_types
    @simple_types ||= docs.each_with_object({}) do |(namespace, doc), types|
      doc.xpath("//xs:schema/xs:simpleType").each do |node|
        type = MyData::Xsd::Element.new(node, namespace: namespace)

        types["#{type.namespace}:#{type.name}"] = type
      end
    end
  end

  private

  def classify(type)
    namespace, name = type.split(":")

    "#{namespace.capitalize}::#{name}"
  end

  def type_mapping(type)
    if ["xs:byte", "xs:long", "xs:int"].include?(type)
      :integer
    elsif type == "xs:decimal"
      :float
    elsif complex_types.key?(type)
      :resource
    elsif simple_types.key?(type)
      type_mapping(simple_types[type].type)
    else
      type.split(":").last.to_sym
    end
  end

  def docs
    @docs ||= {
      inv: read_xsd("InvoicesDoc-v1.0.2.xsd"),
      icls: read_xsd("incomeClassification-v1.0.2.xsd"),
      ecls: read_xsd("expensesClassification-v1.0.2.xsd")
    }
  end

  def read_xsd(name)
    Nokogiri::XML(File.read(File.join(PATH, name)))
  end
end
