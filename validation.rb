module Validation
  def self.included(base)
    base.extend(ClassMethods)
    base.include(InstanceMethods)
  end

  module ClassMethods
    def validate(attr_name, check_type, **args)
      class_variable_set(:@@validation_rules, []) unless class_variable_defined?(:@@validation_rules)
      rules = class_variable_get(:@@validation_rules)
      rules << { check_type => {:attr_name => attr_name, :args => args} }
      class_variable_set(:@@validation_rules, rules)
    end
  end

  module InstanceMethods
    def presense(value, args)
      raise 'No value' if value.nil?
    end

    def format(value, args)
      raise "Don't match #{args[:regex]}" if (value !~ args[:regex])
    end

    def is_type(value, args)
      raise "Not #{args[:is_class]}" unless (value.instance_of?(args[:is_class]))
    end

    def less_than(value, args)
      raise "Not < #{args[:compare_to]}" unless (value < args[:compare_to])
    end

    def validate!
      class_ref = self.class
      return unless class_ref.class_variable_defined?(:@@validation_rules)
      rules = class_ref.class_variable_get(:@@validation_rules)
      rules.each do |rule|
        rule.each do |method, params|
          value = instance_variable_get("@#{params[:attr_name]}")
          send method, value, params[:args]
        end
      end
      true
    end

    def valid?
      begin
        validate!
      rescue
        false
      end
    end
  end
end
