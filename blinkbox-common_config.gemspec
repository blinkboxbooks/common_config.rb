# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift(File.join(__dir__, "lib"))

Gem::Specification.new do |gem|
  gem.name          = "blinkbox-common_config"
  gem.version       = open("./VERSION").read rescue "0.0.0"
  gem.authors       = ["JP Hastings-Spital"]
  gem.email         = ["jphastings@blinkbox.com"]
  gem.description   = %q{Simple helper for loading configuration in the blinkbox Books format}
  gem.summary       = %q{Simple helper for loading configuration in the blinkbox Books format}
  gem.homepage      = ""

  gem.files         = Dir["lib/**/*.rb","VERSION"]
  gem.extra_rdoc_files = Dir["**/*.md"]
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "java_properties"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~> 2.0"
  gem.add_development_dependency "simplecov"
end
