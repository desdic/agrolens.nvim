# frozen_string_literal: true

require 'date'

# A person
class Person
  attr_reader :born, :name

  def initialize(born, name)
    @born = born
    @name = name
  end
end

def wrapped_string(dist)
  "[#{dist.to_i}]"
end

def to_string(dist)
  dist.to_i.to_s
end

def print_intro
  puts 'Age of:'
end

=begin
Calculate days between birth and now
=end
def days_since_birth(born, convf = method(:wrapped_string))
  now = DateTime.now
  born_date = now - Date.strptime(born, '%m-%d-%Y')

  convf.call(born_date)
end

donald = Person.new('07-09-1934', 'Donald Duck')
donald.born
born = donald.born

print_intro
days = days_since_birth(born, method(:to_string))

puts "#{donald.name} is #{days} days old"
