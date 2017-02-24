include_recipe 'ele-repose::default'
include_recipe 'repose::filter-keystone-v2'

if %w(stage prod).include?(node.chef_environment)
  # load non-default secrets
  ele_credentials = Chef::EncryptedDataBagItem.load('passwords', 'ele')
  node.default['repose']['keystone_v2']['username_admin'] = identity_username
  node.default['repose']['keystone_v2']['password_admin'] = identity_password
end

if %w(dev).include?(node.chef_environment)
  node.default['repose']['keystone_v2']['uri'] = 'http://localhost:8900/identity'
end
