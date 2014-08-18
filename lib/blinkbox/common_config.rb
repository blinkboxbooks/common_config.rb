require "java_properties"
require "java_properties/data_types"
require "net/http"
require "tempfile"
require "blinkbox/core_overrides"

module Blinkbox
  class CommonConfig
    # List of sources where properties have been loaded, with the most important first
    attr_reader :sources

    # Generates a CommonConfig object assuming that there is a `reference.properties` in the `config_fir` specified. If
    # an `application.properties` is also present it will load that too (overwriting any repeated property keys) and finally
    # if the environment variable `CONFIG_URL` is set it will load the properties from that (overwriting the others) whether
    # the URL is an absolute, relative (to the working directory, not the `config_dir`) or an HTTP URI.
    #
    # @param [String] config_dir The directory where a `reference.properties` exists and optionally an `application.conf` exists. Relative paths are taken from the working directory.
    # @param [#info, NilClass] logger A logger to which information about what properties have been loaded will be sent. Must respond to #info, can also be `nil`.
    def initialize(config_dir: "config", logger: nil)
      raise ArgumentError, "The logger given doesn't respond to #info." unless logger.nil? || logger.respond_to?(:info)

      reference_prop_file = File.expand_path(File.join(config_dir, "reference.properties"))
      application_prop_file = File.expand_path(File.join(config_dir, "application.properties"))
      raise RuntimeError, "No reference file at #{reference_prop_file}" unless File.exist?(reference_prop_file)

      @options = JavaProperties::Properties.new(reference_prop_file)
      logger.info "Loaded configuration from #{reference_prop_file}" unless logger.nil?
      @sources = [reference_prop_file]

      if File.exist?(application_prop_file)
        @options.load(application_prop_file)
        logger.info "Loaded configuration from #{application_prop_file}" unless logger.nil?
        @sources.unshift(application_prop_file)
      end

      if ENV['CONFIG_URL']
        if ENV['CONFIG_URL'] =~ %r{^https?://}
          res = Net::HTTP.get_response(URI.parse(ENV['CONFIG_URL']))
          raise "The CONFIG_URL points to a resource that returns an HTTP Status code of #{res.code}, not a 200." unless res.code == "200"

          remote_props = Tempfile.new('remote_properties')
          begin
            remote_props.write(res.body)
            remote_props.close
            @options.load(remote_props)
          ensure
            remote_props.unlink
          end
        else
          @options.load(ENV['CONFIG_URL'])
        end
        logger.info "Loaded configuration from #{ENV['CONFIG_URL']}" unless logger.nil?
        @sources.unshift(ENV['CONFIG_URL'])
      end
    end

    # Accessor for the properties stored in the instance. Accepts strings or symbols indifferently.
    #
    # @params [String, Symbol] key The name of the property to retrieve.
    def [](key)
      @options[key]
    end
    alias :get :[]

    # Retrieves a hash of all properties which are beneath this starting element in the tree.
    #
    # # logging.host = "127.0.0.1"
    # # logging.port = 1234
    # # logging = this won't be returned
    #
    # properties.tree(:logging)
    # # => { host: "127.0.0.1", port: 1234 }
    #
    # properties.tree(:log)
    # # => {}
    #
    # @params [String, Symbol] root The root key to look underneath.
    # @returns [Hash] Returns a has
    def tree(root)
      hash = {}
      @options.keys.each { |key|
        len = root.length + 1
        if key.to_s.slice(0, len) == root.to_s + '.'
          hash.deep_set(key.to_s[len..-1], @options[key])
        end
      }
      hash
    end
  end
end