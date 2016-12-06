class PassengerCarriage < Carriage
  CARRIAGE_TYPE = 'Passenger'

  def initialize(number)
    super(number, CARRIAGE_TYPE)
  end

end