module Validation
  def self.included(base)
    base.extend(ClassMethods2)
    base.include(InstanceMethods)
  end

  module ClassMethods
    def validate(value, check_type, **args)
      self.send check_type, value, args
    end

    def presense(value, args)
      !(value.nil? || value.empty?)
    end

    def format(value, args)
      !(value !~ args[:regex])
    end

    def is_type(value, args)
      !(value.is_a?(args[:is_class]))
    end

    def less_than(value, args)
      !(value < args[:compare_to])
    end
  end

  module ClassMethods2
    def validate(value, check_type, **args)
      class_variable_set(:@@validation_rules, []) unless class_variable_defined?(:@@validation_rules)
      rules = class_variable_get(:@@validation_rules)
      rules << {check_type => {:value => value, :args => args}}
      class_variable_set(:@@validation_rules, rules)
    end

    def presense(value, args)
      (value.nil? || value.empty?)
    end

    def format(value, args)
      (value !~ args[:regex])
    end

    def is_type(value, args)
      (value.instance_of?(args[:is_class]))
    end

    def less_than(value, args)
      (value < args[:compare_to])
    end
  end

  module InstanceMethods
  end
end
