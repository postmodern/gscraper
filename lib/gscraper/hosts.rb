#
# GScraper - A web-scraping interface to various Google Services.
#
# Copyright (c) 2007-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
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
  #
  # @api semipublic
  #
  # @since 0.4.0
  #
  module Hosts
    # List of all google domain-names.
    DOMAINS = %w[
      google.com
      google.de
      google.at
      google.pl
      google.fr
      google.nl
      google.it
      google.com.tr
      google.es
      google.ch
      google.be
      google.gr
      google.com.br
      google.lu
      google.fi
      google.pt
      google.hu
      google.hr
      google.bg
      google.com.mx
      google.si
      google.sk
      google.ro
      google.ca
      google.co.uk
      google.cl
      google.com.ar
      google.se
      google.cz
      google.dk
      google.co.th
      google.com.co
      google.lt
      google.co.id
      google.co.in
      google.co.il
      google.com.eg
      google.cn
      google.co.ve
      google.ru
      google.co.jp
      google.com.pe
      google.com.au
      google.co.ma
      google.co.za
      google.com.ph
      google.com.sa
      google.ie
      google.co.kr
      google.no
      google.com.ec
      google.com.vn
      google.lv
      google.com.mt
      google.com.uy
      google.ae
      google.ba
      google.co.nz
      google.com.ua
      google.co.cr
      google.ee
      google.com.do
      google.com.tw
      google.com.hk
      google.com.my
      google.com.sv
      google.com.pr
      google.lk
      google.com.gt
      google.com.bd
      google.com.pk
      google.is
      google.li
      google.com.bh
      google.com.ni
      google.com.py
      google.com.ng
      google.com.bo
      google.co.ke
      google.hn
      google.com.sg
      google.mu
      google.ci
      google.jo
      google.nu
      google.com.jm
      google.com.ly
      google.co.yu
      google.tt
      google.com.kh
      google.ge
      google.com.na
      google.com.et
      google.sm
      google.cd
      google.gm
      google.com.qa
      google.dj
      google.com.cu
      google.com.pa
      google.gp
      google.az
      google.as
      google.pl
      google.mn
      google.ht
      google.md
      google.am
      google.sn
      google.je
      google.com.bn
      google.com.ai
      google.co.zm
      google.ma
      google.rw
      google.co.ug
      google.com.vc
      google.at
      google.com.gi
      google.to
      google.com.om
      google.kz
      google.co.uz
    ]

    # The primary domain
    PRIMARY_DOMAIN = DOMAINS.first
  end
end
