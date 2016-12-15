class PassengerCarriage < Carriage
  attr_reader :seats

  CARRIAGE_TYPE = 'Passenger'

  initialize(number, capacity)
    super(number, CARRIAGE_TYPE)
    @seats = Hash[(1..capacity).map { |seat_number| [seat_number, true] }] if validate!(capacity)
  end

  def take_seat
  end

  def occupied_seats
  	count_seats = 0
  	self.seats.each { |key, value| }
  end

  def free_seats
  end

  protected
  attr_writer :seats

  def validate!(capacity)
    raise "Неверно указано количество мест в вагоне" if !(capacity.instance_of? Integer)
    raise "Неверно указано количество мест в вагоне" if capacity < 1
    true
  end

end