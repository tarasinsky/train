class Carriage
  attr_reader :number
  attr_reader :type

  def initialize(number, type)
    @number = number
    @type   = type
  end

  protected
  attr_writer :number
  attr_writer :type
end