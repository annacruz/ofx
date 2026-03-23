require "spec_helper"

describe OFX do
  describe "#OFX" do
    it "yields an OFX instance" do
      OFX("spec/fixtures/sample.ofx") do |ofx|
        expect(ofx.class).to eql OFX::Parser::OFX102
      end
    end

    it "is an OFX instance" do
      klass = nil
      OFX("spec/fixtures/sample.ofx") do
        klass = self.class
      end
      expect(klass).to eql OFX::Parser::OFX102
    end

    it "returns parser" do
      expect(OFX("spec/fixtures/sample.ofx").class).to eql OFX::Parser::OFX102
    end
  end
end
