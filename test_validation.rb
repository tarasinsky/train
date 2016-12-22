require_relative 'validation.rb'

class Test
  include Validation

  attr_accessor :val

  validate :val, :presense
  validate :val, :is_type, is_class: String

  def validate!
    @@validation_rules.each do |rule|
      puts rule
      rule.each_pair do |method, params|
        result = self.class.send method, eval("#{params[:value]}"), eval("#{params[:args]}")
        #result = self.class.send method, params[:value].send("self"), eval("#{params[:args]}")
        puts result
      end
    end
  end

end

a = "d"

t = Test.new
t.val = a

t.validate!

#result = t.validate t.val, :presense
#puts "presense #{result}"

#t.val = "а"
#name_format = /^[а-я]{1}/i
#result = t.validate t.val, :format, regex: /^[а-я]{1}/i
#puts "regex #{result}"

#t.val = 1
#result = t.validate t.val, :type, is_class: String
#puts "class #{result}"
