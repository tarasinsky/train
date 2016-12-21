module Validation
  def self.included(base)
    base.extend(ClassMethods)
    base.include(InstanceMethods)
  end

  module ClassMethods
  end

  module InstanceMethods
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
end
