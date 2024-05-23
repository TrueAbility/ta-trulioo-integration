require "test_helper"
require "trulioo_integration"

class TruliooIntegration::ClientTest < Minitest::Test
  attr_accessor :client

  def setup
    TruliooIntegration.configure do |config|
      config.base_url = "https://api.globaldatacompany.com"
      config.user_name = "TrueAbility_Demo_DocV_API"
      config.password = "secret"
    end

    @client = TruliooIntegration::Client.new
  end

  def test_country_codes_authorization_success
    VCR.use_cassette("trulioo_integration_success", allow_playback_repeats: true) do
      r = client.country_codes
      assert r.size > 200, "doesn't seem to be enough countries"
      %w(US FR ES IN GB).each do |country_code|
        assert r.include?(country_code), "expected to containe country code: #{country_code.inspect}"
      end
    end
  end

  def test_country_codes_authorization_error
    VCR.use_cassette("trulioo_integration_authorization_error", allow_playback_repeats: true) do
      r = assert_raises(TruliooIntegration::Error) { client.country_codes }
      assert_match "Access Denied", r.message
    end
  end

  def test_document_types_success
    VCR.use_cassette("trulioo_integration_document_types_success", allow_playback_repeats: true) do
      r = client.document_types("US")
      assert_equal "DrivingLicence", r["US"].first
    end
  end

  def test_get_transaction_record_success
    VCR.use_cassette("trulioo_integration_get_transaction_record_success", allow_playback_repeats: true) do
      r = client.get_transaction_record("2074fbd2-c90a-e072-5cd0-40ce4184badc")
      assert r["InputFields"].size > 0
    end
  end

  def test_verify_success
    VCR.use_cassette("trulioo_integration_verify_success", allow_playback_repeats: true) do
      document_front_image = File.open("test/fixtures/document_front_image.b64", "r").read
      r = client.identity_verification(
        document_front_image: document_front_image.strip,
        document_type: "passport",
        callback_url: "https://invalid",
        live_photo: nil,
        document_back_image: nil,
        first_given_name: "Test",
        first_surname: "Test",
        country_code: "US",
      )
      refute r["TransactionID"].nil?, "literally the only thing we are interested in is not here"
    end
  end
end

