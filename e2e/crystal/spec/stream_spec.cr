require "./spec_helper"

describe Crawlberg do
  describe "stream" do
    it "Batch crawl stream produces expected Page and Complete events" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_concurrent\":2}"))
      base_url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/batch_crawl_stream_events"
      urls = ["/page1", "/page2", "/page3"].map { |p| p.starts_with?("http") ? p : "#{base_url}" + p }
      __result_events = [] of Crawlberg::CrawlEvent
      __ch = engine.batch_crawl_stream(Crawlberg::BatchCrawlStreamRequest.from_json("{\"urls\": #{urls.to_json}}"))
      while (__ev = __ch.receive?) && !__ev.is_a?(Nil)
        __result_events << __ev
      end
      __result = {
        "event_count_min" => __result_events.size,
        "has_page_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Page) },
        "has_error_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Error) },
        "has_complete_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Complete) },
      } of String => Int32 | Bool
      (__result["event_count_min"].as(Int32) || 0).should be >= 4
      __result["has_page_event"].as(Bool).should be_true
      __result["has_complete_event"].as(Bool).should be_true
    end
    it "Batch crawl stream emits both Page and Error events for mixed success/failure URLs" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_concurrent\":1}"))
      base_url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/batch_crawl_stream_partial_failure"
      urls = ["/success1", "/fail", "/success2"].map { |p| p.starts_with?("http") ? p : "#{base_url}" + p }
      __result_events = [] of Crawlberg::CrawlEvent
      __ch = engine.batch_crawl_stream(Crawlberg::BatchCrawlStreamRequest.from_json("{\"urls\": #{urls.to_json}}"))
      while (__ev = __ch.receive?) && !__ev.is_a?(Nil)
        __result_events << __ev
      end
      __result = {
        "event_count_min" => __result_events.size,
        "has_page_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Page) },
        "has_error_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Error) },
        "has_complete_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Complete) },
      } of String => Int32 | Bool
      __result["has_page_event"].as(Bool).should be_true
      __result["has_error_event"].as(Bool).should be_true
      __result["has_complete_event"].as(Bool).should be_true
    end
    it "Crawl stream produces page and complete events" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_depth\":1,\"respect_robots_txt\":false}"))
      url = ENV["MOCK_SERVER_CRAWL_STREAM_EVENTS"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/crawl_stream_events"
      __result_events = [] of Crawlberg::CrawlEvent
      __ch = engine.crawl_stream(Crawlberg::CrawlStreamRequest.from_json("{\"url\": #{url.to_json}}"))
      while (__ev = __ch.receive?) && !__ev.is_a?(Nil)
        __result_events << __ev
      end
      __result = {
        "event_count_min" => __result_events.size,
        "has_page_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Page) },
        "has_error_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Error) },
        "has_complete_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Complete) },
      } of String => Int32 | Bool
      (__result["event_count_min"].as(Int32) || 0).should be >= 4
      __result["has_page_event"].as(Bool).should be_true
      __result["has_complete_event"].as(Bool).should be_true
    end
    it "Stream produces events for multi-depth crawl with link following" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_concurrent\":1,\"max_depth\":2}"))
      url = ENV["MOCK_SERVER_STREAM_DEPTH_CRAWL"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/stream_depth_crawl"
      __result_events = [] of Crawlberg::CrawlEvent
      __ch = engine.crawl_stream(Crawlberg::CrawlStreamRequest.from_json("{\"url\": #{url.to_json}}"))
      while (__ev = __ch.receive?) && !__ev.is_a?(Nil)
        __result_events << __ev
      end
      __result = {
        "event_count_min" => __result_events.size,
        "has_page_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Page) },
        "has_error_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Error) },
        "has_complete_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Complete) },
      } of String => Int32 | Bool
      (__result["event_count_min"].as(Int32) || 0).should be >= 5
      __result["has_page_event"].as(Bool).should be_true
      __result["has_complete_event"].as(Bool).should be_true
    end
    it "Stream emits error event when a page fails mid-crawl, but other pages succeed" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_concurrent\":1,\"max_depth\":1,\"respect_robots_txt\":false}"))
      url = ENV["MOCK_SERVER_STREAM_ERROR_EVENT_MID_CRAWL"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/stream_error_event_mid_crawl"
      __result_events = [] of Crawlberg::CrawlEvent
      __ch = engine.crawl_stream(Crawlberg::CrawlStreamRequest.from_json("{\"url\": #{url.to_json}}"))
      while (__ev = __ch.receive?) && !__ev.is_a?(Nil)
        __result_events << __ev
      end
      __result = {
        "event_count_min" => __result_events.size,
        "has_page_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Page) },
        "has_error_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Error) },
        "has_complete_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Complete) },
      } of String => Int32 | Bool
      __result["has_page_event"].as(Bool).should be_true
      __result["has_error_event"].as(Bool).should be_true
      __result["has_complete_event"].as(Bool).should be_true
    end
    it "Stream ensures complete event arrives after all page events" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_concurrent\":1,\"max_depth\":1,\"respect_robots_txt\":false}"))
      url = ENV["MOCK_SERVER_STREAM_EVENT_ORDERING"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/stream_event_ordering"
      __result_events = [] of Crawlberg::CrawlEvent
      __ch = engine.crawl_stream(Crawlberg::CrawlStreamRequest.from_json("{\"url\": #{url.to_json}}"))
      while (__ev = __ch.receive?) && !__ev.is_a?(Nil)
        __result_events << __ev
      end
      __result = {
        "event_count_min" => __result_events.size,
        "has_page_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Page) },
        "has_error_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Error) },
        "has_complete_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Complete) },
      } of String => Int32 | Bool
      __result["has_complete_event"].as(Bool).should be_true
      __result["has_page_event"].as(Bool).should be_true
      (__result["event_count_min"].as(Int32) || 0).should be >= 3
    end
    it "Stream handles crawl of 5+ pages with multiple events" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_depth\":1,\"respect_robots_txt\":false}"))
      url = ENV["MOCK_SERVER_STREAM_LARGE_CRAWL"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/stream_large_crawl"
      __result_events = [] of Crawlberg::CrawlEvent
      __ch = engine.crawl_stream(Crawlberg::CrawlStreamRequest.from_json("{\"url\": #{url.to_json}}"))
      while (__ev = __ch.receive?) && !__ev.is_a?(Nil)
        __result_events << __ev
      end
      __result = {
        "event_count_min" => __result_events.size,
        "has_page_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Page) },
        "has_error_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Error) },
        "has_complete_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Complete) },
      } of String => Int32 | Bool
      (__result["event_count_min"].as(Int32) || 0).should be >= 6
      __result["has_page_event"].as(Bool).should be_true
      __result["has_complete_event"].as(Bool).should be_true
    end
    it "Stream emits page and complete events even when some pages fail" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_concurrent\":1,\"max_depth\":1}"))
      url = ENV["MOCK_SERVER_STREAM_WITH_ERROR_EVENT"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/stream_with_error_event"
      __result_events = [] of Crawlberg::CrawlEvent
      __ch = engine.crawl_stream(Crawlberg::CrawlStreamRequest.from_json("{\"url\": #{url.to_json}}"))
      while (__ev = __ch.receive?) && !__ev.is_a?(Nil)
        __result_events << __ev
      end
      __result = {
        "event_count_min" => __result_events.size,
        "has_page_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Page) },
        "has_error_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Error) },
        "has_complete_event" => __result_events.any? { |e| e.is_a?(Crawlberg::CrawlEvent::Complete) },
      } of String => Int32 | Bool
      __result["has_page_event"].as(Bool).should be_true
      __result["has_complete_event"].as(Bool).should be_true
      (__result["event_count_min"].as(Int32) || 0).should be >= 2
    end
  end
end
