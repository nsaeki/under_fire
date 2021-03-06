module UnderFire
  class Album
    # @return [String] Album title
    attr_reader :title

    # @return [String] Gracenote ID
    attr_reader :gn_id

    # @return [String] Artist
    attr_reader :artist

    # Currently not capturing NUM and ID attributes in GN response
    # @return [String] Name of genre
    attr_reader :genre_name

    # @return [Date] Album date (year)
    attr_reader :date

    # @return [Integer] Track count
    attr_reader :track_count

    # @return [String] Language
    attr_reader :pkg_lang

    # @return [Array] list of tracks
    attr_reader :tracks

    def initialize(album_info, track_klass=Track)
      @album_info = album_info[:responses][:response][:album]
      @title = @album_info[:title]
      @gn_id = @album_info[:gn_id]
      @artist = @album_info[:artist]
      @genre_name = @album_info[:genre]
      @date = Date.new(@album_info[:date].to_i)
      @track_count = @album_info[:track_count].to_i
      @pkg_lang = @album_info[:pkg_lang]
      @tracks = []

      add_tracks(@album_info[:track], track_klass)
    end

    def get_track(id_or_name)
      track = nil
      if id_or_name.respond_to? :-
        track = tracks[id_or_name -1]
      else
        track = tracks.find {|t| t.title.downcase == id_or_name.downcase}
      end
      track
    end

    private

    def add_tracks(track_list, track_klass)
      track_list.each do |t|
        tracks << track_klass.new(t)
      end
    end
  end
end
