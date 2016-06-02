[![Build Status](https://travis-ci.org/mmi-cookbooks/ele-repose.svg)](https://travis-ci.org/mmi-cookbooks/ele-repose)
[![Code Climate](https://codeclimate.com/github/mmi-cookbooks/ele-repose/badges/gpa.svg)](https://codeclimate.com/github/mmi-cookbooks/ele-repose)
[![Coverage Status](https://coveralls.io/repos/mmi-cookbooks/ele-repose/badge.svg?branch=master&service=github)](https://coveralls.io/github/mmi-cookbooks/ele-repose?branch=master)

# ele-repose

Not as cool as [rapper parappa](https://www.youtube.com/watch?v=F5Pm7BL-hyo) but probably more useful :wink:.

This cookbook wraps the standard [repose cookbook](https://github.com/rackerlabs/cookbook-repose) and applies our particular settings and filters.

To use this cookbook you'll need to add it via [berkshelf](http://berkshelf.com/) or otherwise get it into your cookbooks dir.  You'll also need to reference the base repose cookbook.

## Supported Platforms

Other platforms are untested.

- Ubuntu 14 (Trusty Tahr)

## Attributes

Key | Type | Description | Default
--- | --- | --- | ---
['peers'] | Array of Object | List of peer objects |  `[{ cluster_id: 'repose', id: 'repose_node', hostname: 'localhost', port: '13579' }]`
['filters'] | Array | List of Repose filters | `[ header-normalization, header-translation, keystone-v2, extract-device-id, valkyrie-authorization, merge-header]`
['endpoints'] | Array of Object | Public  API endpoints | `[{ cluster_id: 'repose', id: 'public_api', protocol: 'http', hostname: 'localhost', port: '32321', root_path: '/', default: true }]`
['connection_timeout'] | Integer | Connection timeout value in milliseconds | `30,000`
['read_timeout'] | Integer | Read timeout value in milliseconds | `600,000`
['connection_pool']['socket_timeout'] | Integer | Connection timeout value in milliseconds | `600,000`
['connection_pool']['connection_timeout'] | Integer | Connection timeout value in milliseconds | `30,000`
['connection_pool']['max_total'] | Integer | Total | 1000
['connection_pool']['max_per_route'] | Integer | Maximum per route | 500
['header_normalization']['cluster_id'] | Array of Strings | cluster  ID | ['all']
['header_normalization']['uri_regex'] | String | Regular Expression | nil
['header_normalization']['whitelist'] | Array | Whitelist | `[]`
['header_normalization']['blacklist'] | Array | Blacklist | `[...]` (see code)
['version'] | String | Cookbook version | '7.3.0.0'
['jvm_minimum_heap_size'] | String | Maximum Heap size memeory limit | '2g'
['jvm_maximum_heap_size'] | String | Minimum Heap size memeory limit | '4g'
['jvm_maximum_file_descriptors'] | String | Number of file descriptors that can be open at once | '65535'
['owner'] | String | UNIX owner | 'repose'
['group'] | String | UNIX group | 'repose'
['bundle_name'] | String | Name of the java bundle | 'monitoring-custom-filter-bundle.ear'


Note, plugins have namespaces under neat `node['repose']` like `[valkyrie_authorization, keystone_v2, merge_header]`.

## Usage

### ele-repose::default

Include `ele-repose` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[ele-repose::default]"
  ]
}
```

## Releasing
To release a new version of this cookbook, do the following:

1. update the CHANGELOG.md file with the new version and changes
2. update the metadata.rb file
3. commit all changes to master (or merge PR, etc.)
4. tag the repo with the matching version for this release

Then you probably want to update some Berksfiles :smile:
