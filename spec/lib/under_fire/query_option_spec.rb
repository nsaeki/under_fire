require_relative '../../spec_helper.rb'
require 'ox'
require 'rr'

module UnderFire
  describe QueryOption do
    subject { QueryOption.new(:select_extended => [:artist_oet, :mood, :tempo],
                              :select_detail => {
                                genre: '3level',
                                mood: '2level',
                                tempo: '3level',
                                artist_origin: '4level',
                                artist_era: '2level',
                                artist_type: '2level'
                              })}

    before do
      ENV['UF_CONFIG_PATH'] = File.expand_path('spec/fixtures/.ufrc')
    end

    it "accepts a hash of arguments" do
      subject.option.must_be_instance_of Hash
      subject.option.must_include :select_extended
      subject.option.must_include :select_detail
      subject.option[:select_extended].must_include :artist_oet
      subject.option[:select_detail].must_include :genre
    end

    describe "#query" do
      let(:query) do
        builder = Builder::XmlMarkup.new
        subject.build_query(builder)
      end

      it "returns well formed xml" do
        Ox.load(query).must_be_kind_of Ox::Element
      end

      it "returns xml with an option element" do
        query.must_include "<OPTION>"
        query.must_include "</OPTION>"
      end

      describe "with SELECT_EXTENDED" do
        it "returns an xml query with a SELECT_EXTENDED" do
          query.must_include "<PARAMETER>SELECT_EXTENDED</PARAMETER>"
        end

        it "returns an xml query with a VALUE" do
          query.must_include "<VALUE>ARTIST_OET,MOOD,TEMPO</VALUE>"
        end
      end

      describe "with SELECT_DETAIL" do
        it "returns an xml query with a SELECT_DETAIL" do
          query.must_include "<PARAMETER>SELECT_DETAIL</PARAMETER>"
        end
        it "returns an xml query with an VALUE" do
          query.must_include "<VALUE>"
          query.must_include "GENRE:3LEVEL,MOOD:2LEVEL"
          query.must_include "</VALUE>"
        end
      end

      describe "with only SELECT_EXTENDED" do
        let(:query) do
          builder = Builder::XmlMarkup.new
          QueryOption.new({:select_extended => [:artist_oet]}).build_query(builder)
        end

        it "returns an xml query with a SELECT_EXTENDED" do
          query.must_include "<PARAMETER>SELECT_EXTENDED</PARAMETER>"
        end
      end
    end
  end
end
