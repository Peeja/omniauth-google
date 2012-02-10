lib_dir = File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
$:.unshift(lib_dir)
$:.uniq!

require 'rubygems'
require 'rake'

gem 'rspec', '~> 1.2.9'
begin
  require 'spec/rake/spectask'
rescue LoadError
  STDERR.puts 'Please install rspec:'
  STDERR.puts 'sudo gem install rspec'
  exit(1)
end

require File.join(File.dirname(__FILE__), 'lib/omniauth/google', 'version')

PKG_DISPLAY_NAME   = 'OmniAuth Google'
PKG_NAME           = 'google-api-omniauth'
PKG_VERSION        = OmniAuth::Google::VERSION::STRING
PKG_FILE_NAME      = "#{PKG_NAME}-#{PKG_VERSION}"

RELEASE_NAME       = "REL #{PKG_VERSION}"

PKG_AUTHOR         = 'Bob Aman'
PKG_AUTHOR_EMAIL   = 'bob@sporkmonger.com'
PKG_HOMEPAGE       = 'http://code.google.com/p/omniauth-google/'
PKG_SUMMARY        = 'An OmniAuth strategy for Google.'
PKG_DESCRIPTION    = <<-TEXT
An OmniAuth strategy for Google.
TEXT

PKG_FILES = FileList[
    'lib/**/*', 'spec/**/*', 'vendor/**/*',
    'tasks/**/*', 'website/**/*',
    '[A-Z]*', 'Rakefile'
].exclude(/database\.yml/).exclude(/[_\.]git$/)

RCOV_ENABLED = (RUBY_PLATFORM != 'java' && RUBY_VERSION =~ /^1\.8/)
if RCOV_ENABLED
  task :default => 'spec:verify'
else
  task :default => 'spec'
end

WINDOWS = (RUBY_PLATFORM =~ /mswin|win32|mingw|bccwin|cygwin/) rescue false
SUDO = WINDOWS ? '' : ('sudo' unless ENV['SUDOLESS'])

Dir['tasks/**/*.rake'].each { |rake| load rake }
