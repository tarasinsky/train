class Station
  attr_accessor :name
  attr_reader :trains
 
  def initialize(name)
    @name = name
    @trains = []
  end

  def arrive(train)
    false
    if !( (train.instance_of? PassengerTrain) || (train.instance_of? CargoTrain) )
      puts "Wrong argument type"
    elsif self.trains.include?(train)
      puts "Already at the station '#{self.name}', wrong info"
    elsif train.route.nil?
      puts "No route for '#{train.number}', wrong info"
    elsif !train.route.list.include?(self)
      puts "Station '#{self.name}' not listed in route for '#{train.number}', wrong info"
    else
      self.trains << train
      train.current_station_index = train.route.list.index(self)
      true
    end
  end

  def depart(train)
    false
    if !( (train.instance_of? PassengerTrain) || (train.instance_of? CargoTrain) )
      puts "Wrong argument type"
    elsif self.trains.include?(train)
      self.trains.delete(train)
      true
    else
      puts "Already departed from the station '#{self.name}', wrong info"
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
    if !train.instance_of? String
      puts "Wrong argument type"
    else
      if self.trains.size > 0
        puts "#{train.number} type: #{train.type}" 
        self.trains.each { |train| puts "#{train.number}" if train.type == train_type }
      else
        puts "No any train at the station '#{self.name}'" 
      end
    end
  end

end