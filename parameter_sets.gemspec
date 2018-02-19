require_relative './lib/parameter_sets/version'
Gem::Specification.new do |s|
  s.name          = "parameter_sets"
  s.description   = %q{A friendly schema for defining permitted parameters in Rails.}
  s.summary       = %q{This gem provides a simple framework allowing greater controler over which parameters to allow in Active Model mass assignment.}
  s.homepage      = "https://github.com/adamcooke/strong_parameters"
  s.version       = ParameterSets::VERSION
  s.files         = Dir.glob("{lib}/**/*")
  s.require_paths = ["lib"]
  s.authors       = ["Adam Cooke"]
  s.email         = ["me@adamcooke.io"]
  s.licenses      = ['MIT']
end
