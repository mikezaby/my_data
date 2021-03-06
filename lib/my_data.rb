# frozen_string_literal: true

require "active_model"
require "active_support/all"
require "faraday"

require_relative "my_data/version"

module MyData
  class Error < StandardError; end

  autoload :Client, "my_data/client"
  autoload :Resource, "my_data/resource"
  autoload :Resources, "my_data/resources"
  autoload :TypeCaster, "my_data/type_caster"
end
