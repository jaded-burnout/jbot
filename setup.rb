%w[
  app
  lib
].each do |directory|
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), directory))
end

require "rubygems"
require "bundler/setup"
Bundler.require(:default)

require "application"
$application = Application.new
