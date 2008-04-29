require 'gscraper/search/query'
require 'gscraper/web_agent'

module GScraper
  module Search
    class Result

      include WebAgent

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
      # Fetches the page of the result. If a _block_ is given it will be
      # passed the page.
      #
      def page(&block)
        get_page(@url,&block)
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
      # Fetches the cached page of the result. If a _block_ is given it will
      # be passed the cached page.
      #
      def cached_page(&block)
        get_page(@cached_url,&block)
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
