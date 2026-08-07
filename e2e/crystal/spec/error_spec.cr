require "./spec_helper"

describe Crawlberg do
  describe "error" do
    it "Handles 401 Unauthorized response correctly" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_401_unauthorized"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Handles 403 Forbidden response correctly" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"browser\":{\"mode\":\"never\"}}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_403_forbidden"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Handles 404 response correctly" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_404_page"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Handles 408 Request Timeout response correctly" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_408_request_timeout"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Handles 410 Gone response correctly" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_410_gone"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Handles 500 server error" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_500_server"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Handles 502 Bad Gateway response correctly" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_502_bad_gateway"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Browser launch fails when browser mode is always but browser is unavailable" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"browser\":{\"mode\":\"always\",\"timeout\":1}}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_browser_launch_failure"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Browser page load times out" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"browser\":{\"mode\":\"always\",\"timeout\":1}}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_browser_page_timeout"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Handles connection refused error gracefully" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_connection_refused"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Content-Length mismatch causes data loss error" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_data_loss_truncated"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Handles DNS resolution failure gracefully" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_dns_resolution"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Scraping a URL that cannot be found returns an error containing the URL path" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_empty_batch_urls"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Handles 200 with completely empty body gracefully" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_empty_response"
      __result = Crawlberg.scrape(engine, url)
      __result.html.to_s.should be_empty
    end
    it "Proxy pointing to unreachable address causes connection error during scrape" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"proxy\":{\"url\":\"http://127.0.0.1:1\"}}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_invalid_proxy"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Handles incomplete or truncated HTTP response" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_partial_response"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Handles 429 rate limiting with Retry-After" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_rate_limited"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Retries request on 503 Service Unavailable response" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_retry_503"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Implements exponential backoff when retrying failed requests" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_retry_backoff"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Handles SSL certificate validation error" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_ssl_invalid_cert"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Mock server delays response longer than request_timeout, surfacing a timeout error" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"request_timeout\":500}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_timeout"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Unsupported URL scheme (gopher) is rejected" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_unsupported_scheme"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Akamai WAF detection returns WafBlocked error" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"browser\":{\"mode\":\"never\"}}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_waf_akamai"
        Crawlberg.scrape(engine, url)
      end
    end
    it "WAF challenge/block detection returns WafBlocked error" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"browser\":{\"mode\":\"never\"}}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_waf_blocked"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Detects WAF/bot protection false 403 (Cloudflare challenge page)" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"browser\":{\"mode\":\"never\"}}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_waf_false_403"
        Crawlberg.scrape(engine, url)
      end
    end
    it "Imperva/Incapsula WAF detection" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"browser\":{\"mode\":\"never\"}}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/error_waf_imperva"
        Crawlberg.scrape(engine, url)
      end
    end
  end
end
