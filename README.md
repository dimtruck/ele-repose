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

**TODO** Complete the table for a prize!

Key | Type | Description | Default
--- | --- | --- | ---
['foo'] | String | some description | 'bar'

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
