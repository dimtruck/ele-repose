# frozen_string_literal: true

require 'chefspec'
require_relative 'spec_helper'

describe 'ele-repose::filter-keystone-v2' do
  before { stub_resources }

  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
end
