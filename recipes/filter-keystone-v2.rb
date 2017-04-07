include_recipe 'ele-repose::default'

if %w(stage prod).include?(node.chef_environment)
  # load non-default secrets
  ele_credentials = Chef::EncryptedDataBagItem.load('passwords', 'ele')

  # extract regional identity credentials
  ele_us_auth_api_databag_item = "us_auth_api_password_#{node.chef_environment}"
  ele_uk_auth_api_databag_item = "uk_auth_api_password_#{node.chef_environment}"

  if node['ele']['datacenter'] == 'lon3'
    identity_url = node['ele']['uk_identity_service_url_2'].chomp('/v2.0')
    identity_username = node['ele']['uk_auth_service_username']
    identity_password = ele_credentials[ele_uk_auth_api_databag_item]
  else
    identity_url = node['ele']['us_identity_service_url_2'].chomp('/v2.0')
    identity_username = node['ele']['us_auth_service_username']
    identity_password = ele_credentials[ele_us_auth_api_databag_item]
  end

  node.default['repose']['keystone_v2']['uri'] = identity_url
  node.default['repose']['keystone_v2']['username_admin'] = identity_username
  node.default['repose']['keystone_v2']['password_admin'] = identity_password
end

if %w(dev).include?(node.chef_environment)
  node.override['repose']['keystone_v2']['uri'] = 'http://localhost:8900/identity'
end

include_recipe 'repose::filter-keystone-v2'
