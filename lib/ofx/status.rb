module OFX
  # Error Reporting Aggregate
  class Status < Foundation
    attr_accessor :code     # Error code
    attr_accessor :severity # Severity of the error
    attr_accessor :message  # Textual explanation

    def success?
      code == 0
    end
  end
end
