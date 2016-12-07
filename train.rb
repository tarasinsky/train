class Train

# должны быть доступны только из подклассов
  #protected 

  attr_reader   :number
  attr_accessor :speed
  attr_accessor :carriages
  attr_accessor :current_station_index
  attr_accessor :route

  @@trains_list = []

  def initialize(number, type)
    if !(number.instance_of? Fixnum)
      puts "Wrong type for number. Set to 0"
      @number = 0
    else
      @number = number
    end

    if !(type.instance_of? String)
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
    if carriage_ready?(carriage)
      self.carriages << carriage
    end
  end

  def unhitch_carriage(carriage)
    if carriage_ready?(carriage)
      if self.carriages.size == 0 
        puts "Impossible because of no any carriage hitched"
      else
        self.carriages.delete(carriage)
      end
    end
  end

  def assign_route(route)
    if exist_train_route?
      self.route = route
      self.route.list[0].arrive(self)
    end
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

  def self.enlist_train(train)
    @@trains_list[@@trains_list.size] = train
  end

  def self.list_trains()
    @@trains_list
  end

  # forward: true - вперед, false - назад
  def move_by_route(forward=true)
    if exist_train_route?

      if self.route.list.size == 1 
        puts "Couldn't move train '#{self.number}' because of only 1 station in the route"
      else
        if forward && self.current_station_index == (self.route.list.size - 1)
          puts "Already at the final station. Set a new route for the train '#{self.number}'"
        elsif !forward && self.current_station_index == 0
          puts "Already at the start station. Set a new route for the train '#{self.number}'"
        else

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
    end
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

  def exist_train_route?
    exist_train_route = false
    if !self.route
      puts "No route for the train '#{self.number}'"
    elsif self.route.list.size == 0 
      puts "The route is empty for the train '#{self.number}'"
    else
      exist_train_route = true
    end
    exist_train_route
  end

  def carriage_ready?(carriage)
    carriage_ready = false
    if self.speed > 0
      puts "Impossible to hitch because of speed #{self.speed}"
    elsif carriage.type != self.type
      puts "Wrong carriage type"
    else
      carriage_ready = true
    end
    carriage_ready
  end

end