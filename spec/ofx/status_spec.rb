require "spec_helper"

describe OFX::Status do
  let(:ofx) { OFX::Parser::Base.new(ofx_file) }
  let(:parser) { ofx.parser }
  let(:status) { parser.sign_on.status }

  context "success" do
    let(:ofx_file) { "spec/fixtures/creditcard.ofx" }

    it "should return code" do
      expect(status.code).to eql 0
    end

    it "should return severity" do
      expect(status.severity).to eql :info
    end

    it "should return message" do
      expect(status.message).to eql ""
    end

    it "should be successful" do
      expect(status.success?).to eql true
    end
  end

  context "error" do
    let(:ofx_file) { "spec/fixtures/error.ofx" }

    it "should return code" do
      expect(status.code).to eql 2000
    end

    it "should return severity" do
      expect(status.severity).to eql :error
    end

    it "should return message" do
      expect(status.message).to eql "We were unable to process your request. Please try again later."
    end

    it "should not be successful" do
      expect(status.success?).to eql false
    end
  end
end
