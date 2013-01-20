require 'perpetuity'
require "perpetuity/mongodb"
require 'perpetuity_shared'

describe Perpetuity::MongoDB do
  context do
    Perpetuity.configure { Perpetuity::MongoDB.new db: 'perpetuity_gem_test' }

    it_behaves_like "mappable"
    it_behaves_like "persistable"
    it_behaves_like "crud"
    it_behaves_like "pagination"
    it_behaves_like "associations"
    it_behaves_like "validation"
    it_behaves_like "scopable"
    it_behaves_like "indexable"
  end
end
