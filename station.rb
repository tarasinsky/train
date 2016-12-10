class Station
  attr_accessor :name
  attr_reader :trains
 
  @@stations_list = []

  def initialize(name)
    @name = name
    @trains = []
  end

  def arrive(train)
    if ready_for_arrive?(train)
      self.trains << train
      train.current_station_index = train.route.list.index(self)
    end
  end

  def depart(train)
    if ready_for_depart?(train)
      self.trains.delete(train)
    end
  end

  def list_trains
    count_trains = self.trains.size
    if count_trains == 0
      puts "No any train at the station '#{self.name}'" 
    elsif count_trains == 1
      puts "There is only '#{@trains[0].number}' at the station '#{self.name}'"
    else
      puts "There are trains at the station '#{self.name}':"
      self.trains.each { |train| puts "#{train.number}" }
    end
  end

  def list_trains_by_type(train_type)
    if !train_type.instance_of? String
      puts "Wrong argument type"
    elsif self.trains.size = 0
      puts "No any train at the station '#{self.name}'" 
    else
      puts "#{train.number} type: #{train.type}" 
      self.trains.each { |train| puts "#{train.number}" if train.type == train_type }
    end
  end

  def self.enlist_station(station)
    @@stations_list << station
  end

  def self.list_stations
    @@stations_list
  end

  def self.all
    puts "There are stations:"
    @@stations_list.each { |station| puts "'#{station.name}'" }
  end

  private
  
  def ready_for_arrive?
    ready_for_arrive = false
    if !( (train.instance_of? PassengerTrain) || (train.instance_of? CargoTrain) )
      puts "Wrong argument type"
    elsif self.trains.include?(train)
      puts "Already at the station '#{self.name}', wrong info"
    elsif train.route.nil?
      puts "No route for the train '#{train.number}', wrong info"
    elsif !train.route.list.include?(self)
      puts "Station '#{self.name}' not listed in route for '#{train.number}', wrong info"
    else
      ready_for_arrive = false
    end
    ready_for_arrive
  end

  def ready_for_depart?
    ready_for_depart = false
    if !( (train.instance_of? PassengerTrain) || (train.instance_of? CargoTrain) )
      puts "Wrong argument type"
    elsif !self.trains.include?(train)
      puts "Already departed from the station '#{self.name}', wrong info"
    else
      ready_for_depart = true
    end
    ready_for_depart
  end

end