class CargoCarriage < Carriage
  attr_reader :volume, :occupied_volume

  CARRIAGE_TYPE = 'Cargo'

  def initialize(number, volume)
    if validate(volume)
      super(number, CARRIAGE_TYPE)
      @volume = volume
      @occupied_volume = 0.0
    end
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

  def validate(volume)
    raise 'Неверно указан объем' unless ((volume.instance_of? Float) || (volume.instance_of? Fixnum))
    raise 'Неверно указан объем' unless volume > 0
    true
  end
end
