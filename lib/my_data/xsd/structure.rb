# frozen_string_literal: true

module MyData::Xsd::Structure
  extend self

  PATH = File.join(MyData.root, "lib/my_data/xsd/docs")

  def doc(class_name)
    name = class_name.split("::").last
    [name, docs[name]]
  end

  def resource_attributes(class_name, type)
    namespace, name = class_name.split("::").last(2)
    key = namespace == "Resources" ? name : [namespace.downcase, name].join(":")

    current_doc = type == :complex_type ? complex_types[key] : docs[name]

    current_doc.elements.map { |element| element_attributes(element) }
  end

  def docs
    @docs ||= Dir.glob("*.xsd", base: PATH).map do |file_name|
      [file_name.sub(/-.+$/, "").camelize, MyData::Xsd::Doc.new(read_xsd(file_name))]
    end.to_h
  end

  def complex_types
    @complex_types ||= docs.values.each_with_object({}) do |document, types|
      document.complex_types.each do |type|
        name = [type.namespace, type.name].compact.join(":")
        types[name] = type
      end
    end
  end

  def simple_types
    @simple_types ||= docs.values.each_with_object({}) do |document, types|
      document.simple_types.each do |type|
        name = [type.namespace, type.name].compact.join(":")
        types[name] = type
      end
    end
  end

  private

  def element_attributes(element)
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

  def classify(type)
    namespace, name = type.split(":").map(&:camelize)

    "#{namespace}::#{name}"
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

  def read_xsd(name)
    Nokogiri::XML(File.read(File.join(PATH, name)))
  end
end
