# rubocop:disable Naming/FileName
# frozen_string_literal: true

# See https://github.com/ManageIQ/bundler-inject
#
# The gems listed in this file are injected into bundler.
# - `gem` to add new gems
# - `override_gem` to change an existing gem (e.g. the version)
# - `ensure_gem` to make sure a gem is there w/o worrying about if it is an override or not
#
# The bundler-inject plugin is enabled in Hyku's Gemfile (1). This file gets copied
# into /app/.bundler.d/ within Docker (2), where it is then automatically loaded by the plugin (3).
# (1) See hyrax-webapp/Gemfile
# (2) See Dockerfile
# (3) See https://github.com/ManageIQ/bundler-inject/blob/2fd8e3c62e49fbd1113fd3008a28e8fc0465e906/lib/bundler/inject/dsl_patch.rb#L92-L96

override_gem 'bulkrax', '5.4.1'
# rubocop:enable Naming/FileName
