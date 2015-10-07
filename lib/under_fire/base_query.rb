require 'under_fire/configuration'
require 'builder'

module UnderFire
  # Builds an XML query with information common to all queries (to be subclassed by individual queries).
  class BaseQuery
    # @return [String]
    attr_reader :mode

    # @return [UnderFire::Configuration]
    attr_reader :config

    # @param [String] mode Either 'SINGLE_BEST' or 'SINGLE_BEST_COVER' (defaults to 'SINGLE_BEST_COVER').
    # @option options [String] :lang Language code.
    # @option options [String] :country Country code for country-specific genre hierarchy.
    def initialize(mode="SINGLE_BEST_COVER", options={})
      @mode = mode || "SINGLE_BEST_COVER"
      @config = Configuration.instance
      @options = options
    end

    # @yield [Builder] builder object used by subclass's build_query method.
    def build_base_query(&block)
      builder = Builder::XmlMarkup.new
      builder.QUERIES {
        builder.AUTH {
          builder.CLIENT config.client_id
          builder.USER config.user_id
        }
        builder.LANG (@options[:lang] || "eng")
        builder.COUNTRY (@options[:country] || "canada")
        builder.APP_INFO %Q{APP="under-fire #{VERSION}", OS="#{RUBY_PLATFORM}"}
        yield builder
      }
    end
  end
end
