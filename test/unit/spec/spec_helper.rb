# frozen_string_literal: true

# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'rspec/expectations'
require 'chefspec'
require 'chefspec/berkshelf'
require 'chef/application'

::LOG_LEVEL = :fatal
::UBUNTU_OPTS = {
  platform: 'ubuntu',
  version: '14.04'
}.freeze

def stub_resources
  stub_data_bag_item('passwords', 'ele').and_return('us_auth_api_password_dev' => 'pass')
  stub_command('dpkg --get-selections | grep repose-extensions-filter-bundle | grep hold').and_return(true)
  stub_command('dpkg --get-selections | grep repose-filter-bundle | grep hold').and_return(true)
  stub_command('dpkg --get-selections | grep repose-valve | grep hold').and_return(true)
end

at_exit { ChefSpec::Coverage.report! }
