require "spec_helper"

describe OFX::Parser do
  before do
    @ofx = OFX::Parser::Base.new("spec/fixtures/sample.ofx")
  end

  it "accepts file path" do
    @ofx = OFX::Parser::Base.new("spec/fixtures/sample.ofx")
    expect(@ofx.content).not_to be_nil
  end

  it "accepts file handler" do
    file = open("spec/fixtures/sample.ofx")
    @ofx = OFX::Parser::Base.new(file)
    expect(@ofx.content).not_to be_nil
  end

  it "accepts file content" do
    file = open("spec/fixtures/sample.ofx").read
    @ofx = OFX::Parser::Base.new(file)
    expect(@ofx.content).not_to be_nil
  end

  it "sets content" do
    expect(@ofx.content).to eql open("spec/fixtures/sample.ofx").read
  end

  it "works with UTF8 and Latin1 encodings" do
    @ofx = OFX::Parser::Base.new("spec/fixtures/utf8.ofx")
    expect(@ofx.content).to eql open("spec/fixtures/utf8.ofx").read
  end

  it "sets body" do
    expect(@ofx.body).not_to be_nil
  end

  it "raises the exception when trying to parse an unsupported OFX version" do
    expect{
      OFX::Parser::Base.new("spec/fixtures/invalid_version.ofx")
    }.to raise_error(OFX::UnsupportedFileError)
  end

  it "raises the exception when trying to parse an invalid file" do
    expect{
      OFX::Parser::Base.new("spec/fixtures/avatar.gif")
    }.to raise_error(OFX::UnsupportedFileError)
  end

  it "uses 211 parser to parse version 200 ofx files" do
    expect(OFX::Parser::OFX211).to receive(:new).and_return('ofx-211-parser')

    ofx = OFX::Parser::Base.new(ofx_2_example('200'))
    expect(ofx.parser).to eql 'ofx-211-parser'
  end

  it "uses 211 parser to parse version 202 ofx files" do
    expect(OFX::Parser::OFX211).to receive(:new).and_return('ofx-211-parser')

    ofx = OFX::Parser::Base.new(ofx_2_example('202'))
    expect(ofx.parser).to eql 'ofx-211-parser'
  end

  describe "headers" do
    it "has OFXHEADER" do
      expect(@ofx.headers["OFXHEADER"]).to eql "100"
    end

    it "has DATA" do
      expect(@ofx.headers["DATA"]).to eql "OFXSGML"
    end

    it "has VERSION" do
      expect(@ofx.headers["VERSION"]).to eql "102"
    end

    it "has SECURITY" do
      expect(@ofx.headers).to have_key("SECURITY")
      expect(@ofx.headers["SECURITY"]).to be_nil
    end

    it "has ENCODING" do
      expect(@ofx.headers["ENCODING"]).to eql "USASCII"
    end

    it "has CHARSET" do
      expect(@ofx.headers["CHARSET"]).to eql "1252"
    end

    it "has COMPRESSION" do
      expect(@ofx.headers).to have_key("COMPRESSION")
      expect(@ofx.headers["COMPRESSION"]).to be_nil
    end

    it "has OLDFILEUID" do
      expect(@ofx.headers).to have_key("OLDFILEUID")
      expect(@ofx.headers["OLDFILEUID"]).to be_nil
    end

    it "has NEWFILEUID" do
      expect(@ofx.headers).to have_key("NEWFILEUID")
      expect(@ofx.headers["NEWFILEUID"]).to be_nil
    end

    it "parses headers with CR and without LF" do
      header = %{OFXHEADER:100\rDATA:OFXSGML\rVERSION:102\rSECURITY:NONE\rENCODING:USASCII\rCHARSET:1252\rCOMPRESSION:NONE\rOLDFILEUID:NONE\rNEWFILEUID:NONE\r}
      body   = open("spec/fixtures/sample.ofx").read.split(/<OFX>/, 2)[1]
      ofx_with_carriage_return = header + "<OFX>" + body

      @ofx = OFX::Parser::Base.new(ofx_with_carriage_return)
      expect(@ofx.headers.size).to be(9)
    end
  end

  def ofx_2_example(version)
    <<-EndOfx
<?xml version="1.0" encoding="US-ASCII"?>
<?OFX OFXHEADER="200" VERSION="#{version}" SECURITY="NONE" OLDFILEUID="NONE" NEWFILEUID="NONE"?>"
<OFX>
</OFX>
    EndOfx
  end
end
