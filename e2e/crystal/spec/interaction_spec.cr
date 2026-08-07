require "./spec_helper"

describe Crawlberg do
  describe "interaction" do
    it "Execute a sequence of multiple actions (click, type, click) and verify all succeed with correct indices" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"browser\":{\"mode\":\"always\"}}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/interact_action_sequence"
      __result = Crawlberg.interact(engine, url, Array(Crawlberg::PageAction).from_json(("[{\"selector\":\"#open\",\"type\":\"click\"},{\"selector\":\"#field\",\"text\":\"test_data\",\"type\":\"type\"},{\"selector\":\"#submit\",\"type\":\"click\"}]")))
      # skipped: field 'interaction.action_results[0].action_index' not available on result type
      # skipped: field 'interaction.action_results[0].action_type' not available on result type
      # skipped: field 'interaction.action_results[0].success' not available on result type
      # skipped: field 'interaction.action_results[1].action_index' not available on result type
      # skipped: field 'interaction.action_results[1].action_type' not available on result type
      # skipped: field 'interaction.action_results[1].success' not available on result type
      # skipped: field 'interaction.action_results[2].action_index' not available on result type
      # skipped: field 'interaction.action_results[2].action_type' not available on result type
      # skipped: field 'interaction.action_results[2].success' not available on result type
    end
    it "Click a button element and verify success" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"browser\":{\"mode\":\"always\"}}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/interact_click_element"
      __result = Crawlberg.interact(engine, url, Array(Crawlberg::PageAction).from_json(("[{\"selector\":\"#submit\",\"type\":\"click\"}]")))
      # skipped: field 'interaction.action_results[0].success' not available on result type
      # skipped: field 'interaction.action_results[0].action_type' not available on result type
      # skipped: field 'interaction.action_results[0].action_index' not available on result type
    end
    it "Execute JavaScript that returns document.title and verify success with data" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"browser\":{\"mode\":\"always\"}}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/interact_execute_js"
      __result = Crawlberg.interact(engine, url, Array(Crawlberg::PageAction).from_json(("[{\"script\":\"document.title\",\"type\":\"executeJs\"}]")))
      # skipped: field 'interaction.action_results[0].success' not available on result type
      # skipped: field 'interaction.action_results[0].action_type' not available on result type
      # skipped: field 'interaction.action_results[0].data' not available on result type
    end
    it "Click on a non-existent selector and verify error in action_results" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"browser\":{\"mode\":\"always\"}}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/interact_invalid_selector"
      __result = Crawlberg.interact(engine, url, Array(Crawlberg::PageAction).from_json(("[{\"selector\":\"#nonexistent\",\"type\":\"click\"}]")))
      # skipped: field 'interaction.action_results[0].success' not available on result type
      # skipped: field 'interaction.action_results[0].action_type' not available on result type
      # skipped: field 'interaction.action_results[0].error' not available on result type
    end
    it "Submit 101 actions (exceeds MAX_ACTIONS=100) and verify validation error" do
      expect_raises(Exception) do
        engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"browser\":{\"mode\":\"always\"}}"))
        url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/interact_max_actions_exceeded"
        Crawlberg.interact(engine, url, Array(Crawlberg::PageAction).from_json(("[{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"},{\"selector\":\"#btn\",\"type\":\"click\"}]")))
      end
    end
    it "Press a keyboard key (Enter) and verify success" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"browser\":{\"mode\":\"always\"}}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/interact_press_key"
      __result = Crawlberg.interact(engine, url, Array(Crawlberg::PageAction).from_json(("[{\"selector\":\"#searchbox\",\"type\":\"click\"},{\"selector\":\"#searchbox\",\"text\":\"test\",\"type\":\"type\"},{\"key\":\"Enter\",\"type\":\"press\"}]")))
      # skipped: field 'interaction.action_results[2].success' not available on result type
      # skipped: field 'interaction.action_results[2].action_type' not available on result type
      # skipped: field 'interaction.action_results[2].action_index' not available on result type
    end
    it "Execute default Scrape action and verify extracted content" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"browser\":{\"mode\":\"always\"}}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/interact_scrape_default"
      __result = Crawlberg.interact(engine, url, Array(Crawlberg::PageAction).from_json(("[{\"type\":\"scrape\"}]")))
      # skipped: field 'interaction.action_results[0].success' not available on result type
      # skipped: field 'interaction.action_results[0].action_type' not available on result type
      # skipped: field 'interaction.action_results[0].data' not available on result type
    end
    it "Screenshot a specific element via selector and verify image data" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"browser\":{\"mode\":\"always\"}}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/interact_screenshot"
      __result = Crawlberg.interact(engine, url, Array(Crawlberg::PageAction).from_json(("[{\"full_page\":false,\"type\":\"screenshot\"}]")))
      # skipped: field 'interaction.action_results[0].success' not available on result type
      # skipped: field 'interaction.action_results[0].action_type' not available on result type
      # skipped: field 'interaction.action_results[0].data' not available on result type
    end
    it "Screenshot full page and verify image data" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"browser\":{\"mode\":\"always\"}}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/interact_screenshot_full_page"
      __result = Crawlberg.interact(engine, url, Array(Crawlberg::PageAction).from_json(("[{\"full_page\":true,\"type\":\"screenshot\"}]")))
      # skipped: field 'interaction.action_results[0].success' not available on result type
      # skipped: field 'interaction.action_results[0].action_type' not available on result type
      # skipped: field 'interaction.action_results[0].data' not available on result type
    end
    it "Scroll down on the page and verify success" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"browser\":{\"mode\":\"always\"}}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/interact_scroll_down"
      __result = Crawlberg.interact(engine, url, Array(Crawlberg::PageAction).from_json(("[{\"amount\":500,\"direction\":\"down\",\"type\":\"scroll\"}]")))
      # skipped: field 'interaction.action_results[0].success' not available on result type
      # skipped: field 'interaction.action_results[0].action_type' not available on result type
      # skipped: field 'interaction.action_results[0].action_index' not available on result type
    end
    it "Type text into an input field and verify success" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"browser\":{\"mode\":\"always\"}}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/interact_type_input"
      __result = Crawlberg.interact(engine, url, Array(Crawlberg::PageAction).from_json(("[{\"selector\":\"#username\",\"text\":\"john_doe\",\"type\":\"type\"}]")))
      # skipped: field 'interaction.action_results[0].success' not available on result type
      # skipped: field 'interaction.action_results[0].action_type' not available on result type
      # skipped: field 'interaction.action_results[0].action_index' not available on result type
    end
    it "Wait for a CSS selector that exists on the page" do
      engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"browser\":{\"mode\":\"always\"}}"))
      url = (ENV["MOCK_SERVER_URL"]? || "") + "/fixtures/interact_wait_selector"
      __result = Crawlberg.interact(engine, url, Array(Crawlberg::PageAction).from_json(("[{\"selector\":\"#content\",\"type\":\"wait\"}]")))
      # skipped: field 'interaction.action_results[0].success' not available on result type
      # skipped: field 'interaction.action_results[0].action_type' not available on result type
      # skipped: field 'interaction.action_results[0].action_index' not available on result type
    end
  end
end
