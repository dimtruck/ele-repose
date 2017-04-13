# frozen_string_literal: true

include_recipe 'ele-repose::default'

unless node['repose']['filters'].include? 'valkyrie-authorization'
  filters = node['repose']['filters'] + ['valkyrie-authorization']
  node.default['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/valkyrie-authorization.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    cache_timeout_millis: node['repose']['valkyrie_authorization']['cache_timeout_millis'],
    enable_masking_403s: node['repose']['valkyrie_authorization']['enable_masking_403s'],
    enable_bypass_account_admin: node['repose']['valkyrie_authorization']['enable_bypass_account_admin'],
    delegating_quality: node['repose']['valkyrie_authorization']['delegating_quality'],
    valkyrie_server_uri: node['repose']['valkyrie_authorization']['valkyrie_server_uri'],
    device_id_mismatch_action: node['repose']['valkyrie_authorization']['device_id_mismatch_action'],
    preauthorized_service_admin_role: node['repose']['valkyrie_authorization']['preauthorized_service_admin_role']
  )
  notifies :restart, 'service[repose-valve]'
end
