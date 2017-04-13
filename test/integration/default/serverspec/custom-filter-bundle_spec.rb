# encoding: UTF-8

# License:: Apache License, Version 2.0
#

require_relative 'spec_helper'

describe file('/usr/share/repose/filters/monitoring-custom-filter-bundle.ear') do
  it { should be_file }
  it { should be_owned_by 'repose' }
  it { should be_grouped_into 'repose' }
  it { should be_mode 755 }
end
