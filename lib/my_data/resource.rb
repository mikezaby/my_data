# frozen_string_literal: true

module MyData
  module Resource
    extend ActiveSupport::Concern
    include ActiveModel::Validations
    include ActiveModel::Serializers::JSON

    ALLOWED_ATTRIBUTE_OPTS = [
      :class_name,
      :collection,
      :collection_element_name
    ].freeze

    included do
      @attributes = []
      @mappings = {}
      @container = {
        name: name.demodulize.camelize,
        attributes: {}
      }
    end

    class_methods do
      attr_reader :attributes, :mappings, :container

      def container_tag(name, opts = {})
        @container[:name] = name
        @container[:attributes] = opts
      end

      def xsd_structure
        MyData::Xsd::Structure.resource_attributes(name).each do |attrs|
          e_name, type, opts = attrs
          required = opts.delete :required

          attribute(e_name, type, opts)

          validates_presence_of e_name if required
        end
      end

      # @param name [String] the name of the attribute
      # @param type [Symbol] the type of the attribute (:string, :integer, etc)
      # @param opts [Hash] options for custom parsing
      # @option class_name [String] the name of the resource
      # @option collection [Boolean] when the required attribute is a collection
      # @option collection_element_name [String] when we set collection_element_name
      #                                          we nested the elements of collection with that name
      def attribute(name, type, opts = {})
        name = name.to_s

        raise "Wrong type: #{name}: #{type}" unless MyData::TypeCaster.valid_type?(type)

        if opts.any? { |k, _| !ALLOWED_ATTRIBUTE_OPTS.include?(k) }
          raise "Option not supported: #{name}: #{opts.keys - ALLOWED_ATTRIBUTE_OPTS}"
        end

        @attributes.push(name)
        attr_mappings(name, type, opts)

        attr_reader name

        define_attr_setter name, collection: !!opts[:collection]
      end

      private

      def attr_mappings(name, type, opts)
        resource =
          if type == :resource
            klass_name = opts[:class_name].presence || name
            "MyData::Resources::#{klass_name}".constantize
          end

        @mappings[name] = {
          type: type,
          resource: resource,
          collection: opts[:collection],
          collection_element_name: opts[:collection_element_name]
        }
      end

      def define_attr_setter(name, collection: false)
        define_method "#{name}=" do |value|
          type, resource = self.class.mappings[name].values_at(:type, :resource)

          type_casted_value =
            if collection
              value.map { |val| MyData::TypeCaster.cast(value: val, type: type, resource: resource) }
            else
              MyData::TypeCaster.cast(value: value, type: type, resource: resource)
            end

          instance_variable_set("@#{name}", type_casted_value)
        end
      end
    end

    def initialize(attrs = {})
      self.attributes = attrs
    end

    def attribute_names
      @attribute_names ||= self.class.attributes
    end

    def attributes
      attribute_names.reduce({}) do |hash, name|
        hash.merge!(name => public_send(name))
      end
    end

    def attributes=(attrs)
      attrs.each do |key, value|
        next unless attribute_names.include?(key.to_s)

        public_send("#{key}=", value)
      end

      attributes
    end

    def inspect
      "#{self.class}(#{as_json.to_s.gsub(/^{|}$/, "")})"
    end

    def serializable_hash(*args)
      hash = super

      if block_given?
        hash.each { |key, value| hash[key] = yield(key, value) }
      else
        hash.each do |key, value|
          hash[key] = value.serializable_hash if value.respond_to?(:serializable_hash)
        end
      end

      hash
    end
  end
end
