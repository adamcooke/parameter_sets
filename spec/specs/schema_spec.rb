require 'spec_helper'
require "parameter_sets/schema"

describe ParameterSets::Schema do

  it "should use the name as the default param name" do
    schema = ParameterSets::Schema.new(:post)
    expect(schema.base_param_name).to eq(:post)
  end

  it "should allow param name to be changed with an option" do
    schema = ParameterSets::Schema.new(:post, :param_name => :blog_post)
    expect(schema.base_param_name).to eq(:blog_post)
  end

  it "should raise an error when there's no permitted parameters" do
    schema = ParameterSets::Schema.new(:post) do
      # Do nothing...
    end
    expect { schema.parameters(FakeController.new(:post => {:title => 'Hello'})) }.to raise_error(ParameterSets::NoParametersPermittedError)
  end

  it "should permit attributes that are allowed" do
    schema = ParameterSets::Schema.new(:post) do |r|
      r.permit :title
    end
    controller = FakeController.new(:post => {:title => 'Hello', :content => 'Llama'})
    params = schema.parameters(controller)
    expect(params).to be_a(ActionController::Parameters)
    expect(params[:title]).to eq 'Hello'
    expect(params[:content]).to eq nil
  end

  it "should eval the rule block in the context of the controller" do
    controller = FakeController.new(:post => {:title => 'Hello'})
    inner_object = nil
    schema = ParameterSets::Schema.new(:post) do |r|
      r.permit :title
      inner_object = self
    end
    schema.parameters(controller)
    expect(inner_object).to eq controller
  end

  it "should have access to an object" do
    controller = FakeController.new(:post => {:title => 'Hello'})
    object = Object.new
    inner_object = nil
    schema = ParameterSets::Schema.new(:post) do |r, object|
      r.permit :title
      inner_object = object
    end
    schema.parameters(controller, object)
    expect(inner_object).to eq object
  end

  it "should have access to options" do
    controller = FakeController.new(:post => {:title => 'Hello'})
    object = Object.new
    inner_object = nil
    schema = ParameterSets::Schema.new(:post) do |r, object, options|
      r.permit :title
      inner_object = options[:some_option]
    end
    schema.parameters(controller, nil, :some_option => 'HelloPenguin')
    expect(inner_object).to eq 'HelloPenguin'
  end

  it "should allow strong parameter options be provided" do
    controller = FakeController.new(:post => {:title => 'Hello', :tags => ['a', 'b', 'c']})
    schema = ParameterSets::Schema.new(:post) do |r|
      r.permit :title
      r.permit :tags, []
    end
    params = schema.parameters(controller)
    expect(params[:tags]).to be_a(Array)
    expect(params[:tags].size).to eq 3
  end

end
