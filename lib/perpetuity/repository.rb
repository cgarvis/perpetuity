require "perpetuity/retrieval"
require "perpetuity/mongodb"
require "perpetuity/config"
require "perpetuity/mapper"

module Perpetuity
  class Repository

    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def generate_mapper_for klass, &block
      Mapper.generate_for klass, &block
    end

    def has_mapper? klass
      mappers.has_key? klass
    end

    def [] klass
      mappers[klass].new
    end

    def []= klass, mapper
      mappers[klass] = mapper
    end

    def options
      configuration
    end

    protected

    def mappers
      @mappers ||= Hash.new { |_, klass| raise KeyError, "No mapper for #{klass}" }
    end
  end
end
