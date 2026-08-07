require "./spec_helper"

describe Crawlberg do
  describe "markdown" do
    it "Citations correctly handle links inside parentheses with balanced rendering" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/citations_balanced_parens"
      __result = Crawlberg.scrape(engine, url)
      __result.status_code.should eq(200)
      __result.try(&.markdown).try(&.content).to_s.should_not be_empty
      __result.try(&.markdown).try(&.content).to_s.should contain("(")
    end
    it "Citations deduplicates multiple links to the same URL" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/citations_duplicate_urls"
      __result = Crawlberg.scrape(engine, url)
      __result.status_code.should eq(200)
      __result.try(&.markdown).try(&.content).to_s.should_not be_empty
      __result.try(&.markdown).try(&.citations).should be_true
    end
    it "HTML is always converted to markdown alongside raw HTML" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/markdown_basic_conversion"
      __result = Crawlberg.scrape(engine, url)
      __result.status_code.should eq(200)
      __result.try(&.metadata).try(&.title).to_s.strip.should eq("Test")
      __result.html.to_s.should_not be_empty
      __result.try(&.markdown).try(&.content).to_s.should_not be_empty
      __result.try(&.markdown).try(&.content).to_s.should contain("Hello World")
    end
    it "All crawled pages have markdown field populated" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_depth\":1}"))
      url = ENV["MOCK_SERVER_MARKDOWN_CRAWL_ALL_PAGES"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/markdown_crawl_all_pages"
      __result = Crawlberg.crawl(engine, url)
      # skipped: field 'pages_crawled' not available on result type
    end
    it "Fit markdown removes navigation and boilerplate content" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
      url = ENV["MOCK_SERVER_MARKDOWN_FIT_CONTENT"]? || (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/markdown_fit_content"
      __result = Crawlberg.scrape(engine, url)
      __result.status_code.should eq(200)
      __result.try(&.markdown).try(&.content).to_s.should_not be_empty
    end
    it "Markdown conversion preserves heading hierarchy and paragraph text" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/markdown_headings_and_paragraphs"
      __result = Crawlberg.scrape(engine, url)
      __result.try(&.markdown).try(&.content).to_s.should_not be_empty
      __result.try(&.markdown).try(&.content).to_s.should contain("Main Title")
    end
    it "HTML links are converted to markdown link syntax" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/markdown_links_converted"
      __result = Crawlberg.scrape(engine, url)
      __result.status_code.should eq(200)
      __result.html.to_s.should_not be_empty
      __result.try(&.markdown).try(&.content).to_s.should_not be_empty
      __result.try(&.markdown).try(&.content).to_s.should contain("Example")
    end
    it "Markdown includes citation conversion with numbered references" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/markdown_with_citations"
      __result = Crawlberg.scrape(engine, url)
      __result.status_code.should eq(200)
      __result.try(&.markdown).try(&.content).to_s.should_not be_empty
    end
  end
end
