require 'parameter_sets/schema'

module ParameterSets
  class ControllerClassDelegate

    def initialize(controller_class)
      @controller_class = controller_class
    end

    def param_set(name, options = {}, &block)
      name = name.to_sym
      schema = Schema.new(name, options, &block)
      @controller_class.parameter_sets[name] = schema
    end

  end
end
