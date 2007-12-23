require 'test/unit'
require 'gscraper/search/query'

class QueryPages < Test::Unit::TestCase

  include GScraper

  def setup
    @query = Search::Query.new(:query => 'ruby')
  end

  def test_first_page
    page = @query.first_page

    assert_not_nil page
    assert_equal page.empty?, false, "Query of 'ruby' has zero results"
    assert_equal page.length, @query.results_per_page
  end

  def test_second_page
    page = @query.page(2)

    assert_not_nil page
    assert_equal page.empty?, false, "Query of 'ruby' has zero results"
    assert_equal page.length, @query.results_per_page
  end

  def teardown
    @query = nil
  end

end
