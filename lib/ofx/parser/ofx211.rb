module OFX
  module Parser
    class OFX211 < OFX102
      VERSION = "2.1.1"

      def self.parse_headers(header_text)
        doc = Nokogiri::XML(header_text)

        # Nokogiri can't search for processing instructions, so we
        # need to do this manually.
        doc.children.each do |e|
          if e.type == Nokogiri::XML::Node::PI_NODE && e.name == "OFX"
            # Getting the attributes from the element doesn't seem to
            # work either.
            return extract_headers(e.text)
          end
        end

        nil
      end

      private
      def self.extract_headers(text)
        headers = {}
        text.split(/\s+/).each do |attr_text|
          match = /(.+)="(.+)"/.match(attr_text)
          next unless match
          k, v = match[1], match[2]
          headers[k] = v
        end
        headers
      end

      def self.strip_quotes(s)
        return unless s
        s.sub(/^"(.*)"$/, '\1')
      end
    end
  end
end
