require "./spec_helper"

describe Crawlberg do
  describe "metadata" do
    it "Extracts article:published_time, modified_time, author, section, and tags" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/metadata_article_times"
      __result = Crawlberg.scrape(engine, url)
      __result.status_code.should eq(200)
      # skipped: field 'article.published_time' not available on result type
      # skipped: field 'article.modified_time' not available on result type
      # skipped: field 'article.author' not available on result type
      # skipped: field 'article.section' not available on result type
      # skipped: field 'article.tags.length' not available on result type
    end
    it "Extracts favicon link tags including apple-touch-icon" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/metadata_favicons"
      __result = Crawlberg.scrape(engine, url)
      __result.status_code.should eq(200)
      # skipped: field 'favicons.length' not available on result type
      # skipped: field 'favicons[].apple_touch' not available on result type
    end
    it "Extracts heading hierarchy (h1-h6) from HTML page" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/metadata_headings"
      __result = Crawlberg.scrape(engine, url)
      __result.status_code.should eq(200)
      # skipped: field 'headings.h1.length' not available on result type
      # skipped: field 'headings.h1[0].text' not available on result type
      # skipped: field 'headings.length' not available on result type
    end
    it "Extracts hreflang alternate link tags" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/metadata_hreflang"
      __result = Crawlberg.scrape(engine, url)
      __result.status_code.should eq(200)
      # skipped: field 'hreflang.length' not available on result type
      # skipped: field 'hreflang[].lang' not available on result type
    end
    it "Extracts keywords, author, viewport, generator, theme-color, robots, lang, dir metadata" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/metadata_keywords_author"
      __result = Crawlberg.scrape(engine, url)
      __result.status_code.should eq(200)
      __result.try(&.metadata).try(&.title).to_s.strip.should eq("Comprehensive Metadata Test Page")
      __result.try(&.metadata).try(&.canonical_url).to_s.should_not be_empty
      __result.try(&.metadata).try(&.keywords).to_s.should_not be_empty
      __result.try(&.metadata).try(&.keywords).to_s.should contain("rust")
      __result.try(&.metadata).try(&.author).to_s.strip.should eq("Jane Developer")
      __result.try(&.metadata).try(&.viewport).to_s.should_not be_empty
      __result.try(&.metadata).try(&.generator).to_s.strip.should eq("crawlberg/1.0")
      __result.try(&.metadata).try(&.theme_color).to_s.strip.should eq("#ff6600")
      __result.try(&.metadata).try(&.robots).to_s.strip.should eq("index, follow")
      __result.try(&.metadata).try(&.html_lang).to_s.strip.should eq("en")
      __result.try(&.metadata).try(&.html_dir).to_s.strip.should eq("ltr")
    end
    it "Extracts og:video, og:audio, and og:locale:alternate metadata" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/metadata_og_video_audio"
      __result = Crawlberg.scrape(engine, url)
      __result.status_code.should eq(200)
      __result.try(&.metadata).try(&.og_video).to_s.strip.should eq("https://example.com/video.mp4")
      __result.try(&.metadata).try(&.og_audio).to_s.strip.should eq("https://example.com/audio.mp3")
      # skipped: field 'og.locale_alternate.length' not available on result type
    end
    it "Extracts response metadata from HTTP headers (etag, server, content-language)" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/metadata_response_headers"
      __result = Crawlberg.scrape(engine, url)
      __result.status_code.should eq(200)
      # skipped: field 'response_headers.etag' not available on result type
      # skipped: field 'response_headers.last_modified' not available on result type
      # skipped: field 'response_headers.server' not available on result type
      # skipped: field 'response_headers.content_language' not available on result type
    end
    it "Computes word count from visible page text" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/metadata_word_count"
      __result = Crawlberg.scrape(engine, url)
      __result.status_code.should eq(200)
      (__result.try(&.metadata).try(&.word_count) || 0).should be > 99
      (__result.try(&.metadata).try(&.word_count) || 0).should be < 301
    end
  end
end
