require 'perpetuity'
require 'perpetuity_shared'

describe Perpetuity::MongoDB do
  store = Perpetuity::MongoDB.new db: 'perpetuity_gem_test'
  Perpetuity.configure { data_source store }

  it_behaves_like Perpetuity, Perpetuity
end
