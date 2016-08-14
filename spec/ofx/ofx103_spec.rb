require "spec_helper"

describe OFX::Parser::OFX103 do
  before do
    @ofx = OFX::Parser::Base.new("spec/fixtures/v103.ofx")
    @parser = @ofx.parser
  end

  it "should have a version" do
    OFX::Parser::OFX103::VERSION.should == "1.0.3"
  end

  it "should set headers" do
    @parser.headers.should == @ofx.headers
  end

  it "should trim trailing whitespace from headers" do
    headers = OFX::Parser::OFX103.parse_headers("VERSION:103   ")
    headers["VERSION"].should == "103"
  end

  it "should set body" do
    @parser.body.should == @ofx.body
  end

  it "should set account" do
    @parser.account.should be_a_kind_of(OFX::Account)
  end

  it "should set account" do
    @parser.sign_on.should be_a_kind_of(OFX::SignOn)
  end

  it "should know about all transaction types" do
    valid_types = [
      'CREDIT', 'DEBIT', 'INT', 'DIV', 'FEE', 'SRVCHG', 'DEP', 'ATM', 'POS', 'XFER',
      'CHECK', 'PAYMENT', 'CASH', 'DIRECTDEP', 'DIRECTDEBIT', 'REPEATPMT', 'OTHER'
    ]
    valid_types.sort.should == OFX::Parser::OFX103::TRANSACTION_TYPES.keys.sort

    valid_types.each do |transaction_type|
      transaction_type.downcase.to_sym.should equal OFX::Parser::OFX103::TRANSACTION_TYPES[transaction_type]
    end
  end
end
