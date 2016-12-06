class Route
  attr_reader :list

  def initialize(start_station, finish_station=nil)
    @list = []
    if !start_station.instance_of? Station
      puts "Wrong type for 1 argument. Created empty route"
    elsif !start_station.instance_of? Station
      puts "Wrong type for 2 argument. Created empty route"
    else
      @list << start_station << finish_station
    end
  end

  def add_station(station, order = -1)
    if self.list.include?(station)
      puts "The station #{station.name} already in the route"
    else
      count_stations = self.list.size
      if order > count_stations
        puts "Wrong order for station #{station.name}. Added to the end of the route"
        order = count_stations
      elsif order == -1
        order = count_stations
      end
      self.list.insert(order, station)
    end
  end

  def delete_station(station)
    if self.list.include?(station)
      
      to_delete_station = true
      station.trains.each do |train|

        if train.route.include?(station)
          puts "Couldn't delete station"; to_delete_station = !to_delete_station if to_delete_station
          puts "'#{station.name}' is in route for the train '#{train.number}'"
        end

      end

      self.list.delete(station) if to_delete_station
    else
      puts "No such station #{station} in the route"
    end
  end

  def print_stations
    if self.list.size > 0
      puts "Route list:"
      self.list.each {|station| puts "#{station.name}"}
    else
      puts "Empty route"
    end
  end

end