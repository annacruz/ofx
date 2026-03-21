require "spec_helper"

describe OFX do
  describe "#OFX" do
    it "should yield an OFX instance" do
      OFX("spec/fixtures/sample.ofx") do |ofx|
        expect(ofx.class).to eql OFX::Parser::OFX102
      end
    end

    it "should be an OFX instance" do
      klass = nil
      OFX("spec/fixtures/sample.ofx") do
        klass = self.class
      end
      expect(klass).to eql OFX::Parser::OFX102
    end

    it "should return parser" do
      expect(OFX("spec/fixtures/sample.ofx").class).to eql OFX::Parser::OFX102
    end
  end
end
