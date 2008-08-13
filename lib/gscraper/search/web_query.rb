#
#--
# GScraper - A web-scraping interface to various Google Services.
#
# Copyright (c) 2007-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#++
#

require 'gscraper/search/result'
require 'gscraper/search/page'
require 'gscraper/search/query'
require 'gscraper/sponsored_ad'
require 'gscraper/sponsored_links'
require 'gscraper/extensions/uri'
require 'gscraper/has_pages'
require 'gscraper/licenses'
require 'gscraper/gscraper'

require 'hpricot'

module GScraper
  module Search
    class WebQuery < Query

      include HasPages

      # Search host
      SEARCH_HOST = 'www.google.com'

      # Search URL
      SEARCH_URL = "http://#{SEARCH_HOST}/search"

      # Default results per-page
      RESULTS_PER_PAGE = 10

      # Results per-page
      attr_accessor :results_per_page

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
      # Creates a new WebQuery object from the given search options. If a
      # block is given, it will be passed the newly created query object.
      #
      #   WebQuery.new(:query => 'ruby', :with_words => 'sow rspec')
      #
      #   WebQuery.new(:exact_phrase => 'fluent interfaces') do |q|
      #     q.within_past_week = true
      #   end
      #
      def initialize(options={},&block)
        @agent = GScraper.web_agent(options)

        @results_per_page = (options[:results_per_page] || RESULTS_PER_PAGE)

        @language = options[:language]
        @region = options[:region]

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

        @occurrs_within = options[:occurrs_within]
        @rights = options[:rights]
        @filtered = options[:filtered]

        @similar_to = options[:similar_to]
        @links_to = options[:links_to]

        super(options,&block)
      end

      #
      # Creates a new WebQuery object from the specified URL. If a block is
      # given, it will be passed the newly created WebQuery object.
      #
      #   WebQuery.from_url('http://www.google.com/search?q=ruby+zen')
      #
      #   WebQuery.from_url('http://www.google.com/search?q=ruby') do |q|
      #     q.within_last_month = true
      #     q.occurrs_within = :title
      #   end
      #
      def self.from_url(url,options={},&block)
        url = URI(url.to_s)

        options[:results_per_page] = url.query_params['num'].to_i

        options[:query] = url.query_params['q']
        options[:exact_phrase] = url.query_params['as_epq']
        options[:with_words] = url.query_params['as_oq']
        options[:without_words] = url.query_params['as_eq']

        options[:language] = url.query_params['lr']
        options[:region] = url.query_params['cr']

        if url.query_params['as_filetype']
          options[:filetype] = url.query_params['as_filetype']
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
          options[:numeric_range] = Range.new(url.query_params['as_nlo'].to_i,
                                              url.query_params['as_nhi'].to_i)
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

        options[:site] = url.query_params['as_sitesearch']

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

        if url.query_params[:safe] == 'active'
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

        set_param.call('num',@results_per_page)
        set_param.call('q',expression)
        set_param.call('as_epq',@exact_phrase)
        set_param.call('as_oq',@with_words)
        set_param.call('as_eq',@without_words)

        set_param.call('lr',@language)
        set_param.call('cr',@region)

        set_param.call('as_filetype',@filetype)

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

        if @numeric_range.kind_of?(Range)
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

        set_param.call('as_sitesearch',@site)

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

        url.query_params['safe'] = 'active' if @filtered

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

        url.query_params['start'] = result_offset_of(page_index)
        url.query_params['sa'] = 'N'

        return url
      end

      #
      # Returns a Page object containing Result objects at the specified
      # _page_index_.
      #
      def page(page_index)
        Page.new do |new_page|
          doc = @agent.get(page_url(page_index))
          results = doc.search('//div.g')[0...@results_per_page.to_i]

          rank_offset = result_offset_of(page_index)

          results.each_with_index do |result,index|
            rank = rank_offset + (index + 1)
            link = result.at('//a.l')
            title = link.inner_text
            url = URI(link.get_attribute('href'))
            summary_text = ''
            cached_url = nil
            similar_url = nil

            if (content = (result.at('//td.j//font|//td.j/div')))
              content.children.each do |elem|
                break if (!(elem.text?) && elem.name=='br')

                summary_text << elem.inner_text
              end

              if (cached_link = result.at('nobr/a:first'))
                cached_url = URI(cached_link.get_attribute('href'))
              end

              if (similar_link = result.at('nobr/a:last'))
                similar_url = URI("http://#{SEARCH_HOST}" + similar_link.get_attribute('href'))
              end
            end

            new_page << Result.new(rank,title,url,summary_text,cached_url,similar_url)
          end
        end
      end

      #
      # Returns the first Result on the first_page.
      #
      def top_result
        first_page.first
      end

      #
      # Returns the Result at the specified _index_.
      #
      def result_at(index)
        page(page_index_of(index))[result_index_of(index)]
      end

      #
      # Returns a SponsoredLinks object containing SponsoredAd objects of
      # the query.
      #
      def sponsored_links
        SponsoredLinks.new do |links|
          doc = @agent.get(search_url)

          # top and side ads
          doc.search('//a[@id="pa1"]|//a[@id*="an"]').each do |link|
            title = link.inner_text
            url = URI("http://#{SEARCH_HOST}" + link.get_attribute('href'))

            links << SponsoredAd.new(title,url)
          end
        end
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

    end
  end
end
