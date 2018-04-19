# frozen_string_literal: true

name 'ele-repose'
maintainer 'Rackspace'
maintainer_email 'sfo-devops@lists.rackspace.com'
license 'Apache-2.0'
description 'Installs/Configures ele-repose'
long_description 'Installs/Configures ele-repose'
version '0.8.0'
chef_version '>= 12' if respond_to?(:chef_version)

issues_url 'https://github.com/mmi-cookbooks/ele-repose/issues'
source_url 'https://github.com/mmi-cookbooks/ele-repose'

depends 'apt'
depends 'java'
depends 'repose'

supports 'ubuntu'
