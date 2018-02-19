require 'spec_helper'
require 'parameter_sets/controller_instance_delegate'

describe ParameterSets::ControllerInstanceDelegate do

  subject(:controller) { FakeController.new(:post => {:title => "50 ways to permit parameters", :content => "Example content..."}) }
  subject(:delegate) { ParameterSets::ControllerInstanceDelegate.new(controller) }

  after(:each) do
    FakeController.parameter_sets.delete_if { true }
  end

  it "should raise an error when a param set is not defined" do
    expect { delegate.param_set(:fruit) }.to raise_error(ParameterSets::ParameterSetNotDefinedError)
  end

  it "should return parameters that are permitted" do
    controller.class.param_set :post do |r|
      r.permit :title
    end
    expect(delegate.param_set(:post)).to be_a(ActionController::Parameters)
    expect(delegate.param_set(:post)[:title]).to eq "50 ways to permit parameters"
    expect(delegate.param_set(:post)[:content]).to eq nil
  end

  it "should determine a param set name from an object" do
    controller.class.param_set :post do |r|
      r.permit :title
    end
    post = Post.new
    expect(delegate.param_set_for(post)).to be_a(ActionController::Parameters)
    expect(delegate.param_set_for(post)[:title]).to eq "50 ways to permit parameters"
  end

  it "should automatically use param_set_for when passing a non-stringy object to param_set" do
    controller.class.param_set :post do |r|
      r.permit :title
    end
    post = Post.new
    expect(delegate.param_set(post)).to be_a(ActionController::Parameters)
    expect(delegate.param_set(post)[:title]).to eq "50 ways to permit parameters"
  end

end
