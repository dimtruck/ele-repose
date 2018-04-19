# frozen_string_literal: true

require 'chefspec'
require_relative 'spec_helper'

describe 'ele-repose' do
  before { stub_resources }
  let(:chef_run) do
    ChefSpec::SoloRunner.new(UBUNTU_OPTS) do |node|
      env = Chef::Environment.new
      env.name 'dev'
      node.normal['ele']['datacenter'] = 'dev'
      node.normal['ele']['us_identity_service_url_2'] = 'localhost:9090/v2.0'
    end.converge(described_recipe)
  end

  it 'includes the `repose::install` recipe' do
    expect(chef_run).to include_recipe('repose::install')
  end

  it 'creates a template /etc/init/repose-valve.conf' do
    expect(chef_run).to create_template('/etc/init/repose-valve.conf')
  end
  it 'deletes the old init start script at /etc/init.d/repose-valve' do
    expect(chef_run).to delete_file('/etc/init.d/repose-valve')
  end

  it 'enables a service called repose-valve' do
    expect(chef_run).to enable_service('repose-valve')
  end
  it 'starts a service called repose-valve' do
    expect(chef_run).to start_service('repose-valve')
  end
  it 'creates a template /etc/repose/metrics.cfg.xml' do
    expect(chef_run).to create_template('/etc/repose/metrics.cfg.xml')
  end
  it 'creates a template /etc/repose/extract-device-id.cfg.xml' do
    expect(chef_run).to create_template('/etc/repose/extract-device-id.cfg.xml')
  end
  it 'creates a template /etc/repose/merge-header.cfg.xml' do
    expect(chef_run).to create_template('/etc/repose/merge-header.cfg.xml')
  end
  it 'creates a template /etc/repose/valkyrie-authorization.cfg.xml' do
    expect(chef_run).to create_template('/etc/repose/valkyrie-authorization.cfg.xml')
  end
  it 'creates a template /etc/repose/system-model.cfg.xml' do
    expect(chef_run).to create_template('/etc/repose/system-model.cfg.xml')
  end
  it 'creates a template /etc/repose/http-connection-pool.cfg.xml' do
    expect(chef_run).to create_template('/etc/repose/http-connection-pool.cfg.xml')
  end
  it 'creates a template /etc/repose/open-tracing.cfg.xml' do
    expect(chef_run).to create_template('/etc/repose/open-tracing.cfg.xml')
  end
  it 'creates a remote_file /usr/share/repose/filters/monitoring-custom-filter-bundle.ear' do
    expect(chef_run).to create_remote_file('/usr/share/repose/filters/monitoring-custom-filter-bundle.ear')
  end
  it 'creates a directory /etc/repose' do
    expect(chef_run).to create_directory('/etc/repose')
  end
end
