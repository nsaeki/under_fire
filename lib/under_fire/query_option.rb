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
    # Other options are not tested.
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
          @option.each do |k, v|
            builder.PARAMETER k.to_s.upcase
            value = case v
                    when Array then v.join(',')
                    when Hash  then v.map { |a| a.join(':') }.join(',')
                    else
                      v.to_s
                    end

            # I don't know this is correct or not, but I think we should not
            # touch third party ID.
            value.upcase! unless k == :prefer_xid

            builder.VALUE value
          end
        }
    end
  end
end
