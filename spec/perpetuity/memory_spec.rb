require 'perpetuity/memory'
require 'date'

module Perpetuity
  describe Memory do
    let(:store) { Memory.new }
    let(:klass) { String }
    subject { store }

    describe 'initialization params' do
    end

    it 'removes all documents from a collection' do
      store.insert klass, {}
      store.delete_all klass
      store.count(klass).should == 0
    end

    it 'counts the documents in a collection' do
      store.delete_all klass
      3.times do
        store.insert klass, {}
      end
      store.count(klass).should == 3
    end

    it 'gets the first document in a collection' do
      value = {value: 1}
      store.insert klass, value
      store.first(klass)[:hypothetical_value].should == value['value']
    end

    it 'gets all of the documents in a collection' do
      values = [{value: 1}, {value: 2}]
      values.each do |value|
        store.insert klass, value
      end

      store.all(klass).should == values
    end

    it 'retrieves by id' do
      time = Time.now.utc
      id = store.insert klass, {"inserted" => time}

      objects = store.retrieve(klass, id: id).to_a
      objects.map{|i| i["inserted"].to_f}.first.should be_within(0.001).of time.to_f
    end

    it 'updates by id' do
      time = Time.now.utc

      id = store.insert klass, {"modified_at" => time - 8600}
      store.update klass, id, {"modified_at" => time}

      objects = store.retrieve(klass, id: id).to_a
      objects.map{|i| i["modified_at"].to_f}.first.should be_within(0.001).of time.to_f
    end

    it 'deletes by id' do
      time = Time.now.utc
      id = store.insert klass, {"modified_at" => time}

      store.count(klass).should == 1
      store.delete id, klass
      store.count(klass).should == 0
    end
  end
end

