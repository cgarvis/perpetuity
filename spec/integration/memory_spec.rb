require 'perpetuity'
require 'perpetuity/memory'
require 'perpetuity_shared'

describe Perpetuity::Memory do
  store = Perpetuity::Memory.new
  Perpetuity.configure { data_source store }

  it_behaves_like Perpetuity, Perpetuity
end
