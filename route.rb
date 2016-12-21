class Route
  attr_reader :list

  def initialize(start_station, finish_station = nil)
    @list = []
    
    @list << start_station << finish_station if check_stations(start_station, finish_station)
  end

  def add_station(station, order = -1)
    return if exist_station_check?(station)
    count_stations = list.size
    if order > count_stations
      puts "Wrong order for the station #{station.name}. Added to the end of the route"
      order = count_stations
    elsif order == -1
      order = count_stations
    end
    list.insert(order, station)
  end

  def exist_station_check?(station)
    if list.include?(station)
      puts "The station #{station.name} already in the route"
      exist_station = true
    else
      exist_station = false
    end
    exist_station
  end

  def delete_station(station)
    return if not_exist_station_check?(station)
    to_delete_station = true
    station.trains.each do |train|
      next unless train.route.include?(station)
      puts 'Could not delete station'
      to_delete_station = !to_delete_station if to_delete_station
      puts "'#{station.name}' is in route for the train '#{train.number}'"
    end
    list.delete(station) if to_delete_station
  end

  def not_exist_station_check?(station)
    if !list.include?(station)
      puts "No such station #{station.name} in the route"
      not_exist_station = true
    else
      not_exist_station = false
    end
    not_exist_station
  end

  def print_stations
    if !list.empty?
      puts 'Route list:'
      list.each { |station| puts station.name }
    else
      puts 'Empty route'
    end
  end

  def check_stations(start_station, finish_station)
    if !(start_station.instance_of? Station)
      puts 'Wrong type for 1 argument. Created empty route'
    elsif !(finish_station.instance_of? Station)
      puts 'Wrong type for 2 argument. Created empty route'
    end
  end
end
