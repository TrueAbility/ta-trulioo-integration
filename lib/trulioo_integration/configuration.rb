class TruliooIntegration::Configuration

  include TruliooIntegrationTaLogger
  attr_accessor :user_name, :password, :base_url, :access_token

  def initialize(opts = {})
    opts.symbolize_keys!
    @user_name = opts[:user_name]
    @password = opts[:password]
    @base_url = opts[:base_url]
  end

  def to_s
    "user_name: #{user_name.inspect}, base_url: #{base_url.inspect} password: #{password[0..1]}..."
  end
end
