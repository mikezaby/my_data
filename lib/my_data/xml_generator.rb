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
        attr_mappings = mappings[key]
        next if value.nil?

        if attr_mappings[:collection]
          val = value.map { |v| attr_mappings[:resource] ? self.class.new(v, parent_namespace: namespace).to_xml_structure : v.to_s }

          if attr_mappings[:collection_element_name]
            struct = val.map { |v| attr_structure(attr_mappings[:collection_element_name], v) }
            structure.push(attr_structure(key, struct))
          else
            struct = val.map { |v| attr_structure(key, v) }
            structure.push(*struct)
          end
        else
          val = attr_mappings[:resource] ? self.class.new(value, parent_namespace: namespace).to_xml_structure : value.to_s
          structure.push(attr_structure(key, val))
        end
      end
    end

    private

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
