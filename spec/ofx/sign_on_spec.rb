require "spec_helper"

describe OFX::SignOn do
  before do
    @ofx = OFX::Parser::Base.new("spec/fixtures/creditcard.ofx")
    @parser = @ofx.parser
    @sign_on = @parser.sign_on
  end

  describe "sign_on" do
    it "returns language" do
      expect(@sign_on.language).to eql "ENG"
    end

    it "returns Financial Institution ID" do
      expect(@sign_on.fi_id).to eql "24909"
    end

    it "returns Financial Institution Name" do
      expect(@sign_on.fi_name).to eql "Citigroup"
    end

    it "returns status" do
      expect(@sign_on.status).to be_a(OFX::Status)
    end
  end
end
