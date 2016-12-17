require_relative 'manufacturer'
require_relative 'instance_counter'

require_relative 'dispatcher'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'carriage'
require_relative 'passenger_carriage'
require_relative 'cargo_carriage'
require_relative 'station'
require_relative 'route'

dispatcher = Dispatcher.new
dispatcher.act
