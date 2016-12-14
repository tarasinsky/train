class Carriage
  attr_reader :number
  attr_reader :type

  include InstanceCounter
  include Manufacturer

  CARRIAGE_NUMBER_FORMAT = /^\d{3}/

  @@carriages_list = []

  def initialize(number, type)
    @number = number
    @type   = type

    @@carriages_list << self if validate!
  end

  def self.all
    @@carriages_list
  end

  def valid?
    validate!
  rescue
    false
  end

  protected
  attr_writer :number
  attr_writer :type

  def validate!
    raise "Не указан номер вагона" if self.number.nil?
    raise "Длина номера вагона должна быть не менее 3 символов" if self.number.size < 3
    raise "Неверный формат номера вагона #{CARRIAGE_NUMBER_FORMAT}" if self.number !~ CARRIAGE_NUMBER_FORMAT
    true
  end

end