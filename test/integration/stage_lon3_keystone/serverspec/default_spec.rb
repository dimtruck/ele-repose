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

describe service('repose-valve') do
  it { should be_enabled }
  # TODO: This doesn't work under kitchen-docker-travis, figure out why to re-enable
  #  it { should be_running.under('upstart') }
end