#
# GScraper - A web-scraping interface to various Google Services.
#
# Copyright (c) 2007-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
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
#

require 'gscraper/hosts'
require 'gscraper/languages'
require 'gscraper/licenses'
require 'gscraper/gscraper'

module GScraper
  module Search
    class Query

      # Web Search sub-domain
      SUB_DOMAIN = 'www'

      # Default host to submit queries to
      DEFAULT_HOST = "#{SUB_DOMAIN}.#{Hosts::PRIMARY_DOMAIN}"

      # The host to submit queries to
      attr_writer :search_host

      # Search query
      attr_accessor :query

      # The search language
      attr_accessor :language

      # Search 'link' modifier
      attr_accessor :link

      # Search 'related' modifier
      attr_accessor :related

      # Search 'info' modifier
      attr_accessor :info

      # Search 'site' modifier
      attr_accessor :site

      # Search 'filetype' modifier
      attr_accessor :filetype

      # Search 'allintitle' modifier
      attr_accessor :allintitle

      # Search 'intitle' modifier
      attr_accessor :intitle

      # Search 'allinurl' modifier
      attr_accessor :allinurl

      # Search 'inurl' modifier
      attr_accessor :inurl

      # Search 'allintext' modifier
      attr_accessor :allintext

      # Search 'intext' modifier
      attr_accessor :intext

      # Search for results containing the exact phrase
      attr_accessor :exact_phrase

      # Search for results with the words
      attr_accessor :with_words

      # Search for results with-out the words
      attr_accessor :without_words

      # Search for results containing numbers between the range
      attr_accessor :numeric_range

      # Search for results containing the definitions of the keywords
      attr_accessor :define

      #
      # Creates a new query.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String] :search_host (www.google.com)
      #   The host to submit queries to.
      #
      # @option options [String] :query
      #   The search query.
      #
      # @option options [Symbol, String] :language (Languages.native)
      #   The search language.
      #
      # @option options [String] :link
      #   Search for results which link to the specified URI.
      #
      # @option options [String] :related
      #   Search for results which relate to the specified URI.
      #
      # @option options [String] :info
      #   Return information about the specified URI.
      #
      # @option options [String] :site
      #   Limit results to the specified site.
      #
      # @option options [String] :filetype
      #   Limit results to those with the specified file-type.
      #
      # @option options [Array, String] :allintitle
      #   Search for results with all of the keywords appearing in the
      #   title.
      #
      # @option options [String] :intitle
      #   Search for results with the keyword appearing in the title.
      #
      # @option options [Array, String] :allintext
      #   Search for results with all of the keywords appearing in the text.
      #
      # @option options [String] :intext
      #   Search for results with the keyword appearing in the text.
      #
      # @option options [Array, String] :allinanchor
      #   Search for results with all of the keywords appearing in the
      #   text of links.
      #
      # @option options [String] :inanchor
      #   Search for results with the keyword appearing in the text of
      #   links.
      #
      # @option options [String] :exact_phrase
      #   Search for results containing the specified exact phrase.
      #
      # @option options [Array, String] :with_words
      #   Search for results containing all of the specified words.
      #
      # @option options [Array, String] :without_words
      #   Search for results not containing any of the specified words.
      #
      # @option options [Range, Array, String] :numeric_range
      #   Search for results contain numbers that fall within the
      #   specified Range.
      #
      # @option options [String] :define
      #   Search for results containing the definition of the specified
      #   keyword.
      #
      # @option options [Boolean] :load_balance (false)
      #   Specifies whether to distribute queries accross multiple Google
      #   domains.
      #
      # @yield [query]
      #   If a block is given, it will be passed the new query.
      #
      # @yieldparam [Query] query
      #   The new query.
      #
      # @return [Query]
      #   The new query.
      #
      def initialize(options={})
        @search_host = options.fetch(:search_host,DEFAULT_HOST)

        @query    = options[:query]
        @language = options.fetch(:language,Languages.native)

        @link     = options[:link]
        @related  = options[:related]
        @info     = options[:info]
        @site     = options[:site]
        @filetype = options[:filetype]

        @allintitle  = options[:allintitle]
        @intitle     = options[:intitle]
        @allinurl    = options[:allinurl]
        @inurl       = options[:inurl]
        @allintext   = options[:allintext]
        @intext      = options[:intext]
        @allinanchor = options[:allinanchor]
        @inanchor    = options[:inanchor]

        @exact_phrase  = options[:exact_phrase]
        @with_words    = options[:with_words]
        @without_words = options[:without_words]

        @numeric_range = options[:numeric_range]
        @define        = options[:define]

        @load_balance = options.fetch(:load_balance,false)

        yield self if block_given?
      end

      #
      # The host to submit queries to.
      #
      # @return [String]
      #   The host to submit queries to.
      #
      # @since 0.3.1
      #
      def search_host
        if @load_balance
          Hosts::DOMAINS[rand(Hosts::DOMAINS.length)]
        else
          @search_host
        end
      end

      #
      # The query expression.
      #
      # @return [String]
      #   The expression representing the query.
      #
      def expression
        expr = []

        append_modifier = lambda { |name|
          modifier = format_modifier(instance_variable_get("@#{name}"))

          expr << "#{name}:#{modifier}" unless modifier.empty?
        }

        append_options = lambda { |name|
          ops = format_options(instance_variable_get("@#{name}"))

          expr << "#{name}:#{ops}" unless ops.empty?
        }

        expr << @query if @query

        append_modifier.call(:link)
        append_modifier.call(:related)
        append_modifier.call(:info)
        append_modifier.call(:site)
        append_modifier.call(:filetype)

        append_options.call(:allintitle)
        append_modifier.call(:intitle)
        append_options.call(:allinurl)
        append_modifier.call(:inurl)
        append_options.call(:allintext)
        append_modifier.call(:intext)
        append_options.call(:allinanchor)
        append_modifier.call(:inanchor)

        append_modifier.call(:define)

        if @exact_phrase
          expr << "\"#{@exact_phrase}\""
        end

        case @with_words
        when String
          expr << @with_words
        when Enumerable
          expr << @with_words.join(' OR ')
        end

        case @without_words
        when String
          expr << @without_words
        when Enumerable
          expr << @without_words.map { |word| "-#{word}" }.join(' ')
        end

        case @numeric_range
        when String
          expr << @numeric_range
        when Range, Array
          expr << "#{@numeric_range.first}..#{@numeric_range.last}"
        end

        return expr.join(' ')
      end

      protected

      #
      # Formats the value for a search modifier.
      #
      # @param [Regexp, String]
      #   The value for the search modifier.
      #
      # @return [String]
      #   The formatted value.
      #
      def format_modifier(value)
        if value.kind_of?(Regexp)
          return value.source
        else
          return value.to_s
        end
      end

      #
      # Formats the value(s) for a search option.
      #
      # @param [Array, Regexp, String]
      #   The value(s) for the search modifier.
      #
      # @return [String]
      #   The formatted value.
      #
      def format_options(value)
        if value.kind_of?(Array)
          return value.map { |element|
            format_modifier(element)
          }.join(' ')
        else
          return format_modifier(value)
        end
      end

    end
  end
end
