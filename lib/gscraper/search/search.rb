require 'gscraper/search/query'

module GScraper
  module Search
    #
    # Returns a new Query object with the given _opts_. See Query.new.
    #
    #   Search.query(:query => 'ruby', :with_words => 'rspec rails')
    #
    #   Search.query(:exact_phrase => 'fluent interfaces') do |q|
    #     q.within_past_week = true
    #   end
    #
    def Search.query(opts={},&block)
      Query.new(opts,&block)
    end

    #
    # Returns the Query object that represents the specified _url_.
    # See Query.from_url.
    #
    #   Search.query_from_url('http://www.google.com/search?q=ruby+zen)
    #
    #   Search.query_from_url('http://www.google.com/search?q=ruby') do |q|
    #     q.within_last_month = true
    #     q.occurrs_within = :title
    #   end
    #
    def Search.query_from_url(url,&block)
      Query.from_url(url,&block)
    end
  end
end
