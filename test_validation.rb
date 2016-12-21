require_relative 'validation.rb'

class Test
  include Validation

  attr_accessor :val

end

a = nil

t = Test.new
t.val = a

result = t.validate t.val, :presense
puts "presense #{result}"

t.val = "а"
name_format = /^[а-я]{1}/i
result = t.validate t.val, :format, regex: /^[а-я]{1}/i
puts "regex #{result}"

t.val = 1
result = t.validate t.val, :type, is_class: String
puts "class #{result}"
