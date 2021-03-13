# frozen_string_literal: true

module MyData
  class Client
    BASE_URL = "https://mydata-dev.azure-api.net"

    def initialize(user_id:, subscription_key:)
      @user_id = user_id
      @subscription_key = subscription_key
    end

    def connection
      @connection ||= Faraday.new(BASE_URL) do |conn|
        conn.headers = headers
      end
    end

    def send_invoice(invoice_doc)
      response = connection.post("SendInvoices", invoice_doc)

      response_parser(response.body)
    end

    private

    def response_parser(response)
      fixed_xml = response.sub(/^.+/, "").sub("</string>", "").strip
                          .gsub("&lt;", "<").gsub("&gt;", ">")
      data = Hash.from_xml(fixed_xml)["ResponseDoc"].deep_transform_keys { |k| k.underscore }

      MyData::Resources::ResponseDoc.new(data)
    end

    def headers
      @headers ||= {
        "Content-Type" => "application/xml",
        "Accept" => "application/xml",
        "aade-user-id" => @user_id,
        "Ocp-Apim-Subscription-Key" => @subscription_key
      }
    end
  end
end
