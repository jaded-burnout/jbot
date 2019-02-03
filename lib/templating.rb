require "erb"

module Templating
  def render(template_name)
    source = ($application.root + "#{template_name}.text.erb").read
    ERB.new(source).result(binding)
  end
end
