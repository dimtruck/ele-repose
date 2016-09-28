# 0.4.1
- Bump ruby version
- Disable keep alives in connection pool
- Increase connections allowed to origin service

# 0.4.0
- Repose v8.0.1.0

# 0.3.14
- Move to custom `ohai` plugin `networks` for compatibility

# 0.3.11
- Valkyrie v2, Repose v7.3.6.0

# 0.3.7
- rename monitoring custom filter bundle ear file

# 0.3.6
- upgrade to Repose version 7.3.0.0 (Valkyrie culling 500 fixes)

# 0.3.5
- upgrade to Repose version 7.2.2.0
- upgrade to extract-device-id filter version 1.1 (relay uri:null entities)
- parameterize jvm memory in order to lower usage in raxvm
- lower socket connection timeout to 30 seconds
- increase fd limit for repose JVM
- increase connection pool size
- fix culling regexes
- whitelist dashboard URIs in Keystone filter
- accept http or https protocol in culled device uris

# 0.3.4
- renamed wrapper cookbook to 'ele-repose'

# 0.3.3
- switch from runit to upstart

# 0.3.2
- add ‘test’ rake task that runs style, unit, & integration tasks
- support environments named ‘prod’ and ‘stage’ without an ‘ele-’ prefix

# 0.3.1
- use java_ark LWRP directly to avoid conflicts with other attribute-based java cookbook usages
- fix (useless) test
- bump kitchen VM memory to 2.5G and initial repose heap to 2G

# 0.3.0
- upgrade Repose to version 7.1.7.1 (fix for Valkyrie culling bug)
- set JVM min-heap == max-heap to avoid GC pause
- reduce log4j2 logging

# 0.2.19
- complete fixes to runit support
- expand log4j2 logging
- tighten up whitelist regexes

# 0.2.18
- fix runit support
- fix java_opts syntax in sysconfig

# 0.2.17
- add Runit support
- remove sysv init script

# 0.2.16
- switch to Concurrent Mark/Sweep GC
- bump heap to alleviate out of memory issues

# 0.2.15
- whitelist /version to allow Nagios check to succeed
- whitelist /pki/* to allow ServerMill to access keys without token
- extend timeouts for origin connections to 600 seconds

# 0.2.14
- prevent extract-device-id filter from grabbing /entities/ request
- remove masking of Valkyrie device level 403s

# 0.2.13
- use base Repose cookbook to add header-translation filter

# 0.2.12
- insert X-Repose-Forwarded-Host header into all requests

# 0.2.11
- grant pre-authorized to hybridRole in Valkyrie filter

# 0.2.10
- extend timeouts for Repose-origin connections to 60 seconds

# 0.2.9
- use only base url for identity
- ensure endpoint id is 'public_api'

# 0.2.8
- use node eth0 IP for ele environment

# 0.2.7
- pin version of repose (to the one that's not broken :wink:)
- replace boilerplate readme with something useful

# 0.2.6
- use direct path to java (now that it's fully consistent)

# 0.2.5
- specify arch for when kernel[:machine] is nil
- move custom bundle and jdk to cloud files

# 0.2.4
- updated jvm heap to 256/1024 (min/max)
- tweaked stage/prod credential handling
- added per-environment valkyrie url
- tossed some lint

# 0.2.3
- RC1 :)

# 0.1.0
- Initial release of wrapper-repose
