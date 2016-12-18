class PassengerCarriage < Carriage
  attr_reader :seats

  CARRIAGE_TYPE = 'Passenger'.freeze

  def initialize(number, capacity)
    return unless validate(capacity)
    super(number, CARRIAGE_TYPE)
    @seats = Hash[(1..capacity).map { |seat_number| [seat_number, true] }]
  end

  def occupy_seat(preferred_number = 0)
    taken_seat = true
    if preferred_number.zero? && seats.key?(preferred_number) && seats[preferred_number]
      seats[preferred_number] = false
    else
      vacant_number = seats.key(true)
      if !vacant_number.nil?
        seats[vacant_number] = false
      else
        taken_seat = false
      end
    end
    taken_seat
  end

  def count_seats
    seats.size
  end

  def count_occupied_seats
    count_seats = 0
    seats.each_value { |vacant| count_seats += 1 unless vacant }
    count_seats
  end

  def count_free_seats
    count_seats = 0
    seats.each_value { |vacant| count_seats += 1 if vacant }
    count_seats
  end

  protected

  def validate(capacity)
    wrong_type_for_capacity = 'Неверный тип для количества мест в вагоне'
    raise wrong_type_for_capacity unless capacity.instance_of? Fixnum
    raise 'Неверно указано количество мест в вагоне' if capacity < 1
    true
  end
end
