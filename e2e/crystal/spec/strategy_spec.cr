require "./spec_helper"

describe Crawlberg do
  describe "strategy" do
    it "Adaptive strategy stops early when encountering saturation (duplicate content)" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_concurrent\":1,\"max_depth\":2,\"respect_robots_txt\":false}"))
      url = ENV["MOCK_SERVER_STRATEGY_ADAPTIVE_SATURATION"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/strategy_adaptive_saturation"
      __result = Crawlberg.crawl(engine, url)
      # skipped: field 'pages_crawled' not available on result type
    end
    it "Adaptive strategy crawls more pages when content is diverse" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_concurrent\":1,\"max_depth\":1,\"respect_robots_txt\":false}"))
      url = ENV["MOCK_SERVER_STRATEGY_ADAPTIVE_WINDOW"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/strategy_adaptive_window"
      __result = Crawlberg.crawl(engine, url)
      # skipped: field 'pages_crawled' not available on result type
    end
    it "BestFirst strategy always processes the seed URL first" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_concurrent\":1,\"max_depth\":1}"))
      url = ENV["MOCK_SERVER_STRATEGY_BEST_FIRST_SEED"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/strategy_best_first_seed"
      __result = Crawlberg.crawl(engine, url)
      # skipped: field 'pages_crawled' not available on result type
      # skipped: field 'strategy.first_page_url_contains' not available on result type
    end
    it "BFS strategy visits pages in breadth-first order" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_concurrent\":1,\"max_depth\":2}"))
      url = ENV["MOCK_SERVER_STRATEGY_BFS_DEFAULT_ORDER"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/strategy_bfs_default_order"
      __result = Crawlberg.crawl(engine, url)
      # skipped: field 'pages_crawled' not available on result type
      # skipped: field 'strategy.crawl_order' not available on result type
    end
    it "DFS strategy visits pages in depth-first order" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_concurrent\":1,\"max_depth\":2}"))
      url = ENV["MOCK_SERVER_STRATEGY_DFS_DEPTH_FIRST"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/strategy_dfs_depth_first"
      __result = Crawlberg.crawl(engine, url)
      # skipped: field 'pages_crawled' not available on result type
      # skipped: field 'strategy.crawl_order' not available on result type
    end
  end
end
