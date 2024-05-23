module TruliooIntegrationErrorsHelper

  def self.included(base)
    base.extend ClassMethods
  end

  def ti_extract_errors(e)
    self.class.ti_extract_errors(e)
  end

  def ti_error_with_backtrace(message, e)
    self.class.ti_error_with_backtrace(message, e)
  end

  module ClassMethods
    def ti_extract_errors(e)
      if e.respond_to?(:record) && !e.record.nil? && !e.record.errors.full_messages.to_sentence.nil?
        e.record.errors.full_messages.to_sentence
      elsif e.respond_to?(:message)
        e.message
      else
        e
      end
    end

    def ti_error_with_backtrace(message, e)
      message +
        "#{ti_extract_errors(e)}\n" +
        "#{e.respond_to?(:backtrace) ? e.backtrace.join("\n") : ""}"
    end
  end
end
