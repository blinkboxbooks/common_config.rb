require "ruby_units"

module JavaProperties
  module Encoding
    class << self
      alias :raw_decode :decode
      def decode(string)
        string = raw_decode(string)

        case string
        when /^:(\w+)$/
          Regexp.last_match[1].to_sym
        when /^(?:(true)|false)$/i
          !Regexp.last_match[1].nil?
        when /^\d+\ .+$/
          Unit(string)
        when /^\d+$/
          string.to_i
        when /^\d+\.\d+$/
          string.to_f
        else
          string
        end
      end
    end
  end
end