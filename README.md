# AADE MyData ruby client

[![Gem Version](https://badge.fury.io/rb/my_data.svg)](https://rubygems.org/gems/my_data)
[![GitHub Actions CI](https://github.com/mikezaby/my_data/actions/workflows/ci.yml/badge.svg)](https://github.com/mikezaby/my_data/actions/workflows/ci.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/7a96aa72dce8a761467d/maintainability)](https://codeclimate.com/github/mikezaby/my_data/maintainability)

A Ruby client for [AADE myDATA](https://www.aade.gr/mydata) API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'my_data'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install my_data

## Resources
There are all the [resources](https://github.com/mikezaby/my_data/tree/master/lib/my_data/resources)
that are specified by the given
[xsd files](https://www.aade.gr/sites/default/files/2020-11/version%20v1.0.2%20XSDs.zip) from AADE.

e.g.
```irb
irb> MyData::Resources::Inv::PartyType
=> MyData::Resources::Inv::PartyType vat_number: string, country: string, branch: integer, name: string, address: MyData::Resources::Inv::AddressType
```

## Usage

#### Initialize client
```ruby
# You could set environment to :sandbox or :production
client = MyData::Client.new(
  user_id: "johndoe", 
  subscription_key: "c9b79ff1841fb5cfecc66e1ea5a29b4d",
  environment: :sandbox
)
```

#### Send invoices
```ruby
invoice_data = {
  issuer: { vat_number: "111111111", country: "GR", branch: 0 },
  invoice_header: { series: "A", aa: "1", issue_date: "2021-02-21", invoice_type: "11.2", currency: "EUR" },
  invoice_details: [{
    line_number: "1",
    net_value: 100.00,
    vat_category: 1,
    vat_amount: 24.00,
    income_classification: [{ classification_type: "E3_561_003", classification_category: "category1_3", amount: 100.00 }]
  }],
  invoice_summary: {
    total_net_value: 100.00,
    total_vat_amount: 24.00,
    total_withheld_amount: 0.0,
    total_fees_amount: 0.0,
    total_stamp_duty_amount: 0.0,
    total_other_taxes_amount: 0.0,
    total_deductions_amount: 0.0,
    total_gross_value: 124.00,
    income_classification: [{ classification_type: "E3_561_003", classification_category: "category1_3", amount: 100.00 }]
  },
  payment_methods: [{ type: 3, amount: 124.00 }]
}

invoices_doc = MyData::Resources::Inv::InvoicesDoc.new(invoice: [invoice_data])
client.send_invoices(doc: invoices_doc.to_xml)
```

#### Request transmitted docs
```ruby
client.request_transmitted_docs(mark: 1)
```

#### Cancel Invoice
  ```ruby
client.cancel_invoice(mark: 400001831924171)
  ```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mikezaby/my_data.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
