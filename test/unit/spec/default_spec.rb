require 'chefspec'
require_relative 'spec_helper'

describe 'ele-repose' do
  before { stub_resources }
  let(:chef_run) { ChefSpec::SoloRunner.new(UBUNTU_OPTS).converge(described_recipe) }

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

  #  it 'creates a template /etc/repose/metrics.cfg.xml' do
  #    expect(chef_run).to create_template('/etc/repose/metrics.cfg.xml')
  #  end
  it 'creates a template /etc/repose/log4j2.xml' do
    expect(chef_run).to create_template('/etc/repose/log4j2.xml')
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
  it 'creates a template /etc/repose/container.cfg.xml' do
    expect(chef_run).to create_template('/etc/repose/container.cfg.xml')
  end
  it 'creates a remote_file /usr/share/repose/filters/monitoring-custom-filter-bundle.ear' do
    expect(chef_run).to create_remote_file('/usr/share/repose/filters/monitoring-custom-filter-bundle.ear')
  end
  it 'creates a directory /etc/repose' do
    expect(chef_run).to create_directory('/etc/repose')
  end
end
