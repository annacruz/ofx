require "spec_helper"

describe OFX::SignOn do
  before do
    @ofx = OFX::Parser::Base.new("spec/fixtures/creditcard.ofx")
    @parser = @ofx.parser
    @sign_on = @parser.sign_on
  end

  describe "sign_on" do
    it "should return language" do
      @sign_on.language.should == "ENG"
    end

    it "should return Financial Institution ID" do
      @sign_on.fi_id.should == "24909"
    end

    it "should return Financial Institution Name" do
      @sign_on.fi_name.should == "Citigroup"
    end
  end
end
