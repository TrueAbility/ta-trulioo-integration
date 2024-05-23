# keep order
require "hash_ext"
require "httparty"
require "awesome_print"
require "trulioo_integration_errors_helper"

require_relative "trulioo_integration_ta_logger"
require_relative "trulioo_integration/version"
require_relative "trulioo_integration/base"
require_relative "trulioo_integration/configuration"
require_relative "trulioo_integration/client"
require_relative "trulioo_integration/error"


module TruliooIntegration
  class << self
    attr_writer :configuration
  end

  def self.configuration(initialization_opts = {})
    @configuration ||= Configuration.new(initialization_opts)
  end

  def self.configure(initialization_opts = {})
    config = configuration(initialization_opts)
    yield(config) if block_given?
    config.access_token = "Basic " + Base64.encode64("#{config.user_name}:#{config.password}").gsub(/\s+/, "")
  end
end
