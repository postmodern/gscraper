require 'test/unit'
require 'gscraper/search/page'
require 'gscraper/search/query'

class PageResults < Test::Unit::TestCase

  include GScraper

  def setup
    @query = Search::Query.new(:query => 'ruby')
    @page = @query.first_page
  end

  def test_results_per_page
    assert_equal @page.length, @query.results_per_page
  end

  def test_first_result
    assert_not_nil @page[0], "First Page for Query 'ruby' does not have a first Result"
  end

  def test_last_result
    assert_not_nil @page[-1], "First Page for Query 'ruby' does not have a last Result"
  end

  def test_ranks
    ranks = @page.ranks

    assert_not_nil ranks, "First Page for Query 'ruby' does not have any ranks"

    assert_equal ranks.class, Array, "The ranks of a Page must be an Array"

    assert_equal ranks.empty?, false, "The ranks of the First Page are empty"

    assert_equal ranks.length, @page.length
  end

  def test_titles
    titles = @page.titles

    assert_not_nil titles, "First Page for Query 'ruby' does not have any titles"

    assert_equal titles.class, Array, "The titles of a Page must be an Array"

    assert_equal titles.empty?, false, "The titles of the First Page are empty"

    assert_equal titles.length, @page.length
  end

  def test_urls
    urls = @page.urls

    assert_not_nil urls, "First Page for Query 'ruby' does not have any urls"

    assert_equal urls.class, Array, "The urls of a Page must be an Array"

    assert_equal urls.empty?, false, "The urls of the First Page are empty"

    assert_equal urls.length, @page.length
  end

  def test_summaries
    summaries = @page.summaries

    assert_not_nil summaries, "First Page for Query 'ruby' does not have any summaries"

    assert_equal summaries.class, Array, "The summaries of a Page must be an Array"

    assert_equal summaries.empty?, false, "The summaries of the First Page are empty"

    assert_equal summaries.length, @page.length
  end

  def test_cached_urls
    cached_urls = @page.cached_urls

    assert_not_nil cached_urls, "First Page for Query 'ruby' does not have any cached_urls"

    assert_equal cached_urls.class, Array, "The cached_urls of a Page must be an Array"

    assert_equal cached_urls.empty?, false, "The cached_urls of the First Page are empty"

    assert_equal cached_urls.length, @page.length
  end

  def test_similar_urls
    similar_urls = @page.similar_urls

    assert_not_nil similar_urls, "First Page for Query 'ruby' does not have any similar URLs"

    assert_equal similar_urls.class, Array, "The similar URLs of a Page must be an Array"

    assert_equal similar_urls.empty?, false, "The similar URLs of the First Page are empty"

    assert_equal similar_urls.length, @page.length
  end

  def teardown
    @page = nil
    @query = nil
  end

end
