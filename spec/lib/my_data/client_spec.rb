# frozen_string_literal: true

RSpec.describe MyData::Client do
  subject(:client) do
    described_class.new(
      user_id: "johndoe",
      subscription_key: "c9b79ff1841fb5cfecc66e1ea5a29b4d",
      environment: environment
    )
  end

  let(:environment) { :sandbox }

  describe "#request_transmitted_docs" do
    let(:response_parser) { client.request_transmitted_docs(mark: 1) }

    context "when environment is sandbox", vcr: { cassette_name: "request_transmitted_docs_success" } do
      it "reqests to sandbox" do
        expect(response_parser).to be_success
      end
    end

    context "when environment is production", vcr: { cassette_name: "request_production_transmitted_docs_success" } do
      let(:environment) { :production }

      it "reqests to production" do
        expect(response_parser).to be_success
      end
    end

    context "when request is successful", vcr: { cassette_name: "request_transmitted_docs_success" } do
      it "returns a MyData::ResponseParser" do
        expect(response_parser).to be_a(MyData::ResponseParser)
      end

      it "has response that is succeded" do
        expect(response_parser).to be_success
      end

      it "has empty errors" do
        expect(response_parser.errors).to be_empty
      end

      it "has responded_at" do
        expect(response_parser.responded_at).to eq(Time.parse("Thu, 18 Mar 2021 10:37:04 GMT"))
      end

      it "has response that is a MyData::Resources::Inv::RequestDoc" do
        expect(response_parser.response).to be_a(MyData::Resources::Inv::RequestDoc)
      end
    end

    context "when request is get access denied", vcr: { cassette_name: "request_transmitted_docs_error" } do
      it "returns a ResponseParser" do
        expect(response_parser).to be_a(MyData::ResponseParser)
      end

      it "has response that isn't succeded" do
        expect(response_parser).not_to be_success
      end

      it "has errors" do
        expect(response_parser.errors).to be_present
      end

      it "has responded_at" do
        expect(response_parser.responded_at).to eq(Time.parse("Thu, 18 Mar 2021 10:12:52 GMT"))
      end

      it "has nil response" do
        expect(response_parser.response).to be_nil
      end
    end
  end

  describe "#request_docs" do
    let(:response_parser) { client.request_docs(mark: 1) }

    context "when request is successful", vcr: { cassette_name: "request_docs_success" } do
      it "returns a MyData::ResponseParser" do
        expect(response_parser).to be_a(MyData::ResponseParser)
      end

      it "has response that is succeded" do
        expect(response_parser).to be_success
      end

      it "has empty errors" do
        expect(response_parser.errors).to be_empty
      end

      it "has response that is a MyData::Resources::Inv::RequestDoc" do
        expect(response_parser.response).to be_a(MyData::Resources::Inv::RequestDoc)
      end
    end

    context "when request is get access denied", vcr: { cassette_name: "request_docs_error" } do
      it "returns a ResponseParser" do
        expect(response_parser).to be_a(MyData::ResponseParser)
      end

      it "has response that isn't succeded" do
        expect(response_parser).not_to be_success
      end

      it "has errors" do
        expect(response_parser.errors).to be_present
      end

      it "has nil response" do
        expect(response_parser.response).to be_nil
      end
    end
  end

  describe "#send_invoices" do
    let(:response_parser) { client.send_invoices(doc: doc) }
    let(:doc) { "" }

    context "when there is a validation error", vcr: { cassette_name: "send_invoices_validation" } do
      it "returns a ResponseParser" do
        expect(response_parser).to be_a(MyData::ResponseParser)
      end

      it "has response that isn't succeded" do
        expect(response_parser).not_to be_success
      end

      it "cast response body to MyData::Resources::Response" do
        expect(response_parser.response).to be_a(MyData::Resources::Response)
      end

      it "has validation errors" do
        expect(response_parser.errors).to be_present
      end
    end

    context "when request is successful", vcr: { cassette_name: "send_invoices_success", match_requests_on: [:body] } do
      let(:doc) { build(:invoices_doc).to_xml }

      it "has response that is succeded" do
        expect(response_parser).to be_success
      end

      it "cast response body to MyData::Resources::Response" do
        expect(response_parser.response).to be_a(MyData::Resources::Response)
      end

      it "has proper invoice_uid" do
        expect(response_parser.response.response.first.invoice_uid).to eq("4626E9F44FAC8F6BB3B8BBF36EF21377E8202407")
      end

      it "has proper invoice_mark" do
        expect(response_parser.response.response.first.invoice_mark).to eq(400001832005979)
      end

      it "has empty errors" do
        expect(response_parser.errors).to be_empty
      end
    end

    context "when request is successful (myDATA API 1.0.7)", vcr: { cassette_name: "send_invoices_success_modified_v1_0_7", match_requests_on: [:body] } do
      let(:doc) { build(:invoices_doc).to_xml }

      it "has proper qr_url" do
        expect(response_parser.response.response.first.qr_url).to eq("https://mydataapidev.aade.gr/TimologioQR/QRInfo?q=encoded_string_replaced_on_cassette")
      end
    end
  end

  describe "#cancel_invoice" do
    let(:response_parser) { client.cancel_invoice(mark: mark) }

    context "when request is successful", vcr: { cassette_name: "cancel_invoice_success" } do
      let(:mark) { 400001831924171 }

      it "returns a MyData::ResponseParser" do
        expect(response_parser).to be_a(MyData::ResponseParser)
      end

      it "has response that is succeded" do
        expect(response_parser).to be_success
      end

      it "has empty errors" do
        expect(response_parser.errors).to be_empty
      end

      it "has response that is a MyData::Resources::Response" do
        expect(response_parser.response).to be_a(MyData::Resources::Response)
      end

      it "has response that is a MyData::Resources::Inv::RequestDoc" do
        expect(response_parser.response.response.first.cancellation_mark).to eq(400001832031421)
      end
    end

    context "when has validation errors", vcr: { cassette_name: "cancel_invoice_validation" } do
      let(:mark) { 101 }

      it "returns a ResponseParser" do
        expect(response_parser).to be_a(MyData::ResponseParser)
      end

      it "has response that isn't succeded" do
        expect(response_parser).not_to be_success
      end

      it "has errors" do
        expect(response_parser.errors).to be_present
      end

      it "cast response body to MyData::Resources::Response" do
        expect(response_parser.response).to be_a(MyData::Resources::Response)
      end
    end
  end
end
