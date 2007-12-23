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

      # URL of the cached result page
      attr_reader :cached_url

      # URL of the similar results Query
      attr_reader :similar_url

      #
      # Creates a new Result object with the given _rank_, _title_
      # _summary_, _url_, _size_, _cache_url_ and _similar_url_.
      #
      def initialize(rank,title,url,summary,cached_url=nil,similar_url=nil)
        @rank = rank
        @title = title
        @url = url
        @summary = summary
        @cached_url = cached_url
        @similar_url = similar_url
      end

      #
      # Opens the URL of the cached page for the Result. If _opts_ are
      # given, they will be used in accessing the cached page URL.
      #
      #   result.cached_page # => File
      #
      def cached_page(opts={})
        if @cached_url
          return GScraper.open(@cached_url,opts)
        end
      end

      #
      # Create a new Query for results that are similar to the Result. If
      # a _block_ is given, it will be passed the newly created Query
      # object.
      #
      #   result.similar_query # => Query
      #
      #   result.similar_query do |q|
      #     q.first_page.each_url do |url|
      #       puts url
      #     end
      #   end
      #
      def similar_query(&block)
        if @similar_url
          return Query.from_url(@similar_url,&block)
        end
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
