class CargoCarriage < Carriage
  CARRIAGE_TYPE = 'Cargo'

  def initialize(number)
    super(number, CARRIAGE_TYPE)
  end

end