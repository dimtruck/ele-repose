# encoding: UTF-8

# License:: Apache License, Version 2.0
#

require_relative 'spec_helper'

describe file('/etc/sysconfig/repose') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
end

describe file('/etc/repose/system-model.cfg.xml') do
  it { should be_file }
  it { should be_owned_by 'repose' }
  it { should be_grouped_into 'repose' }
  it { should be_mode 644 }
end

describe file('/etc/repose/container.cfg.xml') do
  it { should be_file }
  it { should be_owned_by 'repose' }
  it { should be_grouped_into 'repose' }
  it { should be_mode 640 }
end

describe file('/etc/repose/http-connection-pool.cfg.xml') do
  it { should be_file }
  it { should be_owned_by 'repose' }
  it { should be_grouped_into 'repose' }
  it { should be_mode 644 }
  its(:content) { should contain %r{http.conn-manager.max-total="4000"} }
end

describe file('/etc/repose/header-normalization.cfg.xml') do
  it { should be_file }
  it { should be_owned_by 'repose' }
  it { should be_grouped_into 'repose' }
  it { should be_mode 644 }
  its(:content) { should contain %r{header id="X-Authorization"\/} }
end

describe file('/etc/repose/header-translation.cfg.xml') do
  it { should be_file }
  it { should be_owned_by 'repose' }
  it { should be_grouped_into 'repose' }
  it { should be_mode 644 }
  its(:content) { should contain %r{new-name="X-Repose-Forwarded-Host"} }
end

describe service('repose-valve') do
  it { should be_enabled }
  # TODO: This doesn't work under kitchen-docker-travis, figure out why to re-enable
  #  it { should be_running.under('upstart') }
end
