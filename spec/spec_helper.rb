$:.unshift(File.expand_path('../../lib', __FILE__))

RSpec.configure do |config|
  config.color = true
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

require 'parameter_sets/controller_extension'
require 'action_controller'
require 'active_model/naming'

class FakeController

  include ParameterSets::ControllerExtension::InstanceMethods
  extend ParameterSets::ControllerExtension::ClassMethods

  def initialize(params = {})
    @params = params
  end

  def params
    ActionController::Parameters.new(@params)
  end

end

class Post
  extend ActiveModel::Naming
end
