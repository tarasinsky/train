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
      when 7
        show_trains_and_carriages
      when 8
        occupy_carriage
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
    puts "7. Просмотреть список поездов и вагонов"
    puts "8. Заполнить вагон"
    puts "0. Выход"
    print "Выберите вариант: "
  end

  def create_station
    begin
      print "Укажите название станции: "
      station_name = gets.chomp
      Station.new(station_name)
    rescue RuntimeError => e
      print "Ошибка создания станции '#{e.message}'. Повторить (y-да/любой другой символ - нет)?"
      retry_again = gets.chomp
      retry if retry_again == 'y'
    rescue => e
      puts "Неожиданная ошибка: #{e.to_s}"
    end
  end

  def create_train

    24.times { print "-" }; puts '-'
    puts "Выберите тип поезда"
    puts "1. Пассажирский"
    puts "2. Грузовой"
    puts "Любой другой ответ - отмена действия"
    print "Тип поезда: "; train_type = gets.to_i

    if !(1..2).include?(train_type)
      puts "Не указан тип поезда"
      system 'clear'
    else
      begin
        train_number = input_train_number
        if train_type == 1 
          PassengerTrain.new(train_number)
        elsif train_type == 2
          CargoTrain.new(train_number)
        end
      rescue RuntimeError => e
        print "Ошибка создания поезда '#{e.message}'. Повторить (y-да/любой другой символ - нет)?"
        retry_again = gets.chomp
        retry if retry_again == 'y'
      rescue => e
        puts "Неожиданная ошибка: #{e.to_s}"
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

      arriving_train = get_train_by_number(Train.all)

      if !arriving_train.nil?

        print_stations_list(Station.all)

        print "Номер поезда: "; desired_station = gets.to_i
        if desired_station > 0 || desired_station <= Station.all.size
          if arriving_train.route.nil?
            new_route = Route.new(Station.all[desired_station-1])
            arriving_train.assign_route(new_route)
            arriving_train.set_initial_station()
          end
          Station.all[desired_station-1].arrive(arriving_train)
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
        #Station.all[station_number-1].list_trains
        # Номер поезда, тип, кол-во вагонов
        block = lambda { |train | puts "Поезд № #{train.number}, тип #{train.type}, кол-во вагонов #{train.count_carriages}"}
        Station.all[station_number-1].check_trains(&block)
      else
        puts "Неверный номер станции"
      end
    end
  end

  def show_trains_and_carriages
    if Train.all.size == 0
      puts "Список поездов пуст"
    else
      puts "Выберите интересуемый поезд"
      loco = get_train_by_number(Train.all)
      if !loco.nil?
        if loco.carriages.size > 0
          current_train_type = loco.type
          # Номер вагона, тип, кол-во свободно и занято
          if current_train_type == "Passenger"
            block = lambda { |carriage | puts "Вагон № #{carriage.number}, тип #{carriage.type}, мест занято #{carriage.count_occupied_seats}, мест свободно #{carriage.count_free_seats}" }
          elsif current_train_type == "Cargo"
            block = lambda { |carriage | puts "Вагон № #{carriage.number}, тип #{carriage.type}, занятый объем #{carriage.count_occupied_volume}, свободный объем #{carriage.count_free_volume}" }
          end
          loco.check_carriages(&block)
        else
          puts "К поезду #{loco.number} не прицеплены вагоны"
        end
      else
        puts "Неверный номер станции"
      end
    end
  end

  def hitch_carriage_to_train

    puts "К какому поезду прицепить вагон?"

    loco = get_train_by_number(Train.all)

    if !loco.nil?
      
      current_train_type = loco.type

      begin
        print "Введите номер вагона (тип #{current_train_type}): "
        carriage_number = gets.chomp
      
        new_carriage = nil
        if current_train_type == "Passenger"
          print "Укажите количество мест в вагоне: "
          seats = gets.to_i
          new_carriage = PassengerCarriage.new(carriage_number, seats)
        elsif current_train_type == "Cargo"
          print "Укажите объем вагона: "
          volume = gets.to_f
          new_carriage = CargoCarriage.new(carriage_number, volume)
        end
        
        loco.hitch_carriage(new_carriage) if !new_carriage.nil?
      rescue RuntimeError => e
        print "Ошибка создания вагона '#{e.message}'. Повторить (y-да/любой другой символ - нет)?"
        retry_again = gets.chomp
        retry if retry_again == 'y'
      rescue => e
        puts "Неожиданная ошибка: #{e.to_s}\n#{e.backtrace.join('\n')}"
      end

    else
      puts "Неверный номер поезда"
    end

  end

  def unhitch_carriage_from_train
    
    puts "От какого поезда отцепить вагон?"
    loco = get_train_by_number(Train.all)

    if !loco.nil?
      if loco.carriages.size > 0 

        puts "Укажите номер вагона"
        loco.carriages.each { |carriage| puts "#{carriage.number}" }

        print "Номер вагона: "; carriage_number = gets.to_i

        loco.carriages.each do |carriage|
          loco.hitch_carriage(carriage) if carriage.number == carriage_number; break
        end

      else
        puts "К поезду не прицеплены вагоны"
      end
    else
      puts "Неверный номер поезда"
    end
  end

  def occupy_carriage
    puts "Укажите поезд"
    loco = get_train_by_number(Train.all)

    if !loco.nil?
      if loco.carriages.size > 0 

        puts "Список вагонов в поезде #{loco.number}:"
        current_carriage = get_carriage_by_number(loco.carriages)
        if !current_carriage.nil?
          if current_carriage.type == 'Passenger'
            current_carriage.occupy_seat
          elsif current_carriage.type == 'Cargo'
            current_carriage.occupy_volume
          end
        else
          puts "Ошибка поиска вагона"
        end
      else
        puts "К поезду не прицеплены вагоны"
      end
    else
      puts "Неверный номер поезда"
    end

  end

  def run_train
    puts "Какой поезд отправить по маршруту?"
    train = get_train_by_number(Train.all)
    forward = true

    if train.route.list.size == 1 
      puts "Couldn't move train '#{train.number}' because of only 1 station in the route"
    elsif forward && train.current_station_index == (train.route.list.size - 1)
      puts "Already at the final station. Set a new route for the train '#{train.number}'"
    elsif !forward && train.current_station_index == 0
      puts "Already at the start station. Set a new route for the train '#{train.number}'"
    else
      train.move_by_route(forward)
    end
  end

  def print_stations_list(stations_list)
    puts "Список станций:"
    stations_list.each_with_index { |station, index| puts "#{index+1}. #{station.name}"}
  end

  def print_trains_list(trains_list)
    puts "Список поездов:"
    trains_list.each { |train_number, train| puts "#{train_number}" }
  end

  def input_train_number
    print "Укажите номер поезда: "
    gets.chomp
  end

  def get_train_by_number(trains_list)
    trains_list.each { |train_number, train| puts "#{train_number}" }
    print "Номер поезда: "; train_number = gets.chomp
    trains_list[train_number]
  end

  def get_carriage_by_number(carriages_list)
    carriages_list.each_with_index { |carriage, carriage_num| puts "#{carriage_num+1}. #{carriage.number}" }
    print "Номер вагона: "; carriage_number = gets.to_i
    carriages_list[carriage_number-1] if (1..carriages_list.size).include?(carriage_number)
  end

end