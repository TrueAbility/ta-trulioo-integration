class TruliooIntegration::Client < TruliooIntegration::Base

  include HTTParty

  attr_accessor :config, :token, :assignment
  attr_reader :verify_log_entry

  def initialize(config: TruliooIntegration.configuration)
    @config = config
    ti_logger("Configured: #{config.to_s}")
  end

  def configure
    yield config
  end

  def country_codes
    trulioo_get("/configuration/v1/countrycodes/Identity%20Verification")
  end

  def document_types(country_code)
    trulioo_get("/configuration/v1/documentTypes/#{country_code.upcase}")
  end

  def get_transaction_record(transaction_record_id)
    trulioo_get("/verifications/v1/transactionrecord/#{transaction_record_id}")
  end

  def identity_verification(
    country_code:,
    document_front_image:,
    document_type:,
    callback_url:,
    live_photo: nil,
    document_back_image: nil,
    first_given_name: nil,
    first_surname: nil,
    body_merges: {},
    options: {}
  )
    body =
      {
        "AcceptTruliooTermsAndConditions" => true,
        "CleansedAddress" => false,
        "VerboseMode" => true,
        "ConfigurationName" => "Identity Verification",
        "CallBackUrl" => callback_url,
        "CountryCode" => country_code,
        "DataFields" => {
          "PersonInfo" => {
            "FirstGivenName" => first_given_name,
            "FirstSurName" => first_surname,
          },
          "Document" => {
            "DocumentFrontImage" => document_front_image,
            "DocumentBackImage" => document_back_image,
            "LivePhoto" => live_photo,
            "DocumentType" => document_type
          }
        }
      }

    body.merge!(body_merges)
    response = nil
    begin
      response = HTTParty.post(
        config.base_url + "/verifications/v1/verify",
        body: body.to_json,
        headers: headers
      )
      set_verify_log_entry(body)
      case response.code
      when 200
        JSON.parse(response.body)
      else
        raise response.body
      end
    rescue HTTParty::Error, StandardError, RuntimeError => e
      raise TruliooIntegration::Error.new(ti_extract_errors(e), response&.code)
    end
  end

  private

  def trulioo_get(endpoint)
    response = HTTParty.get(
      config.base_url + endpoint,
      headers: headers
    )
    case response.code
    when 200
      JSON.parse(response.body)
    else
      raise response.body
    end
  rescue HTTParty::Error, StandardError, RuntimeError => e
    raise TruliooIntegration::Error.new(ti_extract_errors(e), response&.code)
  end

  def set_verify_log_entry(body)
    body = body.dup
    %w(DocumentFrontImage DocumentBackImage LivePhoto).each do |field|
      next if body.dig("DataFields", "Document", field).nil?
      body["DataFields"]["Document"][field] = body.dig("DataFields", "Document", field)[0..31]
    end
    @verify_log_entry = <<~ENTRY
      JSON.parse(
        HTTParty.post(
          #{config.base_url} + "/verifications/v1/verify",
          body: #{body},
          headers: #{headers.inspect}
        ).body
      )
    ENTRY
  end

  def headers
    {
      "Content-Type" => "application/json",
      "Authorization" => config.access_token
    }
  end
end