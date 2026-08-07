require "spec"
require "json"
require "socket"
# Returns whether a URL's TCP endpoint is accepting connections.
def alef_mock_ready?(url : String) : Bool
  host, port = url.lchop("http://").split(':', 2)
  begin
    TCPSocket.new(host, port.to_i).close
    true
  rescue
    false
  end
end

# Environment variables set before loading the binding
ENV["CRAWLBERG_ALLOW_PRIVATE_NETWORK"] ||= "true"

# Lazy singleton that owns the e2e mock server child process.
class AlefMockServer
  class_getter instance = new
  @pid : Process? = nil
  @reader : IO::FileDescriptor? = nil
  @env : Hash(String, String) = {} of String => String

  def start
    return unless @pid.nil?
    return unless ENV["MOCK_SERVER_URL"]?.nil?
    mock_server_path = File.join(__DIR__, "..", "..", "rust", "target", "release", "mock-server")
    fixtures_path = File.join(__DIR__, "..", "..", "..", "fixtures")
    raise "mock-server binary not found at #{mock_server_path}. Run: cargo build --release --manifest-path e2e/rust/Cargo.toml --bin mock-server" unless File.exists?(mock_server_path)
    reader, writer = IO.pipe
    # MOCK_SERVER_NO_STDIN_WATCH makes the server block on SIGTERM (not stdin
    # EOF), so the Crystal spec process can reap it cleanly in after_suite.
    pid = Process.new(mock_server_path, [fixtures_path], output: writer, env: {"MOCK_SERVER_NO_STDIN_WATCH" => "1"})
    writer.close
    line = reader.gets
    if line && line.starts_with?("MOCK_SERVER_URL=")
      @env["MOCK_SERVER_URL"] = line.lchop("MOCK_SERVER_URL=").strip
    end
    # The mock server always prints a MOCK_SERVERS={...} line (second)
    # with per-fixture URLs for origin-root fixtures. Export each as
    # MOCK_SERVER_<FIXTURE_ID_UPPER> so specs can target host-root routes.
    servers_line = reader.gets
    if servers_line && servers_line.starts_with?("MOCK_SERVERS=")
      servers_payload = servers_line.lchop("MOCK_SERVERS=")
      servers = JSON.parse(servers_payload)
      servers.as_h.each do |fid, furl|
        @env["MOCK_SERVER_#{fid.upcase}"] = furl.as_s
      end
      @env["MOCK_SERVERS"] = servers_payload
    end
    @env.each { |k, v| ENV[k] = v }
    # Poll the shared URL until it accepts connections (the mock server
    # binds all listeners before printing its sentinel lines, so the
    # shared URL readiness implies origin-root readiness too).
    shared_url = ENV["MOCK_SERVER_URL"]? || ""
    400.times do
      break if alef_mock_ready?(shared_url)
      sleep 50.milliseconds
    end
    @pid = pid
    @reader = reader
    # Drain the child's stdout so the pipe never fills and the child never
    # blocks on a write (SIGPIPE would kill it).
    spawn { while reader.gets; end }
  end

  def stop
    if p = @pid
      Process.signal(Signal::TERM, p.pid) rescue nil
      p.wait
      @pid = nil
    end
  end
end

Spec.before_suite { AlefMockServer.instance.start }
Spec.after_suite { AlefMockServer.instance.stop }

require "crawlberg"
