# tweaks to existing repose attributes

default['repose']['peers'] = [{
  cluster_id: 'repose',
  id: 'repose_node',
  hostname: 'localhost',
  port: '13579'
}]

default['repose']['filters'] = %w(
  header-normalization
  header-translation
  keystone-v2
  extract-device-id
  valkyrie-authorization
  merge-header
)

default['repose']['endpoints'] = [{
  cluster_id: 'repose',
  id: 'public_api',
  protocol: 'http',
  hostname: 'localhost',
  port: '32321',
  root_path: '/',
  default: true
}]

default['repose']['connection_timeout'] = 30_000 # in millis
default['repose']['read_timeout'] = 600_000 # in millis

default['repose']['connection_pool']['socket_timeout'] = 600_000 # in millis
default['repose']['connection_pool']['connection_timeout'] = 30_000 # in millis
default['repose']['connection_pool']['max_total'] = 2000
default['repose']['connection_pool']['max_per_route'] = 1000
# https://repose.atlassian.net/wiki/display/REPOSE/HTTP+Connection+Pool+service
default['repose']['connection_pool']['keepalive_timeout'] = 1 # disabled

default['repose']['header_normalization']['cluster_id'] = ['all']
default['repose']['header_normalization']['uri_regex'] = nil
default['repose']['header_normalization']['whitelist'] = []

default['repose']['header_normalization']['blacklist'] = [{
  id: 'authorization',
  http_methods: 'ALL',
  headers: %w(
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
  )
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

default['repose']['keystone_v2']['cluster_id'] = ['all']
default['repose']['keystone_v2']['uri_regex'] = nil

# defaults are for dev/local (recipe overrides with encrypted data bag item by ele environment)
default['repose']['keystone_v2']['identity_username'] = 'identity_username'
default['repose']['keystone_v2']['identity_password'] = 'identity_p4ssw0rd'

default['repose']['keystone_v2']['identity_uri'] = 'http://localhost:8900/identity'
default['repose']['keystone_v2']['identity_set_roles'] = true
default['repose']['keystone_v2']['identity_set_groups'] = false
default['repose']['keystone_v2']['identity_set_catalog'] = false
default['repose']['keystone_v2']['whitelist_uri_regexes'] = %w(
  ^/?
  ^/pki/.*?
  ^/version?
  ^/_dashboard.*?
  ^/_support.*?
  ^/v1.0/(\d+|[a-zA-Z]+:\d+)/agent_installers/.+(\.sh)?
)
default['repose']['keystone_v2']['tenant_uri_extraction_regex'] = '.*/v1.0/(\d+|[a-zA-Z]+:\d+)/.+'
default['repose']['keystone_v2']['preauthorized_service_admin_role'] = nil
default['repose']['keystone_v2']['token_timeout_variability'] = 15
default['repose']['keystone_v2']['token_timeout'] = 600

default['repose']['valkyrie_authorization']['cluster_id'] = ['all']
default['repose']['valkyrie_authorization']['uri_regex'] = '.*/hybrid:\d+/(?!agent_installers/).*'
default['repose']['valkyrie_authorization']['cache_timeout_millis'] = 60000
default['repose']['valkyrie_authorization']['enable_masking_403s'] = false
default['repose']['valkyrie_authorization']['enable_bypass_account_admin'] = true
default['repose']['valkyrie_authorization']['delegating_quality'] = nil
default['repose']['valkyrie_authorization']['device_id_mismatch_action'] = 'keep'

# TODO : turn to default-level, post chef-server
normal['repose']['valkyrie_authorization']['valkyrie_server_uri'] = if node.chef_environment == 'prod'
                                                                      'https://api.valkyrie.rackspace.com'
                                                                    elsif node.chef_environment == 'stage'
                                                                      'https://staging.api.valkyrie.rackspace.com'
                                                                    else
                                                                      'http://localhost:8900/valkyrie/v2.0'
                                                                    end

default['repose']['merge_header']['cluster_id'] = ['all']
default['repose']['merge_header']['uri_regex'] = nil
default['repose']['merge_header']['headers'] = %w(X-Roles X-Impersonator-Roles)
