### 0.4.0 / 2012-04-26

* Switched from Bundler to rubygems-tasks ~> 0.1.
* Switched from json_pure to json ~> 1.6.
* Require uri-query_params ~> 0.5.
* Require mechanize ~> 2.0.
* Added {GScraper::Search::Blocked}.
* Added {GScraper::Hosts}.
* Added {GScraper::Languages}.
* Added {GScraper::Search::Query#define}.
* Added `:load_balance` option to {GScraper::Search::Query#initialize}, which
  will randomize {GScraper::Search::Query#search_host}.
* Allow `:all*` / `:with*` search options to accept a String or Array values.
* Allow {GScraper::Search::WebQuery} and {GScraper::Search::AJAXQuery} to
  submit queries to alternate domains via the `:search_host` option.
* Renamed `#occurrs_within`, `:occurrs_within` to `#occurs_within`,
  `:occurs_within`, respectively in {GScraper::Search::WebQuery}.
* Prefer XPath over CSS-path expressions.
* Fixed XPath expressions in {GScraper::Search::WebQuery#page}
  (thanks Jake Auswick and Ezekiel Templin).
* Fixed spelling errors.

### 0.3.0 / 2010-07-01

* Upgraded to mechanize ~> 1.0.0.
* Upgraded from json to json_pure ~> 1.4.0.
* Switched from Hoe to Jeweler for building RubyGems.
* Switched to Markdown documentation syntax with full YARD tags.
* Added support for `:allinanchor` and `:inanchor` options to
  {GScraper::Search::Query}.
* Added support for the `:define` option in {GScraper::Search::Query}.
* Aliased {GScraper::Search::WebQuery#similar_to} to `related`.
* Aliased {GScraper::Search::WebQuery#similar_to=} to `related=`.
* Aliased {GScraper::Search::WebQuery#links_to} to `link`.
* Aliased {GScraper::Search::WebQuery#links_to=} to `link=`.
* Removed `GScraper.open_uri`.
* Removed `GScraper.open_page`.
* Fixed the escaping/unescaping of URL query params in `URI::QueryParams`.
* Use `yield` instead of `block.call`, when possible.
* All enumerable methods now return an `Enumerator` object, if no block was
  given.

### 0.2.4 / 2009-03-18

* Added {GScraper::SponsoredAd#direct_link}.
* Fixed a bug in {GScraper::SponsoredAd#direct_url} where direct links
  were not being URI escaped.
* Removed last references to Hpricot, replacing them with Nokogiri.

### 0.2.3 / 2009-01-27

* Fixed a bug in {GScraper::Search::WebQuery#page}, when the search query
  returned less results than the expected results-per-page.

### 0.2.2 / 2009-01-14

* Updated {GScraper::Search::WebQuery} to use Nokogiri properly.

### 0.2.1 / 2008-08-27

* Updated XPath queries in {GScraper::Search::WebQuery} for new Google (tm)
  Search Result HTML schema.

### 0.2.0 / 2008-05-10

* Removed `GScraper::WebAgent`.
* Added {GScraper::Page} and {GScraper::HasPages}.
* {GScraper::Search::Result#page} and {GScraper::Search::Result#cached_page}
  no longer receives blocks.
* Added `GScraper::Search::Query` which supports building query expressions.
* {GScraper::SponsoredLinks#initialize} and {GScraper::Page#initialize}
  now take blocks.
* Renamed `GScraper::Search::Query` to {GScraper::Search::WebQuery}.
* {GScraper::Search::WebQuery#page} and
  {GScraper::Search::WebQuery#sponsored_links} no longer take blocks.
* Added {GScraper::Search::AJAXQuery}.
* Replaced Unit Tests with Rspec specifications.

### 0.1.8 / 2008-04-30

* Added the {GScraper.user_agent_alias=} method.
* Added `URI::HTTP::QueryParams` module.
* Changed license from MIT to GPL-2.

### 0.1.7 / 2008-04-28

* Added support for specifing Search modifiers.

        Search.query(:filetype => :xls)

* Added the {GScraper::Search::Result#page} method.

### 0.1.6 / 2008-03-15

* Renamed `GScraper.http_agent` to {GScraper.web_agent}.
* Added {GScraper.proxy} for global proxy configuration.
* Added the `WebAgent` module.
* Renamed `Search::Query#first_result` to `Search::Query#top_result`.
* Updated `Search::Query#page` logic for the new DOM layout being used.
* Added support for Sponsored Ad scraping.
  * Added the methods `Query#sponsored_links` and
    `Query#top_sponsored_link`.
* Added examples to README.txt.

### 0.1.5 / 2007-12-29

* Fixed class inheritance in `gscraper/extensions/uri/http.rb`, found by
  sanitybit.

### 0.1.4 / 2007-12-23

* Added `Search::Query#result_at` for easier access of a single result at
  a given index.
* Adding scraping of the Cached and Similar Pages URLs of Search
  Results.
* Added methods to `Search::Page` for accessing cached URLs, cached pages,
  similar query URLs and similar Queries in mass.
* Search::Query#page and `Search::Query#first_page` now can receive blocks.
* Improved the formating of URL query parameters.
* Added more unit-tests.
* Fixed scraping of Search Result summaries.
* Fixed various bugs in `Search::Query` uncovered during unit-testing.
* Fixed typos in the documentation for `Search::Page`.

### 0.1.3 / 2007-12-22

* Added the `Search::Page` class, which contains many of convenance methods
  for searching through the results within a Page.

### 0.1.2 / 2007-12-22

* Fixed a bug related to extracting the correct content-rights from search
  query URLs.
* Added {GScraper.user_agent_aliases}.

### 0.1.1 / 2007-12-21

* Forgot to include `lib/gscraper/version.rb`.

### 0.1.0 / 2007-12-20

* Initial release.
* Supports the Google Search service.

