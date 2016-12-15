class PassengerCarriage < Carriage
  attr_reader :seats

  CARRIAGE_TYPE = 'Passenger'

  def initialize(number, capacity)
    if validate(capacity)
      super(number, CARRIAGE_TYPE)
      @seats = Hash[(1..capacity).map { |seat_number| [seat_number, true] }] 
    end
  end

  def occupy_seat(preferred_number=0)
    taken_seat = false
    if preferred_number == 0 && self.seats.key?(preferred_number) && self.seats.key(preferred_number)
      self.seats[preferred_number] = false
      taken_seat = true
    else
      vacant_number = self.seats.key(true)
      if !vacant_number.nil?
        self.seats[vacant_number] = false 
        taken_seat = true
      end
    end
    taken_seat
  end

  def count_seats
    self.seats.size
  end

  def count_occupied_seats
  	count_seats = 0
  	self.seats.each_value { |vacant| count_seats += 1 if !vacant }
    count_seats
  end

  def count_free_seats
    count_seats = 0
    self.seats.each_value { |vacant| count_seats += 1 if vacant }
    count_seats
  end

  protected

  def validate(capacity)
    raise "Неверный тип для количества мест в вагоне" if !(capacity.instance_of? Fixnum)
    raise "Неверно указано количество мест в вагоне" if capacity < 1
    true
  end

end