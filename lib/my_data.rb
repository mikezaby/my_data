# frozen_string_literal: true

require "active_model"
require "active_support/all"
require "faraday"
require "nokogiri"
require "zeitwerk"

module MyData
  LOADER = Zeitwerk::Loader.for_gem
  LOADER.enable_reloading
  LOADER.setup

  class Error < StandardError; end

  def self.root
    File.expand_path '../..', __FILE__
  end

  def self.reload!
    MyData::LOADER.reload
  end
end
