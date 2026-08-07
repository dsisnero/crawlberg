require "./spec_helper"

describe Crawlberg do
  describe "filter" do
    it "BM25 filter works during multi-page crawl, keeping relevant pages" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_concurrent\":1,\"max_depth\":1}"))
      url = ENV["MOCK_SERVER_FILTER_BM25_CRAWL_INTEGRATION"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/filter_bm25_crawl_integration"
      __result = Crawlberg.crawl(engine, url)
      # skipped: field 'filter.remaining_contain_keyword' not available on result type
    end
    it "BM25 filter with empty query passes all pages through" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_depth\":1}"))
      url = ENV["MOCK_SERVER_FILTER_BM25_EMPTY_QUERY"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/filter_bm25_empty_query"
      __result = Crawlberg.crawl(engine, url)
      # skipped: field 'pages_crawled' not available on result type
    end
    it "BM25 filter with very high threshold filters out all pages" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_depth\":1}"))
      url = ENV["MOCK_SERVER_FILTER_BM25_HIGH_THRESHOLD"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/filter_bm25_high_threshold"
      __result = Crawlberg.scrape(engine, url)
      # skipped: field 'filter.pages_after_filter' not available on result type
    end
    it "BM25 filter keeps only pages relevant to the query" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_depth\":1}"))
      url = ENV["MOCK_SERVER_FILTER_BM25_RELEVANT_PAGES"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/filter_bm25_relevant_pages"
      __result = Crawlberg.scrape(engine, url)
      # skipped: field 'filter.remaining_contain_keyword' not available on result type
    end
    it "BM25 filter with zero threshold passes all pages" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_depth\":1}"))
      url = ENV["MOCK_SERVER_FILTER_BM25_THRESHOLD_ZERO"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/filter_bm25_threshold_zero"
      __result = Crawlberg.crawl(engine, url)
      # skipped: field 'pages_crawled' not available on result type
    end
    it "NoopFilter keeps all pages during a multi-page crawl" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_concurrent\":1,\"max_depth\":1}"))
      url = ENV["MOCK_SERVER_FILTER_NOOP_CRAWL_ALL_KEPT"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/filter_noop_crawl_all_kept"
      __result = Crawlberg.crawl(engine, url)
      # skipped: field 'filter.pages_after_filter' not available on result type
    end
    it "No content filter passes all crawled pages through" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_depth\":1}"))
      url = ENV["MOCK_SERVER_FILTER_NOOP_PASSES_ALL"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/filter_noop_passes_all"
      __result = Crawlberg.crawl(engine, url)
      # skipped: field 'pages_crawled' not available on result type
    end
  end
end
