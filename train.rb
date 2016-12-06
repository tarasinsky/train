class Train

# должны быть доступны только из подклассов
  #protected 

  attr_reader   :number
  attr_accessor :speed
  attr_accessor :carriages
  attr_accessor :current_station_index
  attr_accessor :route

  def initialize(number, type)
    if !number.instance_of? Fixnum
      puts "Wrong type for number. Set to 0"
      @number = 0
    else
      @number = number
    end

    if !type.instance_of? String
      puts "Wrong type for train type. Set to PassengerTrain"
      @type = 'PassengerTrain'
    else
      @type = type
    end
    
    @speed = 0
    @route = nil
    @current_station_index = nil
    @carriages = []

  end

  def move(speed)
    self.speed = speed if speed > 0 
  end

  def break
    self.speed = 0
  end

  def hitch_carriage(carriage)
    if !( (carriage.instance_of? PassengerCarriage) || (carriage.instance_of? CargoCarriage) )
      puts "Wrong argument type for carriage"
    elsif self.speed > 0
      puts "Impossible to hitch because of speed #{self.speed}"
    elsif !carriage.type == self.type
      puts "Wrong carriage type"
    else
      self.carriages << carriage
    end
  end

  def unhitch_carriage(carriage)
    if !( (carriage.instance_of? PassengerCarriage) || (carriage.instance_of? CargoCarriage) )
      puts "Wrong argument type for carriage"
    elsif self.speed > 0
      puts "Impossible to hitch because of speed #{self.speed}"
    elsif self.carriages.size == 0 
      puts "Impossible because of no any carriage hitched"
    elsif !carriage.type == self.type
      puts "Wrong carriage type"
    elsif !self.carriages.include?(carriage)
      puts "Impossible because of carriage doesn't hitched"
    else
      self.carriages.delete(carriage)
    end
  end

  def assign_route(route)
    if !route.instance_of? Route
      puts "Wrong argument type"
    elsif route.list.size == 0
      puts "Route is empty. Input other route"
    else
      self.route = route
      self.route.list[0].arrive(self)
      self.current_station_index = 0
    end
  end

# forward: true - вперед, false - назад
  def move_by_route(forward=true)
    if !( (forward.instance_of? TrueClass) || (forward.instance_of? FalseClass) )
      puts "Wrong argument type"
    elsif self.route.list.size == 0 
      puts "Couldn't move train '#{self.number}' because of empty route"
    elsif self.route.list.size == 1 
      puts "Couldn't move train '#{self.number}' because of only 1 station in the route"
    else
      if forward && self.current_station_index == (self.route.list.size - 1)
        puts "Already at the final station. Set a new route for the train '#{self.number}'"
      elsif !forward && self.current_station_index == 0
        puts "Already at the start station. Set a new route for the train '#{self.number}'"
      else
        current_station = self.route.list[self.current_station_index]
        current_station.depart(self)
        
        if forward
          next_station = self.route.list[self.current_station_index + 1]
        else
          next_station = self.route.list[self.current_station_index - 1]
        end
        next_station.arrive(self)
      end
    end
  end

  def current_station
    if !self.route.instance_of? Route
      puts "No route for the train '#{self.number}'"
    elsif self.route.list.size == 0 
      puts "The route is empty for the train '#{self.number}'"
    else
      puts "Current station for the train is '#{self.route.list[self.current_station_index].name}'"
    end
  end

  def next_station
    if !self.route.instance_of? Route
      puts "No route for the train '#{self.number}'"
    elsif self.route.list.size == 0 
      puts "The route is empty for the train '#{self.number}'"
    elsif self.current_station_index >= (self.route.list.size - 1)
      puts "Already at the final station for the train '#{self.number}'"
    else
      puts "Next station for the train is '#{self.number}' is '#{self.route.list[self.current_station_index+1].name}'"
    end
  end
  
  def prev_station
    if !self.route.instance_of? Route
      puts "No route for the train '#{self.number}'"
    elsif self.route.list.size == 0 
      puts "The route is empty for the train '#{self.number}'"
    elsif self.current_station_index == 0
      puts "Already at the start station for the train '#{self.number}'"
    else
      puts "Previous station for the train is '#{self.number}' is '#{self.route.list[self.current_station_index-1].name}'"
    end
  end
end