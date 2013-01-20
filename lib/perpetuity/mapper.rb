require 'perpetuity/attribute_set'
require 'perpetuity/attribute'
require 'perpetuity/validations'
require 'perpetuity/data_injectable'
require 'perpetuity/mapper_registry'
require 'perpetuity/serializer'

module Perpetuity
  class Mapper
    include DataInjectable

    def self.generate_for(klass, &block)
      mapper = Class.new(base_class)
      mapper.map klass
      mapper.instance_exec &block if block_given?
    end

    def self.map klass
      Perpetuity[klass] = self
      @mapped_class = klass
    end

    def self.attribute_set
      @attribute_set ||= AttributeSet.new
    end

    def self.attribute name, options = {}
      type = options.fetch(:type) { nil }
      attribute_set << Attribute.new(name, type, options)
    end

    def self.attributes
      attribute_set.map(&:name)
    end

    def self.index attribute, options={}
      data_source.index mapped_class, attribute_set[attribute], options
    end

    def remove_index! index
      data_source.remove_index index
    end

    def indexes
      data_source.indexes(mapped_class)
    end

    def reindex!
      indexes.each { |index| data_source.activate_index! index }
    end

    def attributes
      self.class.attributes
    end

    def delete_all
      data_source.delete_all mapped_class
    end

    def insert object
      raise "#{object} is invalid and cannot be persisted." unless self.class.validations.valid?(object)
      serializable_attributes = serialize(object)
      if o_id = object.instance_exec(&self.class.id)
        serializable_attributes[:id] = o_id
      end

      new_id = data_source.insert mapped_class, serializable_attributes
      give_id_to object, new_id
      new_id
    end

    def serialize object
      Serializer.new(self).serialize(object)
    end

    def self.data_source
      Perpetuity.configuration.data_source
    end

    def data_source
      self.class.data_source
    end

    def count
      data_source.count mapped_class
    end

    def self.mapped_class
      @mapped_class
    end

    def mapped_class
      self.class.mapped_class
    end

    def first
      retrieve.limit(1).first
    end

    def all
      retrieve
    end

    def retrieve criteria={}
      Perpetuity::Retrieval.new mapped_class, criteria
    end

    def select &block
      query = data_source.class::Query.new(&block).to_db
      retrieve query
    end

    def find id
      retrieve(id: id).first
    end

    def delete object
      data_source.delete object, mapped_class
    end

    def load_association! object, attribute
      reference = object.send(attribute)
      klass = reference.klass
      id = reference.id

      inject_attribute object, attribute, Perpetuity[klass].find(id)
    end

    def self.id &block
      if block_given?
        @id = block
      else
        @id ||= -> { nil }
      end
    end

    def update object, new_data, update_in_memory = true
      id = object.is_a?(mapped_class) ? object.id : object

      inject_data object, new_data if update_in_memory
      data_source.update mapped_class, id, new_data
    end

    def save object
      update object, serialize(object), false
    end

    def self.validate &block
      @validations ||= ValidationSet.new

      validations.instance_exec(&block)
    end

    def self.validations
      @validations ||= ValidationSet.new
    end

    private
    def self.base_class
      Mapper
    end
  end
end

