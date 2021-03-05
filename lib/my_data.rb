# frozen_string_literal: true

require "faraday"

require_relative "my_data/version"

module MyData
  class Error < StandardError; end

  autoload :Client, "my_data/client"
end
