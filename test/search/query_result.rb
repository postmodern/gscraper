require 'test/unit'
require 'gscraper/search/query'

class QueryResult < Test::Unit::TestCase

  include GScraper

  def setup
    @query = Search::Query.new(:query => 'ruby')
  end

  def test_first_result
    result = @query.top_result

    assert_not_nil result, "The Query for 'ruby' has no first-result"
    assert_equal result.rank, 1, "The first result for the Query 'ruby' does not have the rank of 1"
  end

  def test_second_result
    result = @query.result_at(2)

    assert_not_nil result, "The Query for 'ruby' has no second-result"
    assert_equal result.rank, 2, "The second result for the Query 'ruby' does not have the rank of 2"
  end

  def teardown
    @query = nil
  end

end
