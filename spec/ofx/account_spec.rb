require "spec_helper"

describe OFX::Account do
  before do
    @ofx = OFX::Parser::Base.new("spec/fixtures/sample.ofx")
    @parser = @ofx.parser
    @account = @parser.account
  end

  describe "account" do
    it "should return currency" do
      @account.currency.should == "BRL"
    end

    it "should return bank id" do
      @account.bank_id.should == "0356"
    end

    it "should return id" do
      @account.id.should == "03227113109"
    end

    it "should return type" do
      @account.type.should == :checking
    end

    it "should return transactions" do
      @account.transactions.should be_a_kind_of(Array)
      @account.transactions.size.should == 36
    end

    it "should return balance" do
      @account.balance.amount.should == BigDecimal('598.44')
    end

    it "should return balance in pennies" do
      @account.balance.amount_in_pennies.should == 59844
    end

    it "should return balance date" do
      @account.balance.posted_at.should == Time.gm(2009,11,1)
    end

    context "available_balance" do
      it "should return available balance" do
        @account.available_balance.amount.should == BigDecimal('1555.99')
      end

      it "should return available balance in pennies" do
        @account.available_balance.amount_in_pennies.should == 155599
      end

      it "should return available balance date" do
        @account.available_balance.posted_at.should == Time.gm(2009,11,1)
      end

      it "should return nil if AVAILBAL not found" do
        @ofx = OFX::Parser::Base.new("spec/fixtures/utf8.ofx")
        @parser = @ofx.parser
        @account = @parser.account
        @account.available_balance.should be_nil
      end
    end

    context "Credit Card" do
      before do
        @ofx = OFX::Parser::Base.new("spec/fixtures/creditcard.ofx")
        @parser = @ofx.parser
        @account = @parser.account
      end

      it "should return id" do
        @account.id.should == "XXXXXXXXXXXX1111"
      end

      it "should return currency" do
        @account.currency.should == "USD"
      end
    end
    context "With Issue" do # Bradesco do not provide a valid date in balance
      before do
        @ofx = OFX::Parser::Base.new("spec/fixtures/dtsof_balance_issue.ofx")
        @parser = @ofx.parser
        @account = @parser.account
      end

      it "should return nil for date balance" do
        @account.balance.posted_at.should be_nil
      end
    end

    context "Invalid Dates" do
      before do
        @ofx = OFX::Parser::Base.new("spec/fixtures/bradesco.ofx")
        @parser = @ofx.parser
      end
      it "should not raise error when balance has date zero" do
        expect { @parser.account.balance }.to_not raise_error
      end
      it "should return NIL in balance.posted_at when balance date is zero" do
        @parser.account.balance.posted_at.should be_nil
     end
    end

    context "decimal values using a comma" do
      before do
        @ofx = OFX::Parser::Base.new("spec/fixtures/santander.ofx")
        @parser = @ofx.parser
        @account = @parser.account
      end

      it "should return balance" do
        @account.balance.amount.should == BigDecimal('348.29')
      end

      it "should return balance in pennies" do
        @account.balance.amount_in_pennies.should == 34829
      end

      context "available_balance" do
        it "should return available balance" do
          @account.available_balance.amount.should == BigDecimal('2415.87')
        end

        it "should return available balance in pennies" do
          @account.available_balance.amount_in_pennies.should == 241587
        end
      end
    end
  end
end
