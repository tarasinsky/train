require_relative 'validation.rb'

class Test
  include Validation

  attr_accessor :val

  validate :val, :presense
  validate :val, :is_type, is_class: String
end

a = "d"

t = Test.new
t.val = a

puts t.valid?
