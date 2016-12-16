class Train

  TRAIN_NUMBER_FORMAT = /^[а-я\d]{3}-?[а-я\d]{2}$/

  attr_reader   :number
  attr_reader   :type
  attr_accessor :speed
  attr_accessor :carriages
  attr_accessor :current_station_index
  attr_accessor :route

  include Manufacturer
  include InstanceCounter

  @@trains_list = {}

  def initialize(number, type)
    
    @number = number
    @type = type

    @speed = 0
    @route = nil
    @current_station_index = nil
    @carriages = []

    @@trains_list[number] = self if validate!

  end

  def move(speed)
    self.speed = speed if speed > 0 
  end

  def break
    self.speed = 0
  end

  def hitch_carriage(carriage)
    if carriage_ready?(carriage)
      self.carriages << carriage
    end
  end

  def unhitch_carriage(carriage)
    if carriage_ready?(carriage)
      self.carriages.delete(carriage)
    end
  end

  def assign_route(route)
    self.route = route
  end

  def set_initial_station
    self.current_station_index = 0
  end

  def current_station
    if exist_train_route?
      puts "Current station for the train is '#{self.route.list[self.current_station_index].name}'"
    end
  end

  def next_station
    if exist_train_route?
      if self.current_station_index >= (self.route.list.size - 1)
        puts "Already at the final station for the train '#{self.number}'"
      else
        puts "Next station for the train is '#{self.number}' is '#{self.route.list[self.current_station_index+1].name}'"
      end
    end
  end
  
  def prev_station
    if exist_train_route?
      if self.current_station_index == 0
        puts "Already at the start station for the train '#{self.number}'"
      else
        puts "Previous station for the train is '#{self.number}' is '#{self.route.list[self.current_station_index-1].name}'"
      end
    end
  end

  def self.all
    @@trains_list
  end

  def self.find(train_number)
    @@trains_list[train_number]
  end

  # forward: true - вперед, false - назад
  def move_by_route(forward=true)
    
    if exist_train_route?

      depart_from_station()

      train_start_speed_kmh   = 5
      train_regular_speed_kmh = 60

      move (train_start_speed_kmh  )
      move (train_regular_speed_kmh)
      move (train_start_speed_kmh  )

      arrive_to_station(forward)
      brake
          
    end

  end

  def valid?
    validate!
  rescue
    false
  end

  def count_carriages
    self.carriages.size
  end

  def each_carriage
    self.carriages.each { |carriage| yield carriage } if block_given?
  end

  protected

  def arrive_to_station(forward)
    if forward
      next_station = self.route.list[self.current_station_index + 1]
    else
      next_station = self.route.list[self.current_station_index - 1]
    end
    next_station.arrive(self)
  end

  def depart_from_station
    current_station = self.route.list[self.current_station_index]
    current_station.depart(self)
  end

  def carriage_ready?(carriage)
    carriage_ready = false
    if self.speed > 0
      raise "Невозможно выполнить операцию с вагоном во время движения поезда. #{self.speed}"
    elsif carriage.type != self.type
      raise "Неверный тип вагона"
    else
      carriage_ready = true
    end
    carriage_ready
  end

  def validate!
    raise "Неверный тип номера поезда"    if !(self.number.instance_of? String)
    raise "Неверный тип типа поезда"      if !(self.type.instance_of? String  )

    raise "Не указан номер поезда"        if self.number.nil?
    raise "Длина номера поезда должна быть не менее 5 символов" if self.number.size < 5
    raise "Неверный формат номера поезда #{TRAIN_NUMBER_FORMAT}" if self.number !~ TRAIN_NUMBER_FORMAT
    true
  end

end