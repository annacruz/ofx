require "spec_helper"

describe OFX::Status do
  let(:ofx) { OFX::Parser::Base.new(ofx_file) }
  let(:parser) { ofx.parser }
  let(:status) { parser.sign_on.status }

  context "success" do
    let(:ofx_file) { "spec/fixtures/creditcard.ofx" }

    it "should return code" do
      status.code.should == 0
    end

    it "should return severity" do
      status.severity.should == :info
    end

    it "should return message" do
      status.message.should == ""
    end

    it "should be successful" do
      status.success?.should == true
    end
  end

  context "error" do
    let(:ofx_file) { "spec/fixtures/error.ofx" }

    it "should return code" do
      status.code.should == 2000
    end

    it "should return severity" do
      status.severity.should == :error
    end

    it "should return message" do
      status.message.should == "We were unable to process your request. Please try again later."
    end

    it "should not be successful" do
      status.success?.should == false
    end
  end
end
