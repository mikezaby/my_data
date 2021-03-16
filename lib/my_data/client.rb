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

    def send_invoices(invoice_doc)
      response = connection.post("SendInvoices", invoice_doc)

      data = response_body(response)["response_doc"]

      MyData::Resources::ResponseDoc.new(data)
    end

    def request_transmitted_docs(mark)
      response = connection.get("RequestTransmittedDocs", mark: mark)

      response_body(response)
    end

    private

    def response_body(response)
      body = response.body.sub(/^.+/, "").sub("</string>", "").strip.gsub("&lt;", "<").gsub("&gt;", ">")
      Hash.from_xml(body).deep_transform_keys { |k| k.underscore }
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
