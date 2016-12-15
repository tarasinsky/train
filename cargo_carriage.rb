class CargoCarriage < Carriage
  attr_reader :volume
  attr_reader :occupied_volume

  CARRIAGE_TYPE = 'Cargo'

  def initialize(number, volume)
    if validate!(capacity)
      super(number, CARRIAGE_TYPE)
      @volume = volume
      @occupied_volume = 0
    end
  end

  def occupy_volume(reserved_volume)
    taken_volume = false
    if validate!(reserved_volume)
      if (self.volume - self.occupied_volume) >= reserved_volume
        self.occupied_volume = self.occupied_volume + reserved_volume
        taken_volume = true
      end
    end
    taken_volume
  end

  def count_free_volume
    self.volume - self.occupied_volume
  end

  def count_occupied_volume
    self.occupied_volume
  end

  private
  def validate!(volume)
    raise "Неверно указан объем" if !(volume.instance_of? Fixnum)
    raise "Неверно указан объем" if volume <= 0
    true
  end

end