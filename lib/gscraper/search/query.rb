#
#--
# GScraper - A web-scraping interface to various Google Services.
#
# Copyright (c) 2007-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
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
require 'gscraper/sponsored_ad'
require 'gscraper/sponsored_links'
require 'gscraper/extensions/uri'
require 'gscraper/has_pages'
require 'gscraper/licenses'
require 'gscraper/gscraper'

module GScraper
  module Search
    class Query

      # Search query
      attr_accessor :query

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

      #
      # Creates a new Query object from the given search _options_. If a
      # block is given, it will be passed the newly created Query object.
      #
      # _options_ may contain the following keys:
      # <tt>:query</tt>:: The search query.
      # <tt>:link</tt>:: Search for results which link to the specified
      #                  URI.
      # <tt>:related</tt>:: Search for results which relate to the
      #                     specified URI.
      # <tt>:info</tt>:: Return information about the specified URI.
      # <tt>:site</tt>:: Limit results to the specified site.
      # <tt>:filetype</tt>:: Limit results to those with the specified
      #                      file-type.
      # <tt>:allintitle</tt>:: Search for results with all of the keywords
      #                        appearing in the title.
      # <tt>:intitle</tt>:: Search for results with the keyword appearing
      #                     in the title.
      # <tt>:allintext</tt>:: Search for results with all of the keywords
      #                       appearing in the text.
      # <tt>:intext</tt>:: Search for results with the keyword appearing
      #                    in the text.
      # <tt>:allinanchor</tt>:: Search for results with all of the keywords
      #                         appearing in the text of links.
      # <tt>:inanchor</tt>:: Search for results with the keyword appearing
      #                      in the text of links.
      # <tt>:exact_phrase</tt>:: Search for results containing the specified
      #                          exact phrase.
      # <tt>:with_words</tt>:: Search for results containing all of the
      #                        specified words.
      # <tt>:without_words</tt>:: Search for results not containing any of
      #                           the specified words.
      # <tt>:numeric_range</tt>:: Search for results contain numbers that
      #                           fall within the specified Range.
      # <tt>:define</tt>:: Search for results containing the definition of
      #                    the specified keyword.
      #
      def initialize(options={})
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
        @allinanchor = options[:allinanchor]
        @inanchor = options[:inanchor]

        @exact_phrase = options[:exact_phrase]
        @with_words = options[:with_words]
        @without_words = options[:without_words]

        @numeric_range = options[:numeric_range]
        @define = options[:define]

        yield self if block_given?
      end

      #
      # Returns the query expression.
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

        if @with_words.kind_of?(Array)
          expr << @with_words.join(' OR ')
        end
        
        if @without_words.kind_of?(Array)
          expr << @without_words.map { |word| "-#{word}" }.join(' ')
        end

        if @numeric_range.kind_of?(Range)
          expr << "#{@numeric_range.begin}..#{@numeric_range.end}"
        end

        return expr.join(' ')
      end

      protected

      def format_modifier(value)
        if value.kind_of?(Regexp)
          return value.source
        else
          return value.to_s
        end
      end

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
