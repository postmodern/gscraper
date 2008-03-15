require 'test/unit'
require 'gscraper/search/query'

class QuerySponsoredLinks < Test::Unit::TestCase

  include GScraper

  def setup
    @query = Search::Query.new(:query => 'honda')
  end

  def test_sponsored_links
    assert_equal @query.sponsored_links.empty?, false, "The Query for 'honda' has no sponsored links"
  end

  def teardown
    @query = nil
  end

end
