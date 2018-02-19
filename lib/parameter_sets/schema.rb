require 'parameter_sets/error'
require 'parameter_sets/schema_dsl'

module ParameterSets
  class Schema

    def initialize(name, options = {}, &block)
      @name = name
      @options = options
      @block = block
    end

    # Return the base parameter name to get from the request's parameters.
    def base_param_name
      @options[:param_name] || @name
    end

    # Return a suitablely scoped ActionController::Parameters object based on the
    # rules defined for this param set.
    #
    # @param controller [ActionController::Base] the controller we're working within
    # @param object [ActiveModel::Base] an object to generate attributes for
    def parameters(controller, object = nil, options = {})
      dsl = SchemaDSL.new
      controller.instance_exec(dsl, object, options, &@block) if @block
      if dsl.fields.empty?
        raise NoParametersPermittedError, "No fields were permitted"
      else
        controller.params.require(base_param_name).permit(*dsl.fields)
      end
    end

  end
end
