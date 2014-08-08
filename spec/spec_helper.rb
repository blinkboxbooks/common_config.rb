$LOAD_PATH.unshift File.join(__dir__, "../lib")
require "blinkbox/common_config"

module Helpers
  def load_properties(properties_text)
    Dir.mktmpdir { |dir|
      open(File.join(dir, "reference.properties"), "w") do |f|
        f.puts properties_text
      end

      Blinkbox::CommonConfig.new(config_dir: dir)
    }
  end
end

RSpec.configure do |c|
  c.include Helpers
end