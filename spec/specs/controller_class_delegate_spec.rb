require 'spec_helper'
require 'parameter_sets/controller_class_delegate'

describe ParameterSets::ControllerClassDelegate do

  subject(:controller) { FakeController }
  subject(:delegate) { ParameterSets::ControllerClassDelegate.new(controller) }

  after(:each) do
    FakeController.parameter_sets.delete_if { true }
  end

  it "should allow new parameter sets to be defined" do
    delegate.param_set :post do |r|
      r.permit :name
    end
    expect(controller.parameter_sets[:post]).to be_a(ParameterSets::Schema)
  end

end
