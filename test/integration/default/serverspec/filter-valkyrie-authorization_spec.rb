# frozen_string_literal: true

# License:: Apache License, Version 2.0
#

require_relative 'spec_helper'

describe file('/etc/repose/valkyrie-authorization.cfg.xml') do
  it { should be_file }
  it { should be_owned_by 'repose' }
  it { should be_grouped_into 'repose' }
  it { should be_mode 644 }
end
