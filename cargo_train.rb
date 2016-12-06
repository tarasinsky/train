class CargoTrain < Train
  TRAIN_TYPE = 'Cargo'

  def initialize(number)
    super(number, type)
  end

  def type
    TRAIN_TYPE
  end

end