require "spec_helper"

RSpec.describe OFX::Transaction do
  before do
    @ofx = OFX::Parser::Base.new("spec/fixtures/sample.ofx")
    @parser = @ofx.parser
    @account = @parser.account
  end

  context "debit" do
    before do
      @transaction = @account.transactions[0]
    end

    it "sets amount" do
      expect(@transaction.amount).to eql BigDecimal('-35.34')
    end

    it "casts amount to BigDecimal" do
      expect(@transaction.amount.class).to be BigDecimal
    end

    it "sets amount in pennies" do
      expect(@transaction.amount_in_pennies).to eql -3534
    end

    it "sets fit id" do
      expect(@transaction.fit_id).to eql "200910091"
    end

    it "sets memo" do
      expect(@transaction.memo).to eql "COMPRA VISA ELECTRON"
    end

    it "sets check number" do
      expect(@transaction.check_number).to eql "0001223"
    end

    it "has date" do
      expect(@transaction.posted_at).to eql Time.parse("2009-10-09 08:00:00 +0000")
    end

    it 'has user date' do
      expect(@transaction.occurred_at).to eql Time.parse("2009-09-09 08:00:00 +0000")
    end

    it "has type" do
      expect(@transaction.type).to eql :debit
    end

    it "has sic" do
      expect(@transaction.sic).to eql '5072'
    end
  end

  context "credit" do
    before do
      @transaction = @account.transactions[1]
    end

    it "sets amount" do
      expect(@transaction.amount).to eql BigDecimal('60.39')
    end

    it "sets amount in pennies" do
      expect(@transaction.amount_in_pennies).to eql 6039
    end

    it "sets fit id" do
      expect(@transaction.fit_id).to eql "200910162"
    end

    it "sets memo" do
      expect(@transaction.memo).to eql "DEPOSITO POUP.CORRENTE"
    end

    it "sets check number" do
      expect(@transaction.check_number).to eql "0880136"
    end

    it "has date" do
      expect(@transaction.posted_at).to eql Time.parse("2009-10-16 08:00:00 +0000")
    end

    it "has user date" do
      expect(@transaction.occurred_at).to eql Time.parse("2009-09-16 08:00:00 +0000")
    end

    it "has type" do
      expect(@transaction.type).to eql :credit
    end

    it "has empty sic" do
      expect(@transaction.sic).to eql ''
    end
  end

  context "with more info" do
    before do
      @transaction = @account.transactions[2]
    end

    it "sets payee" do
      expect(@transaction.payee).to eql "Pagto conta telefone"
    end

    it "sets check number" do
      expect(@transaction.check_number).to eql "000000101901"
    end

    it "has date" do
      expect(@transaction.posted_at).to eql Time.parse("2009-10-19 12:00:00 -0300")
    end

    it "has user date" do
      expect(@transaction.occurred_at).to eql Time.parse("2009-10-17 12:00:00 -0300")
    end

    it "has type" do
      expect(@transaction.type).to eql :other
    end

    it "has reference number" do
      expect(@transaction.ref_number).to eql "101.901"
    end
  end

  context "with name" do
    before do
      @transaction = @account.transactions[3]
    end

    it "sets name" do
      expect(@transaction.name).to eql "Pagto conta telefone"
    end
  end

  context "with other types" do
    before do
      @ofx = OFX::Parser::Base.new("spec/fixtures/bb.ofx")
      @parser = @ofx.parser
      @account = @parser.account
    end

    it "returns dep" do
      @transaction = @account.transactions[9]
      expect(@transaction.type).to eql :dep
    end

    it "returns xfer" do
      @transaction = @account.transactions[18]
      expect(@transaction.type).to eql :xfer
    end

    it "returns cash" do
      @transaction = @account.transactions[45]
      expect(@transaction.type).to eql :cash
    end

    it "returns check" do
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

      it "sets amount" do
        expect(@transaction.amount).to eql BigDecimal('-11.76')
      end

      it "sets amount in pennies" do
        expect(@transaction.amount_in_pennies).to eql -1176
      end
    end

    context "credit" do
      before do
        @transaction = @account.transactions[3]
      end

      it "sets amount" do
        expect(@transaction.amount).to eql BigDecimal('47.01')
      end

      it "sets amount in pennies" do
        expect(@transaction.amount_in_pennies).to eql 4701
      end
    end
  end

  context "invalid decimal values" do
    before do
      @ofx = OFX::Parser::Base.new("spec/fixtures/cef_malformed_decimal.ofx")
      @parser = @ofx.parser
    end

    it "does not raise error" do
      expect { @parser.account.transactions }.not_to raise_error
    end

    it "returns zero in amount" do
      expect(@parser.account.transactions[0].amount).to eql BigDecimal('0.0')
    end

    it "returns zero in amount_in_pennies" do
      expect(@parser.account.transactions[0].amount_in_pennies).to eql 0
    end
  end
end
