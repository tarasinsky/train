module Validation
  def self.included(base)
    base.extend(ClassMethods)
    base.include(InstanceMethods)
  end

  module ClassMethods
  end

  module InstanceMethods
    def validate(value, check_type, **args)
      case check_type
      when :presense
        result = !(value.nil? || value.empty?)
      when :format
        result = !(value !~ args[:regex])
      when :type
        result = !(value.is_a?(args[:is_class]))
      when :less_than
        result = !(value < args[:compare_to])
      end
      puts args[:error_message] if result && !args[:error_message].nil?
      result
    end

    def validate!
      case self.class
      when String
      end
    end

    def valid?
      validate!
    rescue
      false
    end
  end

end

class Test
  include Validation

  attr_accessor :val

end

a = "a"

t = Test.new
t.val = a

result = t.validate t.val, :presense
puts "presense #{result}"

t.val = "а"
name_format = /^[а-я]{1}/i
result = t.validate t.val, :format, regex: /^[а-я]{1}/i
puts "regex #{result}"

t.val = 1
result = t.validate t.val, :type, is_class: String
puts "class #{result}"

t.validate!
