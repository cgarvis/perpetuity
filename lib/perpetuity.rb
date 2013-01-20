require "perpetuity/version"
require "perpetuity/repository"

module Perpetuity
  class << self
    def repository
      @repository = Perpetuity::Repository.new unless defined?(@repository)
      @repository
    end

    def respond_to_missing?(method_name, include_private=false); repository.respond_to?(method_name, include_private); end if RUBY_VERSION >= "1.9"
    def respond_to?(method_name, include_private=false); repository.respond_to?(method_name, include_private) || super; end if RUBY_VERSION < "1.9"

    private

    def method_missing(method_name, *args, &block)
      return super unless repository.respond_to?(method_name)
      repository.send(method_name, *args, &block)
    end
  end
end
