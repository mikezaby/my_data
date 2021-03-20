# frozen_string_literal: true

require_relative "lib/my_data/version"

Gem::Specification.new do |spec|
  spec.name          = "my_data"
  spec.version       = MyData::VERSION
  spec.authors       = ["Michalis Zamparas"]
  spec.email         = ["mikezaby@gmail.com"]

  spec.summary       = "Api client for AADE myData"
  spec.description   = "Api client for AADE myData"
  spec.homepage      = "https://github.com/mikezaby/my_data"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel", ">= 3.2"
  spec.add_dependency "activesupport", ">= 3.2"
  spec.add_dependency "faraday", "~> 1.0"
  spec.add_dependency "nokogiri", ">= 1.10"
  spec.add_dependency "zeitwerk", ">= 2.4"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
