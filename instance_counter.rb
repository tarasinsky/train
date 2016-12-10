module InstanceCounter
  def self.included(base)
    base.extend(ClassMethods)
    #base.send :include, InstanceMethods
    base.include(InstanceMethods)
  end

  module InstanceMethods
    protected
    def register_instance
      self.class.class_variable_set(:@@instance_counter, self.class.class_variable_get(:@@instance_counter) + 1)
    end
  end

  module ClassMethods
    def instances
      self.class_variable_get(:@@instance_counter)
    end
  end

end