require 'perpetuity'
require 'perpetuity/memory'
require 'perpetuity_shared'

describe Perpetuity::Memory do
  context do
    Perpetuity.configure { data_source Perpetuity::Memory.new }
    it_behaves_like Perpetuity
  end
end
