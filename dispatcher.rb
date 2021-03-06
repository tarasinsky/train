class Dispatcher
  def act
    menu_items = create_main_menu

    loop do
      input = show_menu(menu_items)

      system 'clear'

      break if input == '0'
      execute_menu_item = menu_items[input][1] if menu_items.key?(input)

      eval(execute_menu_item) unless (execute_menu_item.nil? || execute_menu_item.empty?)
    end  
  end

  private

  def create_main_menu
    return {
      '1' => ['Создать станцию'                      , 'create_station'              ],
      '2' => ['Создать поезд'                        , 'create_train'                ],
      '3' => ['Прицепить вагон к поезду'             , 'hitch_carriage_to_train'     ],
      '4' => ['Отцепить вагон от поезда'             , 'unhitch_carriage_from_train' ],
      '5' => ['Поместить поезд на станцию'           , 'arrive_train_to_station'     ],
      '6' => ['Просмотреть список станций и поездов' , 'show_stations_and_trains'    ],
      '7' => ['Просмотреть список поездов и вагонов' , 'show_trains_and_carriages'   ],
      '8' => ['Заполнить вагон'                      , 'occupy_carriage'             ],
      '0' => ['Выход'                                , ""                            ]
    }
  end

  def show_menu(menu_items)
    49.times { print '=' }; puts '='
    menu_items.each do |menu_item, menu_action|
      puts "#{menu_item}. #{menu_action[0]}"
    end
    print 'Выберите вариант: '
    gets.chomp
  end

  def create_station
    begin
      print 'Укажите название станции: '
      station_name = gets.chomp
      Station.new(station_name)
    rescue RuntimeError => e
      print "Ошибка создания станции '#{e.message}'. Повторить (y-да/любой другой символ - нет)?"
      retry_again = gets.chomp
      retry if retry_again == 'y'
    rescue => e
      puts "Неожиданная ошибка: #{e}\n#{e.backtrace.join('\n')}"
    end
  end

  def create_train
    train_type = get_train_type
    return if train_type.zero?

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
      puts "Неожиданная ошибка: #{e}\n#{e.backtrace.join('\n')}"
    end
  end

  def get_train_type
    24.times { print '-' }; puts '-'
    puts 'Выберите тип поезда'
    puts '1. Пассажирский'
    puts '2. Грузовой'
    puts 'Любой другой ответ - отмена действия'
    print 'Тип поезда: '
    train_type = gets.to_i

    unless (1..2).include?(train_type)
      puts 'Не указан тип поезда'
      system 'clear'
      train_type = 0
    end
    train_type
  end

  def arrive_train_to_station
    return if possible_to_arrive?

    puts 'Какой поезд нужно поместить на станцию?'
    arriving_train = get_train_by_number(Train.all)

    if arriving_train.nil?
      puts 'Нет такого поезда'
      return
    end
      
    print_stations_list(Station.all)
    print 'Номер поезда: '
    desired_station = gets.to_i

    return desired_station < 1 || desired_station > Station.all.size
    
    if arriving_train.route.nil?
      new_route = Route.new(Station.all[desired_station - 1])
      arriving_train.assign_route new_route
      arriving_train.set_initial_station
    end
    Station.all[desired_station - 1].arrive(arriving_train)

  end

  def possible_to_arrive?
    if Train.all.size.zero?
      puts 'Список поездов пуст'
      possible_to_arrive = false
    elsif Station.all.size.zero?
      puts 'Список станций пуст'
      possible_to_arrive = false
    else
      possible_to_arrive = true
    end
    possible_to_arrive
  end

  def show_stations_and_trains
    if Station.all.size.zero?
      puts 'Список станций пуст'
      return
    end
    
    print_stations_list(Station.all)
    print 'Номер станции: '
    station_number = gets.to_i
    if station_number.size > 0 && station_number > 0 && station_number <= Station.all.size
      Station.all[station_number-1].each_train do |train | 
        puts "Поезд № #{train.number}, тип #{train.type}, кол-во вагонов #{train.count_carriages}"
      end
    else
      puts 'Неверный номер станции'
    end

  end

  def show_trains_and_carriages
    if Train.all.size.zero?
      puts 'Список поездов пуст'
      return
    end
    
    puts 'Выберите интересуемый поезд'
    loco = get_train_by_number(Train.all)
    
    if loco.nil?
      puts 'Неверный номер поезда'
      return
    end

    if loco.carriages.size.zero?
      puts "К поезду #{loco.number} не прицеплены вагоны"
      return
    end

    loco.each_carriage do |carriage|
      if carriage.type == "Passenger"
        carriage_details = ", мест занято #{carriage.count_occupied_seats}, мест свободно #{carriage.count_free_seats}"
      elsif carriage.type == "Cargo"
        carriage_details = ", занятый объем #{carriage.count_occupied_volume}, свободный объем #{carriage.count_free_volume}"
      end
      puts "Вагон № #{carriage.number}, тип #{carriage.type}#{carriage_details}"
    end

  end

  def hitch_carriage_to_train
    puts 'К какому поезду прицепить вагон?'
    loco = get_train_by_number(Train.all)

    if loco.nil?
      puts 'Неверный номер поезда'
      return
    end

    current_train_type = loco.type
    begin
      new_carriage = create_carriage_by_train_type(current_train_type)
      loco.hitch_carriage(new_carriage) unless new_carriage.nil?
    rescue RuntimeError => e
      print "Ошибка создания вагона '#{e.message}'. Повторить (y-да/любой другой символ - нет)?"
      retry_again = gets.chomp
      retry if retry_again == 'y'
    rescue => e
      puts "Неожиданная ошибка: #{e}\n#{e.backtrace.join('\n')}"
    end

  end

  def create_carriage_by_train_type(current_train_type)
    print "Введите номер вагона (тип #{current_train_type}): "
    carriage_number = gets.chomp
    if current_train_type == 'Passenger'
      print 'Укажите количество мест в вагоне: '
      seats = gets.to_i
      new_carriage = PassengerCarriage.new(carriage_number, seats)
    elsif current_train_type == 'Cargo'
      print 'Укажите объем вагона: '
      volume = gets.to_f
      new_carriage = CargoCarriage.new(carriage_number, volume)
    else
      new_carriage = nil
    end
    new_carriage
  end

  def unhitch_carriage_from_train
    puts 'От какого поезда отцепить вагон?'
    loco = get_train_by_number(Train.all)

    return unless possible_to_unhitch?(loco)

    puts 'Укажите номер вагона'
    loco.carriages.each { |carriage| puts carriage.number.to_s }

    print 'Номер вагона: '
    carriage_number = gets.to_i

    loco.carriages.each do |carriage|
      loco.unhitch_carriage(carriage) if carriage.number == carriage_number
      break
    end

  end

  def possible_to_unhitch?(loco)
    if loco.nil?
      puts 'Неверный номер поезда'
      possible_to_unhitch = false
    elsif loco.carriages.size.zero?
      puts 'К поезду не прицеплены вагоны'
      possible_to_unhitch = false
    else
      possible_to_unhitch = true
    end
    possible_to_unhitch
  end

  def occupy_carriage
    puts 'Укажите поезд'
    loco = get_train_by_number(Train.all)

    return unless possible_to_occupy?(loco)

    puts "Список вагонов в поезде #{loco.number}:"
    current_carriage = get_carriage_by_number(loco.carriages)

    if current_carriage.nil?
      puts 'Ошибка поиска вагона'
    elsif current_carriage.type == 'Passenger'
      current_carriage.occupy_seat
    elsif current_carriage.type == 'Cargo'
      current_carriage.occupy_volume 1
    end
  end

  def possible_to_occupy?(loco)
    possible_to_occupy = true
    if loco.nil?
      possible_to_occupy = false
      puts 'Неверный номер поезда' 
    elsif loco.carriages.size.zero?
      possible_to_occupy = false
      puts 'К поезду не прицеплены вагоны'
    end
    possible_to_occupy
  end

  def run_train
    puts 'Какой поезд отправить по маршруту?'
    train = get_train_by_number(Train.all)
    forward = true

    if train.route.list.size == 1
      puts "Couldn't move train '#{train.number}' because of only 1 station in the route"
    elsif forward && train.current_station_index == (train.route.list.size - 1)
      puts "Already at the final station. Set a new route for the train '#{train.number}'"
    elsif !forward && train.current_station_index.zero?
      puts "Already at the start station. Set a new route for the train '#{train.number}'"
    else
      train.move_by_route(forward)
    end
  end

  def print_stations_list(stations_list)
    puts 'Список станций:'
    stations_list.each_with_index do |station, index|
      puts "#{index + 1}. #{station.name}"
    end
  end

  def print_trains_list(trains_list)
    puts 'Список поездов:'
    trains_list.each_key { |train_number| puts train_number.to_s }
  end

  def input_train_number
    print 'Укажите номер поезда: '
    gets.chomp
  end

  def get_train_by_number(trains_list)
    trains_list.each_key { |train_number| puts train_number.to_s }
    print 'Номер поезда: '
    train_number = gets.chomp
    trains_list[train_number]
  end

  def get_carriage_by_number(carriages_list)
    carriages_list.each_with_index do |carriage, carriage_num|
      puts "#{carriage_num + 1}. #{carriage.number}"
    end
    print 'Номер вагона: '
    carriage_number = gets.to_i
    carriages_list[carriage_number - 1] if (1..carriages_list.size).cover?(carriage_number)
  end
end
