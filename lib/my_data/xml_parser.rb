# frozen_string_literal: true

module MyData
  class XmlParser
    attr_reader :doc, :mappings, :class_name

    def initialize(doc, mappings, class_name)
      @doc = doc
      @mappings = mappings
      @class_name = class_name
    end

    def parse_xml
      doc.children.select(&:element?).each_with_object({}) do |element, parse_attrs|
        attr_names = extract_attr_names(element)

        attr_names.each do |attr_name|
          value = extract_value(element, attr_name)
          parse_attrs[attr_name] = value if value
        end
      end
    end

    private

    def extract_attr_names(element)
      posible_attrs = mappings.select { |_, opts| element.name == opts[:tag_name] }

      if posible_attrs.present?
        attr_names = posible_attrs
                     .select { |_name, opts| match_static_tag_attributes?(element, opts[:static_tag_attrs]) }
      else
        attr_names = []
        # raise "Not implemented: #{class_name}: #{element.name}"
      end

      if attr_names.empty?
        # raise("Tag attributes not matched: #{class_name}: #{element.name}, element attrs: #{element.attributes}")
      end

      attr_names.map(&:first)
    end

    def extract_value(element, attr_name)
      value = element
      attr_opts = mappings[attr_name]

      # TODO: current we dont check that the attribute setting matcing the elements
      if attr_opts[:nested_tags].present?
        attr_opts[:nested_tags].each do |tag|
          return if value.nil?

          value = value.children.select(&:element?).find { |element| element.name == tag[:name].to_s }
        end

        return value if value.nil?
      end

      if attr_opts[:collection]
        value.children.select(&:element?).map { |val| get_value(val, attr_opts) }
      else
        get_value(value, attr_opts)
      end
    end

    def get_value(value, attr_opts)
      if attr_opts[:type] == :model
        nested_parser = self.class.new(
          value,
          attr_opts[:class_name].mappings,
          attr_opts[:class_name].name
        )
        value = nested_parser.parse_xml
      else
        value = if attr_opts[:dynamic_tag_attr].present?
                  value.attributes[attr_opts[:dynamic_tag_attr]].value
                else
                  value.text
                end
      end
    end

    def match_static_tag_attributes?(element, static_tag_attributes)
      static_tag_attributes.all? do |tag_attribute|
        element_attr = element.attributes[tag_attribute.name]

        next false unless element_attr

        matched = (element_attr.value == tag_attribute.value) &&
                  (tag_attribute.namespace.nil? || tag_attribute.namespace == element_attr.namespace.prefix)

        matched
      end
    end
  end
end
