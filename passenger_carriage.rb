class PassengerCarriage < Carriage
  attr_reader :seats, :capacity

  CARRIAGE_TYPE = 'Passenger'.freeze

  def initialize(number, capacity)
    @capacity = capacity
    return unless validate!
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

  def validate!
    raise 'Неверно указано количество мест в вагоне' unless validate(capacity, :less_than, compare_to: 1)
    true
  end
end
