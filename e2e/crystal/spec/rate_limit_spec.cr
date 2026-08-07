require "./spec_helper"

describe Crawlberg do
  describe "rate_limit" do
    it "Exponential backoff retry succeeds after 429 Too Many Requests" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"respect_robots_txt\":false,\"retry_codes\":[429],\"retry_count\":2}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/rate_limit_adaptive_backoff"
      __result = Crawlberg.scrape(engine, url)
      __result.status_code.should eq(200)
    end
    it "Rate limiter adds delay between requests to the same domain" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_depth\":1}"))
      url = ENV["MOCK_SERVER_RATE_LIMIT_BASIC_DELAY"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/rate_limit_basic_delay"
      __result = Crawlberg.crawl(engine, url)
      # skipped: field 'pages_crawled' not available on result type
      # skipped: field 'rate_limit.min_duration_ms' not available on result type
    end
    it "Per-domain rate limiting applies delay between requests to same domain" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_concurrent\":1,\"max_depth\":1}"))
      url = ENV["MOCK_SERVER_RATE_LIMIT_PER_DOMAIN"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/rate_limit_per_domain"
      __result = Crawlberg.crawl(engine, url)
      (__result.pages.size || 0).should be >= 2
      __result.pages[0].status_code.should eq(200)
    end
    it "Respects Crawl-delay directive in robots.txt" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_depth\":1,\"respect_robots_txt\":true,\"user_agent\":\"TestBot\"}"))
      url = ENV["MOCK_SERVER_RATE_LIMIT_ROBOTS_CRAWL_DELAY"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/rate_limit_robots_crawl_delay"
      __result = Crawlberg.crawl(engine, url)
      (__result.pages.size || 0).should be >= 1
      __result.pages[0].status_code.should eq(200)
    end
    it "Rate limiter with zero delay does not slow crawling" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_depth\":1}"))
      url = ENV["MOCK_SERVER_RATE_LIMIT_ZERO_NO_DELAY"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/rate_limit_zero_no_delay"
      __result = Crawlberg.crawl(engine, url)
      # skipped: field 'pages_crawled' not available on result type
    end
  end
end
