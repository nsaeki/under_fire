require 'builder'

module UnderFire
  # Builds XML for Gracenote's OPTION queries.
  #
  # @example
  #   search = UnderFire::AlbumSearch.new(:artist => 'Radiohead',
  #                                       :option => {
  #                                          :select_extended => [:artist_oet, :mood, :tempo],
  #                                          :select_detail => {
  #                                             genre: '3level',
  #                                             mood: '2level',
  #                                             tempo: '3level',
  #                                             artist_origin: '4level',
  #                                             artist_era: '2level',
  #                                             artist_type: '2level'
  #                                          }
  #                                        })
  class QueryOption
    # @return [Hash]
    attr_reader :option

    # Creates OPTION query instance from given argument.
    # Currently supports SELECT_EXTENDED and SELECT_DETAIL.
    #
    # @param [Hash] args the arguments for an QeuryOption.
    # @option args [Array] :select_extended arguments for SELECT_EXTENDED.
    # @option args [Hash] :track_title arguments for SELECT_DETAIL.
    def initialize(args)
      @option = args || {}
    end

    # Builds OPTION query by given builder.
    #
    # @return [String] XML string for OPTION query.
    def build_query(builder)
        builder.OPTION {
          if @option[:select_extended]
            builder.PARAMETER 'SELECT_EXTENDED'
            builder.VALUE @option[:select_extended].map(&:upcase).join(',')
          end
          if @option[:select_detail]
            builder.PARAMETER 'SELECT_DETAIL'
            builder.VALUE @option[:select_detail].map { |a|
              "#{a[0]}:#{a[1]}".upcase
            }.join(',')
          end
        }
    end
  end
end
