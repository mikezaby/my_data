# frozen_string_literal: true

module MyData
  class XmlGenerator
    attr_reader :resource, :mappings, :class_name, :container, :parent_namespace

    def initialize(resource, parent_namespace: nil)
      @resource = resource
      @mappings = resource.class.mappings
      @class_name = resource.class.name
      @container = resource.class.container
      @parent_namespace = parent_namespace
    end

    def namespace
      @namespace ||= resource.class.module_parent_name.split("::").last.downcase
    end

    def to_xml
      to_doc.parent.to_xml
    end

    def to_xml_structure
      resource.attributes.each_with_object([]) do |(key, value), structure|
        next if value.nil? || (value.respond_to?(:empty?) && value.empty?)

        value = value_to_xml_structure(key, value)

        structure.push(*extract_attributes(key, value))
      end
    end

    private

    def value_to_string(key, value)
      case mappings[key][:type]
      when :date
        value.strftime("%Y-%m-%d")
      when :time
        value.strftime("%H:%M:%S")
      else
        value.to_s
      end
    end

    def value_to_xml_structure(key, value)
      is_resource = mappings[key][:resource].present?

      transform = lambda do |v|
        if is_resource
          self.class.new(v, parent_namespace: namespace).to_xml_structure
        else
          value_to_string(key, v)
        end
      end

      value.is_a?(Array) ? value.map(&transform) : transform.call(value)
    end

    def extract_attributes(key, value)
      collection, collection_element_name = mappings[key].values_at(:collection, :collection_element_name)

      if !collection
        [attr_structure(key, value)]
      elsif collection_element_name
        attrs = value.map { |v| attr_structure(collection_element_name, v) }

        [attr_structure(key, attrs)]
      else
        value.map { |v| attr_structure(key, v) }
      end
    end

    def attr_structure(key, value)
      prefix = parent_namespace && namespace != parent_namespace ? "#{namespace}:" : ""

      {
        name: [prefix, key.camelize(:lower)].join,
        value: value
      }
    end

    def to_doc
      Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
        xml.send(container[:name], container[:attributes]) do
          create_nodes(xml, to_xml_structure)
        end
      end
    end

    def create_nodes(xml, structure)
      if structure.is_a?(Array)
        structure.each do |es|
          create_node(xml, es[:name], es[:value])
        end
      else
        create_node(xml, structure[:name], structure[:value])
      end
    end

    def create_node(xml, name, value)
      xml.send(name) do
        value.is_a?(String) ? (xml << value) : create_nodes(xml, value)
      end
    end
  end
end
