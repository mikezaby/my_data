# frozen_string_literal: true

module MyData
  class Client
    BASE_URL = "https://mydata-dev.azure-api.net"

    def initialize(user_id:, subscription_key:)
      @user_id = user_id
      @subscription_key = subscription_key
    end

    def send_invoices(invoice_doc)
      response = connection.post("SendInvoices", invoice_doc)

      parse_response(
        response,
        resource: MyData::Resources::Response,
        root: "response_doc"
      )
    end

    def request_transmitted_docs(mark)
      response = connection.get("RequestTransmittedDocs", mark: mark)

      parse_response(
        response,
        resource: MyData::Resources::Inv::RequestDoc,
        root: "requested_doc"
      )
    end

    def cancel_invoice(mark)
      response = connection.post("CancelInvoice") do |req|
        req.params["mark"] = mark
      end

      parse_response(
        response,
        resource: MyData::Resources::Response,
        root: "response_doc"
      )
    end

    private

    def connection
      @connection ||= Faraday.new(BASE_URL) do |conn|
        conn.headers = headers
      end
    end

    def parse_response(response, resource:, root:)
      MyData::XmlParser.xml_to_hash(xml: response.body, resource: resource, root: root)
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
