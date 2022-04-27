# frozen_string_literal: true

RSpec.describe MyData do
  it "has a version number" do
    expect(MyData::VERSION).not_to be_nil
  end
end
