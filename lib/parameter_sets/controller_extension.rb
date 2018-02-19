require 'parameter_sets/controller_instance_delegate'
require 'parameter_sets/controller_class_delegate'

module ParameterSets
  module ControllerExtension

    module InstanceMethods
      def param_set(*args)
        parameter_sets_delegate.param_set(*args)
      end

      private

      def parameter_sets_delegate
        @parameter_sets_delegate ||= ControllerInstanceDelegate.new(self)
      end
    end

    module ClassMethods
      def param_set(*args, &block)
        parameter_sets_delegate.param_set(*args, &block)
      end

      def parameter_sets
        @parameter_sets ||= {}
      end

      private

      def parameter_sets_delegate
        @parameter_sets_delegate ||= ControllerClassDelegate.new(self)
      end
    end

  end
end
