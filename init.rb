require 'redmine'
require 'overview_patch'

Redmine::Plugin.register :redmine_overview_extend do
  name 'Overview Extend plugin'
  author 'TCS'
  description 'This is a plugin for Redmine to extend project overview with custom option'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end

