module Perpetuity
  module DataInjectable
    def inject_attribute object, attribute, value
      attribute = "@#{attribute}" unless attribute[0] == '@'
      object.instance_variable_set(attribute, value)
    end

    def inject_data object, data
      data.each_pair do |attribute,value|
        inject_attribute object, attribute, value
      end
      give_id_to object if object.instance_variables.include?(:@id)
    end

    def give_id_to object, *args
      object.define_singleton_method :id do
        args.first || object.instance_variable_get(:@id)
      end
    end
  end
end
