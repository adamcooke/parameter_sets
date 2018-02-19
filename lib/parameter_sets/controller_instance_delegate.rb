module ParameterSets
  class ControllerInstanceDelegate

    def initialize(controller)
      @controller = controller
    end

    def param_set(name, object = nil, options = {})
      if name.is_a?(Symbol) || name.is_a?(String)
        if schema = @controller.class.parameter_sets[name.to_sym]
          schema.parameters(@controller, object, options)
        else
          raise ParameterSetNotDefinedError, "No parameter set named #{name} is defined"
        end
      else
        param_set_for(name, object.is_a?(Hash) ? object : nil)
      end
    end

    def param_set_for(object, options = {})
      param_set_name = object.model_name.param_key
      param_set(param_set_name.to_sym, object, options)
    end

  end
end
