include_attribute 'repose'

# tweaks to existing repose attributes

default['repose']['peers'] = [{
  cluster_id: 'repose',
  id: 'repose_node',
  hostname: 'localhost',
  port: '13579'
}]

default['repose']['filters'] = %w[
  header-normalization
  header-translation
  keystone-v2
  extract-device-id
  valkyrie-authorization
  merge-header
]

default['repose']['endpoints'] = [{
  cluster_id: 'repose',
  id: 'public_api',
  protocol: 'http',
  hostname: 'localhost',
  port: '32321',
  root_path: '/',
  default: true
}]

default['repose']['services'] = %w[
  http-connection-pool
]

default['repose']['http_connection_pool']['socket_timeout'] = 300_000 # in millis
default['repose']['http_connection_pool']['connection_timeout'] = 30_000 # in millis
default['repose']['http_connection_pool']['max_total'] = 4000
default['repose']['http_connection_pool']['max_per_route'] = 2000
# https://repose.atlassian.net/wiki/display/REPOSE/HTTP+Connection+Pool+service
default['repose']['http_connection_pool']['keepalive_timeout'] = 1 # disabled

# metrics configuration
#
## should this be dependent on ele-base attrs?  I'll have to add a dependency but
## right now we have to add this in 2 places (ele graphite_server & ele graphite_port)
default['repose']['graphite_server'] = '127.0.0.1'
default['repose']['graphite_port'] = 2003
default['repose']['graphite_period'] = 10
default['repose']['graphite_prefix'] = ''

default['repose']['header_normalization']['cluster_id'] = ['all']
default['repose']['header_normalization']['uri_regex'] = nil
default['repose']['header_normalization']['whitelist'] = []

default['repose']['header_normalization']['blacklist'] = [{
  id: 'authorization',
  http_methods: 'ALL',
  headers: %w[
    X-Authorization
    X-Token-Expires
    X-Identity-Status
    X-Impersonator-Id
    X-Impersonator-Name
    X-Impersonator-Roles
    X-Roles
    X-Contact-Id
    X-Device-Id
    X-User-Id
    X-User-Name
    X-PP-User
    X-PP-Groups
    X-Catalog
    X-Subject-Token
    X-Subject-Name
    X-Subject-ID
  ]
}]

default['repose']['version'] = '8.0.1.0'
default['repose']['jvm_minimum_heap_size'] = '2g'
default['repose']['jvm_maximum_heap_size'] = '4g'
default['repose']['jvm_maximum_file_descriptors'] = '65535'

default['repose']['owner'] = 'repose'
default['repose']['group'] = 'repose'

# attributes for new recipes
default['repose']['bundle_name'] = 'monitoring-custom-filter-bundle.ear'

default['repose']['header_translation']['cluster_id'] = ['all']
default['repose']['header_translation']['uri_regex'] = nil
default['repose']['header_translation']['headers'] = [{
  original_name: 'Host',
  new_name: 'X-Repose-Forwarded-Host',
  remove_original: 'false'
}]

default['repose']['extract_device_id']['cluster_id'] = ['all']
default['repose']['extract_device_id']['uri_regex'] = '.*/hybrid:\d+/entities/.+'
default['repose']['extract_device_id']['maas_service_uri'] = 'http://localhost:32321'
default['repose']['extract_device_id']['cache_timeout_millis'] = 60000
default['repose']['extract_device_id']['delegating_quality'] = nil

default['repose']['keystone_v2']['uri'] = 'http://localhost:8900/identity'
default['repose']['keystone_v2']['roles_in_header'] = true
default['repose']['keystone_v2']['white_list'] = %w(
  ^/?
  ^/pki/.*?
  ^/version?
  ^/_dashboard.*?
  ^/_support.*?
  ^/v1.0/(\d+|[a-zA-Z]+:\d+)/agent_installers/.+(\.sh)?
)
default['repose']['keystone_v2']['tenant_handling'] = {
  'validate_tenant' => {
    'url_extraction_regex' => '.*/v1.0/(\d+|[a-zA-Z]+:\d+)/.+'
  }
}
default['repose']['keystone_v2']['cache'] = {
  'timeout_variability' => 15,
  'token_timeout' => 600
}

default['repose']['valkyrie_authorization']['cluster_id'] = ['all']
default['repose']['valkyrie_authorization']['uri_regex'] = '.*/hybrid:\d+/(?!agent_installers/).*'
default['repose']['valkyrie_authorization']['cache_timeout_millis'] = 60000
default['repose']['valkyrie_authorization']['enable_masking_403s'] = false
default['repose']['valkyrie_authorization']['enable_bypass_account_admin'] = true
default['repose']['valkyrie_authorization']['delegating_quality'] = nil
default['repose']['valkyrie_authorization']['device_id_mismatch_action'] = 'keep'

# TODO : turn to default-level, post chef-server
normal['repose']['valkyrie_authorization']['valkyrie_server_uri'] = 'http://localhost:8900/valkyrie/v2.0'

default['repose']['merge_header']['cluster_id'] = ['all']
default['repose']['merge_header']['uri_regex'] = nil
default['repose']['merge_header']['headers'] = %w[X-Roles X-Impersonator-Roles]
