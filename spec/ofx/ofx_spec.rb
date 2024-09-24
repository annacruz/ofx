require "spec_helper"

describe OFX do
  describe "#OFX" do
    it "creates the OFX instance" do
      OFX("spec/fixtures/sample.ofx") do |ofx|
        expect(ofx.class).to eql OFX::Parser::OFX102
      end
    end

    it "returns the OFX instance" do
      ofx_instace = OFX("spec/fixtures/sample.ofx")
      expect(ofx_instace.class).to eql OFX::Parser::OFX102
    end

    it "returns the parser" do
      expect(OFX("spec/fixtures/sample.ofx").class).to eql OFX::Parser::OFX102
    end
  end
end
