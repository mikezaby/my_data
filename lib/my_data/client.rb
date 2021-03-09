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

    private

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
