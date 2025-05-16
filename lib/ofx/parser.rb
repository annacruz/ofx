module OFX
  module Parser
    class Base
      attr_reader :headers
      attr_reader :body
      attr_reader :content
      attr_reader :parser

      def initialize(resource)
        resource = open_resource(resource)
        resource.rewind
        begin
          @content = convert_to_utf8(resource.read)
          @headers, @body = prepare(content)
        rescue
          raise OFX::UnsupportedFileError
        end

        case headers["VERSION"]
        when /100|102/ then
          @parser = OFX102.new(:headers => headers, :body => body)
        when /103/ then
          @parser = OFX103.new(:headers => headers, :body => body)
        when /200|202|211|220/ then
          @parser = OFX211.new(:headers => headers, :body => body)
        else
          raise OFX::UnsupportedFileError
        end
      end

      def open_resource(resource)
        if resource.respond_to?(:read)
          resource
        else
          open(resource)
        end
      rescue
        StringIO.new(resource)
      end

      private
      def prepare(content)
        # split headers & body
        header_text, body = content.dup.split(/<OFX>/, 2)

        raise OFX::UnsupportedFileError unless body

        # Header format is different between versions. Give each
        # parser a chance to parse the headers.
        headers = nil

        OFX::Parser.constants.grep(/OFX/).each do |name|
          headers = OFX::Parser.const_get(name).parse_headers(header_text)
          break if headers
        end

        # Replace body tags to parse it with Nokogiri
        body.gsub!(/>\s+</m, "><")
        body.gsub!(/\s+</m, "<")
        body.gsub!(/>\s+/m, ">")
        body.gsub!(/<(\w+?)>([^<]+)/m, '<\1>\2</\1>')

        [headers, body]
      end

      def convert_to_utf8(string)
        return string if Kconv.isutf8(string)
        string.encode("UTF-8", "ISO-8859-1")
      end
    end
  end
end
