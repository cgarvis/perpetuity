require 'perpetuity'
require "perpetuity/mongodb"
require 'perpetuity_shared'

describe Perpetuity::MongoDB do
  context do
    Perpetuity.configure { Perpetuity::MongoDB.new db: 'perpetuity_gem_test' }
    it_behaves_like Perpetuity
  end
end
