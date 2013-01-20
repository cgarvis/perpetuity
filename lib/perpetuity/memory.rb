require 'securerandom'

module Perpetuity
  class Memory
    def initialize options = {}
      @cache    = Hash.new
      @indexes  = Hash.new { |hash, key| hash[key] = active_indexes(key) }
    end

    def insert klass, attributes
      unless attributes.has_key? :id
        attributes[:id] = SecureRandom.uuid
      end

      # make keys indifferent
      attributes.default_proc = proc do |h, k|
        case k
          when String then sym = k.to_sym; h[sym] if h.key?(sym)
          when Symbol then str = k.to_s; h[str] if h.key?(str)
        end
      end

      collection(klass) << attributes
      attributes[:id]
    end

    def count klass
      collection(klass).size
    end

    def delete_all klass
      collection(klass).clear
    end

    def first klass
      collection(klass).first
    end

    def retrieve klass, criteria, options = {}
      collection(klass).find_all do |r|
        criteria.all? do |field, value|
          r[field] === value
        end
      end
    end

    def all klass
      retrieve klass, {}, {}
    end

    def delete object, klass=nil
      klass ||= object.class
      id = object.class == String || !object.respond_to?(:id) ? object : object.id

      collection(klass).each_with_index do |record, index|
        if record[:id] === id
          collection(klass).delete_at index
        end
      end
    end

    def update klass, id, new_data
      collection(klass).each_with_index do |record, index|
        if record[:id] == id
          collection(klass)[index] = record.merge(new_data)
        end
      end
    end

    def can_serialize? value
      true
    end

    def index klass, attribute, options={}
      @indexes[klass] ||= Set.new
    end

    def indexes klass
      @indexes[klass]
    end

    def active_indexes klass
      Set.new
    end

    def activate_index! klass
      true
    end

    def remove_index index
    end

    protected

    def collection klass
      @cache[klass] = Array.new unless @cache.key? klass
      @cache[klass]
    end
  end
end
