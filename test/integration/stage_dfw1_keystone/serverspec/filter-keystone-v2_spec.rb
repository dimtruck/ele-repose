# frozen_string_literal: true

# License:: Apache License, Version 2.0
#

require_relative 'spec_helper'

describe file('/etc/repose/keystone-v2.cfg.xml') do
  it { should be_file }
  it { should be_owned_by 'repose' }
  it { should be_grouped_into 'repose' }
  it { should be_mode 640 }
  its(:content) { should match %r{uri="https://staging.identity.api.rackspacecloud.com."} }
  its(:content) { should_not match %r{uri="https://lon.staging.identity.api.rackspacecloud.com."} }
  its(:content) { should_not match %r{uri="https://staging.identity.api.rackspacecloud.com./v2.0"} }
  its(:content) { should match %r{username="us-admin"} }
  its(:content) { should_not match %r{username="uk-admin"} }
  its(:content) { should match %r{password="uspass"} }
  its(:content) { should_not match %r{password="ukpass"} }
  its(:content) { should match %r{white-list} }
end
