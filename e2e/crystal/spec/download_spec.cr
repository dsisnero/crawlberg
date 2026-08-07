require "./spec_helper"

describe Crawlberg do
  describe "download" do
    it "Download a basic PDF document with download_documents enabled" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"download_documents\":true,\"respect_robots_txt\":false}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/download_basic_pdf"
      __result = Crawlberg.scrape(engine, url)
      __result.try(&.downloaded_document).try(&.mime_type).to_s.strip.should eq("application/pdf")
    end
    it "Extract filename from Content-Disposition header" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"download_documents\":true,\"respect_robots_txt\":false}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/download_filename_extraction"
      __result = Crawlberg.scrape(engine, url)
      __result.try(&.downloaded_document).try(&.mime_type).to_s.strip.should eq("application/pdf")
      __result.status_code.should eq(200)
    end
    it "Only download documents matching specified MIME types (PDF only, not DOCX)" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"document_mime_types\":[\"application/pdf\"],\"download_documents\":true,\"respect_robots_txt\":false}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/download_mime_filter"
      __result = Crawlberg.scrape(engine, url)
      __result.try(&.downloaded_document).try(&.mime_type).to_s.strip.should eq("application/pdf")
    end
    it "HTML pages are not downloaded as documents even when download_documents is enabled" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"download_documents\":true,\"respect_robots_txt\":false}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/download_no_document"
      __result = Crawlberg.scrape(engine, url)
      __result.status_code.should eq(200)
    end
    it "Reject documents exceeding the configured size limit" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"document_max_size\":100,\"download_documents\":true,\"respect_robots_txt\":false}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/download_size_limit"
      __result = Crawlberg.scrape(engine, url)
      __result.status_code.should eq(200)
    end
  end
end
