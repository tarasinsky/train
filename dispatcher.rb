class Dispatcher

  def act

    loop do

      menu

      input = gets.chomp.to_i
      break if input == 0

      system 'clear'

      case input
      when 1
        create_station
      when 2
        create_train
      when 3
        hitch_carriage_to_train
      when 4
        unhitch_carriage_from_train
      when 5
        arrive_train_to_station
      when 6
        show_stations_and_trains
      end

    end  

  end

  private

  def menu
    49.times { print "=" }; puts '='
    puts "1. Создать станцию"
    puts "2. Создать поезд"
    puts "3. Прицепить вагон к поезду"
    puts "4. Отцепить вагон от поезда"
    puts "5. Поместить поезд на станцию"
    puts "6. Просмотреть список станций и поездов"
    puts "0. Выход"
    print "Выберите вариант: "
  end

  def create_station()
    print "Укажите название станции: "
    station_name = gets.chomp
    if station_name.size > 0
      Station.enlist_station(Station.new(station_name))
    else
      puts "Не указано название станции"
    end
  end

  def create_train()

    train_number = input_train_number

    if train_number.size > 0
      24.times { print "-" }; puts '-'
      puts "Выберите тип поезда"
      puts "1. Пассажирский"
      puts "2. Грузовой"
      puts "Любой другой ответ - отмена действия"
      print "Тип поезда: "; train_type = gets.to_i
      if train_type == 1 
        Train.enlist_train(PassengerTrain.new(train_number))
      elsif train_type == 2
        Train.enlist_train(CargoTrain.new(train_number))
      else
        puts "Не указан тип поезда"
      end
    end

  end

  def arrive_train_to_station()

    if Train.list_trains.size == 0
      puts "Список поездов пуст"
    elsif Station.list_stations.size == 0
      puts "Список станций пуст"
    else
      puts "Какой поезд нужно поместить на станцию?"

      found_train_index = get_train_by_number(Train.list_trains)

      if found_train_index > -1

        print_stations_list(Station.list_stations)

        print "Номер поезда: "; desired_station = gets.to_i
        if desired_station > 0 || desired_station <= Station.list_stations.size
          if Train.list_trains[found_train_index].route.nil?
            new_route = Route.new(Station.list_stations[desired_station-1])
            Train.list_trains[found_train_index].assign_route(new_route)
            Train.list_trains[found_train_index].set_initial_station()
          end
          Station.list_stations[desired_station-1].arrive(Train.list_trains[found_train_index])
        end

      else
        puts "Нет поезда с номером '#{train_number}'"
      end

    end
  end

  def show_stations_and_trains()
    if Station.list_stations.size == 0
      puts "Список станций пуст"
    else
      print_stations_list(Station.list_stations)
      print "Номер станции: "; station_number = gets.to_i
      if station_number.size > 0
        Station.list_stations[station_number-1].list_trains
      else
        puts "Неверный номер станции"
      end
    end
  end

  def hitch_carriage_to_train()

    puts "К какому поезду прицепить вагон?"

    train_number_index = get_train_by_number(Train.list_trains)

    if train_number_index > -1
      
      current_train_type = Train.list_trains[train_number_index].type

      print "Укажите номер вагона (тип #{current_train_type}): "
      carriage_number = gets.to_i
      
      if carriage_number.size > 0 
        created_carriage = false
        if current_train_type == "Passenger"
          Carriage.enlist_carriage(PassengerCarriage.new(carriage_number))
          created_carriage = true
        elsif current_train_type == "Cargo"
          Carriage.enlist_carriage(CargoCarriage.new(carriage_number))
          created_carriage = true
        end
        if created_carriage
          Train.list_trains[train_number_index].hitch_carriage(Carriage.list_carriages[Carriage.list_carriages.size-1])
        end
      else
        puts "Неверный номер вагона"
      end

    else
      puts "Неверный номер поезда"
    end

  end

  def unhitch_carriage_from_train()
    
    puts "От какого поезда отцепить вагон?"
    train_number_index  = get_train_by_number(Train.list_trains)

    if train_number_index > -1
      if Train.list_trains[train_number_index].carriages.size > 0 

        puts "Укажите номер вагона"
        Train.list_trains[train_number_index].carriages.each { |carriage| puts "#{carriage.number}" }

        print "Номер вагона: "; carriage_number = gets.to_i

        Train.list_trains[train_number_index].carriages.each do |carriage|
          Train.list_trains[train_number_index].hitch_carriage(carriage) if carriage.number == carriage_number
        end

      else
        puts "К поезду не прицеплены вагоны"
      end
    else
      puts "Неверный номер поезда"
    end
  end

  def print_stations_list(stations_list)
    puts "Список станций:"
    stations_list.each_with_index { |station, index| puts "#{index+1}. #{station.name}"}
  end

  def print_trains_list(trains_list)
    puts "Список поездов:"
    trains_list.each { |train| puts "#{train.number}" }
  end

  def input_train_number
    print "Укажите номер поезда: "
    gets.chomp.to_i
  end

  def get_train_by_number(trains_list)
    found_train_index = -1
    trains_list.each { |train| puts "#{train.number}" }
    print "Номер поезда: "; train_number = gets.to_i
    if train_number.size > 0 

      found_train_index = -1
      trains_list.each_with_index do |train, index|
        if train.number == train_number
          found_train_index = index
          break
        end
      end
    end
    found_train_index
  end

end