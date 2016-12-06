require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'carriage'
require_relative 'passenger_carriage'
require_relative 'cargo_carriage'
require_relative 'station'
require_relative 'route'

stations_list   = []
trains_list     = []
carriages_list  = []

class RepeatedActions

  def print_stations_list(stations_list)
    puts "Список станций:"
    stations_list.each_with_index { |station, index| puts "#{index+1}. #{station.name}"}
  end

  def print_trains_list(trains_list)
    puts "Список поездов:"
    trains_list.each { |train| puts "#{train.number}" }
  end

  def input_train_number
    puts "Укажите номер поезда"
    gets.chomp.to_i
  end

  def get_train_by_number(trains_list)
    found_train_index = -1
    trains_list.each { |train| puts "#{train.number}" }
    train_number = gets.to_i
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

repeated_actions = RepeatedActions.new

loop do

  49.times { print "=" }; puts '='
  puts "1. Создать станцию"
  puts "2. Создать поезд"
  puts "3. Прицепить вагон к поезду"
  puts "4. Отцепить вагон от поезда"
  puts "5. Поместить поезд на станцию"
  puts "6. Просмотреть список станций и поездов"
  puts "0. Выход"
  puts "Выберите вариант:"

  input = gets.chomp.to_i
  break if input == 0

  system 'clear'

  case input
  when 1
    puts "Укажите название станции"
    station_name = gets.chomp
    if station_name.size > 0
      stations_list[stations_list.size] = Station.new(station_name)
    else
      puts "Не указано название станции"
    end
  when 2

    train_number = repeated_actions.input_train_number

    if train_number.size > 0
      puts "Выберите тип поезда"
      24.times { print "-" }; puts '-'
      puts "1. Пассажирский"
      puts "2. Грузовой"
      puts "Любой другой ответ - отмена действия"
      train_type = gets.to_i
      if train_type == 1 
        trains_list[trains_list.size] = PassengerTrain.new(train_number)
      elsif train_type == 2
        trains_list[trains_list.size] = CargoTrain.new(train_number)
      else
        puts "Не указан тип поезда"
      end
    end

  when 3

    puts "К какому поезду прицепить вагон?"

    train_number_index = repeated_actions.get_train_by_number(trains_list)

    if train_number_index > -1
      
      current_train_type = trains_list[train_number_index].type

      puts "Укажите номер вагона (тип #{current_train_type}):"
      carriage_number = gets.to_i
      
      if carriage_number.size > 0 
        created_carriage = false
        if current_train_type == "Passenger"
          carriages_list[carriages_list.size] = PassengerCarriage.new(carriage_number)
          created_carriage = true
        elsif current_train_type == "Cargo"
          carriages_list[carriages_list.size] = CargoCarriage.new(carriage_number)
          created_carriage = true
        end
        if created_carriage

          trains_list[train_number_index].hitch_carriage(carriages_list[carriages_list.size-1])
        end
      else
        puts "Неверный номер вагона"
      end

    else
      puts "Неверный номер поезда"
    end
  
  when 4
    
    puts "От какого поезда отцепить вагон?"
    train_number_index  = repeated_actions.get_train_by_number(trains_list)

    if train_number_index > -1
      if trains_list[train_number_index].carriages.size > 0 

        puts "Укажите номер вагона"
        trains_list[train_number_index].carriages.each { |carriage| puts "#{carriage.number}" }

        carriage_number = gets.to_i

        trains_list[train_number_index].carriages.each do |carriage|
          trains_list[train_number_index].hitch_carriage(carriage) if carriage.number == carriage_number
        end

      else
        puts "К поезду не прицеплены вагоны"
      end
    else
      puts "Неверный номер поезда"
    end

  when 5

    if trains_list.size == 0
      puts "Список поездов пуст"
    elsif stations_list.size == 0
      puts "Список станций пуст"
    else
      puts "Какой поезд нужно поместить на станцию?"

      found_train_index = repeated_actions.get_train_by_number(trains_list)

      if found_train_index > -1

        repeated_actions.print_stations_list(stations_list)

        desired_station = gets.to_i
        if desired_station > 0 || desired_station <= stations_list.size
          if trains_list[found_train_index].route.nil?
            new_route = Route.new(stations_list[desired_station-1])
            trains_list[found_train_index].assign_route(new_route)
          end
          stations_list[desired_station-1].arrive(trains_list[found_train_index])
        end

      else
        puts "Нет поезда с номером '#{train_number}'"
      end

    end

  when 6

    if stations_list.size == 0
      puts "Список станций пуст"
    else
      repeated_actions.print_stations_list(stations_list)
      station_number = gets.to_i
      if station_number.size > 0
        stations_list[station_number-1].list_trains
      else
        puts "Неверный номер станции"
      end
    end

  end

end