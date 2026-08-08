require "./spec_helper"

describe Crawlberg do
  describe "engine" do
    it "CrawlEngine with defaults batch scrapes like the free function" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/engine_batch_basic"
      __result = Crawlberg.scrape(engine, url)
      # skipped: field 'completed_count' not available on result type
      # skipped: field 'total_count' not available on result type
    end
    it "CrawlEngine with defaults crawls multiple pages like the free function" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_depth\":1}"))
      url = ENV["MOCK_SERVER_ENGINE_CRAWL_BASIC"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/engine_crawl_basic"
      __result = Crawlberg.crawl(engine, url)
      # skipped: field 'pages_crawled' not available on result type
      # skipped: field 'min_pages' not available on result type
    end
    it "CrawlEngine with defaults discovers URLs like the free function" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
      url = ENV["MOCK_SERVER_ENGINE_MAP_BASIC"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/engine_map_basic"
      __result = Crawlberg.map_urls(engine, url)
      # skipped: field 'min_urls' not available on result type
    end
    it "CrawlEngine with defaults scrapes a page identically to the free function" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
      url = ENV["MOCK_SERVER_ENGINE_SCRAPE_BASIC"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/engine_scrape_basic"
      __result = Crawlberg.scrape(engine, url)
      __result.status_code.should eq(200)
      __result.content_type.to_s.strip.should eq("text/html")
      __result.try(&.metadata).try(&.title).to_s.strip.should eq("Engine Test")
      __result.try(&.metadata).try(&.description).to_s.should contain("Testing the engine")
      (__result.links.size || 0).should be >= 1
      (__result.try(&.metadata).try(&.headings).try(&.size) || 0).should be >= 1
    end
    it "CrawlEngine with defaults streams events like the free function" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_depth\":1}"))
      url = ENV["MOCK_SERVER_ENGINE_STREAM_BASIC"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/engine_stream_basic"
      __result_chunks = [] of Crawlberg::CrawlEvent
      __ch = engine.crawl_stream(Crawlberg::CrawlStreamRequest.from_json("{\"url\": #{url.to_json}}"))
      while (__ev = __ch.receive?) && !__ev.is_a?(Nil)
        __result_chunks << __ev
      end
      __result = {
        "chunks" => __result_chunks,
        "event_count_min" => __result_chunks.size,
        "has_page_event" => __result_chunks.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Page) },
        "has_error_event" => __result_chunks.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Error) },
        "has_complete_event" => __result_chunks.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Complete) }
      } of String => Array(Crawlberg::CrawlEvent) | String | Int32 | Bool
      __result["has_page_event"].as(Bool).should be_true
      __result["has_complete_event"].as(Bool).should be_true
      (__result["event_count_min"].as(Int32) || 0).should be >= 3
    end
  end
end
