module TruliooIntegrationTaLogger

  def self.included(base)
    base.extend ClassMethods
  end

  def ti_logger(message, method = :info, gid_s: nil)
    self.class.ti_logger(message, method, gid_s: gid_s || (gid_str rescue nil))
  end

  def ti_logger_prefix(gid_s = nil)
    self.class.ti_logger_prefix(gid_s)
  end

  module ClassMethods

    attr_reader :_logger

    def ti_logger(message, method = :info, gid_s: nil)
      m = "#{ti_logger_prefix(gid_s)}: #{message}"
      if (Object.const_get(:Rails) rescue nil)
        puts m if Rails.env.test? && log_to_stdout?
        Rails.logger.send(method, m)
      else
        @_logger = Logger.new(STDOUT)
        _logger.send(method, m)
      end
    end

    def ti_logger_prefix(gid_s = nil)
      s = "#{self.class == Class ? self : self.class}"
      g = gid_s || (gid_str rescue nil)
      s << ": #{g}" if !g.nil?
      s
    end
  end
end
