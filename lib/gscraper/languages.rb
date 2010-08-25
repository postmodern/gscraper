#
# GScraper - A web-scraping interface to various Google Services.
#
# Copyright (c) 2007-2010 Hal Brodigan (postmodern.mod3 at gmail.com)
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

module GScraper
  module Languages
    # The list of language names
    NAMES = %w[
      af
      ar
      be
      bg
      ca
      cs
      da
      de
      el
      en
      eo
      es
      et
      fa
      fi
      fr
      hi
      hr
      hu
      hy
      id
      is
      it
      iw
      ja
      ko
      lt
      lv
      nl
      no
      pl
      pt
      ro
      ru
      sk
      sl
      sr
      sv
      sw
      th
      tl
      tr
      uk
      vi
      zh-CN
      zh-TW
    ]

    #
    # Looks up the language for the given locale.
    #
    # @param [String] locale
    #   A locale.
    #
    # @return [String]
    #   The language used by the locale.
    #
    # @since 0.3.1
    #
    def Languages.find(locale)
      if locale =~ /^zh_CN/
        'zh-CN'
      elsif locale =~ /^zh_TW/
        'zh-TW'
      else
        if (match = locale.match(/^([^_@]+)([_@].+)?$/))
          match[1] if (match[1] && NAMES.include?(match[1]))
        end
      end
    end

    #
    # Determines the native language.
    #
    # @return [String]
    #   The native language.
    #
    # @since 0.3.1
    #
    def Languages.native
      Languages.find(ENV['LANG'])
    end
  end
end
