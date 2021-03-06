module InstanceCounter
  def self.included(base)
    base.extend(ClassMethods)
    base.include(InstanceMethods)
  end

  module InstanceMethods
    protected
    def register_instance
      class_ref = self.class
      class_ref.class_variable_set(:@@instance_counter, 0) unless class_ref.class_variable_defined?(:@@instance_counter)
      class_ref.class_variable_set(:@@instance_counter, class_ref.class_variable_get(:@@instance_counter) + 1)
    end
  end

  module ClassMethods
    def instances
      self.class_variable_get(:@@instance_counter)
    end
  end
end
