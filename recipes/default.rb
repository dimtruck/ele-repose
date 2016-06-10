require 'uri'

# extract-device-id filter requires java 1.8
java_ark 'jdk' do
  url 'http://f203e7ccada4106422d5-525efbc04163a45a7d6a38d479995b34.r68.cf2.rackcdn.com/jdk-8u60-linux-x64.tar.gz'
  checksum '1ab9805c5c1b20d56ac287613c3ffa9fc74f2a0dc0fcf1a9eea90811964a5055'
  app_home '/usr/lib/jvm'
  default false
  reset_alternatives false
  use_alt_suffix false
  action :install
end

include_recipe 'ele-repose::log4j2'

include_recipe 'repose::filter-header-normalization'
include_recipe 'repose::filter-header-translation'
include_recipe 'ele-repose::filter-extract-device-id'
include_recipe 'ele-repose::filter-keystone-v2'
include_recipe 'ele-repose::filter-merge-header'
include_recipe 'ele-repose::filter-valkyrie-authorization'

include_recipe 'repose::install'

# ensure package init script is removed to avoid confusion
file '/etc/init.d/repose-valve' do
  action :delete
end

if node.chef_environment == 'dev'
  node.set['repose']['jvm_minimum_heap_size'] = '1g'
  node.set['repose']['jvm_maximum_heap_size'] = '1g'
  node.set['repose']['jvm_maximum_file_descriptors'] = '16384'
end

# NOTE repose::default is mostly copied here due to the following code (which makes wrapping nigh impossible):
# https://github.com/rackerlabs/cookbook-repose/blob/31a561526a1d393b1d7ef8370be26b3999e01f84/recipes/default.rb#L93

template '/etc/init/repose-valve.conf' do
  source 'repose-valve.upstart.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

service 'repose-valve' do
  supports restart: true, status: true
  action [:enable, :start]
  provider Chef::Provider::Service::Upstart
end

include_recipe 'repose::load_peers' if node['repose']['peer_search_enabled']

unless node['repose']['cluster_id'].nil?
  log "Please note that node['repose']['cluster_id'] is deprecated. We've set node['repose']['cluster_ids'] to [#{node['repose']['cluster_id']}] in an effort to maintain compatibility with earlier versions. This functionality will be removed in a future version."
  node.normal['repose']['cluster_ids'] = [node['repose']['cluster_id']]
end

directory node['repose']['config_directory'] do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0755'
end

services = node['repose']['services'].reject { |x| x == 'connection-pool' }

node['repose']['services'].each do |service|
  include_recipe "repose::service-#{service}"
end

if %w(stage prod).include?(node.chef_environment)
  # load non-default secrets
  ele_credentials = Chef::EncryptedDataBagItem.load('passwords', 'ele')
  repose_credentials = Chef::EncryptedDataBagItem.load('credentials', 'repose')

  # extract regional identity credentials
  ele_us_auth_api_databag_item = "us_auth_api_password_#{node.chef_environment}"
  ele_uk_auth_api_databag_item = "uk_auth_api_password_#{node.chef_environment}"

  if node['ele']['datacenter'] == 'lon3'
    identity_url = node['ele']['uk_identity_service_url_2']
    identity_username = node['ele']['uk_auth_service_username']
    identity_password = ele_credentials[ele_uk_auth_api_databag_item]
  else
    identity_url = node['ele']['us_identity_service_url_2']
    identity_username = node['ele']['us_auth_service_username']
    identity_password = ele_credentials[ele_us_auth_api_databag_item]
  end

  identity_url = URI.join(identity_url, '/').to_s # strip trailing path (repose adds it)

  valkyrie_url = repose_credentials["valkyrie_url_#{node.chef_environment}"]
  valkyrie_username = repose_credentials["valkyrie_username_#{node.chef_environment}"]
  valkyrie_password = repose_credentials["valkyrie_password_#{node.chef_environment}"]

  node.set['repose']['keystone_v2']['identity_uri'] = identity_url
  node.set['repose']['keystone_v2']['identity_username'] = identity_username
  node.set['repose']['keystone_v2']['identity_password'] = identity_password

  node.set['repose']['valkyrie_authorization']['valkyrie_server_uri'] = valkyrie_url
  node.set['repose']['valkyrie_authorization']['valkyrie_server_username'] = valkyrie_username
  node.set['repose']['valkyrie_authorization']['valkyrie_server_password'] = valkyrie_password

  # set non-default (environment-specific) configuration

  node.set['repose']['extract_device_id']['maas_service_uri'] = "http://#{node['network']['ipaddress_eth0']}:7000"

  # TODO: these next two attr updates would break a default len > 1 list of peers (should iterate and update ports?)
  # update for stage/prod port
  node.set['repose']['peers'] = [{
    cluster_id: 'repose',
    id: 'repose_node',
    hostname: node['network']['ipaddress_eth0'],
    port: '8080'
  }]

  # update for stage/prod port
  node.set['repose']['endpoints'] = [{
    cluster_id: 'repose',
    id: 'public_api',
    protocol: 'http',
    hostname: node['network']['ipaddress_eth0'],
    port: '7000',
    root_path: '/',
    default: true
  }]

end

# NOTE these hash keys should be left as strings or system-model.cfg.xml.erb will break
filter_cluster_map = {
  'header-normalization'   => node['repose']['header_normalization']['cluster_id'],
  'header-translation'     => node['repose']['header_translation']['cluster_id'],
  'keystone-v2'            => node['repose']['keystone_v2']['cluster_id'],
  'extract-device-id'      => node['repose']['extract_device_id']['cluster_id'],
  'valkyrie-authorization' => node['repose']['valkyrie_authorization']['cluster_id'],
  'merge-header'           => node['repose']['merge_header']['cluster_id']
}

filter_uri_regex_map = {
  'header-normalization'   => node['repose']['header_normalization']['uri_regex'],
  'header-translation'     => node['repose']['header_translation']['uri_regex'],
  'keystone-v2'            => node['repose']['keystone_v2']['uri_regex'],
  'extract-device-id'      => node['repose']['extract_device_id']['uri_regex'],
  'valkyrie-authorization' => node['repose']['valkyrie_authorization']['uri_regex'],
  'merge-header'           => node['repose']['merge_header']['uri_regex']
}

service_cluster_map = {
  :'dist-datastore' => node['repose']['dist_datastore']['cluster_id']
}

template "#{node['repose']['config_directory']}/system-model.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    cluster_ids: node['repose']['cluster_ids'],
    rewrite_host_header: node['repose']['rewrite_host_header'],
    nodes: node['repose']['peers'],
    services: services,
    service_cluster_map: service_cluster_map,
    filters: node['repose']['filters'],
    filter_cluster_map: filter_cluster_map,
    filter_uri_regex_map: filter_uri_regex_map,
    endpoints: node['repose']['endpoints']
  )
  notifies :restart, 'service[repose-valve]'
end

template "#{node['repose']['config_directory']}/container.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    connection_timeout: node['repose']['connection_timeout'],
    read_timeout: node['repose']['read_timeout'],
    deploy_auto_clean: node['repose']['deploy_auto_clean'],
    filter_check_interval: node['repose']['filter_check_interval']
  )
  notifies :restart, 'service[repose-valve]'
end

remote_file "/usr/share/repose/filters/#{node['repose']['bundle_name']}" do
  # distfiles container in maasproject cloud files account (credentials in secure.git)
  source 'https://1897ddfb466c9e3b1daa-525efbc04163a45a7d6a38d479995b34.ssl.cf2.rackcdn.com/custom-bundle-1.2-SNAPSHOT.ear'
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0755'
  action :create
end
