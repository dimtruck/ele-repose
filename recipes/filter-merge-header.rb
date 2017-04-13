# frozen_string_literal: true

include_recipe 'ele-repose::default'

unless node['repose']['filters'].include? 'merge-header'
  filters = node['repose']['filters'] + ['merge-header']
  node.default['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/merge-header.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    headers: node['repose']['merge_header']['headers']
  )
  notifies :restart, 'service[repose-valve]'
end
