require 'perpetuity'
require 'perpetuity/memory'
require 'perpetuity_shared'

describe Perpetuity::Memory do
  before(:all) do
    Perpetuity.configure { data_source Perpetuity::Memory.new }
  end

  it_behaves_like "mappable"
  it_behaves_like "persistable"
  it_behaves_like "crud"
  it_behaves_like "pagination"
end
