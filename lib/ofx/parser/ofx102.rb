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

      def account
        @account ||= build_account
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
      def build_account
        OFX::Account.new({
          :bank_id           => html.search("bankacctfrom > bankid").inner_text,
          :id                => html.search("bankacctfrom > acctid, ccacctfrom > acctid").inner_text,
          :type              => ACCOUNT_TYPES[html.search("bankacctfrom > accttype").inner_text.to_s.upcase],
          :transactions      => build_transactions,
          :balance           => build_balance,
          :available_balance => build_available_balance,
          :currency          => html.search("bankmsgsrsv1 > stmttrnrs > stmtrs > curdef, " +
                                            "creditcardmsgsrsv1 > ccstmttrnrs > ccstmtrs > curdef").inner_text
        })
      end

      def build_sign_on
        OFX::SignOn.new({
          :language          => html.search("signonmsgsrsv1 > sonrs > language").inner_text,
          :fi_id             => html.search("signonmsgsrsv1 > sonrs > fi > fid").inner_text,
          :fi_name           => html.search("signonmsgsrsv1 > sonrs > fi > org").inner_text
        })
      end

      def build_transactions
        html.search("banktranlist > stmttrn").collect do |element|
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
        BigDecimal.new(element.search("trnamt").inner_text)
      end

      def build_date(date)
        _, year, month, day, hour, minutes, seconds = *date.match(/(\d{4})(\d{2})(\d{2})(?:(\d{2})(\d{2})(\d{2}))?/)

        date = "#{year}-#{month}-#{day} "
        date << "#{hour}:#{minutes}:#{seconds}" if hour && minutes && seconds

        Time.parse(date)
      end

      def build_balance
        amount = html.search("ledgerbal > balamt").inner_text.to_f
        posted_at = build_date(html.search("ledgerbal > dtasof").inner_text) rescue nil

        OFX::Balance.new({
          :amount => amount,
          :amount_in_pennies => (amount * 100).to_i,
          :posted_at => posted_at
        })
      end

      def build_available_balance
        if html.search("availbal").size > 0
          amount = html.search("availbal > balamt").inner_text.to_f

          OFX::Balance.new({
            :amount => amount,
            :amount_in_pennies => (amount * 100).to_i,
            :posted_at => build_date(html.search("availbal > dtasof").inner_text)
          })
        else
          return nil
        end
      end
    end
  end
end
