# frozen_string_literal: true

require "active_model"
require "active_support/all"
require "faraday"
require "nokogiri"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.setup

module MyData
  class Error < StandardError; end

  def self.root
    File.expand_path '../..', __FILE__
  end
end
