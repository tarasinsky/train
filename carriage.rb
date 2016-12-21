class Carriage
  include InstanceCounter
  include Manufacturer
  include Validation

  class << self; attr_accessor :carriages_list; end

  attr_reader :number, :type

  CARRIAGE_NUMBER_FORMAT = /^[\d]{1}/

  @carriages_list = []

  def initialize(number, type)
    @number = number
    @type   = type

    Carriage.carriages_list << self if validate!
  end

  def self.all
    Carriage.carriages_list
  end

  def valid?
    validate!
  rescue
    false
  end

  protected

  attr_writer :number, :type

  def validate!
    raise 'Не указан номер вагона' unless validate(number, :presense)
    raise 'Длина номера вагона должна быть не менее 1 символа'      unless validate(number.size , :less_than, compare_to: 1)
    raise "Неверный формат номера вагона #{CARRIAGE_NUMBER_FORMAT}" unless validate(number      , :format   , regex: CARRIAGE_NUMBER_FORMAT)
    true
  end
end
