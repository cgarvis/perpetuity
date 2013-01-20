require 'perpetuity/mapper'

module Perpetuity
  describe Mapper do
    let(:mapper_class) { Class.new(Mapper) }
    let(:mapper) { mapper_class.new }
    subject { mapper }

    it { should be_a Mapper }

    it 'has correct attributes' do
      Class.new(Mapper) { attribute :name }.attributes.should eq [:name]
    end

    it 'returns an empty attribute list when no attributes have been assigned' do
      Mapper.attributes.should be_empty
    end

    it 'can have embedded attributes' do
      mapper_with_embedded_attrs = Class.new(Mapper)
      mapper_with_embedded_attrs.attribute :comments, embedded: true
      mapper_with_embedded_attrs.attribute_set[:comments].should be_embedded
    end

    context 'with unserializable embedded attributes' do
      let(:unserializable_object) { 1.to_c }
      let(:serialized_attrs) do
        [ Marshal.dump(unserializable_object) ]
      end

      it 'serializes attributes' do
        object = Object.new
        object.instance_variable_set '@sub_objects', [unserializable_object]
        mapper_class.attribute :sub_objects, embedded: true
        mapper_class.map Object
        data_source = double(:data_source)
        mapper.stub(data_source: data_source)
        data_source.should_receive(:can_serialize?).with(unserializable_object).and_return false

        mapper.serialize(object)['sub_objects'].should eq serialized_attrs
      end
    end

    describe 'subclassing Mapper' do
      let!(:mapper_subclass) { Class.new(Mapper) { map String } }
      let(:mapper) { mapper_subclass.new }

      it 'can explicitly map a class' do
        Perpetuity[String].should be_instance_of mapper_subclass
      end
    end
  end
end
