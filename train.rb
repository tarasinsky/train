class Train
  include Manufacturer
  include InstanceCounter
  include Accessor

  class << self; attr_accessor :trains_list; end

  attr_reader   :number, :type, :route
  attr_accessor :speed, :carriages, :current_station_index

  TRAIN_NUMBER_FORMAT = /^[а-я\d]{3}-?[а-я\d]{2}$/

  @trains_list = {}

  def initialize(number, type)
    @number = number
    @type = type

    @speed = 0
    @route = nil
    @current_station_index = nil
    @carriages = []

    Train.trains_list[number] = self if validate!
  end

  def move(set_speed)
    speed = set_speed if set_speed > 0
  end

  def break
    speed = 0
  end

  def hitch_carriage(carriage)
    carriages << carriage if carriage_ready?(carriage)
  end

  def unhitch_carriage(carriage)
    carriages.delete(carriage) if carriage_ready?(carriage)
  end

  def assign_route(new_route)
    route = new_route
  end

  def set_initial_station
    current_station_index = 0
  end

  def current_station
    current_station_name = route.list[current_station_index].name
    announce_text = "Current station for the train is '#{current_station_name}'"
    puts announce_text if exist_train_route?
  end

  def next_station
    return unless exist_train_route?
    if current_station_index >= (route.list.size - 1)
      announce_text = "Already at the final station for the train '#{number}'"
    else
      next_station_name = route.list[current_station_index + 1].name
      announce_text = "Next station for the train is '#{number}' is '#{next_station_name}'"
    end
    puts announce_text
  end

  def prev_station
    return unless exist_train_route?
    if current_station_index.zero?
      announce_text = "Already at the start station for the train '#{number}'"
    else
      prev_station_name = route.list[current_station_index - 1].name
      announce_text = "Previous station for the train is '#{number}' is '#{prev_station_name}'"
    end
    puts announce_text
  end

  # forward: true - ahead, false - reverse
  def move_by_route(forward = true)
    return unless exist_train_route?
    depart_from_station

    train_start_speed_kmh   = 5
    train_regular_speed_kmh = 60

    move train_start_speed_kmh
    move train_regular_speed_kmh
    move train_start_speed_kmh

    arrive_to_station forward
    brake
  end

  def self.all
    Train.trains_list
  end

  def self.find(train_number)
    Train.trains_list[train_number]
  end

  def count_carriages
    carriages.size
  end

  def each_carriage
    carriages.each { |carriage| yield carriage } if block_given?
  end

  def valid?
    validate!
  rescue
    false
  end

  protected

  attr_writer :route

  def arrive_to_station(forward)
    if forward
      next_station = route.list[current_station_index + 1]
    else
      next_station = route.list[current_station_index - 1]
    end
    next_station.arrive(self)
  end

  def depart_from_station
    current_station = route.list[current_station_index]
    current_station.depart(self)
  end

  def carriage_ready?(carriage)
    carriage_ready = false
    if speed > 0
      raise "Невозможно выполнить операцию с вагоном #{carriage.number} во время движения поезда. #{speed}"
    elsif carriage.type != type
      raise "Неверный тип вагона #{carriage.number}"
    else
      carriage_ready = true
    end
    carriage_ready
  end

  def validate!
    raise 'Неверный тип номера поезда'    unless number.instance_of? String
    raise 'Неверный тип типа поезда'      unless type.instance_of? String

    raise 'Не указан номер поезда'        if number.nil?
    raise 'Длина номера поезда должна быть не менее 5 символов' if number.size < 5
    raise "Неверный формат номера поезда #{TRAIN_NUMBER_FORMAT}" if number !~ TRAIN_NUMBER_FORMAT
    true
  end
end
