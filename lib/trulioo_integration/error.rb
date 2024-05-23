class TruliooIntegration::Error < StandardError
  attr_accessor :status_code

  def initialize(msg="", status_code=nil)
    super(msg)
    @status_code = status_code
    self
  end
end
