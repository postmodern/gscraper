module GScraper
  module Search
    class Result

      # Rank of the result page
      attr_reader :rank

      # Title of the result page
      attr_reader :title

      # URL of the result page
      attr_reader :url

      # Summary from the result page
      attr_reader :summary

      #
      # Creates a new Result object with the given _rank_, _title_
      # _summary_, _url_ and _size_.
      #
      def initialize(rank,title,url,summary)
        @rank = rank
        @title = title
        @url = url
        @summary = summary
      end

      #
      # Returns a string containing the result's title.
      #
      def to_s
        @title.to_s
      end

    end
  end
end
