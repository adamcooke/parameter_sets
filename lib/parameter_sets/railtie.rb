module ParameterSets
  class Railtie < Rails::Railtie

    initializer 'parameter_sets.initialize' do
      ActiveSupport.on_load(:action_controller) do
        require 'parameter_sets/controller_extension'
        include ParameterSets::ControllerExtension::InstanceMethods
        extend ParameterSets::ControllerExtension::ClassMethods
      end
    end

  end
end
