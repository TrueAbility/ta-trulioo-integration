$VERBOSE=nil
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "webmock"
require "vcr"
require "minitest/autorun"
require "trulioo_integration"

VCR.configure do |config|
  config.ignore_localhost = true
  # config.debug_logger = File.open("#{Rails.root}/log/vcr.log", 'w')
  config.register_request_matcher :ignore_content_length do |rq1, rq2|
    rq1.uri == rq2.uri && rq1.method == rq2.method &&
      (rq1.headers.to_a - rq2.headers.to_a).select { |k| k[0] != "Content-Length" }.empty?
  end

  # config.register_request_matcher :bump_node_matcher do |request_1, request_2|
  #   "https://as-12345-0.ascreen.co:2867/stop?token=12345" == request_2.uri.to_s
  # end

  config.cassette_library_dir = "test/vcr_cassettes"
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = false #change to true only to grab new input, flip back then
end

