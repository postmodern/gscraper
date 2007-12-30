require 'gscraper/search/result'
require 'gscraper/search/page'
require 'gscraper/sponsored_ad'
require 'gscraper/sponsored_links'
require 'gscraper/extensions/uri'
require 'gscraper/licenses'
require 'gscraper/gscraper'

require 'hpricot'

module GScraper
  module Search
    class Query

      SEARCH_HOST = 'www.google.com'
      SEARCH_URL = "http://#{SEARCH_HOST}/search"

      RESULTS_PER_PAGE = 10

      # Results per-page
      attr_accessor :results_per_page

      # Search query
      attr_accessor :query

      # Search for results containing the exact phrase
      attr_accessor :exact_phrase

      # Search for results with the words
      attr_accessor :with_words

      # Search for results with-out the words
      attr_accessor :without_words

      # Search for results written in the language
      attr_accessor :language

      # Search for results from the region
      attr_accessor :region

      # Search for results in the format
      attr_accessor :in_format

      # Search for results not in the format
      attr_accessor :not_in_format

      # Search for results within the past day
      attr_accessor :within_past_day

      # Search for results within the past week
      attr_accessor :within_past_week

      # Search for results within the past months
      attr_accessor :within_past_months

      # Search for results within the past year
      attr_accessor :within_past_year

      # Search for results containing numbers between the range
      attr_accessor :numeric_range

      # Search for results where the query ocurrs within the area
      attr_accessor :occurrs_within

      # Search for results inside the domain
      attr_accessor :inside_domain

      # Search for results outside the domain
      attr_accessor :outside_domain

      # Search for results which have the rights
      attr_accessor :rights

      # Filter the search results
      attr_accessor :filtered

      # Search for results similar to the page
      attr_accessor :similar_to

      # Search for results linking to the page
      attr_accessor :links_to

      #
      # Creates a new Query object from the given search options. If a
      # block is given, it will be passed the newly created query object.
      #
      #   Query.new(:query => 'ruby', :with_words => 'sow rspec')
      #
      #   Query.new(:exact_phrase => 'fluent interfaces') do |q|
      #     q.within_past_week = true
      #   end
      #
      def initialize(opts={},&block)
        super()

        @results_per_page = (opts[:results_per_page] || RESULTS_PER_PAGE)

        @query = opts[:query]
        @exact_phrase = opts[:exact_phrase]
        @with_words = opts[:with_words]
        @without_words = opts[:without_words]

        @language = opts[:language]
        @region = opts[:region]
        @in_format = opts[:in_format]
        @not_in_format = opts[:not_in_format]

        if opts[:within_past_day]
          @within_past_day = opts[:within_past_day]
          @within_past_week = false
          @within_past_months = false
          @within_past_year = false
        elsif opts[:within_past_week]
          @within_past_day = false
          @within_past_week = opts[:within_past_week]
          @within_past_months = false
          @within_past_year = false
        elsif opts[:within_past_months]
          @within_past_day = false
          @within_past_week = false
          @within_past_months = opts[:within_past_months]
          @within_past_year = false
        elsif opts[:within_past_year]
          @within_past_day = false
          @within_past_week = false
          @within_past_months = false
          @within_past_year = opts[:within_past_year]
        else
          @within_past_day = false
          @within_past_week = false
          @within_past_months = false
          @within_past_year = false
        end

        @numeric_range = opts[:numeric_range]
        @occurrs_within = opts[:occurrs_within]
        @inside_domain = opts[:inside_domain]
        @outside_domain = opts[:outside_domain]
        @rights = opts[:rights]
        @filtered = opts[:filtered]

        @similar_to = opts[:similar_to]
        @links_to = opts[:links_to]

        block.call(self) if block
      end

      #
      # Creates a new Query object from the specified URL. If a block is
      # given, it will be passed the newly created Query object.
      #
      #   Query.from_url('http://www.google.com/search?q=ruby+zen)
      #
      #   Query.from_url('http://www.google.com/search?q=ruby') do |q|
      #     q.within_last_month = true
      #     q.occurrs_within = :title
      #   end
      #
      def self.from_url(url,&block)
        url = URI.parse(url)
        opts = {}

        opts[:results_per_page] = url.query_params['num']

        opts[:query] = url.query_params['as_q']
        opts[:exact_phrase] = url.query_params['as_epq']
        opts[:with_words] = url.query_params['as_oq']
        opts[:without_words] = url.query_params['as_eq']

        opts[:language] = url.query_params['lr']
        opts[:region] = url.query_params['cr']

        case url.query_params['as_ft']
        when 'i'
          opts[:in_format] = url.query_params['as_filetype']
        when 'e'
          opts[:not_in_format] = url.query_params['as_filetype']
        end

        case url.query_params['as_qdr']
        when 'd'
          opts[:within_past_day] = true
        when 'w'
          opts[:within_past_week] = true
        when 'm'
          opts[:within_past_months] = 1
        when 'm2'
          opts[:within_past_months] = 2
        when 'm3'
          opts[:within_past_months] = 3
        when 'm6'
          opts[:within_past_months] = 6
        when 'y'
          opts[:within_past_year] = true
        end

        if (url.query_params['as_nlo'] || url.query_params['as_nhi'])
          opts[:numeric_range] = Range.new(url.query_params['as_nlo'].to_i,url.query_params['as_nhi'].to_i)
        end

        case url.query_params['as_occt']
        when 'title'
          opts[:occurrs_within] = :title
        when 'body'
          opts[:occurrs_within] = :body
        when 'url'
          opts[:occurrs_within] = :url
        when 'links'
          opts[:occurrs_within] = :links
        end

        case url.query_params['as_dt']
        when 'i'
          opts[:inside_domain] = url.query_params['as_sitesearch']
        when 'e'
          opts[:outside_domain] = url.query_params['as_sitesearch']
        end

        case url.query_params['as_rights']
        when '(cc_publicdomain|cc_attribute|cc_sharealike|cc_noncommercial|cc_nonderived)'
          opts[:rights] = Licenses::CC_BY_NC_ND
        when '(cc_publicdomain|cc_attribute|cc_sharealike|cc_nonderived).-(cc_noncommercial)'
          opts[:rights] = Licenses::CC_BY_SA
        when '(cc_publicdomain|cc_attribute|cc_sharealike|cc_noncommercial).-(cc_nonderived)'
          opts[:rights] = Licenses::CC_BY_NC
        when '(cc_publicdomain|cc_attribute|cc_sharealike).-(cc_noncommercial|cc_nonderived)'
          opts[:rights] = Licenses::CC_BY
        end

        if url.query_params[:safe]=='active'
          opts[:filtered] = true
        end

        if url.query_params['as_rq']
          opts[:similar_to] = url.query_params['as_rq']
        elsif url.query_params['as_lq']
          opts[:links_to] = url.query_params['as_lq']
        end

        return self.new(opts,&block)
      end

      #
      # Returns the URL that represents the query.
      #
      def search_url
        url = URI.parse(SEARCH_URL)

        if @results_per_page
          url.query_params['num'] = @results_per_page
        end

        url.query_params['as_q'] = @query if @query
        url.query_params['as_epq'] = @exact_phrase if @exact_phrase
        url.query_params['as_oq'] = @with_words if @with_words
        url.query_params['as_eq'] = @without_words if @without_words

        url.query_params['lr'] = @language if @language
        url.query_params['cr'] = @region if @region

        if @in_format
          url.query_params['as_ft'] = 'i'
          url.query_params['as_filtetype'] = @in_format
        elsif @not_in_format
          url.query_params['as_ft'] = 'e'
          url.query_params['as_filtetype'] = @not_in_format
        end

        if @within_past_day
          url.query_params['as_qdr'] = 'd'
        elsif @within_past_week
          url.query_params['as_qdr'] = 'w'
        elsif @within_past_months
          case @within_past_months
          when 1
            url.query_params['as_qdr'] = 'm'
          when 2
            url.query_params['as_qdr'] = 'm2'
          when 3
            url.query_params['as_qdr'] = 'm3'
          when 6
            url.query_params['as_qdr'] = 'm6'
          end
        elsif @within_past_year
          url.query_params['as_qdr'] = 'y'
        end

        if @numeric_range
          url.query_params['as_nlo'] = @numeric_range.begin
          url.query_params['as_nhi'] = @numeric_range.end
        end

        case @occurrs_within
        when :title, 'title'
          url.query_params['as_occt'] = 'title'
        when :body, 'body'
          url.query_params['as_occt'] = 'body'
        when :url, 'url'
          url.query_params['as_occt'] = 'url'
        when :links, 'links'
          url.query_params['as_occt'] = 'links'
        end

        if @inside_domain
          url.query_params['as_dt'] = 'i'
          url.query_params['as_sitesearch'] = @inside_domain
        elsif @outside_domain
          url.query_params['as_dt'] = 'e'
          url.query_params['as_sitesearch'] = @outside_domain
        end

        case @rights
        when Licenses::CC_BY_NC_ND
          url.query_params['as_rights'] = '(cc_publicdomain|cc_attribute|cc_sharealike|cc_noncommercial|cc_nonderived)'
        when Licenses::CC_BY_SA
          url.query_params['as_rights'] = '(cc_publicdomain|cc_attribute|cc_sharealike|cc_nonderived).-(cc_noncommercial)'
        when Licenses::CC_BY_ND
          url.query_params['as_rights'] = '(cc_publicdomain|cc_attribute|cc_sharealike|cc_noncommercial).-(cc_nonderived)'
        when Licenses::CC_BY
          url.query_params['as_rights'] = '(cc_publicdomain|cc_attribute|cc_sharealike).-(cc_noncommercial|cc_nonderived)'
        end

        url.query_params['safe'] = true if @filtered

        if @similar_to
          url.query_params['as_rq'] = @similar_to
        elsif @links_to
          url.query_params['as_lq'] = @links_to
        end

        return url
      end

      #
      # Returns the URL that represents the query at the specific
      # _page_index_.
      #
      def page_url(page_index)
        url = search_url

        url.query_params['start'] = page_result_offset(page_index)
        url.query_params['sa'] = 'N'

        return url
      end

      #
      # Returns a Page object containing Result objects at the specified
      # _page_index_. If _opts_ are given, they will be used in accessing
      # the SEARCH_URL. If a _block_ is given, it will be passed the newly
      # created Page.
      #
      def page(page_index,opts={},&block)
        doc = Hpricot(GScraper.open(page_url(page_index),opts))

        new_page = Page.new
        results = doc.search('//div.g')[0...@results_per_page.to_i]

        results.each_with_index do |result,index|
          rank = page_result_offset(page_index) + (index + 1)
          title = result.at('//h2.r').inner_text
          url = result.at('//h2.r/a').get_attribute('href')

          summary = result.at('//td.j//font').children[0...-3].inject('') do |accum,elem|
            accum + elem.inner_text
          end

          cached_url = nil
          similar_url = nil

          if (cached_link = result.at('//td.j//font/nobr/a:first'))
            cached_url = cached_link.get_attribute('href')
          end

          if (similar_link = result.at('//td.j//font/nobr/a:last'))
            similar_url = "http://#{SEARCH_HOST}" + similar_link.get_attribute('href')
          end

          new_page << Result.new(rank,title,url,summary,cached_url,similar_url)
        end

        block.call(new_page) if block
        return new_page
      end

      #
      # Returns a SponsoredLinks object containing Ad objects at the specified
      # _page_index_. If _opts_ are given, they will be used in accessing
      # the SEARCH_URL. If a _block_ is given, it will be passed the newly
      # created Page.
      #
      def sponsored_links(page_index,opts={},&block)
        doc = Hpricot(GScraper.open(page_url(page_index),opts))
        new_links = SponsoredLinks.new

        # top and side ads
        doc.search('//div.ta/a|//#mbEnd/tr[3]/td//a').each do |link|
          title = link.inner_text
          url = "http://#{SEARCH_HOST}" + link.get_attribute('href')

          new_links << SponsoredAd.new(title,url)
        end

        block.call(new_links) if block
        return new_links
      end

      #
      # Returns the Results on the first page. If _opts_ are given, they
      # will be used in accessing the SEARCH_URL. If a _block_ is given
      # it will be passed the newly created Page.
      #
      def first_page(opts={},&block)
        page(1,opts,&block)
      end

      #
      # Returns the Result at the specified _index_. If _opts_ are given,
      # they will be used in accessing the Page containing the requested
      # Result.
      #
      def result_at(index,opts={})
        page(result_page_index(index),opts)[page_result_index(index)]
      end

      #
      # Returns the first Result at the specified _index_. If _opts_ are
      # given, they will be used in accessing the Page containing the
      # requested Result.
      #
      def first_result(opts={})
        result_at(1,opts)
      end

      #
      # Iterates over the results at the specified _page_index_, passing
      # each to the given _block_. If _opts_ are given they will be used
      # in accessing the SEARCH_URL.
      #
      #   query.each_on_page(2) do |result|
      #     puts result.title
      #   end
      #
      def each_on_page(page_index,opts={},&block)
        page(page_index,opts).each(&block)
      end

      #
      # Iterates over the results on the first page, passing
      # each to the given _block_. If _opts_ are given, they will be used
      # in accessing the SEARCH_URL.
      #
      #   query.each_on_first_page do |result|
      #     puts result.url
      #   end
      #
      def each_on_first_page(opts={},&block)
        each_on_page(1,opts,&block)
      end

      protected

      #
      # Returns the rank offset for the specified _page_index_.
      #
      def page_result_offset(page_index)
        (page_index.to_i - 1) * @results_per_page.to_i
      end

      #
      # Returns the in-Page index of the _result_index_.
      #
      def page_result_index(result_index)
        (result_index.to_i - 1) % @results_per_page.to_i
      end

      #
      # Returns the page index for the specified _result_index_
      #
      def result_page_index(result_index)
        ((result_index.to_i - 1) / @results_per_page.to_i) + 1
      end

    end
  end
end
