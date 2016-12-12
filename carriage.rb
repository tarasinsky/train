class Carriage
  attr_reader :number
  attr_reader :type

  include InstanceCounter
  include Manufacturer

  @@carriages_list = []

  def initialize(number, type)
    @number = number
    @type   = type

    @@carriages_list << self
  end

  def self.all
    @@carriages_list
  end

  protected
  attr_writer :number
  attr_writer :type
end