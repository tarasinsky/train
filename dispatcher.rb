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

  def create_station
    print "Укажите название станции: "
    station_name = gets.chomp
    if station_name.size > 0
      Station.new(station_name)
    else
      puts "Не указано название станции"
    end
  end

  def create_train

    train_number = input_train_number

    if train_number.size > 0
      24.times { print "-" }; puts '-'
      puts "Выберите тип поезда"
      puts "1. Пассажирский"
      puts "2. Грузовой"
      puts "Любой другой ответ - отмена действия"
      print "Тип поезда: "; train_type = gets.to_i
      if train_type == 1 
        PassengerTrain.new(train_number)
      elsif train_type == 2
        CargoTrain.new(train_number)
      else
        puts "Не указан тип поезда"
      end
    end

  end

  def arrive_train_to_station

    if Train.all.size == 0
      puts "Список поездов пуст"
    elsif Station.all.size == 0
      puts "Список станций пуст"
    else
      puts "Какой поезд нужно поместить на станцию?"

      found_train_index = get_train_by_number(Train.all)

      if found_train_index > -1

        print_stations_list(Station.all)

        print "Номер поезда: "; desired_station = gets.to_i
        if desired_station > 0 || desired_station <= Station.all.size
          if Train.all[found_train_index].route.nil?
            new_route = Route.new(Station.all[desired_station-1])
            Train.all[found_train_index].assign_route(new_route)
            Train.all[found_train_index].set_initial_station()
          end
          Station.all[desired_station-1].arrive(Train.all[found_train_index])
        end

      else
        puts "Нет такого поезда"
      end

    end
  end

  def show_stations_and_trains
    if Station.all.size == 0
      puts "Список станций пуст"
    else
      print_stations_list(Station.all)
      print "Номер станции: "; station_number = gets.to_i
      if station_number.size > 0
        Station.all[station_number-1].list_trains
      else
        puts "Неверный номер станции"
      end
    end
  end

  def hitch_carriage_to_train

    puts "К какому поезду прицепить вагон?"

    train_number_index = get_train_by_number(Train.all)

    if train_number_index > -1
      
      current_train_type = Train.all[train_number_index].type

      print "Укажите номер вагона (тип #{current_train_type}): "
      carriage_number = gets.to_i
      
      if carriage_number.size > 0 
        created_carriage = false
        if current_train_type == "Passenger"
          PassengerCarriage.new(carriage_number)
          created_carriage = true
        elsif current_train_type == "Cargo"
          CargoCarriage.new(carriage_number)
          created_carriage = true
        end
        if created_carriage
          Train.all[train_number_index].hitch_carriage(Carriage.all[Carriage.all.size-1])
        end
      else
        puts "Неверный номер вагона"
      end

    else
      puts "Неверный номер поезда"
    end

  end

  def unhitch_carriage_from_train
    
    puts "От какого поезда отцепить вагон?"
    train_number_index  = get_train_by_number(Train.all)

    if train_number_index > -1
      if Train.all[train_number_index].carriages.size > 0 

        puts "Укажите номер вагона"
        Train.all[train_number_index].carriages.each { |carriage| puts "#{carriage.number}" }

        print "Номер вагона: "; carriage_number = gets.to_i

        Train.all[train_number_index].carriages.each do |carriage|
          Train.all[train_number_index].hitch_carriage(carriage) if carriage.number == carriage_number
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
    gets.chomp
  end

  def get_train_by_number(trains_list)
    found_train_index = -1
    trains_list.each { |train| puts "#{train.number}" }
    print "Номер поезда: "; train_number = gets.chomp
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