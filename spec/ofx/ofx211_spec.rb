require "spec_helper"

describe OFX::Parser::OFX211 do
  before do
    @ofx = OFX::Parser::Base.new("spec/fixtures/v211.ofx")
    @parser = @ofx.parser
  end

  it "has a version" do
    expect(OFX::Parser::OFX211::VERSION).to eql "2.1.1"
  end

  it "sets headers" do
    expect(@parser.headers).to eql @ofx.headers
  end

  it "sets body" do
    expect(@parser.body).to eql @ofx.body
  end

  it "sets account" do
    expect(@parser.account).to be_a_kind_of(OFX::Account)
  end

  it "sets sign_on" do
    expect(@parser.sign_on).to be_a_kind_of(OFX::SignOn)
  end

  it "sets accounts" do
    expect(@parser.accounts.size).to eql 2
  end

  context "transactions" do
    # Test file contains only three transactions. Let's just check
    # them all.
    context "first" do
      before do
        @t = @parser.accounts[0].transactions[0]
      end

      it "contains the correct values" do
        expect(@t.amount).to eql BigDecimal('-80')
        expect(@t.fit_id).to eql "219378"
        expect(@t.memo).to be_empty
        expect(@t.posted_at).to eql Time.parse("2005-08-24 08:00:00 +0000")
        expect(@t.name).to eql "FrogKick Scuba Gear"
      end
    end

    context "second" do
      before do
        @t = @parser.accounts[1].transactions[0]
      end

      it "contains the correct values" do
        expect(@t.amount).to eql BigDecimal('-23')
        expect(@t.fit_id).to eql "219867"
        expect(@t.memo).to be_empty
        expect(@t.posted_at).to eql Time.parse("2005-08-11 08:00:00 +0000")
        expect(@t.name).to eql "Interest Charge"
      end
    end

    context "third" do
      before do
        @t = @parser.accounts[1].transactions[1]
      end

      it "contains the correct values" do
        expect(@t.amount).to eql BigDecimal('350')
        expect(@t.fit_id).to eql "219868"
        expect(@t.memo).to be_empty
        expect(@t.posted_at).to eql Time.parse("2005-08-11 08:00:00 +0000")
        expect(@t.name).to eql "Payment - Thank You"
      end
    end
  end
end

