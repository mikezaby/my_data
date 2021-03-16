# frozen_string_literal: true

module MyData
  module TypeCaster
    extend self

    ALLOWED_TYPES = [
      :string,
      :integer,
      :float,
      :date,
      :time,
      :boolean,
      :resource
    ].freeze

    def valid_type?(type)
      ALLOWED_TYPES.include?(type)
    end

    def cast(value:, type:, resource: nil)
      return type_cast_resource(value, resource) if type == :resource

      send("type_cast_#{type}", value)
    end

    private

    def type_cast_string(value)
      value.to_s.strip
    end

    def type_cast_integer(value)
      value.present? ? value.to_i : nil
    end

    def type_cast_float(value)
      value.present? ? value.to_f : nil
    end

    def type_cast_date(value)
      value.present? ? value.to_date : nil
    end

    def type_cast_time(value)
      value.present? ? value.to_time : nil
    end

    def type_cast_boolean(value)
      value.downcase == "true"
    end

    def type_cast_resource(value, resource)
      value.present? ? resource.new(value) : nil
    end
  end
end
