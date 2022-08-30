require "spec_helper"

describe OFX::Transaction do
  before do
    @ofx = OFX::Parser::Base.new("spec/fixtures/sample.ofx")
    @parser = @ofx.parser
    @account = @parser.account
  end

  context "debit" do
    before do
      @transaction = @account.transactions[0]
    end

    it "should set amount" do
      expect(@transaction.amount).to eql BigDecimal('-35.34')
    end

    it "should cast amount to BigDecimal" do
      expect(@transaction.amount.class).to be BigDecimal
    end

    it "should set amount in pennies" do
      expect(@transaction.amount_in_pennies).to eql -3534
    end

    it "should set fit id" do
      expect(@transaction.fit_id).to eql "200910091"
    end

    it "should set memo" do
      expect(@transaction.memo).to eql "COMPRA VISA ELECTRON"
    end

    it "should set check number" do
      expect(@transaction.check_number).to eql "0001223"
    end

    it "should have date" do
      expect(@transaction.posted_at).to eql Time.parse("2009-10-09 08:00:00 +0000")
    end

    it 'should have user date' do
      expect(@transaction.occurred_at).to eql Time.parse("2009-09-09 08:00:00 +0000")
    end

    it "should have type" do
      expect(@transaction.type).to eql :debit
    end

    it "should have sic" do
      expect(@transaction.sic).to eql '5072'
    end
  end

  context "credit" do
    before do
      @transaction = @account.transactions[1]
    end

    it "should set amount" do
      expect(@transaction.amount).to eql BigDecimal('60.39')
    end

    it "should set amount in pennies" do
      expect(@transaction.amount_in_pennies).to eql 6039
    end

    it "should set fit id" do
      expect(@transaction.fit_id).to eql "200910162"
    end

    it "should set memo" do
      expect(@transaction.memo).to eql "DEPOSITO POUP.CORRENTE"
    end

    it "should set check number" do
      expect(@transaction.check_number).to eql "0880136"
    end

    it "should have date" do
      expect(@transaction.posted_at).to eql Time.parse("2009-10-16 08:00:00 +0000")
    end

    it "should have user date" do
      expect(@transaction.occurred_at).to eql Time.parse("2009-09-16 08:00:00 +0000")
    end

    it "should have type" do
      expect(@transaction.type).to eql :credit
    end

    it "should have empty sic" do
      expect(@transaction.sic).to eql ''
    end
  end

  context "with more info" do
    before do
      @transaction = @account.transactions[2]
    end

    it "should set payee" do
      expect(@transaction.payee).to eql "Pagto conta telefone"
    end

    it "should set check number" do
      expect(@transaction.check_number).to eql "000000101901"
    end

    it "should have date" do
      expect(@transaction.posted_at).to eql Time.parse("2009-10-19 12:00:00 -0300")
    end

    it "should have user date" do
      expect(@transaction.occurred_at).to eql Time.parse("2009-10-17 12:00:00 -0300")
    end

    it "should have type" do
      expect(@transaction.type).to eql :other
    end

    it "should have reference number" do
      expect(@transaction.ref_number).to eql "101.901"
    end
  end

  context "with name" do
    before do
      @transaction = @account.transactions[3]
    end

    it "should set name" do
      expect(@transaction.name).to eql "Pagto conta telefone"
    end
  end

  context "with other types" do
    before do
      @ofx = OFX::Parser::Base.new("spec/fixtures/bb.ofx")
      @parser = @ofx.parser
      @account = @parser.account
    end

    it "should return dep" do
      @transaction = @account.transactions[9]
      expect(@transaction.type).to eql :dep
    end

    it "should return xfer" do
      @transaction = @account.transactions[18]
      expect(@transaction.type).to eql :xfer
    end

    it "should return cash" do
      @transaction = @account.transactions[45]
      expect(@transaction.type).to eql :cash
    end

    it "should return check" do
      @transaction = @account.transactions[0]
      expect(@transaction.type).to eql :check
    end
  end

  context "decimal values using a comma" do
    before do
      @ofx = OFX::Parser::Base.new("spec/fixtures/santander.ofx")
      @parser = @ofx.parser
      @account = @parser.account
    end

    context "debit" do
      before do
        @transaction = @account.transactions[0]
      end

      it "should set amount" do
        expect(@transaction.amount).to eql BigDecimal('-11.76')
      end

      it "should set amount in pennies" do
        expect(@transaction.amount_in_pennies).to eql -1176
      end
    end

    context "credit" do
      before do
        @transaction = @account.transactions[3]
      end

      it "should set amount" do
        expect(@transaction.amount).to eql BigDecimal('47.01')
      end

      it "should set amount in pennies" do
        expect(@transaction.amount_in_pennies).to eql 4701
      end
    end
  end

  context "invalid decimal values" do
    before do
      @ofx = OFX::Parser::Base.new("spec/fixtures/cef_malformed_decimal.ofx")
      @parser = @ofx.parser
    end

    it "should not raise error" do
      expect { @parser.account.transactions }.to_not raise_error
    end

    it "should return zero in amount" do
      expect(@parser.account.transactions[0].amount).to eql BigDecimal('0.0')
    end

    it "should return zero in amount_in_pennies" do
      expect(@parser.account.transactions[0].amount_in_pennies).to eql 0
    end
  end
end
