class Station
  attr_accessor :name
  attr_reader :trains
 
  include InstanceCounter

  @@stations_list = []

  NAME_FORMAT = /^[а-я]{1}/i

  def initialize(name)
    @name = name
    @trains = {}

    @@stations_list << self if validate!
  end

  def arrive(train)
    if ready_for_arrive?(train)
      self.trains[train.number] = train
    end
  end

  def depart(train)
    if ready_for_depart?(train)
      self.trains.delete(train.number)
    end
  end

  def list_trains
    count_trains = self.trains.size
    if count_trains == 0
      puts "No any train at the station '#{self.name}'" 
    else
      puts "There are trains at the station '#{self.name}':"
      self.trains.each { |train_number, train| puts "#{train_number}" }
    end
  end

  def list_trains_by_type(train_type)
    if !train_type.instance_of? String
      puts "Wrong argument type"
    elsif self.trains.size = 0
      puts "No any train at the station '#{self.name}'" 
    else
      puts "Trains list of type: #{train.type}" 
      self.trains.each { |train_number, train| puts "#{train_number}" if train.type == train_type }
    end
  end

  def self.all
    @@stations_list
  end

  def valid?
    validate!
  rescue
    false
  end

  def check_trains(&block)
    #self.trains.each { |train_number, train| block.call(train_number, train.type, train.count_carriages) }
    self.trains.each { |train_number, train| block.call(train) }
  end

  private
  
  def ready_for_arrive?(train)
    ready_for_arrive = false
    if !( (train.instance_of? PassengerTrain) || (train.instance_of? CargoTrain) )
      puts "Wrong argument type"
    elsif self.trains.has_value?(train)
      puts "Already at the station '#{self.name}', wrong info"
    elsif train.route.nil?
      puts "No route for the train '#{train.number}', wrong info"
    elsif !train.route.list.include?(self)
      puts "Station '#{self.name}' not listed in route for '#{train.number}', wrong info"
    else
      ready_for_arrive = true
    end
    ready_for_arrive
  end

  def ready_for_depart?(train)
    ready_for_depart = false
    if !( (train.instance_of? PassengerTrain) || (train.instance_of? CargoTrain) )
      puts "Wrong argument type"
    elsif !self.trains.has_value?(train)
      puts "Already departed from the station '#{self.name}', wrong info"
    else
      ready_for_depart = true
    end
    ready_for_depart
  end

  def validate!
    raise "Не указано название станции" if self.name.nil?
    raise "Длина названия станции должна быть не менее 1 символа" if self.name.size < 1
    raise "Неверный формат названия станции #{NAME_FORMAT}" if self.name !~ NAME_FORMAT
    true
  end
end