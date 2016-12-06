class PassengerTrain < Train
  TRAIN_TYPE = 'Passenger'

  def initialize(number)
    super(number, type)
  end

  def type
    TRAIN_TYPE
  end


end