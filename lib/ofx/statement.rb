module OFX
  class Statement < Foundation
    attr_accessor :account
    attr_accessor :available_balance
    attr_accessor :balance
    attr_accessor :currency
    attr_accessor :start_date
    attr_accessor :end_date
    attr_accessor :transactions
  end
end
