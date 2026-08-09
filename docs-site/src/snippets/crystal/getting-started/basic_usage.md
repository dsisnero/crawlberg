```crystal title="Crystal"
require "crawlberg"

# Download the native FFI library first (see README):
#   ./scripts/download_ffi.sh
# Build with:
#   crystal build --link-flags="-L.lib -Wl,-rpath,$(pwd)/.lib" src/app.cr

# Simplest case: scrape a single page with default settings.
engine = Crawlberg.create_engine(Crawlberg::CrawlConfig.from_json("{\"max_concurrent\":2}"))

result = Crawlberg.scrape(engine, "https://example.com/")

puts "Title: #{result.metadata.try(&.title)}"
puts "Status: #{result.status_code}"
puts "Links found: #{result.links.size}"
```
