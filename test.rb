require_relative 'instance_counter'

class Test

  @@instance_counter = 0
  include InstanceCounter

  def initialize

    register_instance
    #@@instance_counter += 1
    #puts "S"
    
  end

 #def self.instances
  #    @@instance_counter
  #end

    #def register_instance
    #  @@instance_counter += 1
    #end
 


end