module Accessors
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def attr_accessor_with_history(*methods)
      methods.each do |method|
        raise TypeError.new("method name is not symbol") unless method.is_a?(Symbol)

        define_method(method) { instance_variable_get("@#{method}") }
        
        define_method("#{method}=") do |value|
          prev_value = instance_variable_get("@#{method}")

          instance_variable_set("@#{method}", value)

          instance_variable_set("@saved_history", {}) unless instance_variable_defined?("@saved_history")
          saved_history = instance_variable_get("@saved_history")
          saved_history[method] = [] unless saved_history[method].is_a?(Array)
          saved_history[method] << prev_value
          instance_variable_set("@saved_history", saved_history)
        end

        define_method("#{method}_history") { instance_variable_get("@saved_history")[method] }
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


class Test
  include Accessors

  strong_attr_accessor :at, String

  attr_accessor_with_history :hi, :ri

  def initialize
  end

  def t
    puts @@hi
  end
end

t=Test.new
t.hi=1
t.hi=2
t.hi=3

t.ri=11
t.ri=12
t.ri=13

puts "hi_history=#{t.hi_history}"

puts "ri_history=#{t.ri_history}"

t.at = 'test'
t.at = 1
t.at = []
