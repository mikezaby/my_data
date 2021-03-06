# frozen_string_literal: true

require "active_model"
require "active_support/all"
require "faraday"
require "nokogiri"

require_relative "my_data/version"

module MyData
  class Error < StandardError; end

  def self.root
    File.expand_path '../..', __FILE__
  end

  autoload :Client, "my_data/client"
  autoload :Resource, "my_data/resource"
  autoload :Resources, "my_data/resources"
  autoload :TypeCaster, "my_data/type_caster"
  autoload :XmlGenerator, "my_data/xml_generator"
  autoload :Xsd, "my_data/xsd"
end
