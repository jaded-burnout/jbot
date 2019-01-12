$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))

require "rubygems"
require "bundler/setup"
Bundler.require(:default)

require "application"
$application = Application.new
