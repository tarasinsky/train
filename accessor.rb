module Accessor
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def attr_accessor_with_history(*methods)
      methods.each do |method|
        raise TypeError.new("method name is not symbol") unless method.is_a?(Symbol)
        method_name = method.to_s
        define_method(method) do
          self.class_variable_get("@@#{method_name}") if self.class_variable_defined?("@@#{method_name}")
        end
        define_method("#{method}=") do |value|
          self.class_variable_set("@@#{method_name}", value)
        end

        #history_method = "@@#{method}_history"
        #history_method_name = history_method.to_sym
        #define_method(history_method) do
        #  self.class_variable_get(history_method_name) if self.class_variable_defined?(history_method_name)
        #end
      end
    end
  end
end


class Test
  include Accessor

  attr_accessor_with_history :hi
end