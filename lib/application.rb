require "pathname"

class Application
  def initialize
    @root = Pathname.new(File.join(File.dirname(__FILE__), ".."))
  end

  attr_reader :root
end
