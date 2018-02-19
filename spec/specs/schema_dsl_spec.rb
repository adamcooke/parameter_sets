require 'spec_helper'
require "parameter_sets/schema_dsl"

describe ParameterSets::SchemaDSL do

  subject(:dsl) { ParameterSets::SchemaDSL.new }

  it "should start with no fields" do
    expect(dsl.fields).to be_empty
  end

  it "should be able to have fields added" do
    dsl.permit :name
    expect(dsl.fields.size).to eq 1
    expect(dsl.fields[0]).to eq :name
  end

  it "should be able to add multiple fields on the same line" do
    dsl.permit :name, :content
    expect(dsl.fields.size).to eq 2
    expect(dsl.fields[0]).to eq :name
    expect(dsl.fields[1]).to eq :content
  end

  it "should be able to add options with a field" do
    dsl.permit :name, []
    expect(dsl.fields.size).to eq 1
    expect(dsl.fields[0]).to be_a(Hash)
    expect(dsl.fields[0].first[0]).to eq :name
    expect(dsl.fields[0].first[1]).to eq []
  end

end
