module OFX
  module Parser
    class OFX102
      VERSION = "1.0.2"

      ACCOUNT_TYPES = {
        "CHECKING" => :checking
      }

      TRANSACTION_TYPES = [
        'ATM', 'CASH', 'CHECK', 'CREDIT', 'DEBIT', 'DEP', 'DIRECTDEBIT', 'DIRECTDEP', 'DIV',
        'FEE', 'INT', 'OTHER', 'PAYMENT', 'POS', 'REPEATPMT', 'SRVCHG', 'XFER'
      ].inject({}) { |hash, tran_type| hash[tran_type] = tran_type.downcase.to_sym; hash }

      attr_reader :headers
      attr_reader :body
      attr_reader :html

      def initialize(options = {})
        @headers = options[:headers]
        @body = options[:body]
        @html = Nokogiri::HTML.parse(body)
      end

      def accounts
        @accounts ||= html.search("stmttrnrs, ccstmttrnrs").collect { |node| build_account(node) }
      end

      # DEPRECATED: kept for legacy support
      def account
        @account ||= build_account(html.search("stmttrnrs, ccstmttrnrs").first)
      end

      def sign_on
        @sign_on ||= build_sign_on
      end

      def self.parse_headers(header_text)
        # Change single CR's to LF's to avoid issues with some banks
        header_text.gsub!(/\r(?!\n)/, "\n")

        # Parse headers. When value is NONE, convert it to nil.
        headers = header_text.to_enum(:each_line).inject({}) do |memo, line|
          _, key, value = *line.match(/^(.*?):(.*?)\s*(\r?\n)*$/)

          unless key.nil?
            memo[key] = value == "NONE" ? nil : value
          end

          memo
        end

        return headers unless headers.empty?
      end

      private
      def build_account(node)
        OFX::Account.new({
          :bank_id           => node.search("bankacctfrom > bankid").inner_text,
          :id                => node.search("bankacctfrom > acctid, ccacctfrom > acctid").inner_text,
          :type              => ACCOUNT_TYPES[node.search("bankacctfrom > accttype").inner_text.to_s.upcase],
          :transactions      => build_transactions(node),
          :balance           => build_balance(node),
          :available_balance => build_available_balance(node),
          :currency          => node.search("stmtrs > curdef, ccstmtrs > curdef").inner_text
        })
      end

      def build_sign_on
        OFX::SignOn.new({
          :language          => html.search("signonmsgsrsv1 > sonrs > language").inner_text,
          :fi_id             => html.search("signonmsgsrsv1 > sonrs > fi > fid").inner_text,
          :fi_name           => html.search("signonmsgsrsv1 > sonrs > fi > org").inner_text
        })
      end

      def build_transactions(node)
        node.search("banktranlist > stmttrn").collect do |element|
          build_transaction(element)
        end
      end

      def build_transaction(element)
        OFX::Transaction.new({
          :amount            => build_amount(element),
          :amount_in_pennies => (build_amount(element) * 100).to_i,
          :fit_id            => element.search("fitid").inner_text,
          :memo              => element.search("memo").inner_text,
          :name              => element.search("name").inner_text,
          :payee             => element.search("payee").inner_text,
          :check_number      => element.search("checknum").inner_text,
          :ref_number        => element.search("refnum").inner_text,
          :posted_at         => build_date(element.search("dtposted").inner_text),
          :type              => build_type(element),
          :sic               => element.search("sic").inner_text
        })
      end

      def build_type(element)
        TRANSACTION_TYPES[element.search("trntype").inner_text.to_s.upcase]
      end

      def build_amount(element)
        to_decimal(element.search("trnamt").inner_text)
      end

      def build_date(date)
        _, year, month, day, hour, minutes, seconds = *date.match(/(\d{4})(\d{2})(\d{2})(?:(\d{2})(\d{2})(\d{2}))?/)

        date = "#{year}-#{month}-#{day} "
        date << "#{hour}:#{minutes}:#{seconds}" if hour && minutes && seconds

        Time.parse(date)
      end

      def build_balance(node)
        value = node.search("ledgerbal > balamt").inner_text
        amount = to_decimal(set_zero_in_empty(value))
        posted_at = build_date(node.search("ledgerbal > dtasof").inner_text) rescue nil

        OFX::Balance.new({
          :amount => amount,
          :amount_in_pennies => (amount * 100).to_i,
          :posted_at => posted_at
        })
      end

      def build_available_balance(node)
        if node.search("availbal").size > 0
          value = node.search("availbal > balamt").inner_text
          amount = to_decimal(set_zero_in_empty(value))

          OFX::Balance.new({
            :amount => amount,
            :amount_in_pennies => (amount * 100).to_i,
            :posted_at => build_date(node.search("availbal > dtasof").inner_text)
          })
        else
          return nil
        end
      end

      def to_decimal(amount)
        BigDecimal(amount.to_s.gsub(',', '.'))
      end

      def set_zero_in_empty(value)
        value.empty? ? 0 : value
      end
    end
  end
end
