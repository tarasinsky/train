class CargoCarriage < Carriage
  attr_reader :volume, :occupied_volume

  CARRIAGE_TYPE = 'Cargo'

  def initialize(number, volume)
    @volume = volume
    return unless validate!
    super(number, CARRIAGE_TYPE)
    @occupied_volume = 0.0
  end

  def occupy_volume(reserved_volume)
    taken_volume = false
    if validate(reserved_volume)
      if (volume - occupied_volume) >= reserved_volume
        self.occupied_volume += reserved_volume
        taken_volume = true
      end
    end
    taken_volume
  end

  def count_free_volume
    volume - occupied_volume
  end

  def count_occupied_volume
    occupied_volume
  end

  private

  attr_writer :occupied_volume

  def validate!
    raise 'Неверно указан объем в м3' unless validate(volume, :less_than, compare_to: 10)
    true
  end
end
