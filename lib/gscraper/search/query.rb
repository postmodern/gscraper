require 'gscraper/search/result'
require 'gscraper/search/page'
require 'gscraper/sponsored_ad'
require 'gscraper/sponsored_links'
require 'gscraper/extensions/uri'
require 'gscraper/licenses'
require 'gscraper/web_agent'

require 'hpricot'

module GScraper
  module Search
    class Query

      include WebAgent

      # Search host
      SEARCH_HOST = 'www.google.com'

      # Search URL
      SEARCH_URL = "http://#{SEARCH_HOST}/search"

      # Default results per-page
      RESULTS_PER_PAGE = 10

      # Results per-page
      attr_accessor :results_per_page

      # Search query
      attr_accessor :query

      # Search modifiers
      attr_reader :modifiers

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
      def initialize(options={},&block)
        @results_per_page = (options[:results_per_page] || RESULTS_PER_PAGE)

        @query = options[:query]

        @link = options[:link]
        @related = options[:related]
        @info = options[:info]
        @site = options[:site]
        @filetype = options[:filetype]

        @allintitle = options[:allintitle]
        @intitle = options[:intitle]
        @allinurl = options[:allinurl]
        @inurl = options[:inurl]
        @allintext = options[:allintext]
        @intext = options[:intext]

        @exact_phrase = options[:exact_phrase]
        @with_words = options[:with_words]
        @without_words = options[:without_words]

        @language = options[:language]
        @region = options[:region]
        @in_format = options[:in_format]
        @not_in_format = options[:not_in_format]

        if options[:within_past_day]
          @within_past_day = options[:within_past_day]
          @within_past_week = false
          @within_past_months = false
          @within_past_year = false
        elsif options[:within_past_week]
          @within_past_day = false
          @within_past_week = options[:within_past_week]
          @within_past_months = false
          @within_past_year = false
        elsif options[:within_past_months]
          @within_past_day = false
          @within_past_week = false
          @within_past_months = options[:within_past_months]
          @within_past_year = false
        elsif options[:within_past_year]
          @within_past_day = false
          @within_past_week = false
          @within_past_months = false
          @within_past_year = options[:within_past_year]
        else
          @within_past_day = false
          @within_past_week = false
          @within_past_months = false
          @within_past_year = false
        end

        @numeric_range = options[:numeric_range]
        @occurrs_within = options[:occurrs_within]
        @inside_domain = options[:inside_domain]
        @outside_domain = options[:outside_domain]
        @rights = options[:rights]
        @filtered = options[:filtered]

        @similar_to = options[:similar_to]
        @links_to = options[:links_to]

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
      def self.from_url(url,options={},&block)
        url = URI.parse(url)

        options[:results_per_page] = url.query_params['num']

        options[:query] = url.query_params['as_q']
        options[:exact_phrase] = url.query_params['as_epq']
        options[:with_words] = url.query_params['as_oq']
        options[:without_words] = url.query_params['as_eq']

        options[:language] = url.query_params['lr']
        options[:region] = url.query_params['cr']

        case url.query_params['as_ft']
        when 'i'
          options[:in_format] = url.query_params['as_filetype']
        when 'e'
          options[:not_in_format] = url.query_params['as_filetype']
        end

        case url.query_params['as_qdr']
        when 'd'
          options[:within_past_day] = true
        when 'w'
          options[:within_past_week] = true
        when 'm'
          options[:within_past_months] = 1
        when 'm2'
          options[:within_past_months] = 2
        when 'm3'
          options[:within_past_months] = 3
        when 'm6'
          options[:within_past_months] = 6
        when 'y'
          options[:within_past_year] = true
        end

        if (url.query_params['as_nlo'] || url.query_params['as_nhi'])
          options[:numeric_range] = Range.new(url.query_params['as_nlo'].to_i,url.query_params['as_nhi'].to_i)
        end

        case url.query_params['as_occt']
        when 'title'
          options[:occurrs_within] = :title
        when 'body'
          options[:occurrs_within] = :body
        when 'url'
          options[:occurrs_within] = :url
        when 'links'
          options[:occurrs_within] = :links
        end

        case url.query_params['as_dt']
        when 'i'
          options[:inside_domain] = url.query_params['as_sitesearch']
        when 'e'
          options[:outside_domain] = url.query_params['as_sitesearch']
        end

        case url.query_params['as_rights']
        when '(cc_publicdomain|cc_attribute|cc_sharealike|cc_noncommercial|cc_nonderived)'
          options[:rights] = Licenses::CC_BY_NC_ND
        when '(cc_publicdomain|cc_attribute|cc_sharealike|cc_nonderived).-(cc_noncommercial)'
          options[:rights] = Licenses::CC_BY_SA
        when '(cc_publicdomain|cc_attribute|cc_sharealike|cc_noncommercial).-(cc_nonderived)'
          options[:rights] = Licenses::CC_BY_NC
        when '(cc_publicdomain|cc_attribute|cc_sharealike).-(cc_noncommercial|cc_nonderived)'
          options[:rights] = Licenses::CC_BY
        end

        if url.query_params[:safe]=='active'
          options[:filtered] = true
        end

        if url.query_params['as_rq']
          options[:similar_to] = url.query_params['as_rq']
        elsif url.query_params['as_lq']
          options[:links_to] = url.query_params['as_lq']
        end

        return self.new(options,&block)
      end

      #
      # Returns the URL that represents the query.
      #
      def search_url
        url = URI(SEARCH_URL)
        query_expr = []

        set_param = lambda { |param,value|
          url.query_params[param.to_s] = value if value
        }

        append_modifier = lambda { |name|
          modifier = instance_variable_get("@#{name}")

          query_expr << "#{name}:#{modifier}" if modifier
        }

        join_ops = lambda { |name|
          ops = instance_variable_get("@#{name}")

          if ops.kind_of?(Array)
            query_expr << "#{name}:#{ops.join(' ')}"
          elsif ops
            query_expr << "#{name}:#{ops}"
          end
        }

        set_param.call('num',@results_per_page)

        query_expr << @query if @query

        append_modifier.call(:link)
        append_modifier.call(:related)
        append_modifier.call(:info)
        append_modifier.call(:site)
        append_modifier.call(:filetype)

        join_ops.call(:allintitle)
        append_modifier.call(:intitle)
        join_ops.call(:allinurl)
        append_modifier.call(:inurl)
        join_ops.call(:allintext)
        append_modifier.call(:intext)

        unless query_expr.empty?
          url.query_params['as_q'] = query_expr.join(' ')
        end

        set_param.call('as_epq',@exact_phrase)
        set_param.call('as_oq',@with_words)
        set_param.call('as_eq',@without_words)

        set_param.call('lr',@language)
        set_param.call('cr',@region)

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
      # _page_index_. If a _block_ is given, it will be passed the newly
      # created Page.
      #
      def page(page_index,&block)
        doc = get_page(page_url(page_index))

        new_page = Page.new
        results = doc.search('//div.g')[0...@results_per_page.to_i]

        results.each_with_index do |result,index|
          rank = page_result_offset(page_index) + (index + 1)
          link = result.at('//a.l')
          title = link.inner_text
          url = link.get_attribute('href')
          summary_text = ''
          cached_url = nil
          similar_url = nil

          if (content = (result.at('//td.j//font|//td.j/div.sml')))
            content.children.each do |elem|
              break if (!(elem.text?) && elem.name=='br')

              summary_text << elem.inner_text
            end
            
            if (cached_link = result.at('nobr/a:first'))
              cached_url = cached_link.get_attribute('href')
            end

            if (similar_link = result.at('nobr/a:last'))
              similar_url = "http://#{SEARCH_HOST}" + similar_link.get_attribute('href')
            end
          end

          new_page << Result.new(rank,title,url,summary_text,cached_url,similar_url)
        end

        block.call(new_page) if block
        return new_page
      end

      #
      # Returns the Results on the first page. If a _block_ is given it
      # will be passed the newly created Page.
      #
      def first_page(&block)
        page(1,&block)
      end

      #
      # Returns the Result at the specified _index_.
      #
      def result_at(index)
        page(result_page_index(index))[page_result_index(index)]
      end

      #
      # Returns the first Result on the first_page.
      #
      def top_result
        result_at(1)
      end

      #
      # Iterates over the results at the specified _page_index_, passing
      # each to the given _block_.
      #
      #   query.each_on_page(2) do |result|
      #     puts result.title
      #   end
      #
      def each_on_page(page_index,&block)
        page(page_index).each(&block)
      end

      #
      # Iterates over the results on the first page, passing each to the
      # given _block_.
      #
      #   query.each_on_first_page do |result|
      #     puts result.url
      #   end
      #
      def each_on_first_page(&block)
        each_on_page(1,&block)
      end

      #
      # Returns a SponsoredLinks object containing SponsoredAd objects of
      # the query. If a _block_ is given, it will be passed the newly
      # created Page.
      #
      def sponsored_links(&block)
        doc = get_page(search_url)
        new_links = SponsoredLinks.new

        # top and side ads
        doc.search('//a[@id="pa1"]|//a[@id*="an"]').each do |link|
          title = link.inner_text
          url = "http://#{SEARCH_HOST}" + link.get_attribute('href')

          new_links << SponsoredAd.new(title,url)
        end

        block.call(new_links) if block
        return new_links
      end

      #
      # Returns the first sponsored link on the first page of results.
      #
      def top_sponsored_link
        top_sponsored_links.first
      end

      #
      # Iterates over the sponsored links on the first page of
      # results passing each to the specified _block_.
      #
      def each_sponsored_link(&block)
        sponsored_links.each(&block)
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
