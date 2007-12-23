require 'test/unit'
require 'gscraper/search/query'

class QueryFromURL < Test::Unit::TestCase

  include GScraper

  QUERY_URL = 'http://www.google.com/search?as_q=test&hl=en&num=20&btnG=Google+Search&as_epq=what+if&as_oq=dog&as_eq=haha&lr=&cr=&as_ft=i&as_filetype=&as_qdr=w&as_nlo=&as_nhi=&as_occt=body&as_dt=i&as_sitesearch=&as_rights=&safe=images'

  def setup
    @query = Search::Query.from_url(QUERY_URL)
  end

  def test_query
    assert_equal @query.query, 'test'
  end

  def test_exact_phrase
    assert_equal @query.exact_phrase, 'what+if'
  end

  def test_with_words
    assert_equal @query.with_words, 'dog'
  end

  def test_without_words
    assert_equal @query.without_words, 'haha'
  end

  def test_within_past_week
    assert_equal @query.within_past_week, true
  end

  def test_occurrs_within
    assert_equal @query.occurrs_within, :body
  end

  def test_similar_to
    assert_nil @query.similar_to
  end

  def test_links_to
    assert_nil @query.links_to
  end

  def teardown
    @query = nil
  end

end
