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
        @content = convert_to_utf8(resource.read)

        begin
          @headers, @body = prepare(content)
        rescue Exception
          raise OFX::UnsupportedFileError
        end

        case @headers["VERSION"]
        when /102/ then
          @parser = OFX::Parser::OFX102.new(:headers => headers, :body => body)
        when /200|211/ then
          @parser = OFX::Parser::OFX211.new(:headers => headers, :body => body)
        else
          raise OFX::UnsupportedFileError
        end
      end

      def open_resource(resource)
        if resource.respond_to?(:read)
          return resource
        else
          begin
            return open(resource)
          rescue
            return StringIO.new(resource)
          end
        end
      end

      private
      def prepare(content)
        # split headers & body
        header_text, body = content.dup.split(/<OFX>/, 2)

        raise OFX::UnsupportedFileError unless body

        # Header format is different between versions. Give each
        # parser a chance to parse the headers.
        headers = OFX::Parser::OFX102.parse_headers(header_text)
        headers ||= OFX::Parser::OFX211.parse_headers(header_text)

        # Replace body tags to parse it with Nokogiri
        body.gsub!(/>\s+</m, '><')
        body.gsub!(/\s+</m, '<')
        body.gsub!(/>\s+/m, '>')
        body.gsub!(/<(\w+?)>([^<]+)/m, '<\1>\2</\1>')

        [headers, body]
      end

      def convert_to_utf8(string)
        return string if Kconv.isutf8(string)
        Iconv.conv('UTF-8', 'LATIN1//IGNORE', string)
      end
    end
  end
end
