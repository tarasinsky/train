module Accessors
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def attr_accessor_with_history(*methods)
      methods.each do |method|
        saved_history_var = '@saved_history'

        define_method(method) { instance_variable_get("@#{method}") }
        
        define_method("#{method}=") do |value|
          prev_value = instance_variable_get("@#{method}")

          instance_variable_set("@#{method}", value)

          instance_variable_set(saved_history_var, {}) unless instance_variable_defined?(saved_history_var)
          saved_history = instance_variable_get(saved_history_var)
          saved_history[method] ||= []
          saved_history[method] << prev_value
          instance_variable_set(saved_history_var, saved_history)
        end

        define_method("#{method}_history") { instance_variable_get(saved_history_var)[method] }
      end
    end

    def strong_attr_accessor(attr_name, attr_class)
      attr_sym = attr_name.to_sym
      define_method(attr_sym) { instance_variable_get("@#{attr_sym}") }
      
      define_method("#{attr_name}=") do |value|
        if value.is_a?(attr_class)
          instance_variable_set("@#{attr_name}", value)
        else
          raise TypeError.new("Wrong class #{value.class} for #{value}, not #{attr_class}")
        end
      end
    end
  end
end
