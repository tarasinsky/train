class Carriage
  attr_reader :number
  attr_reader :type

  @@carriages_list = []

  def initialize(number, type)
    @number = number
    @type   = type
  end

  def self.enlist_carriage(carriage)
    @@carriages_list[@@carriages_list.size] = carriage
  end

  def self.list_carriages()
    @@carriages_list
  end

  protected
  attr_writer :number
  attr_writer :type
end