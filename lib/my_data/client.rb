# frozen_string_literal: true

module MyData
  class Client
    BASE_URL = {
      sandbox: "https://mydataapidev.aade.gr",
      production: "https://mydatapi.aade.gr/myDATA/"
    }.freeze

    def initialize(user_id:, subscription_key:, environment:)
      @user_id = user_id
      @subscription_key = subscription_key
      @environment = environment
    end

    def send_invoices(doc:)
      response = connection.post("SendInvoices", doc)

      parse_response(
        response,
        resource: MyData::Resources::Response,
        root: "response_doc"
      )
    end

    def request_docs(mark:, next_partition_key: nil, next_row_key: nil)
      base_request_docs(
        endpoint: "RequestDocs",
        mark: mark,
        next_partition_key: next_partition_key,
        next_row_key: next_row_key
      )
    end

    def request_transmitted_docs(mark:, next_partition_key: nil, next_row_key: nil)
      base_request_docs(
        endpoint: "RequestTransmittedDocs",
        mark: mark,
        next_partition_key: next_partition_key,
        next_row_key: next_row_key
      )
    end

    def cancel_invoice(mark:)
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

    def base_request_docs(endpoint:, mark:, next_partition_key:, next_row_key:)
      params = { mark: mark }

      if next_partition_key && next_row_key
        params.merge!(nextPartitionKey: next_partition_key, nextRowKey: next_row_key)
      end

      response = connection.get(endpoint, params)

      parse_response(
        response,
        resource: MyData::Resources::Inv::RequestDoc,
        root: "requested_doc"
      )
    end

    def connection
      @connection ||= Faraday.new(BASE_URL[@environment]) do |conn|
        conn.headers = headers
      end
    end

    def parse_response(response, resource:, root:)
      MyData::ResponseParser.new(response, resource: resource, root: root)
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
