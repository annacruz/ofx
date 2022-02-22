module OFX
  class Transaction < Foundation
    attr_accessor :amount
    attr_accessor :amount_in_pennies
    attr_accessor :check_number
    attr_accessor :fit_id
    attr_accessor :memo
    attr_accessor :name
    attr_accessor :payee
    attr_accessor :posted_at
    attr_accessor :occurred_at
    attr_accessor :ref_number
    attr_accessor :currency_currate
    attr_accessor :type
    attr_accessor :sic
  end
end
