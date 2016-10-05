require 'chefspec'
require_relative 'spec_helper'

describe 'ele-repose::default' do
  before { stub_resources }

  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'includes the `repose::install` recipe' do
    expect(chef_run).to include_recipe('repose::install')
  end
end
